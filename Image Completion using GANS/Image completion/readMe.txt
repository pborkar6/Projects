
Contents of the Folder - 
Image_Generate_v4.py takes in the incomplete images and the complete images and trains a conditional GAN on it. 
Testing_v4.py - Runs the model on the test images
post_processing - superimposes the generated image strips on the incomplete images



The final design is chosen based on the pix2pix paper. I’ve trained GANs for an assignment and I have first hand knowledge that DC-GANs are very hard to train, especially on larger images. Mode collapse is common. So, though I found some papers which used DC-GANs for image inpainting, I chose conditional GANs, since the pix2pix paper states that the model works well with small datasets also. 

Our generator is an auto encoder, with 7 layers in encoder and 7 layers in decoder. The paper stated the stride length is 2. Since we used an image size of 128 x 128, we adjusted the number of layers accordingly. 

The discriminator is a 3 layer convolutional net. 
Since it is a conditional GAN, the discriminator and generator are both conditionally dependent on the target (complete/original image). The number of filters in both generator and discriminator were chosen as 64 and then upsampled/ downsampled to match the final data shapes. The amount of up sampling and downsampling for each layer was done via trial and error.  



**Note** 

Some tasks were manually handled, like copying some images in the right folders, etc. testing_v4.py generates inputs and outputs into the same folder. These were manually separated for running post_processing.py. 
To run, system requires, python 3.5, Tensorflow 1.0.1, openCV 3. 
Images must be placed in the right folders. 


