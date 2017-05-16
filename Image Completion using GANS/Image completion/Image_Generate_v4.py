from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import tensorflow as tf
import numpy as np
import argparse
import os
import glob
import random
import collections
import math
import time

EPS = 1e-12
input_dir = "input"
mode = "train"
output_dir = "output_test"
checkpoint = None #"checkpoint"
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

    input_paths = glob.glob(os.path.join(input_dir, "*.png"))
    decode = tf.image.decode_png

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

        input = tf.concat([discrim_inputs, discrim_targets], axis=3)

        with tf.variable_scope("layer_1"):
            convolved = conv(input, disc_filter, stride=2)
            activation_fxn = lrelu(convolved, 0.2)
            layers.append(activation_fxn)

        for i in range(n_layers):
            with tf.variable_scope("layer_%d" % (len(layers) + 1)):
                out_channels = disc_filter * min(2**(i+1), 8)
                stride = 1 if i == n_layers - 1 else 2
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

def main():
    checkpoint = "checkpoint"
    seed = 0
    if seed is None:
        seed = random.randint(0, 2**31 - 1)

    tf.set_random_seed(seed)
    np.random.seed(seed)
    random.seed(seed)

    examples = load_examples()
    print("examples count = %d" % examples.count)


    model = create_model(examples.inputs, examples.targets)

    inputs = (examples.inputs)
    targets =(examples.targets)
    outputs =(model.outputs)



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

        # training
        start = time.time()

        for step in range(max_steps):
            print(step)
            def should(freq):
                return freq > 0 and ((step + 1) % freq == 0 or step == max_steps - 1)

            options = None
            run_metadata = None

            fetches = {
                "train": model.train,
                "global_step": sv.global_step,
            }

            if should(progress_freq):
                fetches["discrim_loss"] = model.discrim_loss
                fetches["gen_loss_GAN"] = model.gen_loss_GAN
                fetches["gen_loss_L1"] = model.gen_loss_L1


            results = sess.run(fetches, options=options, run_metadata=run_metadata)


            if should(progress_freq):
                train_epoch = math.ceil(results["global_step"] / examples.steps_per_epoch)
                train_step = (results["global_step"] - 1) % examples.steps_per_epoch + 1
                rate = (step + 1) * batch_size / (time.time() - start)
                remaining = (max_steps - step) * batch_size / rate
                print("progress  epoch %d  step %d  image/sec %0.1f  remaining %dm" % (train_epoch, train_step, rate, remaining / 60))
                print("discriminator_loss", results["discrim_loss"])
                print("gen_loss_GAN", results["gen_loss_GAN"])
                print("gen_loss_L1", results["gen_loss_L1"])

            if should(save_freq):
                print("saving model")
                saver.save(sess, os.path.join(output_dir, "model"), global_step=sv.global_step)

            if sv.should_stop():
                break
main()



