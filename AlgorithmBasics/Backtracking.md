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

2. 每個選項有限制使用次數，`nums`裡面的數字"不重複出現"
[1774. Closest Dessert Cost](https://leetcode.com/problems/closest-dessert-cost/)
```cpp
// Use an additioal param "idx" to inidicate which item we're checking now
static constexpr int limits = 2;
void backtrack(vector<int>& nums, int target, int idx, int& res) {
    if (target < 0) return 0;
    if (idx >= nums.size()) {
        return target == 0;
    }
    
    // Chcek each element can use what times
    for (int count = 0; count <= limits; ++count) {
        res += backtrack(nums, target - count * nums[idx], idx + 1, res);
    }
}
```

3. 每個選項限制使用"一次"，`nums`裡面的數字"可能重複出現"
[40. Combination Sum II](https://leetcode.com/problems/combination-sum-ii/)
```cpp

// This need nums to be sort
sort(nums.begin(), nums.end());

void backtrack(vector<int>& nums, int target, int idx, int& res) {
    if (target < 0) return 0;
    if (i >= nums.size()) {
        return target == 0;
    }

    for (int i = idx; i < nums.size(); ++i) {
        // In same call stack (same position of the tmp array)
        // don't use same number
        if (i > idx && nums[i] == nums[i - 1])
            continue;
        res += backtrack(nums, target - nums[i], idx + 1, res);
    }
}
```