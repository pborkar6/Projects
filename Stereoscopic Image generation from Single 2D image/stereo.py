# -*- coding: utf-8 -*-
"""
Created on Mon Apr 03 16:12:37 2017

@author: Pranjali
"""

import numpy as np
import cv2
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from skimage import morphology


I= cv2.imread('yay_4.png')    #depth image
I= cv2.cvtColor( I, cv2.COLOR_RGB2GRAY)
m,n=I.shape
original=cv2.imread('Capture1.png')   # Original image

M,N,C=original.shape
O=cv2.resize(original,(n,m))
cv2.imwrite('cones_original_2.png',O)


Ol=cv2.resize(O,(n,m))
Or=cv2.resize(O,(n,m))

holesL=np.zeros(Ol.shape)-2000
holesR=np.zeros(Or.shape)-2000

parallax=np.zeros(I.shape)

MM=5.75						# Recommended Interocular distance value
p=np.zeros(I.shape,dtype=float)
parallax=MM*(1-(np.float64(I)/255)) 		# Parallax value generation


left=np.zeros(O.shape)
right=np.zeros(O.shape)

ratio=m*n/100000
for i in range (0,m):
    for j in range (0,n):
        sh=ratio*(parallax[i][j])/2;			
        if(int(j-sh)>0):
            Ol[i][int(j-sh)]=np.float64(O[i][j])
            holesL[i][int(j-sh)]=np.float64(O[i][j])
        if(int(j+sh)<m):
            Or[i][int(j+sh)]=np.float64(O[i][j])
            holesR[i][int(j-sh)]=np.float64(O[i][j])

### Hole Filling ########################################################################            
for c in range(0,C):         
    for i in range (0,m):
        for j in range (0,n):
            if(holesL[i][j][c]==-2000):
                holesL[i][j][c]=np.uint8(255)
            else:
                holesL[i][j][c]=np.uint8(0)
cv2.imwrite('left_mask.png',holesL)
holesL = np.uint8(holesL)
for c in range(0,C):         
    for i in range (0,m):
        for j in range (0,n):
            if(holesR[i][j][c]==-2000):
                holesR[i][j][c]=np.uint8(255)
            else:
                holesR[i][j][c]=np.uint8(0)
cv2.imwrite('right_mask.png',holesR)
holesR = np.uint8(holesR)

dstL = cv2.inpaint(Ol,holesL[:,:,0],3,cv2.INPAINT_TELEA)		#inpainting
dstR = cv2.inpaint(Or,holesR[:,:,0],3,cv2.INPAINT_TELEA)

cv2.imwrite('left_holesfilled_sofa.png',dstL)
cv2.imwrite('right_holesfilled_sofa.png',Or)

result=np.zeros([128,320,3],dtype='uint8')
result[:,0:160,:]=dstL
result[:,160:320,:]=dstR
cv2.imwrite('result.png',result)

cv2.imwrite('left.png',Ol)
cv2.imwrite('right.png',Or)


bl,gl,rl = cv2.split(dstL)
br,gr,rr = cv2.split(dstR)

R=cv2.merge((bl,gl,rr))
cv2.imwrite('anaglyph.png',R)



 











 
              

        