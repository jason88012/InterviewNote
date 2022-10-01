# Segment Tree

線段樹是一種可以快速查詢範圍內資料的平衡二元樹，基本上它結合了Binary Tree和Binary Search的一些特點。適用的例題:
- [307. Range Sum Query - Mutable](https://leetcode.com/problems/range-sum-query-mutable/)

詳細解說參考: [花花酱 Segment Tree 线段树](https://www.youtube.com/watch?v=rYBtViWXYeI)

## Basic Structure
首先定義線段樹中的節點，既然線段樹是用來做範圍查詢的，所以我們主要要定義3+2個東西:
- 範圍起點/終點
- 要查詢的目標，這邊以Leetcode 307舉例所以使用的是"總和"
- 左右子節點
```cpp
struct SegmentTreeNode {
    int start;
    int end;
    int sum;    // Could be min, max, average... etc
    SegmentTreeNode* left;
    SegmentTreeNode* right;

    SegmentTreeNode(int l, int r, int val):
        start(l), end(r), sum(val), left(nullptr), right(nullptr) {}
};
```

## Basic APIs
再來定義線段樹會使用到的API，主要有3種:
- `buildTree()`: 基本上約等於constructor，就是把array轉換成樹的形式
- `update(idx, val)`: 把原先`array[index]`替換成`val`
- `query(l, r)`: 查詢`array[l:r]`的目標資料，這邊就是`sum(array[l:r])`

接下來依序介紹:

### Build Tree
首先是創造樹，線段樹的基本原理就是每個節點都代表一個範圍，最底下的leaf就代表了"1個"元素(start == end)，而每個parent都依據自己的children的值去計算自己的值，所以創建樹的過程其實就是一個很基本的DFS，而每次我們都要把樹分成兩半，以維持樹形狀的平衡。時間複雜度為`O(n)`
```cpp
SegmentTreeNode* buildTree(vector<int>& nums, int l, int r) {
    if (l == r) {
        // When l == r, means this node only contains "1"
        // element in original array, which is a leaf node
        return new SegmentTreeNode(l, r, nums[l]);
    }
    // Use binary search concept divide array into 2 parts.
    // Build left / right sub tree arrcording to 2 pieces.
    int m = l + (r - l) / 2;
    auto* ln = buildTree(nums, l, m);
    auto* rn = buildTree(nums, m + 1, r);
    auto* curr = new SegmentTreeNode(l, r, ln->sum + rn->sum);
    curr->left = ln;
    curr->right = rn;
    return curr;
}
```

### Update value
再來是更新某個`index`的值，這邊基本上就是利用Binary Search去找到目標節點的leaf node，然後再從底往上一路更新所有包含index的節點。這樣時間複雜度是`O(logn)`

```cpp
void update(SegmentTreeNode* curr, int idx, int val) {
    if (curr->left == idx && curr->right == idx) {
        curr->sum = val;
        return;
    }
    int m = curr->left + (curr->right - curr->left) / 2;
    // 0 1 2 3 --> m = 1
    // idx = 1 --> left (<=)
    // idx = 2 --> right (>)
    if (idx <= m) {
        update(curr->left, idx, val);
    } else {
        update(curr->right, idx, val);
    }
    // Update curr node according to children node's change.
    curr->sum = curr->left->sum + curr->right->sum;
}
```

### Range Query
最後是查詢範圍內的值，一樣用Binary Search去找到目標的範圍，然後回傳查詢到的值，但這邊會有一個例外，由於在`buildTree`的時候，每個節點的範圍都已經是固定的了，所以有可能會遇到查詢的範圍跟節點內範圍重疊但又不相等的情況，所以這時就要把查詢範圍拆成左右兩邊分開去搜尋，最後再把結果加起來。由於上述的例外狀況，我們可能需要額外的搜尋，而最多就是多找到`k`個leaf節點(`k`為搜尋範圍的長度)，故時間複雜度是`O(logn + k)`
```cpp
int query(SegmentTreeNode* curr, int l, int r) {
    if (curr->left == l && curr->right == r) {
        return curr->sum;
    }
    int m = curr->left + (curr->right - curr->left) / 2;
    // 0 1 2 3 --> m = 1
    // l == 0, r == 1 --> whole section in left (r <= m)
    // l == 2, r == 3 --> whole section in right (l > m)
    if (r <= m) {
        return query(curr->left, l, r);
    } else {
        return query(curr->right, l, r);
    }
    // l == 0, r == 3 --> cross 2 section,
    // accumulate 2 section's search result.
    return query(curr->right, l, m) +
           query(curr->right, m + 1, r);
}
```

其實這裡很多概念都用到了Binary Search中最常見的模板: `while (l < r); r = m; l = m + 1`的概念，如果不知道為什麼在做線段分割/搜尋時要這樣切可以再去想想Binary Search那邊是怎麼分割的。基本概念並不難，但要寫一大堆的code，最後可能還需要一些API與member variable的封裝才能把題目完成。
