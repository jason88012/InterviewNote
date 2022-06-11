# Binary Search Template

Binary Search簡單說就是把每次搜尋的區間減半，概念上很簡單，但實作上很容易出錯。最常見的問題就是: `l`與`r`的邊界條件該怎麼設定? 每次搜尋後要怎麼改動`l`與`r`? 以下介紹Binary Search三種不同的實作方式，分別可以應用於不同的情況:

## Template 1: while (l < r); r = m; l = m + 1;
這種做法是最常見的作法，有個比較重要的地方就是為什麼只有改動`l`的時候要`+1`? 原因是當我們在搜尋一個長度是偶數的區間時，`m`會因為除法的無條件捨去偏向左半區間，所以右側區間的長度就會比左邊多`1`，故在更改`l`的時候(搜尋右半區間)，要加上`1`讓區間大小相同
```
nums = [1, 2, 3, 4]

1  2  3  4
l  m     r

// use m = l + (r - l) / 2 calc m to avoid overflow
l = 0, r = 3 --> m = 0 + (3 - 0) / 2 = 1;

1  2 | 3  4
l  r         --> If search left, r = m;
       l  r  --> If search right, l = m + 1;
```
這種做法最後得到的`l`和`r`是相同的，所以適用於:
1. 一定找的到一組解的時候
2. 找滿足條件最小解的時候
```cpp
int binarySearch(vector<int>& nums) {
    int l = 0, r = nums.size() - 1;
    while (l < r) {
        int m = l + (r - l) / 2;
        if (condition()) {
            r = m;
        } else {
            l = m + 1;
        }
    }
    return l; // same as return r
}
```

## Template 2: while (l + 1 < r); r = m; l = m;
這種做法的特色是強制把中止條件設得比較寬鬆，並且改動`lr`時是對稱的寫法，這樣寫的好處是比較不容易出錯，也可以處理答案不一定在搜尋區間內的題目，但是缺點也很明顯，第一就是最後搜尋出的`lr`必定是相鄰的兩個數字，想要得到解答得再多一個判斷，如此較不利於branch prediction。

```
nums = [1, 2, 3, 4]

1  2  3  4
l  m     r

1  2 | 3  4
l  r
   l      r

If search left area: [1, 2] --> while end, check l(1) and r(2)
If search right area: [2, 3, 4] --> searching continues.
```

```cpp
int binarySearch(vector<int>& nums) {
    int l = 0, r = nums.size() - 1;
    while (l + 1 < r) {
        int m = l + (r - l) / 2;
        if (condition()) {
            r = m;
        } else {
            l = m;
        }
    }
    if (condition(l)) return l;
    if (condition(r)) return r;
    return -1;  // not found
}
```

## Template 3: while (l <= r); r = m - 1; l = m + 1;
最後一種寫法是比較積極縮小搜索區間的寫法，這種寫法保證每次搜尋如果`m`不是我們要的答案就會被排除在外，不過這也是為什麼終止條件需要設成`<=`，因為我們每個`m`都需要檢查，所以即使在`l == r`的情況下也要再做一次檢查。
這種方法只適用於答案必定包含在搜尋區間內並且是唯一一個滿足`condition()`的題目，例如: 找某個數字是否在array裡面
```
nums = [1, 2, 3, 4]

1  2  3  4
l  m     r

1 | 2 | 3  4
lr  x   l  r

2 has been removed from searching area
```

```cpp
int binarySearch(vector<int>& nums) {
    int l = 0, r = nums.size() - 1;
    while (l <= r) {
        int m = l + (r - l) / 2;
        if (condition()) {
            return m;
        } else if (needSearchLeft()) {
            r = m - 1;
        } else {
            l = m + 1;
        }
    }
    return -1;  // not found
}
```
