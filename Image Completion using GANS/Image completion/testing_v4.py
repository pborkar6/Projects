from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import tensorflow as tf
import numpy as np
import os
import glob
import random
import collections
import math

EPS = 1e-12
input_dir = "val_input"
mode = "test"
output_dir = "output_validation"
checkpoint = "checkpoint"
seed = 0
max_steps = 1
max_epochs = 200
summary_freq = 100
save_freq = 50
progress_freq = 50
trace_freq = 0
display_freq = 0
aspect_ratio = 50
batch_size = 100
which_direction = "BtoA"
gen_filter = 64
disc_filter = 64
scale_size = 128
flip = True
lr = 0.0002
beta1 = 0.5
l1_weight = 100
gan_weight = 1.0
output_filetype = "png"

Model = collections.namedtuple("Model", "outputs, predict_real, predict_fake, discrim_loss, discrim_grads_and_vars, gen_loss_GAN, gen_loss_L1, gen_grads_and_vars, train")
Examples = collections.namedtuple("Examples", "paths, inputs, targets, count, steps_per_epoch")

def conv(batch_input, out_channels, stride):
    with tf.variable_scope("conv"):
        input_channels = batch_input.get_shape()[3]
        filter = tf.get_variable("filter", [4, 4, input_channels, out_channels], dtype=tf.float32, initializer=tf.random_normal_initializer(0, 0.02))
        padded_input = tf.pad(batch_input, [[0, 0], [1, 1], [1, 1], [0, 0]], mode="CONSTANT")
        conv = tf.nn.conv2d(padded_input, filter, [1, stride, stride, 1], padding="VALID")
        return conv

def lrelu(x, a):
    with tf.name_scope("lrelu"):
        x = tf.identity(x)
        return (0.5 * (1 + a)) * x + (0.5 * (1 - a)) * tf.abs(x)

def batchnorm(input):
    with tf.variable_scope("batchnorm"):
        input = tf.identity(input)
        channels = input.get_shape()[3]
        offset = tf.get_variable("offset", [channels], dtype=tf.float32, initializer=tf.zeros_initializer())
        scale = tf.get_variable("scale", [channels], dtype=tf.float32, initializer=tf.random_normal_initializer(1.0, 0.02))
        mean, variance = tf.nn.moments(input, axes=[0, 1, 2], keep_dims=False)
        variance_epsilon = 1e-6 #!!!
        normalized = tf.nn.batch_normalization(input, mean, variance, offset, scale, variance_epsilon=variance_epsilon)
        return normalized


def deconv(batch_input, out_channels):
    with tf.variable_scope("deconv"):
        batch, input_height, in_width, input_channels = [int(d) for d in batch_input.get_shape()]
        filter = tf.get_variable("filter", [4, 4, out_channels, input_channels], dtype=tf.float32, initializer=tf.random_normal_initializer(0, 0.02))
        conv = tf.nn.conv2d_transpose(batch_input, filter, [batch, input_height * 2, in_width * 2, out_channels], [1, 2, 2, 1], padding="SAME")
        return conv


