
import cv2
import glob
from os import listdir
from os.path import isfile, join
import numpy as np

input_path='final_input'
output_path='final_output'
input_imgs = [f for f in listdir(input_path) if isfile(join(input_path,f))]
output_imgs = [f for f in listdir(output_path) if isfile(join(output_path,f))]
count = 0
for n in range(0, len(input_imgs)):

    target = cv2.imread(join(input_path, input_imgs[n]))
    cv2.imwrite('target.jpg', target)
    gen = cv2.imread(join(output_path, output_imgs[n]))
    
    M, N, C = np.shape(gen)
    for i in range(0,M):
        for j in range(0, N):
            
            if(target[i, j, 0] >= 0 and target[i, j, 0] < 35) and (target[i,j,1]>=0 and target[i,j,1]<35) and (target[i,j,2]>=0 and target[i,j,2]<35):
                count += 1
                target[i, j, :] = gen[i, j, :]

    target = cv2.resize(target, (1024, 128))
    nn = n
    cv2.imwrite(str(501+nn)+'-result.jpg', target)
    nn = +1


    



