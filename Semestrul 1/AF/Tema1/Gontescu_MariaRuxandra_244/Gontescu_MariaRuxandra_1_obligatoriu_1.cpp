//time complexity: O(n+2E)
#include <iostream>
#include <fstream>
#include <vector>
using namespace std;
//solutia incarcata pt subpunctul a)
class SolutionA {
    bool dfs (vector<vector<int>> &adj, vector<int> &color, int node){
        if (color[node] == -1)
            color[node] = 1;
        for (auto i:adj[node]){
            if (color[i]==-1){
                //change the color
                color[i] = 1-color[node];
                if (dfs(adj, color, i) == 0)
                    return 0;
            }
            else
                //check if color of 2 adjacent nodes are same
            if (color[i] == color[node])
                return 0;
        }
        return 1;
    }
public:
    bool possibleBipartition(int n, vector<vector<int>>& dislikes) {
        vector<vector<int>> adj(n+1);
        vector<int> color (n+1, -1); //init -1
        //create adj list for the graph
        for (auto i:dislikes){
            //undirected graph
            adj[i[0]].push_back(i[1]);
            adj[i[1]].push_back(i[0]);
        }
        for (int i=1; i<=n; i++){
            if (color[i] == -1)
                if (dfs(adj, color, i) == 0)
                    return 0;
        }
        //    for (int i=1; i<=n; i++)
        //        cout << color[i] << " ";
        return true;
    }
};


bool dfs (vector<vector<int>> &adj, vector<int> &color, int node){
    if (color[node] == -1)
        color[node] = 1;
    for (auto i:adj[node]){
        if (color[i]==-1){
            //change the color
            color[i] = 1-color[node];
            if (dfs(adj, color, i) == 0)
                return 0;
        }
        else
            //check if color of 2 adjacent nodes are same
            if (color[i] == color[node])
                return 0;
    }
    return 1;
}
void possibleBipartition(int n, vector<vector<int>>& dislikes){
    vector<vector<int>> adj(n+1);
    vector<int> color (n+1, -1); //init -1
    //create adj list for the graph
    for (auto i:dislikes){
        //undirected graph
        adj[i[0]].push_back(i[1]);
        adj[i[1]].push_back(i[0]);
    }
    for (int i=1; i<=n; i++){
        if (color[i] == -1)
            if (dfs(adj, color, i) == 0){
                cout << "Not possible!";
                return ;
            }

    }
    int i;
    cout << "Un grup este ";
    for ( i=1; i<=n; i++)
        if (color[i] == 0)
            cout << i << " ";
    cout << "\ncelalalt: ";
    for (i=1; i<=n; i++)
        if (color[i] == 1)
            cout << i << " ";
    return ;
}
int main() {
    int n = 4;
    vector<vector<int>> dislikes = {{1,2},{1,3},{2,4}} ;
    possibleBipartition(n, dislikes);

    return 0;
}
//O(V+E)
//Maintain a color vector ,initially all elements as -1. 
// it will keep track of the colors of all adjacent nodes.
//If a node isn't colored ,then make dfs call & set its color to 1.
//Now check if its adjacent node isn't colored, then color it as 1-col[start] ,i.e. 1-color of its adjacent node.
//If its adjacent node is already colored then,check if color of both the nodes are same ,then return false .
//else return true.