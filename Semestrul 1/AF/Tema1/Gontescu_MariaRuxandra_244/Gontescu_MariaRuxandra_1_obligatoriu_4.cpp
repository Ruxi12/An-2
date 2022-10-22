#include <iostream>
#include <fstream>
#include <vector>
using namespace std;
int nrVrafuri, nrMuchii;
vector<vector<int>> adjList;
vector<vector<int>> revGraph;
vector<int> topological;
vector<bool> visited;
vector<vector<int>> sol;
vector<int> aux;

void DFS1(int nod){
    visited[nod] = true;
    for (auto& x : adjList[nod]){
        if(!visited[x]){
            DFS1(x);
        }
    }
    topological.push_back(nod);
}
void DFS2(int nod){
    aux.push_back(nod);
    visited[nod] = true;
    for (auto& x: revGraph[nod]){
        if (!visited[x])
            DFS2(x);
    }
}
int main() {
    //citire date
    ifstream f ("ctc.in");
    f >> nrVrafuri >> nrMuchii;
    adjList = vector<vector<int>>(nrVrafuri, vector<int>());
    revGraph = vector<vector<int>>(nrVrafuri, vector<int>());
    visited = vector<bool>(nrVrafuri, false);
    int i;
    int x, y;
    for (i=0; i<nrMuchii; i++){
        f >> x >> y;
        --x;
        --y;
        adjList[x].push_back(y);
        revGraph[y].push_back(x);
    }
    f.close();
    //formare array dupa topological sort
    for (i=0; i<nrVrafuri; i++)
        if(! visited[i])
            DFS1(i);
    //reinit visited
    visited = vector<bool>(nrVrafuri, false);
    for(i=nrVrafuri-1; i>=0; i--)
        if(!visited[topological[i]]){
            aux.clear();
            DFS2(topological[i]);
            sol.push_back(aux);
        }
    ofstream g ("ctc.out");
    g << sol.size() << endl;
    for (auto& v : sol) {
        for (auto& i : v) {
            g << i + 1 << " ";
        }
        g << "\n";
    }
    g.close();
    return 0;
}
// Θ(V+E) (linear) time

//Pasul 1: Creeaza o stiva goala „S” si parcurge graful printr-un DFS. In momentul cand te intorci din parcurgerea recursiva („zona 4” din DFS – vorbim despre asta mai jos) – pune nodul in stiva.
// De exemplu, in problema de mai sus obtinem stiva: 7 4 8 5 6 3 2 1 (unde 1 este ultimul element introdus in stiva).
//Pasul 2: Inversam directiile grafului pentru a construi transpusa acestuia.
//Pasul 3: Scoate cate un element rand pe rand din stiva „S”. Daca elementul selectat nu a mai fost vizitat, porneste o parcurgere DFS in graful construit la pasul 2.
// De fiecare data cand vom porni un DFS vom avea o noua componenta conexa.