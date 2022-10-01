# [78. Subsets](https://leetcode.com/problems/subsets/)

## Problem
Given an integer array nums of unique elements, return all possible subsets (the power set).
The solution set must not contain duplicate subsets. Return the solution in any order.

```
Input: nums = [1,2,3]
Output: [[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]
```

給一組數字求出所有subset的組合

## Backtracking
看到這種要找出"所有組合"的題目，就是使用backtracking暴力解，我們每次選擇一個數字都可以選擇"要"或"不要"加入subset中，所以總共有`O(2^n)`種組合，接著就能寫出程式碼如下:

```cpp
class Solution {
public:
    vector<vector<int>> subsets(vector<int>& nums) {
        vector<vector<int>> ans;
        vector<int> tmp;
        helper(nums, 0, tmp, ans);
        return ans;
    }
    
private:
    void helper(vector<int>& nums, int idx, vector<int>& tmp, vector<vector<int>>& ans) {
        if (idx >= nums.size()) {
            ans.push_back(tmp);
            return;
        }
        // not use nums[idx]
        helper(nums, idx + 1, tmp, ans);
        // use nums[idx]
        tmp.push_back(nums[idx]);
        helper(nums, idx + 1, tmp, ans);        
        tmp.pop_back();
    }
};
```

這邊稍微要記得的就是離開call stack時要把上一次使用的數字從`tmp` pop掉

```
Runtime: 4 ms, faster than 54.98% of C++ online submissions for Subsets.
Memory Usage: 10.6 MB, less than 26.81% of C++ online submissions for Subsets.
```

## Bit Mask
看到這個"每個元素都可以選擇要或不要"，我們可以試著將他與bit mask對應起來:

```
nums = [1, 2, 3] --> size = 3 --> 2^3 = 8 possible subsets

0  0  0 --> []
0  0  1 --> [1]
0  1  0 --> [2]
0  1  1 --> [1,2]
1  0  0 --> [3]
1  0  1 --> [1,3]
1  1  0 --> [2,3]
1  1  1 --> [1,2,3]
```

所以實際上我們可以用2個for迴圈搞定

```cpp
    vector<vector<int>> subsets(vector<int>& nums) {
        vector<vector<int>> ans;
        int n = nums.size();
        int possible = pow(2, n);
        for (int i = 0; i < possible; ++i) {
            vector<int> tmp;
            int mask = i;
            for (int j = 0; j < n; ++j) {
                if (mask >> j) tmp.push_back(nums[j]);
            }
            ans.push_back(tmp);
        }
        return ans;
    }
```
實作上要記得每個數字都只需要位移`n`次，所以可以用`for`去做bit mask檢查，不必使用`while (mask)`去跑，雖然時間複雜度都是`O(2^n)`，但這個方法比使用backtracking減少了call stack需要儲存的記憶體空間

```
Runtime: 4 ms, faster than 54.98% of C++ online submissions for Subsets.
Memory Usage: 7.2 MB, less than 46.79% of C++ online submissions for Subsets.
```
