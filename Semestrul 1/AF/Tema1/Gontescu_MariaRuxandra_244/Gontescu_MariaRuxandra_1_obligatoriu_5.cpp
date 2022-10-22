#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
using namespace std;
void add_edge(vector<vector<int>> &adjList, int x, int y){
    adjList[x].push_back(y);
    adjList[y].push_back(x);
}
int BFS (vector<vector<int>> &adjList, int src, int dest,
          int nrVarfuri, int pred[], int dist[]){
    queue<int> queue;
    vector<bool> visited(nrVarfuri+1);
    //init elements
    int i;
    for (i=1; i<=nrVarfuri; i++){
        visited[i] = false;
        dist[i] = INT_MAX;
        pred[i] = -1;
    }
    //primul nod
    visited[src] = true;
    dist[src] = 0;
    queue.push(src);
    //BFS algorithm
    int current;
    while(!queue.empty()){
        current = queue.front();
        //cout << current << " " << adjList[current].size() << endl;
        queue.pop();
        for(i=0; i<adjList[current].size(); i++){
            //cout << adjList[current][i] << endl;
            if (visited[adjList[current][i]] == false) {
                visited[adjList[current][i]] = true;
                dist[adjList[current][i]] = dist[current] + 1;
                pred[adjList[current][i]] = current;
                queue.push(adjList[current][i]);
                //stop when destination is found
                if (adjList[current][i] == dest) {
                    int k;
//                    cout << dest << "   :   " << dist[dest] << endl;
//                    for(k=1; k<=dest; k++)
//                        cout << dist[k] << " ";
//                    cout << endl;
                    return dist[dest];
                }
            }
        }
    }
    return 0;
}
int main() {
    int nrVarfuri, nrMuchii, c1, c2;
    vector<vector<int>> adjList(nrVarfuri+1);
    //citire date -> lista de adiacenta
    ifstream f("graf.in");
    f >> nrVarfuri >> nrMuchii;
    int i, x, y;
    for(i=0;i<nrMuchii; i++){
        f >> x >> y;
        add_edge(adjList,x,y );
    }
    f >> c1 >> c2;
    f.close();
    //verificare liste ad
//    for(i=1;i<=nrVarfuri; i++){
//        cout << "Size " << adjList[i].size() << endl;
//        cout << i << " : ";
//        for (int j=0; j<adjList[i].size(); j++)
//            cout << adjList[i][j] << " ";
//        cout << endl;
//    }
//    cout << endl;
    //parcurgere noduri
    int d1, d2;
    int pred[nrVarfuri+1], dest[nrVarfuri+1];
    ofstream g("graf.out");
    // in graful neorientat BFS-ul ofera drumul de lungime minima
    // in BFS se formeaza vectorul de distanta
    // pentru fiecare nod i se retine si predecesorul nodului respectiv in pred
    for(i=1; i<=nrVarfuri; i++){
        
        d1 = BFS(adjList, i, c1,nrVarfuri, pred, dest );
        d2 = BFS(adjList, i, c2, nrVarfuri, pred, dest);
        // se calc drumul de lungime minima
        g << min(d1, d2) << " ";
    }
    g.close();
    return 0;
}
//Time Complexity : O(V + E)
//Auxiliary Space: O(V)