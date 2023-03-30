

#include <bits/stdc++.h>
using namespace std;

int main() {
    long n, x, y, poz_st, poz_dr, poz_sus, poz_jos, y_ant, x_ant;
    long x_min=INT_MAX, x_max=INT_MIN, y_min=INT_MAX, y_max=INT_MIN;
    vector<pair<long,long>> puncte;
    cin >> n;
    for (long i = 0; i < n; i++){
        cin >> x >> y;
        puncte.push_back(make_pair(x, y));
        // aflu extremitatile
        if(x < x_min){ x_min = x; poz_st=i;}
        if(x > x_max){ x_max = x; poz_dr=i;}
        if(y < y_min){ y_min = y; poz_jos=i;}
        if(y > y_max){ y_max = y; poz_sus=i;}
    }
    puncte.push_back(puncte[0]);


//--------- x monoton ----------------------------------------------------

    bool x_monoton = true;

    // partea de sus
    if(poz_st>poz_dr) {
        x_ant = puncte[poz_st].first; //  pornesc verificarea din pct maxim
        for(long i = poz_st; i>=poz_dr; i--) {
            if (puncte[i].first < x_ant) { // muchie in stanga
                x_monoton = false;
                break;
            }
            // actualizare x anterior
            x_ant = puncte[i].first;
        }
    }
    else{
        x_ant = puncte[poz_st].first; //  pornesc verificarea din pct maxim
        for(long i=poz_st;i>=0;i--) {
            if (puncte[i].first < x_ant) { // muchie in stanga
                x_monoton = false;
                break;
            }
            // actualizare x anterior
            x_ant = puncte[i].first;
        }
        // daca nu ajunge pana la pct minim
        for(long i=puncte.size()-2; i>=poz_dr; i--) {
            if (puncte[i].first < x_ant) { // muchie in stanga
                x_monoton = false;
                break;
            }
            // actualizare x anterior
            x_ant = puncte[i].first;
        }
    }
    // partea de jos
    if(poz_st<poz_dr) {
        x_ant = puncte[poz_st].first; //  pornesc verificarea din pct cel mai din st
        for (long i = poz_st; i <= poz_dr; i++) {
            if (puncte[i].first < x_ant) { // muchie in stanga
                x_monoton = false;
                break;
            }
            // actualizare x anterior
            x_ant = puncte[i].first;
        }
    }
    else{
        x_ant = puncte[poz_st].first; //  pornesc verificarea din pct cel mai din st
        for(long i=poz_st; i<puncte.size(); i++) {
            if (puncte[i].first < x_ant) { // muchie in stanga
                x_monoton = false;
                break;
            }
            // actualizare x anterior
            x_ant = puncte[i].first;
        }
        // daca nu ajunge pana la pct minim
        for(long i=1;i<=poz_dr; i++) {
            if (puncte[i].first < x_ant) { // muchie in stanga
                x_monoton = false;
                break;
            }
            // actualizare x anterior
            x_ant = puncte[i].first;
        }
    }

    if(x_monoton == true)
        cout<<"YES"<<endl;
    else
        cout<<"NO"<<endl;


//--------- y monoton ----------------------------------------------------

    bool y_monoton = true;

    // partea din dreapta
    if(poz_jos<poz_sus) {
        y_ant = puncte[poz_sus].second; //  pornesc verificarea din pct maxim
        for(long i = poz_sus; i>=poz_jos; i--) {
            if (puncte[i].second > y_ant) { // muchie in sus
                y_monoton = false;
                break;
            }
            // actualizare y anterior
            y_ant = puncte[i].second;
        }
    }
    else{
        y_ant = puncte[poz_sus].second; //  pornesc verificarea din pct maxim
        for(long i=poz_sus;i>=0;i--) {
            if (puncte[i].second > y_ant) { // muchie in sus
                y_monoton = false;
                break;
            }
            // actualizare y anterior
            y_ant = puncte[i].second;
        }
        // daca nu ajunge pana la pct minim
        for(long i=puncte.size()-2; i>=poz_jos; i--) {
            if (puncte[i].second > y_ant) { // muchie in sus
                y_monoton = false;
                break;
            }
            // actualizare y anterior
            y_ant = puncte[i].second;
        }

    }
    // partea din stanga
    if(poz_sus<poz_jos) {
        y_ant = puncte[poz_sus].second; //  pornesc verificarea din pct maxim
        for (long i = poz_sus; i <= poz_jos; i++) {
            if (puncte[i].second > y_ant) { // muchie in sus
                y_monoton = false;
                break;
            }
            // actualizare y anterior
            y_ant = puncte[i].second;
        }
    }
    else{
        y_ant = puncte[poz_sus].second; //  pornesc verificarea din pct maxim
        for(long i=poz_sus; i<puncte.size(); i++) {
            if (puncte[i].second > y_ant) { // muchie in sus
                y_monoton = false;
                break;
            }
            // actualizare y anterior
            y_ant = puncte[i].second;
        }
        // daca nu ajunge pana la pct minim
        for(long i=1;i<=poz_jos; i++) {
            if (puncte[i].second > y_ant) { // muchie in sus
                y_monoton = false;
                break;
            }
            // actualizare y anterior
            y_ant = puncte[i].second;
        }
    }

    if(y_monoton == true)
        cout<<"YES"<<endl;
    else
        cout<<"NO"<<endl;

}

