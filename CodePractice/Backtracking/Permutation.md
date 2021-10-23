# Permutation

## [46. Permutations](https://leetcode.com/problems/permutations/)

Given an array nums of distinct integers, return all the possible permutations. You can return the answer in any order.
```
Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
```

這題題目有說輸入的數字不會重複，所以我們可以把每個index跟後面的所有index做交換，然後就可以把答案寫出來
```cpp
class Solution {
    public:
    vector<vector<int>> permute(vector<int>& nums) {
        ans_.clear();
        backtracking(nums, 0);
        return ans_;
    }

private:
    vector<vector<int>> ans_;
    void backtracking(vector<int>& nums, int start) {
        if (start == nums.size()) {
            ans_.push_back(nums);
            return;
        }

        for (int i = start; i < nums.size(); ++i) {
            swap(nums[i], nums[start]);
            backtracking(nums, start + 1);
            swap(nums[i], nums[start]);
        }
    }
};
```

## [47. Permutations II](https://leetcode.com/problems/permutations-ii/)

這題是上一題的延伸題，但這題的輸入有可能會有重複的數字
```
Input: nums = [1,1,2]
Output:
[[1,1,2],
 [1,2,1],
 [2,1,1]]
```

這題需要注意的重點如下:
1. 由於會有重複的數字出現，我們需要對`nums`做排序，把相同的數字擺在一起，然後在選擇要放哪個數字時跳過重複的數字
2. 為了coding方便，這次用一個`tmp` array逐一記錄要放的數字
3. 由於是逐一加入數字，所以每次加入array的index都不一定會從某個數字開始(e.g. `[2, 0, 1]`)，所以在找排列組合的過程中我們需要(1)記錄哪個index已經被用過 (2)每次for loop都從`0`開始，用過的數字跳過
4. 為了不挑到重覆數字(在下面的例子中就是使用了`2a`兩次)，我們必須在遇到相同數字時檢查前一個數字是否被已經被使用過了，如果已經被使用過了的話我們才可以使用現在這個相同的數字，以下圖為例，我們這樣可以保證所有相同的數字都是按照順序被加入`tmp`中的

```
        u   u
nums = [1, 2a, 2b, 2c, 3]
               ^
tmp = [1, 2a]
when check 2b, 2a is used, so we can add 2b to tmp
```

```
        u      
nums = [1, 2a, 2b, 2c, 3]
               ^
tmp = [1]
when check 2b, 2a is not used, so we should NOT add 2b now.
```

CODE:
```cpp
class Solution {
public:
    vector<vector<int>> permuteUnique(vector<int>& nums) {
        ans_.clear();
        used_ = vector<bool>(nums.size(), false);
        vector<int> tmp;
        // put same values together
        sort(nums.begin(), nums.end());
        bt(nums, tmp);
        return ans_;
    }

private:
    vector<vector<int>> ans_;
    vector<bool> used_;
    void bt(vector<int>& nums, vector<int>& tmp) {
        if (tmp.size() == nums.size()) {
            ans_.push_back(tmp);
            return;
        }
        for (int i = 0; i < nums.size(); ++i) {
            // If the number in this index is used, skip it.
            if (used_[i]) continue;
            // when meet same number,
            // should not use the one with larger index first.
            if (i > 0 && nums[i-1] == nums[i] && !used_[i-1]) continue;
            used_[i] = true;
            tmp.push_back(nums[i]);
            bt(nums, tmp);
            used_[i] = false;
            tmp.pop_back();
        }
    }
};
```

其實在leetcode討論區中有提到，不論使用:
- `if (i > 0 && nums[i-1] == nums[i] && !used_[i-1]) continue;`
- `if (i > 0 && nums[i-1] == nums[i] && used_[i-1]) continue;`

這兩個其實"都可以"，不過其實只要看上面的說明就知道，限制`!used_[i-1]`是為了讓加入重複數字的順序由前到後，反之`used_[i-1]`就是讓加入重複數字的順序由後到前。