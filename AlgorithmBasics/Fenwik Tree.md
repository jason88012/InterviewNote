# Fenwik Tree
通常我們在做range query的時候我們會使用prefix sum，但當我們array中的值會常常改變，繼續用prefix sum時間複雜度會變成`O(n^2)`，因為每次更新值都要重新計算`prefix sum`(`O(n)`)，所以有另一種資料結構可以在內容會改變的情況下快速做ranged query就是這邊要介紹的Fenwik tree(又稱Binary Index Tree)

Fenwik Tree的概念就是在一個array中，每個index都對應一個節點，每個節點都代表了一段數字的總和，而當我們要加入新的數字時，所有對應的節點都會被更新，而當我們查詢的時候，從目標的index依序往上累加回parent即是結果。可以參考:
- [花花酱 Fenwick Tree / Binary Indexed Tree](https://www.youtube.com/watch?v=WbafSgetDDk)
- [Tushar - Fenwick Tree or Binary Indexed Tree](https://www.youtube.com/watch?v=CWDQJGaN1gY)

## Implementation
首先介紹何謂"lowbit"，lowbit就是一個數字用二進制表示時最低位的1，以下舉例:
```
5 = 00000101
           ^
lowbit(5) = 00000001 = 1

8 = 00001000
        ^
lowbit(8) = 00001000 = 8
```
那要怎麼計算這個lowbit呢? 直接背起來比較快
```
n & (~n + 1) == n & (-n)
```

根據Fenwik Tree的定義，每次更新數值後所有會被影響的index就是當前`index`加上`lowbit(index)`直到超出範圍，每次要計算總和就是所有總和`index`不斷減去`lowibt(index)`直到index為0，所以實作上其實非常簡單，程式碼的數量比segment tree精簡多了。

```cpp
class Fenwik {
    vector<int> tree;
    inline int lowbit(int x) {
        return x & (-x);
    }
public:
    Fenwik(int n) {
        // Use 1 additional space for root (idx = 0)
        tree = vector<int>(n + 1, 0);
    }

    void update(int idx, int val) {
        while (idx < tree.size()) {
            tree[idx] += val;
            idx += lowbit(idx);
        }
    }

    int query(int idx) {
        int sum = 0;
        while (idx >= 0) {
            sum += tree[idx];
            idx -= lowbit(idx);
        }
        return sum;
    }

    int rangeQuery(int start, int end) {
        return query(end) - query(start - 1);
    }
};
```

以上就是Fenwik Tree的實作，主要要背的地方就是:
- `lowbit`的實作方法: `x & (-x)`
- `tree`需要多一個`[0]`用作root
- `update`每次 `+= lowbit`，`query`每次 `-= lowbit`

## Constraints
從`update()`的計算過程中可以發現Fenwik Tree的計算順序是固定的，所以如果要做: range query max這種兩兩之間計算順序不同的就還是得用比較複雜的segment tree。
