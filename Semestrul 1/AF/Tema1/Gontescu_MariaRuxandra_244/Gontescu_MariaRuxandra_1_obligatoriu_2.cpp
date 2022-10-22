#include <iostream>
#include <vector>
#include <algorithm>
#include <fstream>
using namespace std;
vector <int> pozitie, rezultat;
bool functie(int i, int j) {
    return (pozitie[i] < pozitie[j]);
}
void dfs(int nod, vector<int> &sel, vector<vector<int>>& lista_ad) {
    rezultat.push_back(nod);
    sel[nod] = 1;
    for(auto vec: lista_ad[nod]){
        if(!sel[vec])
            dfs(vec, sel, lista_ad);
    }
}
int main() {
    int n, m, x;
    ifstream f ("graf.in");
    f >> n >> m;
    pozitie.resize(n+1);
    vector<int> sel(n + 1, 0), perm;
    vector<vector<int>> lista_ad(n+1);
    for(int i = 1; i <= n ; i++) {
        f >> x;
        // se retine permutarea
        perm.push_back(x);
        //se retine pozitia nodului in permutare
        pozitie[x] = i;
    }
    // creare liste de adiacenta
    for(int i = 1; i <= m; i++) {
        int a, b;
        f >> a >> b;
        lista_ad[a].push_back(b);
        lista_ad[b].push_back(a);
    }
//    for(int i = 1; i <= n; i++){
//        cout << i << " : ";
//        for (int j = 0; j<lista_ad[i].size(); j++)
//            cout << lista_ad[i][j] << " ";
//        cout << endl;
//    }
//    cout << endl;
    f.close();
    //sortare liste de adiacenta in functie de pozitia in permutare
    for(int i = 1; i <= n; i++)
        sort(lista_ad[i].begin(), lista_ad[i].end(), functie);

//    for(int i = 1; i <= n; i++){
//        cout << i << " : ";
//        for (int j = 0; j<lista_ad[i].size(); j++)
//            cout << lista_ad[i][j] << " ";
//        cout << endl;
//    }
    // traversare graf
    dfs(1, sel, lista_ad);
    // interpretare rezultate
    if(perm != rezultat)
        cout << 0;
    else
        cout << 1;
    return 0;
}
//o(v+e) - lista de adiacenta DFS
