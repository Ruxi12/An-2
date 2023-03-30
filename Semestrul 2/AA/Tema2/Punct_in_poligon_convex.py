class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y


def crossProduct(a, b):
    return a.x * b.y - b.x * a.y


def squaredDistance(a, b):
    return (a.x - b.x) * 2 + (a.y - b.y) * 2


def orientation(segment_point1, segment_point2, exterior_point):
    P, Q, R = segment_point1, segment_point2, exterior_point
    return Q.x * R.y + P.x * Q.y + P.y * R.x - Q.x * P.y - Q.y * R.x - P.x * R.y


def onSegment(p, q, r):
    if max(p.x, r.x) >= q.x >= min(p.x, r.x) and max(p.y, r.y) >= q.y >= min(p.y, r.y):
        return True
    return False


def checkPointInsidePolygon(x, y, polygonPoints):
    p1 = Point(polygonPoints[-1].x - polygonPoints[0].x, polygonPoints[-1].y - polygonPoints[0].y)
    p2 = Point(polygonPoints[1].x - polygonPoints[0].x, polygonPoints[1].y - polygonPoints[0].y)
    pq = Point(x - polygonPoints[0].x, y - polygonPoints[0].y)

    boundary = False
    aux = Point(x, y)
    if (orientation(polygonPoints[0], polygonPoints[numberOfPolygonPoints - 1], aux) == 0 and
            onSegment(polygonPoints[0], aux, polygonPoints[numberOfPolygonPoints - 1])):
        print("BOUNDARY")
        boundary = True
        return False, boundary

    if orientation(polygonPoints[0], polygonPoints[1], aux) == 0 and onSegment(polygonPoints[0], aux, polygonPoints[1]):
        print("BOUNDARY")
        boundary = True
        return False, boundary

    last = numberOfPolygonPoints - 2
    first = 2
    while orientation(polygonPoints[0], polygonPoints[last + 1], polygonPoints[last]) == 0:
        if (orientation(polygonPoints[0], polygonPoints[last], aux) == 0 and
                onSegment(polygonPoints[0], aux, polygonPoints[last])):
            print("BOUNDARY")
            boundary = True
            return False, boundary
        last -= 1

    while orientation(polygonPoints[0], polygonPoints[first - 1], polygonPoints[first]) == 0:
        if (orientation(polygonPoints[0], polygonPoints[first], aux) == 0 and
                onSegment(polygonPoints[0], aux, polygonPoints[first])):
            print("BOUNDARY")
            boundary = True
            return False, boundary
        first += 1

    # q is on the opposite side of the line defined by p1 and p2 than the vector pq.
    if not (crossProduct(p1, pq) <= 0 and crossProduct(p2, pq) >= 0):
        return False, boundary

    left, right = 0, len(polygonPoints)
    while right - left > 1:
        mid = (left + right) // 2
        cur = Point(polygonPoints[mid].x - polygonPoints[0].x, polygonPoints[mid].y - polygonPoints[0].y)

        if crossProduct(cur, pq) < 0:
            right = mid
        else:
            left = mid

    if (orientation(polygonPoints[left], polygonPoints[left + 1], aux) == 0 and
            onSegment(polygonPoints[left], aux, polygonPoints[left + 1])):
        print("BOUNDARY")
        boundary = True
        return False, boundary

    if left == len(polygonPoints) - 1:
        return squaredDistance(polygonPoints[0], Point(x, y)) <= squaredDistance(polygonPoints[0],
                                                                                 polygonPoints[left]), boundary
    else:
        l_l1 = Point(polygonPoints[left + 1].x - polygonPoints[left].x,
                     polygonPoints[left + 1].y - polygonPoints[left].y)
        lq = Point(x - polygonPoints[left].x, y - polygonPoints[left].y)
        return crossProduct(l_l1, lq) >= 0, boundary


def chooseStartPoint(polygonPoints):
    min_x = 1e9 + 5
    max_y = -1e9 - 5
    min_i = 0
    for i in range(len(polygonPoints)):
        if polygonPoints[i].x < min_x or (polygonPoints[i].x == min_x and polygonPoints[i].y > max_y):
            min_x = polygonPoints[i].x
            max_y = polygonPoints[i].y
            min_i = i

    polygonPoints[:] = polygonPoints[min_i:] + polygonPoints[:min_i]


numberOfPolygonPoints = int(input())

_polygonPoints = list(Point(int(x), int(y)) for x, y in (input().split() for _ in range(numberOfPolygonPoints)))

chooseStartPoint(_polygonPoints)

numberOfCheckPoints = int(input())
checkPoints = list(Point(int(x), int(y)) for x, y in (input().split() for _ in range(numberOfCheckPoints)))

for i in range(numberOfCheckPoints):
    answer, boundary = checkPointInsidePolygon(checkPoints[i].x, checkPoints[i].y, _polygonPoints)
    if not boundary:
        print("INSIDE" if answer else "OUTSIDE")
