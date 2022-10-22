#include <iostream>
#include <fstream>
#include <vector>
using namespace std;
bool cycle;
vector<vector<int>> adjList;
vector<int> visited;
void clean (int n){
    visited.resize(n);
    for (int i=0; i<=n ;i++)
        visited[i] = false;
}
void eraseLeaves(int n){
    int i;
    int first;
    vector<int> leaves;
    // se creeaza un array care retine frunzele din graf
    for(i=1; i<=n; i++)
        if(adjList[i].size() == 1)
            leaves.push_back(i);
    for(i=0; i<leaves.size(); i++)
        if (adjList[leaves[i]].size() != 0){
            first = adjList[leaves[i]][0];
            adjList[first].erase(find(adjList[first].begin(), adjList[first].end(),
                                      leaves[i]));
        }
    leaves.clear();

}
void dfs(int node, int parent){
    visited[node] = true;
    int i;
    for (i=0; i<adjList[node].size(); i++)
        if (adjList[node][i] != parent){
            if(visited[adjList[node][i]] == true){
                cycle = true;
                return ;
            }
            dfs(adjList[node][i], node);
        }
}
bool findCycle ( int n){
    int i;
    for(i=1; i<=n; i++)
        if (visited[i] == false)
            dfs(i, 0);
    // cand exista ciclu nu avem cum sa il prindem 
    if (cycle)
        return false;
    // se elimina frunzele din adjList
    eraseLeaves(n);
    //afisare lista de adiacenta
//    for(i=1; i<=n; i++){
//        cout << i << " : ";
//        for (auto node: adjList[i])
//            cout << node << " ";
//        cout << endl;
//    }
    // se cauta configuratia omida
    for (i=1; i<=n; i++)
        if (adjList[i].size() > 2)
            return false;
    return true;
}
int main() {
    //citire date
    int t, n ,m;

    ifstream f ("lesbulan.in");
    ofstream g ("lesbulan.out");
    f >> t;
    int i, x, y;
    while (t--){
        //citire n , m
        f >> n >> m;
        adjList.resize(n);
        while (m--){
            f >> x >> y;
            adjList[x].push_back(y);
            adjList[y].push_back(x);
        }
        //seteaza valorile noi
        cycle = false;
        clean(n);
        g << findCycle(n) << endl;

    }
    f.close();
    g.close();
    return 0;
}
