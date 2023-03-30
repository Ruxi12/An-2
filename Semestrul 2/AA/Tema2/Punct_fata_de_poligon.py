def inside_polygon(polygon, point):
    """
    Determină dacă un punct este în interiorul, pe latura sau în afara poligonului dat.

    Argumente:
        polygon: o listă de puncte care definesc vârfurile poligonului; fiecare punct este o tuplă de două coordonate (x, y)
        point: un punct pentru care se determină poziția față de poligon; este o tuplă de două coordonate (x, y)

    Rezultat:
        Returnează unul din următoarele:
            - "INTERIOR" dacă punctul se află în interiorul poligonului
            - "BOUNDARY" dacă punctul se află pe una dintre laturile poligonului
            - "EXTERIOR" dacă punctul se află în afara poligonului
    """
    n = len(polygon)
    inside = False
    boundary = False
    x, y = point
    xinters = 1e10
    p1x, p1y = polygon[0]
    for i in range(n + 1):
        p2x, p2y = polygon[i % n]
        # este pe segment, sunt coliniare
        if x >= min(p1x, p2x) and x <= max(p1x, p2x) and y >= min(p1y, p2y) and y <= max(p1y, p2y) and (p1x - x) * (
                p2y - y) == (p1y - y) * (p2x - x):
            return "BOUNDARY"
        # ray intersects p1 p2
        if y > min(p1y, p2y):
            if y <= max(p1y, p2y):
                if x <= max(p1x, p2x):
                    if p1y != p2y:
                        xinters = (y - p1y) * (p2x - p1x) / (p2y - p1y) + p1x

                    if p1x == p2x or x <= xinters:
                        inside = not inside
                if x == xinters:
                    boundary = True
        p1x, p1y = p2x, p2y

    if boundary:
        return "BOUNDARY"
    elif inside:
        return "INSIDE"
    else:
        return "OUTSIDE"


poligon = []
puncte = []
xmax = -1e9
ymax = -1e9

n = int(input())

for i in range(n):
    coord = [int(x) for x in input().split()]
    if coord[1] > ymax:
        ymax = coord[1]
    poligon.append(coord)

n = int(input())

for i in range(n):
    punct = [int(x) for x in input().split()]
    print(inside_polygon(poligon, punct))
