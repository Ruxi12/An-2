
def intersectie(semiplane):
    maximX, maximY = 9999999999, 9999999999
    minimX, minimY = -9999999999, -9999999999

    for semiplan in semiplane:
        stanga = -9999999999
        dreapta = 9999999999
        # verificare semiplan vertical
        if semiplan[0] == 0:
            if semiplan[1] < 0: # ne aflam in partea stanga a planului
                #se calc cood x a punctului de intersectie dintre semiplan si
                # axa Ox
                stanga = -1 * semiplan[2] / semiplan[1]
            else:
                dreapta = -1 * semiplan[2] / semiplan[1]
        else: # este semiplan orizontal
            if semiplan[0] < 0:  # ne aflam in partea stanga a planului
                # se calc cood x a punctului de intersectie dintre semiplan si
                # axa Ox
                stanga = -1 * semiplan[2] / semiplan[0]
            else:
                dreapta = -1 * semiplan[2] / semiplan[0]
        # vertical
        if semiplan[0] == 0:
            minimY = max(minimY, stanga)
            maximY = min(maximY, dreapta)
        else: #orizontal
            minimX = max(minimX, stanga)
            maximX = min(maximX, dreapta)
    # verificare intersectie vida
    if minimY > maximX or minimX > maximX:
        return 0
    # intersectie nevida, marginita
    if (minimX != -9999999999 and maximX != 9999999999)  and (minimY != -9999999999 and maximY != 9999999999):
        return 1
    # intersectie nevida, nemarginita
    return 2

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # citire date
    n = int(input())
    semiplane = []
    for i in range(n):
        line = input().split()
        semiplan = (float(line[0]), float(line[1]), float(line[2]))
        semiplane.append(semiplan)
    output = intersectie(semiplane)
    if output == 0:
        print("VOID")
    else:
        if output == 1:
            print("BOUNDED")
        else:
            print("UNBOUNDED")
