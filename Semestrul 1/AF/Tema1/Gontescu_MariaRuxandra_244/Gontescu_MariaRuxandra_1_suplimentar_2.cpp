#include <fstream>
#include <iostream>
#include <vector>
#include <queue>
using namespace std;
//vectors for the position we can move N V E S
const int dx[] = {0, 0, 1, -1};
const int dy[] = {1, -1, 0, 0};
queue<pair<int, int>> q;
int n, m;
vector<vector<int>> matrix(n+5);
vector<vector<int>> cost(n+5);

// check to be within the matrix
bool validare( int i, int j){
    if (i>0 && i<=n)
        if (j>0 && j<=m)
            return true;
    return false;
}
void fill (int pl, int pc,int c){
    int i, x, y;
    // form cost matrix
    cost[pl][pc] = c;
    // add indexs to queue
    q.emplace(pl, pc);

    for (i=0; i<4; i++){
        x = pl + dx[i];
        y = pc + dy[i];
        if (validare( x, y)) // if there are in the matrix
            if (matrix[pl][pc] == matrix[x][y]) //same tree
                if (cost[x][y] == INT_MAX) // unvisited
                    fill(x, y, c);
    }
}
void lee (){
    pair<int, int> now;
    int i, x, y;
    while(q.empty() == false){
        now = q.front();
        q.pop();
        for(i=0; i<4; i++){
            x = now.first + dx[i];
            y = now.second + dy[i];
            if (validare(x, y))
                if (cost[x][y] == INT_MAX) //nevizitat
                    fill(x, y, cost[now.first][now.second]+1); //se creeaza insula noua
        }
    }
}
//The algorithm is a breadth-first based algorithm that uses queues to store the steps.
// It usually uses the following steps:
//Choose a starting point and add it to the queue.
//Add the valid neighboring cells to the queue.
//Remove the position you are on from the queue and continue to the next element.
//Repeat steps 2 and 3 until the queue is empty.
int main() {
    //citire date
    ifstream f("padure.in");
    int pl,pc,cl, cc;
    int i, j, x;
    f >> n >> m ;
    matrix.resize(n+1);
    cost.resize(n+1);

    f >> pl >> pc >> cl >> cc;
    for(i=0; i<=n+1; i++){
        for(j=0; j<=m+1;j++) {
            matrix[i].push_back(0);
            cost[i].push_back(INT_MAX); // init cost matric with INT_MAX
        }
    }
    // read matrix
    for (i=1; i<=n; i++) {
        for (j = 1; j <= m; j++) {
            f >> x;
            matrix[i][j] = x;
        }
    }

    fill(pl, pc, 0);
    lee();
    for(i=1; i<=n; i++){
        for(j=1; j<=m;j++) {
            cout << cost[i][j] << " ";
        }
        cout << endl;
    }
    cout << cost[cl][cc];
    return 0;
}
// O(M*N)