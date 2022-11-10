from math import floor
import cv2 as cv

img = cv.resize(cv.cvtColor(cv.imread("./image.jpg"),cv.COLOR_RGB2GRAY),(32,31))

odd = []
golden = []
tmp1 = []
tmp2 = []
times = 1

for i in range(31):
    if (i%2 == 0):
        for j in range(32):
            odd.append(hex(img[i][j]))
            
with open("img.dat","w",encoding="utf-8") as f:
    for item in odd:
        f.write(item[2:])
        f.write("\n")



while times != 16:
    if len(tmp1) != 32:
        tmp1.append(odd.pop(0))
    elif len(tmp2) != 32:
        tmp2.append(odd.pop(0))
    else:
        for i in range(32):
            if (i == 0 or i == 31):
                golden.append(hex(floor((int(tmp1[i],16)+int(tmp2[i],16))/2))[2:])
            else:
                D1 = abs(int(tmp1[i-1],16)-int(tmp2[i+1],16))
                D2 = abs(int(tmp1[i],16)-int(tmp2[i],16))
                D3 = abs(int(tmp1[i+1],16)-int(tmp2[i-1],16))               
                if D2 <= D1 and D2 <= D3:
                    golden.append(hex(floor((int(tmp1[i],16)+int(tmp2[i],16))/2))[2:])
                elif D1 <= D3 and D1 <= D2:
                    golden.append(hex(floor((int(tmp1[i-1],16)+int(tmp2[i+1],16))/2))[2:])
                else:
                    golden.append(hex(floor((int(tmp1[i+1],16)+int(tmp2[i-1],16))/2))[2:])
        tmp1 = tmp2
        tmp2 = []
        times = times + 1

odd = []
for i in range(31):
    if (i%2 == 0):
        for j in range(32):
            odd.append(hex(img[i][j]))


with open("golden.dat","w",encoding="utf-8") as f:
    for i in range(992):
        if (i // 32) % 2 == 0:
            f.write(odd.pop(0)[2:])
            f.write("\n")
        else:
            f.write(golden.pop(0))
            f.write("\n")

