## Binary Search
一般來講會在STL中經常使用到的binary search library就是`lower_bound`和`upper_bound`，不然如果單純要考binary search的話都是需要自己手刻條件的

## Use case
binary search必須用於已排序的container上，而只要是stl container都可以套用這個api，例如我們也可以對`std::map<int, int>`做lower_bound搜尋，這兩個api回傳的是iterator

## lower_bound
lower bound回傳**大於等於**`value`的"最小值"的位置

```cpp
vector<int> nums = {1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 6};
auto pos = lower_bound(nums.begin(), nums.end(), 3);
// pos = nums.begin() + 5, point to the first 3;
```

## upper_bound
upper_bound回傳**大於**`value`的"最小值"的位置

```cpp
vector<int> nums = {1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 6};
auto pos = upper_bound(nums.begin(), nums.end(), 3);
// pos = nums.begin() + 8, point to the first 4
```
