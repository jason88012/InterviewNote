# Combination

Combination的重點如下:
1. 不同順序還是視為同一種combination (e.g. `[2, 4]` == `[4, 2]`)

## [77. Combinations](https://leetcode.com/problems/combinations/)
Given two integers n and k, return all possible combinations of k numbers out of the range [1, n]. You may return the answer in **any order**.

```
Input: n = 4, k = 2
Output:
[
  [2,4],
  [3,4],
  [2,3],
  [1,2],
  [1,3],
  [1,4],
]
```

```cpp
class Solution{
public:
    vector<vector<int>> combine(int n, int k) {
        ans_.clear();
        vector<int> tmp;
        backtracking(n, k, 1, tmp);
        return ans_;
    }
private:
    vector<vector<int>> ans_;
    void backtracking(int n, int remain, int start, vector<int>& tmp) {
        if (remain == 0) {
            ans_.push_back(tmp);
            return;
        }
        for (int i = start; i <= n; ++i) {
            tmp.push_back(i);
            backtracking(n, remain-1, i+1, tmp);
            tmp.pop_back();
        }
    }
};
```

## [39. Combination Sum](https://leetcode.com/problems/combination-sum/)
Given an array of distinct integers candidates and a target integer target, return a list of all unique combinations of candidates where the chosen numbers sum to target. You may return the combinations in any order.

```
Input: candidates = [2,3,6,7], target = 7
Output: [[2,2,3],[7]]
```

這題要多考慮一個條件:
1. 可以使用重複元素(類似於Coin Change)
2. 給的數字不會重複

CODE
```cpp
class Solution {
public:
    vector<vector<int>> combinationSum(vector<int>& nums, int target) {
        vector<int> tmp;
        ans_.clear();
        backtracking(nums, tmp, target, 0);
        return ans_;
    }
    
private:
    vector<vector<int>> ans_;
    void backtracking(vector<int>& nums, vector<int>& tmp, int remain, int idx) {
        if (remain < 0)
            return;
        if (remain == 0) {
            ans_.push_back(tmp);
            return;
        }
        
        for (int i = idx; i < nums.size(); ++i) {
            tmp.push_back(nums[i]);
            // can use same element, pass i to next call stack
            backtracking(nums, tmp, remain - nums[i], i);
            tmp.pop_back();
        }
    }
};
```

## [40. Combination Sum II](https://leetcode.com/problems/combination-sum-ii/)
延伸上題，但這次題目的條件改變:
1. 同一個數字只能使用**一次**
2. 給的數字會**有重複**數字出現

```
Input: candidates = [10,1,2,7,6,1,5], target = 8
Output: 
[
[1,1,6],
[1,2,5],
[1,7],
[2,6]
]
```

```cpp
class Solution {
public:
    vector<vector<int>> combinationSum2(vector<int>& nums, int target) {
        ans_.clear();
        vector<int> tmp;
        // For put same numbers together, need to sort first
        sort(nums.begin(), nums.end());
        backtracking(nums, tmp, target, 0);
        return ans_;
    }
private:
    vector<vector<int>> ans_;
    void backtracking(vector<int>& nums, vector<int>& tmp, int remain, int start) {
        if (remain < 0)
            return;
        if (remain == 0) {
            ans_.push_back(tmp);
            return;
        }
        for (int i = start; i < nums.size(); ++i) {
            // In same call stack (same position of the tmp array)
            // don't use same number
            if (i > start && nums[i] == nums[i-1])
                continue;
            tmp.push_back(nums[i]);
            // can't use same element, pass i+1
            backtracking(nums, tmp, remain - nums[i], i+1);
            tmp.pop_back();
        }
    }
};
```