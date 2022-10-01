## priority_queue

這是非常常使用到的一種資料結構，又被稱為heap，有分為min heap跟max heap，實際上裡面的資料結構就是一顆"完全二元樹"(complete binary tree)，我們也可以用array模擬二元樹的方法來實作)

## Array Implementation
參考: [215. Kth Largest Element in an Array](https://leetcode.com/problems/kth-largest-element-in-an-array/)

## Min / Max Heap
我們以二元樹的觀點來看，所謂`Min heap`代表`root->val < root->left->val && root->right->val`這時我們可以以`O(1)`時間來查找queue中最小的值，反之則是root比左右都大，稱為max heap。

## STL priority_queue
在C++`<queue>`header裡面已經包含了`priority_queue`的實作，我們只要拿出來用就可以了，如果我們只宣告了pq裡面的元素類型，那預設就會是一個max heap

```cpp
vector<int> nums = {3, 4, 1, 8, 6};
priority_queue<int> pq;
for (int num: nums) {
    pq.push(num);
}
cout << pq.top();  // 8
```

如果我們想改成使用min heap，那我們必須改變預設的comparator，這時pq的宣告方法如下:
```cpp
vector<int> nums = {3, 4, 1, 8, 6};
priority_queue<int, vector<int>, greater<int>> pq;
for (int num: nums) {
    pq.push(num);
}
cout << pq.top();  // 1
```

我們注意到多了兩個地方:
1. 多了一個`vector<int>`，這是代表內部存放的容器形式
2. `greater<int>`，這是代表比較大的數字必須被往後放(也就是說預設的max heap使用的是`less<int>`，不過可以不用寫)

最後如果我們需要存放的元素不是預設元素，例如我們想要放自訂義的`struct`進去，這時我們得自訂comparator，寫法如下:
```cpp
struct Info {
    int x;
    int y;
    Info(int x_, int y_): x(x_), y(y_) {}
};

vector<Info> info = {{4, 9}, {1, 5}, {6, 7}};

auto comp = [](Info& a, Info& b) {
    return a.x > b.x;
};

priority_queue<Info, vector<Info>, decltype(comp)> pq(comp);
for (auto i: info) {
    pq.push(i);
}
cout << pq.top().x << ", " << pq.top().y;  // {1, 5}
```

這邊注意幾點:
1. 我們使用了lambda function來自訂comparator，不要忘記加lambda的分號
2. comparator裡面判斷的是"大於"，跟`std::greater<int>`意思一樣，這就代表了比較大的要往後放，也就是是一個min heap。
3. construct `priority_queue`的時候要把comparator當參數傳入

## Complexity
priority_queue的`push()`與`pop()`都是`O(logn)`時間，但是在查詢`top()`的時候是`O(1)`，如果還有需要快速查找中間的數字的需求的話，使用`std::map`(RB tree)或是`unordered_map`(hash map)
