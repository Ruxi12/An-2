# se citesc coordonatele patrulaterului
linie = input().split()
x1 = int(linie[0])   # A
y1 = int(linie[1])
linie = input().split()
x2 = int(linie[0])   #B
y2 = int(linie[1])
linie = input().split()
x3 = int(linie[0])   #C
y3 = int(linie[1])
linie = input().split()
x4 = int(linie[0])    #D
y4 = int(linie[1])


# verificare in triunghi ABC - 123

# determinantul format de varfurile triunghiului
det = (x1 * y2) + (x2 * y3) + (x3 * y1) - (y1 * x2) - (y2 * x3) - (y3 * x1)
# se obtin coordonatele centrului cercului circumscris
x_c = (((x1 ** 2 + y1 ** 2) * (y2 - y3)) + ((x2 ** 2 + y2 ** 2) * (y3 - y1)) + ((x3 ** 2 + y3 ** 2) * (y1 - y2))) / (2 * det)
y_c = -(((x1 ** 2 + y1 ** 2) * (x2 - x3)) + ((x2 ** 2 + y2 ** 2) * (x3 - x1)) + ((x3 ** 2 + y3 ** 2) * (x1 - x2))) / (2 * det)
#print(x_c, y_c)
# raza
import math
r = math.sqrt((x1 - x_c) ** 2 + (y1 - y_c) ** 2)


# distanta dintre punct si centrul cercului
d = math.sqrt((x4 - x_c) ** 2 + (y4 - y_c) ** 2)
# if abs(d - r) < 1e-6:
#     print("BOUNDARY")
# elif d < r:
#     print("INSIDE")
# else:
#     print("OUTSIDE")
if d < r:
    print("AC: ILLEGAL")
else:
    print("AC: LEGAL")

# pentru triunghiul BCD - 234
# determinantul format de varfurile triunghiului
det = (x2 * y3) + (x3 * y4) + (x4 * y2) - (y2 * x3) - (y3 * x4) - (y4 * x2)
# se obtin coordonatele centrului cercului circumscris
x_c = (((x2 ** 2 + y2 ** 2) * (y3 - y4)) + ((x3 ** 2 + y3 ** 2) * (y4 - y2)) + ((x4 ** 2 + y4 ** 2) * (y2 - y3))) / (2 * det)
y_c = -(((x2 ** 2 + y2 ** 2) * (x3 - x4)) + ((x3 ** 2 + y3 ** 2) * (x4 - x2)) + ((x4 ** 2 + y4 ** 2) * (x2 - x3))) / (2 * det)

r = math.sqrt((x2 - x_c) ** 2 + (y2 - y_c) ** 2)
d = math.sqrt((x1 - x_c) ** 2 + (y1 - y_c) ** 2)

if d < r:
    print("BD: ILLEGAL")
else:
    print("BD: LEGAL")
