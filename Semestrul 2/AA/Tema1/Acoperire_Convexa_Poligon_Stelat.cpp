#include <iostream>
#include <vector>
#include <stack>
using namespace std;
struct punct {
    long long int x, y;
};
int n;
vector<punct> p;
stack<punct> st;
long long int dist (punct p1, punct p2){
    return (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p1.y) * (p1.y - p2.x);
}
punct nextToTop (){
    punct p = st.top();
    st.pop();
    punct res = st.top();
    st.push(p);
    return res;
}

long long int orientation (punct p, punct q, punct r){
    int val = (q.y-p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);
    if (val == 0)
        return 0; // puncte coliniare
    return (val > 0) ? 1 : 2;
}
int main() {
    // citire date
    cin >> n;
    p.resize(n);
    for (int i=0; i<n; i++){
        cin >> p[i].x >> p[i].y;
    }
    // se cauta cel mai stanga pct - min pe axa x
    int minn = p[0].x, poz = 0;
    for (int i=1; i<n; i++){
        if (p[i].x < minn){
            minn = p[i].x;
            poz = i;
        }
    }
    vector<punct> pct(n+1);
    // se calculeaza determinanti circular incepand cu elem de pe pozitia p
    // creare vector auxiliar - circular
    int j;
    for (j=poz; j<n; j++)
        pct[j-poz] = p[j];

    for (int i=0; i<poz; i++)
        pct[j+i-poz] = p[i];

//    for (int i=0; i<n; i++)
//        cout << pct[i].x << " " ;
    // adaugare pozitie finala - adaugare ultim elem la pct !!!!!!!!
//    pct[n].x = pct[0].x;
//    pct[n].y = pct[0].y;

    // intit stiva cu primele 3 puncte
    st.push(pct[0]);
    st.push(pct[1]);

   for (j=2; j<n; j++){
       while (orientation(nextToTop(), st.top(), pct[j]) != 2){
           st.pop();
       }
       st.push(pct[j]);
   }
   cout << st.size() << endl;
    while (!st.empty()){
        punct p = st.top();
        cout << p.x << " " << p.y << endl;
        st.pop();
    }
    return 0;
}
