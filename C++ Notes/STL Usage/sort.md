# sort

我們常常會需要用到有序結構(`priority_queue`, `set`, `map`)或是做`sort()`，但是常常會搞不清楚到底小的在前面還是大的在前面，如果要自訂比較函數，要用大於還是小於，這邊就整理並記錄一下。

通常STL中預設的比較函數都是用`std::less<int>`

## vector - default
對`vector<int>`做`sort`，由`begin()`到`end()`是由小排到大:
這也同等於使用:
- `std::less<int>`
- `[](int lh, int rh) { return lh < rh; }`
做為比較函數
```cpp
    vector<int> v = {6,8,4,3,1,5,6};
    sort(v.begin(), v.end());
    for (int i: v)
        cout << i << ' ';

    //  1 3 4 5 6 6 8 
```

反之若使用:
- `std::greater<int>`
- `[](int lh, int rh) { return lh > rh; }`
則由大排到小

## priority_queue<int> - default
如果使用預設的`priority_queue`，最大的會在`pq.top()`
這也同等於使用:
- `priority_queue<int, vector<int>, std::less<int>> pq;`
```cpp
    vector<int> v = {6,8,4,3,1,5,6};
    priority_queue<int> pq;
    for (int i: v) {
        pq.push(i);
    }
    while (pq.size()) {
        cout << pq.top() << " ";
        pq.pop();
    }

    // 8 6 6 5 4 3 1 
```

反之如果使用`greater<int>`，會是最小的在`pq.top()`


## set / multiset
如果使用預設的`set`，由`begin()`到`end()`是由小排到大
```cpp
    vector<int> v = {6,8,4,3,1,5,6};
    set<int> s(v.begin(), v.end());
    for (int i: s) {
        cout << i << ' ';
    }

    // 1 3 4 5 6 8 
```

## map
如果使用預設的`map`，由`begin()`到`end()`是由小排到大
```cpp
    vector<int> v = {6,8,4,3,1,5,6};
    map<int, int> m;
    for (int i: v) {
        m[i]++;
    }
    for (auto& p: m) {
        cout << p.first << ' ';
    }

    // 1 3 4 5 6 8 
```

## Conclusion
只有`priority_queue`預設是由大排到小，其他有序結構/排序預設都是由小排到大
