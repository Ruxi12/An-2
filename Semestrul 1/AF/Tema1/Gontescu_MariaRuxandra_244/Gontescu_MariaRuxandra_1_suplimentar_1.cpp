#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;
class Solution {
private:
    //Initiazing all 2 vectors with 0.
    vector<int> disc{0}, low{0};
    int time = 1; //We start the our variable time counter from 1 and keep on incrementing it
    vector<vector<int>> rez;
    unordered_map<int, vector<int>> edge;
public:
    void DFS (int current, int previous){
        disc[current] = low[current] = time++;
        for(int elem : edge[current]){
            if (disc[elem] == 0){
                DFS(elem, current);
                low[current] = min(low[current], low[elem]);
            }
            else
                //muchie de intoarcere
                if (elem != previous)
                    low[current] = min(low[current], disc[elem]);
                if (low[elem] > disc[current])
                    //(elem, current) can be a bridge only if low[elem] > disc[current]
                    rez.push_back({current, elem});
                    //Because disc[elem] will always be greater than disc[current]
                    //But low[elem] will only be greater than disc[current] when there is no backedge associated with current.
        }
    }
    vector<vector<int>> criticalConnections(int n, vector<vector<int>>& connections) {
        //disc = The time at which the node is discovered
        //low = Accessible node with the lowest time possible
        disc = vector<int>(n);
        low = vector<int>(n);
        // creare lista de adiacenta
        for(auto x: connections){
            edge[x[0]].push_back(x[1]);
            edge[x[1]].push_back(x[0]);
        }
        DFS(0, -1);
        return rez;
    }
};
int main() {
    Solution s;
    vector<vector<int>> sol;
    vector<vector<int>> input = { {0,1},{1,2},{2,0},{1,3} };
    sol = s.criticalConnections(4, input);
    for (int i=0; i<sol.size(); i++)
        cout << sol[i][0] << " " << sol[i][1] << endl;

    return 0;
}
//complexity O( V + E )
//space O(v)
