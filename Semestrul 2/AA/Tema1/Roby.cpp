#include <iostream>
#include <vector>
using namespace std;
struct punct {
    float x, y;
};
int n;
vector<punct> points;
int Left, Right, touch;
int main() {
    // citire date
    cin >> n;
    points.resize(n);
    for (int i=0; i<n; i++){
        cin >> points[i].x >> points[i].y;
    }
    // se calculeaza panta pentru cate 3 puncte in parte
    float panta; // p q r
    for(int i=0; i<n-2; i++){
        panta = (points[i+1].x - points[i].x) * (points[i+2].y - points[i].y) -
                (points[i+1].y - points[i].y) * (points[i+2].x - points[i].x);
        if (panta < 0)
            Right++;
        else
        if (panta == 0)
            touch ++;
        else
            Left ++ ;
    }
    // verificare p_(n-2), p_(n-1), p_0
    //              p        q       r
    panta = (points[n-1].x - points[n-2].x) * (points[0].y - points[n-2].y) -
            (points[n-1].y - points[n-2].y) * (points[0].x - points[n-2].x);

    if (panta < 0)
        Right++;
    else
    if (panta == 0)
        touch ++;
    else
        Left ++ ;
    cout << Left << " " << Right << " " << touch << endl;
    return 0;
}
