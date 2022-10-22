#include <iostream>
#include <vector>
#include <queue>
using namespace std;
class Solution{
public:
    vector<int> findOrder(int numCourses, vector<vector<int>>& prerequisites) {
        bool isPossible;
        isPossible = true;
        vector<vector<int>> adjList(numCourses+1);
        int i;
        for (i=0; i<prerequisites.size(); i++){
            //create edge
            adjList[prerequisites[i][1]].push_back(prerequisites[i][0]);
        }
        //create vector for the indegree of evert node
        vector<int> indegree(numCourses, 0);
        for(auto x:adjList){
            for(auto node:x)
                indegree[node]++;
        }
        //topological sort

        //keep nodes with indegree 0
        queue<int> queue;
        //add all nodes with 0 indegree to queue
        for(i=0; i<numCourses; i++){
            if(indegree[i] == 0)
                queue.push(i);
        }
        vector<int> topological;
        int current;
        while (!queue.empty()){
            current = queue.front();
            topological.push_back(current);
            queue.pop();
            //traverse the neighbours
            for(auto x:adjList[current]){
                // reduce the indegree
                indegree[x]--;
                //when degree becomes 0 -> add it to queue
                if(indegree[x] == 0)
                    queue.push(x);
            }
        }
        if (topological.size() == numCourses)
            return topological;
        else
            return {};
    }
};
vector<vector<int>> cycles;
void DFS_cycle(vector<vector<int>> adjList, int u, int p,
               vector<int> visited,vector<int> parent,
               int &cycleNumber){
    //visited vertex
    if (visited[u] == 2)
        return ;
    //seen vertex, but not completly visited
    // -> cycle detected
    // backtr based on parents to find cycle complete
    if (visited[u] == 1){
        cycleNumber++;
        vector<int> vect;
        int current = p;
        vect.push_back(current);
        //backtr the vertex
        while (current != u){
            current = parent[current];
            vect.push_back(current);
        }
        cycles.push_back(vect);
        return;
    }
    parent[u] = p;
    //partial vizitat
    visited[u] = 1;
    //dfs on graph
    for (int v:adjList[u]){
        // nevizitat inainte
        if (v == parent[u])
            continue;
        DFS_cycle(adjList, v, u, visited, parent, cycleNumber);
    }
    //complet vizitat
    visited[u] = 2;
}
void afisareCiclu(int& cyclenumber){
    int i;
    for (i=0; i<cyclenumber; i++){
        cout << "Serie de cursuri: " << i + 1 << " : ";
        for (int y : cycles[i])
            cout << y << " ";
        cout << cycles[i][0] << endl;
    }
}
int main() {
    Solution s;
    vector<vector<int>> input = { {1,0}, {2,0}, {3,1}, {3,2} };
    vector<int> vec = s.findOrder(4, input);
    int i ;
    for (i=0;i<vec.size(); i++)
        cout << vec[i] << " ";
    if (vec.size() == 0){
        // in cazul in care nu pot fi urmate toate cursurile
        // se determina circuite din graf
        int n = input.size();
        vector<int> visited(n, 0);
        vector<int> parent(n, 0);
        vector<vector<int>> adjList(n +1);
        int i;
        for (i=0; i<n; i++){
            //create edge
            adjList[input[i][1]].push_back(input[i][0]);
        }
        int cyclenumber = 0;
        //dfs to mark cycles
        DFS_cycle(adjList,0,0, visited, parent, cyclenumber);
        afisareCiclu(cyclenumber);
    }
    return 0;
}
// pentru a)
//Time Complexity: O(V + E)O(V+E)
//Space Complexity: O(V + E)O(V+E)
// to determine cycles
//Time Complexity: O(N + M)  - where N is the number of
// vertexes and M is the number of edges
// Auxiliary Space: O(N + M)