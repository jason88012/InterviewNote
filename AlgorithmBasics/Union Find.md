# Union Find

在無向圖中找出是否有cycle的時候我們可以使用Union&Find，也就是被稱為`Disjoint Set`的資料結構。Union&Find的運作原理是每個節點都會有一個屬於自己的parent節點(所有節點的預設parent為自己)

在Union兩個節點時檢查兩個節點的parent是否是同一個，如果不是代表兩個節點不屬於同個union，反之則屬於同個union，而這也代表了如果在連結這兩個節點前，兩個節點已經屬於同一個union，最後再加上這個連結就會形成cycle

```
Try to union 2 and 4, but they've alredy belongs to same union
(parents might be 1 or 2 or 3 or 4)
1 -- 2
|
|
3 -- 4
```

這邊介紹disjoint set的模板以及實作上的優化方式: Path compression以及Union by rank，首先我們寫出disjoint set的預設介面，我們要有一個vector代表每個節點的parent，並且把預設值設為自己

```cpp
class DisjointSet {
    vector<int> parents_;
    vector<int> ranks_;
public:
    DisjointSet(int n) {
        parents_ = vector<int>(n);
        std::iota(parents_.begin(), parents_.end(), 0)
        ranks_ = vector<int>(n);
    }

    int Find(int a) {
        if (parents_[a] != a) {
            // path compression
            parents_[a] = Find(parents_[a]);
        }
        return parents_[a];
    }

    bool Union(int a, int b) {
        int pa = Find(a), pb = Find(b);
        if (pa == pb) {
            // no connection is build.
            return false;
        }

        // union by rank
        if (ranks_[pa] < ranks_[pb]) {
            parents_[pa] = pb;
        } else if (ranks_[pa] > ranks_[pb]) {
            parents_[pb] = pa;
        } else {
            parents_[pa] = pb;
            ranks_[pb]++;
        }
        return true;
    }

    /*
    Sample code from geeksforgeeks

    // A function that does union of two sets of x and y
    // (uses union by rank)
    void Union(struct subset subsets[], int xroot, int yroot)
    {
    
        // Attach smaller rank tree under root of high rank tree
        // (Union by Rank)
        if (subsets[xroot].rank < subsets[yroot].rank)
            subsets[xroot].parent = yroot;
        else if (subsets[xroot].rank > subsets[yroot].rank)
            subsets[yroot].parent = xroot;
    
        // If ranks are same, then make one as root and
        // increment its rank by one
        else {
            subsets[yroot].parent = xroot;
            subsets[xroot].rank++;
        }
    }
    */
};

```

由於我們有做Path compression，在Union的過程中就會不斷壓縮search path的長度，再加上union by rank，每次都盡量做比較少次數的Find，也就是平均的時間複雜度可以到`O(1)` (amortized `O(1)`)
