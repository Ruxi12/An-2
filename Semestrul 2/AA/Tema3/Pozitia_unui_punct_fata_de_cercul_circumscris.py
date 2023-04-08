# se citesc coordonatele triunghiului
linie = input().split()
x1 = int(linie[0])
y1 = int(linie[1])
linie = input().split()
x2 = int(linie[0])
y2 = int(linie[1])
linie = input().split()
x3 = int(linie[0])
y3 = int(linie[1])

# determinantul format de varfurile triunghiului
det = (x1 * y2) + (x2 * y3) + (x3 * y1) - (y1 * x2) - (y2 * x3) - (y3 * x1)
# se obtin coordonatele centrului cercului circumscris
x_c = (((x1 ** 2 + y1 ** 2) * (y2 - y3)) + ((x2 ** 2 + y2 ** 2) * (y3 - y1)) + ((x3 ** 2 + y3 ** 2) * (y1 - y2))) / (2 * det)
y_c = -(((x1 ** 2 + y1 ** 2) * (x2 - x3)) + ((x2 ** 2 + y2 ** 2) * (x3 - x1)) + ((x3 ** 2 + y3 ** 2) * (x1 - x2))) / (2 * det)
#print(x_c, y_c)
# raza
import math
r = math.sqrt((x1 - x_c) ** 2 + (y1 - y_c) ** 2)


m = int(input())
point = [0, 0]
while m != 0:
    point = input().split()
    point[0] = int(point[0])
    point[1] = int(point[1])
    # distanta dintre punct si centrul cercului
    d = math.sqrt((point[0] - x_c) ** 2 + (point[1] - y_c) ** 2)
    if abs(d - r) < 1e-6:
        print("BOUNDARY")
    elif d < r:
        print("INSIDE")
    else:
        print("OUTSIDE")
    m -= 1
