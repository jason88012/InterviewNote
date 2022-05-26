# Dijkstra Algorithm

Dijkstra演算法可以被用於尋找一個邊帶有權重的圖中某個點到其他所有點的最短距離，並且可以藉此產生最短路徑樹，但是要注意的是Dijkstra演算法並不適用於帶有**負數**權重的圖。

## 流程
Dijkstra是基於BFS進行搜索的演算法，基本原理如下:
1. 挑選截至目前為止距離最短的節點當作下一個要搜尋的節點
2. 一個被搜尋過的節點不會再被搜尋第二次(由於我們每次都是挑最短的節點檢查，如果被重複處理那必定不是最短路徑)
3. 每次處理節點時同時更新該節點所有鄰居的最短路徑

## 程式碼實作
一般的BFS是使用`queue`來儲存接下來要搜尋的節點，但是由於Dijkstra有個特性就是每次都要挑當前最短的節點，所以我們可以利用`priority_queue`來快速找出現在距離最短的節點是哪個
同時我們需要幾個array/unordered_map來記錄:
1. 是否已經檢查過這個節點
2. 到該節點的最短距離是多少 --> 我們想要的答案

依據以上的觀念我們可以得到Dijkstra的模板大致如下(假設傳入的graph已經是一個adjacency list):
```cpp

struct Node {
    int id;
    int dist;
};

vector<int> dijkstra(const vector<vector<Node>>& graph, int start) {
    int n = graph.size();
    vector<bool> visited(n, false);
    vector<int> distance(n, INT_MAX);
    auto comp = [](Node& n1, Node& n2) {
        // put the larger weight in the heap's bottom.
        return n1.dist > n2.dist;
    }
    priority_queue<Node, vector<Node>, decltype(comp)> q(comp);
    // The distance to reach node 'start' is 0
    q.push({start, 0});
    while (!q.empty()) {
        // Pick the node with shortest distance.
        Node curr = q.top(); q.pop();
        // If this node is already proceed, ignore it.
        // Since it is not the shortest path
        if (visited[curr.id])
            continue;
        // record the result we want
        visited[curr.id] = true;
        distance[curr.id] = curr.dist;
        for (int next: graph[curr.id]) {
            // Also, if the next node is already proceed, ignore.
            if (visited[next.id])
                continue;
            q.push({next.id, curr.dist + next.dist});
        }
    }
}

```

可以發現基本上跟BFS長得一模一樣，但是有一點需要特別注意，那就是我們實際上並沒有真正做"每次處理節點時同時更新該節點所有鄰居的最短路徑"這個動作，我們做的只是把所有鄰居的距離push進queue裡，這是因為我們每次都從最短的路徑中挑下個要處理的節點，所以假設有兩條路徑可以到達節點`x`而距離分別是`1`和`2`，即使是距離為`2`的那段路徑先被push進queue裡，距離為`1`的路徑依然會先被pop出來並且被設定為最短路徑，這時當距離為`2`的路徑被pop出來時，因為我們已經確定到達過節點`x`，所以連這次要檢查的距離是多少都不用看就可以直接把距離為`2`的路徑忽略。

e.g.
```

   [2]
   / \
  1   1
 /     \
[1]    [4]
 \     /
  1   2
   \ /
   [3]

```
在上面的圖中可以看到由於到達`[2]`和`[3]`的距離是一樣的，所以哪個先被pop出來都有可能，但今天無論我們先pop `[2]`或`[3]`都會得到一樣的結果，因為priority queue的關係我們終究會先挑到距離比較近的路徑

```
If push [2] first --> reach node [4] with 1 + 1 --> push {4, 2}
q = [{3, 1}, {4, 1+1}]
next check [3] --> reach node [4] with 1 + 2 --> push {4, 3}
q = [{4, 2}, {4, 3}]
next check [4] with dist 2

If push [3] first --> reach node [4] with 1 + 2
q = [{3, 1}, {4, 1+2}]
next check [3] --> reach node [4] with 1 + 1 --> push {4, 2}
q = [{4, 2}, {4, 3}]  <-- sorted by priority queue here!
next check [4] with dist 2

```
