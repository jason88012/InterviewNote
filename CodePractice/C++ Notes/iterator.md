## Iterator特性

在寫了幾題需要用到iterator的題目後，可以知道iterator的特性如下:

## Random Access
在做random access的時候，iterator基本上就等同於index
```cpp
vector<int> nums = {0, 1, 2, 3, 4, 5};

int idx = 2;
int accessViaIndex = nums[idx];  // accessViaIndex == 2
int accessViaIterator = *nums.begin() + idx; // accessViaIterator == 2
```

## Algorithm Library
將iterator應用在`<algorithm>`的一些函式時，iterator要視為Python中的slice point
```cpp
vector<int> nums = {0, 1, 2, 3, 4, 5};
auto p = *max_element(nums.begin(), nums.begin() + 3);  // *p = 2
```
這邊`nums.begin()`的位置是在0的前面，`nums.begin()+3`的位置在2與3的中間，也就是如下所示:

```
| 0, 1, 2, | 3, 4, 5 |
b         b+3        e

b = begin();
e = end();
```

在需要計算某個區間的時候要記得iterator的正確位置!