def load_examples():

    input_paths = glob.glob(os.path.join(input_dir, "*.jpg"))
    decode = tf.image.decode_jpeg

    def get_name(path):
        name, _ = os.path.splitext(os.path.basename(path))
        return name

    input_paths = sorted(input_paths, key=lambda path: int(get_name(path)))


    with tf.name_scope("load_images"):
        path_queue = tf.train.string_input_producer(input_paths, shuffle=True)
        reader = tf.WholeFileReader()
        paths, contents = reader.read(path_queue)
        raw_input = decode(contents)
        raw_input = tf.image.convert_image_dtype(raw_input, dtype=tf.float32)


        raw_input.set_shape([None, None, 3])

        width = tf.shape(raw_input)[1]
        a_images = (raw_input[:,:width//2,:])
        b_images = (raw_input[:,width//2:,:])

        inputs, targets = [a_images, b_images]
        seed = random.randint(0, 2**31 - 1)

        def transform(image):
            r = image
            r = tf.image.random_flip_left_right(r, seed=seed)
            r = tf.image.resize_images(r, [scale_size, scale_size], method=tf.image.ResizeMethod.AREA)
            return r

        with tf.name_scope("input_images"):
            input_images = transform(inputs)

        with tf.name_scope("target_images"):
            target_images = transform(targets)

        paths_batch, inputs_batch, targets_batch = tf.train.batch([paths, input_images, target_images], batch_size=batch_size)
        steps_per_epoch = int(math.ceil(len(input_paths) / batch_size))

        return Examples(paths_batch,inputs_batch,targets_batch,len(input_paths),steps_per_epoch)


def create_generator(generator_inputs, generator_outputs_channels):
        layers = []


        with tf.variable_scope("encoder_1"):
            output = conv(generator_inputs, gen_filter, stride=2)
            layers.append(output)

        layer_specs = [gen_filter * 2,gen_filter * 4, gen_filter * 8, gen_filter * 8, gen_filter * 8, gen_filter * 8,]

        for out_channels in layer_specs:
            with tf.variable_scope("encoder_%d" % (len(layers) + 1)):
                activation_fxn = lrelu(layers[-1], 0.2)

                convolved = conv(activation_fxn, out_channels, stride=2)
                output = batchnorm(convolved)
                layers.append(output)

        layer_specs = [(gen_filter * 8, 0.5),  (gen_filter * 8, 0.5),   (gen_filter * 8, 0.5), (gen_filter * 8, 0.0),   (gen_filter * 4, 0.0),   (gen_filter * 2, 0.0),]


        num_encoder_layers = len(layers)
        for decoder_layer, (out_channels, dropout) in enumerate(layer_specs):
            skip_layer = num_encoder_layers - decoder_layer - 1
            with tf.variable_scope("decoder_%d" % (skip_layer + 1)):
                if decoder_layer == 0:
                    input = layers[-1]
                else:
                    input = tf.concat([layers[-1], layers[skip_layer]], axis=3)

                activation_fxn = tf.nn.relu(input)
                output = deconv(activation_fxn, out_channels)
                output = batchnorm(output)

                if dropout > 0.0:
                    output = tf.nn.dropout(output, keep_prob=1 - dropout)

                layers.append(output)

        with tf.variable_scope("decoder_1"):
            input = tf.concat([layers[-1], layers[0]], axis=3)
            activation_fxn = tf.nn.relu(input)
            output = deconv(activation_fxn, generator_outputs_channels)
            output = tf.tanh(output)
            layers.append(output)

        return layers[-1]

def create_model(inputs, targets):
    def create_discriminator(discrim_inputs, discrim_targets):
        n_layers = 3
        layers = []

        # 2x [batch, height, width, in_channels] => [batch, height, width, in_channels * 2]
        input = tf.concat([discrim_inputs, discrim_targets], axis=3)

        # layer_1: [batch, 256, 256, in_channels * 2] => [batch, 128, 128, disc_filter]
        with tf.variable_scope("layer_1"):
            convolved = conv(input, disc_filter, stride=2)
            activation_fxn = lrelu(convolved, 0.2)
            layers.append(activation_fxn)

        for i in range(n_layers):
            with tf.variable_scope("layer_%d" % (len(layers) + 1)):
                out_channels = disc_filter * min(2**(i+1), 8)
                stride = 1 if i == n_layers - 1 else 2  # last layer here has stride 1
                convolved = conv(layers[-1], out_channels, stride=stride)
                normalized = batchnorm(convolved)
                activation_fxn = lrelu(normalized, 0.2)
                layers.append(activation_fxn)

        with tf.variable_scope("layer_%d" % (len(layers) + 1)):
            convolved = conv(activation_fxn, out_channels=1, stride=1)
            output = tf.sigmoid(convolved)
            layers.append(output)

        return layers[-1]

    with tf.variable_scope("generator") as scope:
        output_channels = int(targets.get_shape()[-1])
        outputs = create_generator(inputs, output_channels)

    with tf.name_scope("real_discriminator"):
        with tf.variable_scope("discriminator"):
            predict_real = create_discriminator(inputs, targets)

    with tf.name_scope("fake_discriminator"):
        with tf.variable_scope("discriminator", reuse=True):
            predict_fake = create_discriminator(inputs, outputs)

    with tf.name_scope("discriminator_loss"):
        discrim_loss = tf.reduce_mean(-(tf.log(predict_real + EPS) + tf.log(1 - predict_fake + EPS)))

    with tf.name_scope("generator_loss"):
        gen_loss_GAN = tf.reduce_mean(-tf.log(predict_fake + EPS))
        gen_loss_L1 = tf.reduce_mean(tf.abs(targets - outputs))
        gen_loss = gen_loss_GAN * gan_weight + gen_loss_L1 * l1_weight

    with tf.name_scope("discriminator_train"):
        discrim_tvars = [var for var in tf.trainable_variables() if var.name.startswith("discriminator")]
        discrim_optim = tf.train.AdamOptimizer(lr, beta1)
        discrim_grads_and_vars = discrim_optim.compute_gradients(discrim_loss, var_list=discrim_tvars)
        discrim_train = discrim_optim.apply_gradients(discrim_grads_and_vars)

    with tf.name_scope("generator_train"):
        with tf.control_dependencies([discrim_train]):
            gen_tvars = [var for var in tf.trainable_variables() if var.name.startswith("generator")]
            gen_optim = tf.train.AdamOptimizer(lr, beta1)
            gen_grads_and_vars = gen_optim.compute_gradients(gen_loss, var_list=gen_tvars)
            gen_train = gen_optim.apply_gradients(gen_grads_and_vars)

    ema = tf.train.ExponentialMovingAverage(decay=0.99)
    update_losses = ema.apply([discrim_loss, gen_loss_GAN, gen_loss_L1])

    global_step = tf.contrib.framework.get_or_create_global_step()
    incr_global_step = tf.assign(global_step, global_step+1)

    return Model(
        predict_real=predict_real,predict_fake=predict_fake,discrim_loss=ema.average(discrim_loss),discrim_grads_and_vars=discrim_grads_and_vars,
        gen_loss_GAN=ema.average(gen_loss_GAN),gen_loss_L1=ema.average(gen_loss_L1),gen_grads_and_vars=gen_grads_and_vars,
        outputs=outputs,train=tf.group(update_losses, incr_global_step, gen_train),)

def save_images(fetches, step=None):
    image_dir = os.path.join(output_dir, "images")
    if not os.path.exists(image_dir):
        os.makedirs(image_dir)

    output_imgs = []
    for i, in_path in enumerate(fetches["paths"]):
        name, _ = os.path.splitext(os.path.basename(in_path.decode("utf8")))
        fileset = {"name": name, "step": step}
        for kind in ["inputs", "outputs"]:
            filename = name + "-" + kind + ".png"
            fileset[kind] = filename
            out_path = os.path.join(image_dir, filename)
            contents = fetches[kind][i]
            with open(out_path, "wb") as f:
                f.write(contents)
        output_imgs.append(fileset)
    return output_imgs

def main():

    checkpoint = "checkpoint"
    seed = 0
    if seed is None:
        seed = random.randint(0, 2**31 - 1)

    tf.set_random_seed(seed)
    np.random.seed(seed)
    random.seed(seed)

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    examples = load_examples()
    print("examples count = %d" % examples.count)


    model = create_model(examples.inputs, examples.targets)



    inputs = (examples.inputs)
    targets = (examples.targets)
    outputs = (model.outputs)

    def convert(image):
        image = tf.image.resize_images(image, [scale_size, scale_size], method=tf.image.ResizeMethod.AREA)
        return tf.image.convert_image_dtype(image, dtype=tf.uint8, saturate=True)

    # reverse any processing on images so they can be written to disk or displayed to user
    with tf.name_scope("convert_inputs"):
        converted_inputs = convert(inputs)

    with tf.name_scope("convert_targets"):
        converted_targets = convert(targets)

    with tf.name_scope("convert_outputs"):
        converted_outputs = convert(outputs)

    with tf.name_scope("encode_images"):
        display_fetches = {
            "paths": examples.paths,
            "inputs": tf.map_fn(tf.image.encode_png, converted_inputs, dtype=tf.string, name="input_pngs"),
            "outputs": tf.map_fn(tf.image.encode_png, converted_outputs, dtype=tf.string, name="output_pngs"),
        }

    # summaries
    with tf.name_scope("inputs_summary"):
        tf.summary.image("inputs", converted_inputs)

    with tf.name_scope("targets_summary"):
        tf.summary.image("targets", converted_targets)

    with tf.name_scope("outputs_summary"):
        tf.summary.image("outputs", converted_outputs)

    with tf.name_scope("predict_real_summary"):
        tf.summary.image("predict_real", tf.image.convert_image_dtype(model.predict_real, dtype=tf.uint8))

    with tf.name_scope("predict_fake_summary"):
        tf.summary.image("predict_fake", tf.image.convert_image_dtype(model.predict_fake, dtype=tf.uint8))

    tf.summary.scalar("discriminator_loss", model.discrim_loss)
    tf.summary.scalar("generator_loss_GAN", model.gen_loss_GAN)
    tf.summary.scalar("generator_loss_L1", model.gen_loss_L1)

    for var in tf.trainable_variables():
        tf.summary.histogram(var.op.name + "/values", var)

    for grad, var in model.discrim_grads_and_vars + model.gen_grads_and_vars:
        tf.summary.histogram(var.op.name + "/gradients", grad)

    with tf.name_scope("parameter_count"):
        parameter_count = tf.reduce_sum([tf.reduce_prod(tf.shape(v)) for v in tf.trainable_variables()])

    saver = tf.train.Saver(max_to_keep=1)

    logdir = output_dir
    sv = tf.train.Supervisor(logdir=logdir, save_summaries_secs=0, saver=None)
    with sv.managed_session() as sess:
        print("parameter_count =", sess.run(parameter_count))

        if checkpoint is not None:
            print("loading model from checkpoint")
            checkpoint = tf.train.latest_checkpoint(checkpoint)
            saver.restore(sess, checkpoint)

        max_steps = 2000
        if max_epochs is not None:
            max_steps = examples.steps_per_epoch * max_epochs



        max_steps = min(examples.steps_per_epoch, max_steps)
        for step in range(max_steps):
            print(step)
            results = sess.run(display_fetches)
            output_imgs = save_images(results)


main()

