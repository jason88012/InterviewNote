## Cyclic Sort

Cyclic sort是一種`Time: O(n), Space: O(1)`的排序法，但只適用於數列中所有數字(或是想排序的目標數字)範圍在`0 or 1 ~n-1`之間的時候
排序的方法很簡單，就是把對應的數字直接交換到他正確的位置，由於我們目標的數字都在`0~n-1`之間，所以一定有辦法換過去，那最後沒辦法做交換的那些數字還是會遺留在array裡面，但針對所有`0~n-1`的數字都會是已經排序好的

## Base case
```
[0, 2, 3, 1]
 ^  0 is in correct position, skip

[0, 2, 3, 1]
    ^ 2 should be put in index 2, swap to there

[0, 3, 2, 1]
    ^ 3 should be put in index 3, swap to there

[0, 1, 2, 3]
    ^  now 1 is correct, skip

[0, 1, 2, 3]
       ^  ^  2, 3 are correct, done
```

CODE:
```cpp
void cyclicSort(vector<int>& nums) {
    int i = 0, n = nums.size();
    while (i < n) {
        int correct_pos = nums[i]
        if (i == correct_pos) {
            i++;
        } else {
            swap(nums[i], nums[correct_pos]);
        }
    }
}
```

## Questions
[268. Missing Number](https://leetcode.com/problems/missing-number/)

```
Input: nums = [3,0,1]
Output: 2
Explanation: n = 3 since there are 3 numbers, so all numbers are in the range [0,3]. 2 is the missing number in the range since it does not appear in nums.
```

在這題需要注意的是，假設我們題目給`nums.size() = 3`，那目標的所有數字是`0, 1, 2, 3`，但是我們沒辦法交換到`index=3`的地方，所以當我們遇到無法交換的數字時我們必須要跳過，反正最後我們只要檢查數字跟index對不起來的地方就是答案，如果我們沒有找到對不起來的地方，那缺少的就是最後一個數字也就是`n`

```cpp
    int missingNumber(vector<int>& nums) {
        int i = 0, n = nums.size();
        while (i < n) {
            int correct_pos = nums[i];
            if (i == correct_pos || nums[i] == n) {
                i++;
            } else {
                swap(nums[i], nums[correct_pos]);
            }
        }
        for (int i = 0; i < n; ++i) {
            if (nums[i] != i) return i;
        }
        return n;
    }
```

PS. 其實這題最佳解是用XOR

[41. First Missing Positive](https://leetcode.com/problems/first-missing-positive/)

```
Input: nums = [3,4,-1,1]
Output: 2
```
這題要求的是找出第一個消失的"正數"，也就是說我們在意的數字其實只有`1~n`，看到這裡就知道可以使用cyclic sort把我們想要的正數都排好，最後再依序檢查第一個數字跟index對不起來的地方即可，如果沒有找到那就代表`1~n`都有了，所以答案就是`n+1`

但是這題有兩個需要注意的地方:
1. `INT_MIN`: 通常我們在計算正確的交換位置時我們會用`nums[i] - 1`，但這邊`nums[i]`有可能是`INT_MIN`，這樣就會overflow，不過由於我們只需要考慮`1~n`的數字，所以這個我們必須先判斷要交換的數字是否在我們目標區間內，這樣我們在真正做減法前，`INT_MIN`的case就會被排除掉了
2. 重複的數字: 假設我們拿到一個array長這樣: `[1, 1]`，當我們把第2個`1`交換到"正確的位置"之後，沒想到換過來的數字又是`1`，這樣就會進入無窮迴圈，所以我們必須把重複的數字排除掉

CODE:
```cpp
    int firstMissingPositive(vector<int>& nums) {
        int n = nums.size();
        int i = 0;
        while (i < n) {
            if (nums[i] <= 0 || nums[i] >= n || nums[i] == nums[nums[i] - 1]) {
                i++;
            } else {
                swap(nums[i], nums[nums[i] - 1]);
            }
        }
        for (int num = 1; num <= n; ++num) {
            if (num != nums[num-1])
                return num;
        }
        return n + 1;
    }
```