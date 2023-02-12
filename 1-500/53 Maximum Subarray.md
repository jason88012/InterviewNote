# [53 Maximum Subarray](https://leetcode.com/problems/maximum-subarray/)

## 題目大綱
給一個array，找出sub-array中總和最大的值

## DP - O(n) space
由於sub-array必須要包含前一個元素(不然就沒有連續了)，所以在做dp時可以這樣考慮: 如果取前k個array可以拿到的最大值由前k-1個可以拿到的最大值與第k個元素決定，如果前k-1個能得到的最大值加上自己會變得更大，那當然要加上自己；如果前k-1個能得到的最大值加上自己反而比自己小，那代表前k個可以得到的最大值是**負數**，不要也罷，乾脆只使用自己反而更大，所以轉移方程式可以寫成如下:
```
dp[k] = max(dp[k-1] + nums[k], nums[k])
```

答案就可以寫成如下:
```cpp
    int maxSubArray(vector<int>& nums) {
        vector<int> dp(nums.size(), 0);
        dp[0] = nums[0];
        for (int i = 1; i < nums.size(); i++){
            dp[i] = max(dp[i-1] + nums[i], nums[i]);
        }
        int max_sum = dp[0];
        for (int i = 0; i < dp.size(); i++){
            if (dp[i] > max_sum) max_sum = dp[i];
        }
        return max_sum;
    }
```

## DP - O(1) space - Kadane's Algorithm
由上面的轉移函數，我們可以知道這題的轉移函數**只跟前一個值有關**，這樣的DP題目我們可以只使用O(1)的空間寫出來。
簡單來說就是利用一個變數來記錄每次iteration算出來的最大值(同時這個值可以在下次iteration時作為上一個iteration的結果，也就是轉移函數中的`dp[k-1]`)，再利用另一個變數去存到目前為止出現的最大值，如此可以改寫答案如下:
```cpp
    int maxSubArray(vector<int>& nums) {
        int curr = nums[0], res = nums[0];
        for (int i = 1; i < nums.size(); ++i) {
            // Use new item only or accumulate
            curr = max(nums[i], curr + nums[i]);
            // record result
            res = max(res, curr);
        }
        return res;
    }
```

```
Runtime: 134 ms, faster than 82.23% of C++ online submissions for Maximum Subarray.
Memory Usage: 67.7 MB, less than 90.31% of C++ online submissions for Maximum Subarray.
```

@dp
