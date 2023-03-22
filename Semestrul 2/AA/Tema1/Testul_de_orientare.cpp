#include <iostream>
using namespace std;
struct punct{
    float x, y;
};
int t;
punct p, q, r;
float panta;
int main() {
    // citire date
    cin >> t;
    while (t--){
        cin >> p.x >> p.y;
        cin >> q.x >> q.y;
        cin >> r.x >> r.y;
        //panta = (r.y - q.y)/(r.x - q.x) - (q.y - p.y)/(q.x - p.x);
        // se calculeaza panta
        panta = (q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x);
        if (panta < 0)
            cout << "RIGHT\n";
        else
            if (panta == 0)
                cout << "TOUCH\n";
            else
                cout << "LEFT\n";

    }
    return 0;
}
