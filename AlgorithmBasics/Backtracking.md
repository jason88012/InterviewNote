# Backtracking

Backtracking是一種類似DFS的遞迴算法

這邊用一個簡單的例子來說明模板的寫法:
假設有一個`vector<int> num`，問有幾種方法可以找出一個組合使得這些數字總合為`target`

這邊主要有兩種形式:
1. 每個選項可以使用無限次
```cpp
void backtrack(vector<int>& nums, int target, int& res) {
    if (target < 0) return 0;
    if (target == 0) return 1;
    for (int num: nums) {
        res += backtrack(nums, target - num, res);
    }
}
```

2. 每個選項有限制使用次數
```cpp
// Use an additioal param "i" to inidicate which item we're checking now
static constexpr int limits = 2;
void backtrack(vector<int>& nums, int target, int i, int& res) {
    if (target < 0) return 0;
    if (target == 0) return 1;
    for (int count = 0; count <= limits; ++count) {
        res += backtrack(nums, target - count * nums[i], i + 1, res);
    }
}
```
