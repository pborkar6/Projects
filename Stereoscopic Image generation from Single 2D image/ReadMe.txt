A pretrained RESNET model was used to obtain the depth maps from the original 2D images.

stereo.py generates two shifted (Stereoscopic images) from the original image using the depth map.
It also implements hole filling for improving the quality of the images.

The 4 image files contain:
1. cones_color is the original Image
2. cones_4 is the depth map
3. left_holefilled_cones and right_holefilled_cones are the two stereoscopic images.
