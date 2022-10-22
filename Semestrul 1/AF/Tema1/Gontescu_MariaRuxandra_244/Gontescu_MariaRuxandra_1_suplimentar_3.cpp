#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
using namespace std;
vector<int> visited;
void add_edge(vector<vector<int>> &adjList, int x, int y){
    adjList[x].push_back(y);
    adjList[y].push_back(x);
}
void BFS1(vector<vector<int>> &adjList, vector<int> & dist, int start){
    queue<int> q;
    int node, i, aux;
    q.push(start);
    dist[start] = 1;
    while (!q.empty()){
        node = q.front();
        q.pop();
        for (i=0; i<adjList[node].size(); i++){
            aux = adjList[node][i];
            if (dist[aux] > dist[node] + 1){
                dist[aux] = dist[node] + 1;
                q.push(aux);
            }
        }
    }
}
vector<int> answear;

void BFS2(vector<vector<int>> &adjList, vector<int> & dist, int start){
    queue<int> q;
    int node, i, aux;
    q.push(start);
    visited[start] = true;
    while (!q.empty()){
        node = q.front();
        q.pop();
        if (q.empty()) // daca coada este goala, inseamna ca nodul curent "node" se afla in toate traseele de lungime optime
            answear.push_back(node);
        for (i=0; i<adjList[node].size(); i++){
            aux = adjList[node][i];
            if (dist[aux] + 1 == dist[node] && visited[aux] == false){
                q.push(aux);
                visited[aux] = true;
            }
        }
    }
}
int main() {
    int nrVarfuri, nrMuchii, start, end;
    vector<vector<int>> adjList(nrVarfuri+1);
    //citire date -> lista de adiacenta
    ifstream f("graf.in");
    f >> nrVarfuri >> nrMuchii >> start >> end;
    int i, x, y;
    for(i=0;i<nrMuchii; i++){
        f >> x >> y;
        add_edge(adjList,x,y );
    }
    f.close();
    cout << endl;
    vector<int> dist(nrVarfuri+1, INT_MAX);
    visited.resize(nrVarfuri+1, false);
    // formare vector de distanta
    BFS1(adjList, dist, start);
    // se reface traseul incepand de la nodul de end ca sa se reconstruiasca traseul
    BFS2(adjList, dist, end);

    // make sure nodes are in ascending order
    sort(answear.begin(), answear.end()); // n=answear.size() o (n logn)
    ofstream g("graf.out");
    g <<answear.size() << "\n";
    for(auto &x: answear)
        g << x << " ";
    g.close();
    return 0;
}
//O(V+E)