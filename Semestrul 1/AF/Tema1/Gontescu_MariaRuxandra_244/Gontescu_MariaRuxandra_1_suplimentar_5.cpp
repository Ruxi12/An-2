#include <iostream>
#include <fstream>
#include <vector>
using namespace std;
class Solution{
    int n, m;
    //parcurgere bfs in matrice
    int parcurgere(int i, int j, vector<vector<int>> &grid){
        if (i<0 || j<0 || i>=n || j>=m || !grid[i][j])
            return 0;
        grid[i][j] = 0;
        // se merge in toate directiile posibile
        return 1+parcurgere(i-1, j, grid)+ parcurgere(i, j-1, grid)
                + parcurgere(i+1, j, grid) + parcurgere(i, j+1, grid);
    }
public:
    int maxAreaOfIsland(vector<vector<int>> &grid){
        int res = 0; int i;
        n = grid.size();
        m = grid[0].size();
        // se traverseaza fiecare celula din matrice
        for(i=0; i<n; i++)
            for (int j = 0; j < m; j++)
                if (grid[i][j]) // in mom in care apare 1 se porneste un dfs din acea celula prin care i se afla suprafata
                    res = max(res, parcurgere(i, j, grid)); // insula de marima maxima 
        return res;
    }
};
int main() {
    vector< vector<int>> grid = {{0,0,1,0,0,0,0,1,0,0,0,0,0},
                                {0,0,0,0,0,0,0,1,1,1,0,0,0},
                                {0,1,1,0,1,0,0,0,0,0,0,0,0},
                                {0,1,0,0,1,1,0,0,1,0,1,0,0},
                                {0,1,0,0,1,1,0,0,1,1,1,0,0},
                                {0,0,0,0,0,0,0,0,0,0,1,0,0},
                                {0,0,0,0,0,0,0,1,1,1,0,0,0},
                                {0,0,0,0,0,0,0,1,1,0,0,0,0}};
    Solution sol;
    cout << sol.maxAreaOfIsland(grid);
    return 0;
}
// O(N*M)