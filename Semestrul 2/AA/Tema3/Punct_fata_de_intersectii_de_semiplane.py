
def intersectie(semiplane, Q):
    maximX, maximY = 9999999999, 9999999999
    minimX, minimY = -9999999999, -9999999999

    for semiplan in semiplane:
        # verificare semiplan vertical
        if semiplan[0] == 0:
            # vedem in ce parte a semiplanului se afla Q
            if (semiplan[2] + semiplan[1] * Q[1]) >= 0:  # ecuatia dreptei care defineste semiplanul in functie de Qy
                continue # se afla in partea gresita
        else:
            if (semiplan[2] + semiplan[0] * Q[0]) >= 0: # semiplanul in functie de Qx
                continue

        if semiplan[0] == 0:
            # coordonata y a punctului de intersecție al semiplanei cu axa y.
            if -1 * semiplan[2] / semiplan[1] < Q[1]:
                # intersectia se afla deasupra deasupra lui Q
                minimY = max(minimY, -1 * semiplan[2] / semiplan[1])
            else:
                maximY = min(maximY, -1 * semiplan[2] / semiplan[1])
        else:
            if -1 * semiplan[2] / semiplan[0] < Q[0]:
                minimX = max(minimX, -1 * semiplan[2] / semiplan[0])
            else:
                maximX = min(maximX, -1 * semiplan[2] / semiplan[0])

    if max(maximX, maximY) == 9999999999 or min(minimX, minimY) == -9999999999:
        return 0  # nu exista dreptunghiuri
    return (maximX - minimX) * (maximY - minimY)  # calculez valoarea ariilor


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # citire date
    n = int(input())
    semiplane = []
    for i in range(n):
        line = input().split()
        semiplan = (float(line[0]), float(line[1]), float(line[2]))
        semiplane.append(semiplan)

    m = int(input())
    for i in range(m):
        linie = input().split()
        result = intersectie(semiplane, (float(linie[0]), float(linie[1])))
        if result == 0:
            print("NO")
        else:
            print("YES")
            print(result)
