# Subset Sum

這類型的題目通常就是要求在一個array中找到一組subset並且這個subset中所有數字的總和要符合某個條件，subset sum其實是一種`0/1 knapsack`的變形，針對每個元素我們可以選擇"加入"或是"不加入"目前的subset中。

通常會有以下4種類型:
1. Subset Sum: subset的總和需要等於某個數字
2. Eqal Subset Sum: 將array分成**兩個**subset並且兩個subset的總和相同
3. Minimun Subset Sum difference: 將array分成**兩個**subset並且求兩個subset差的最小值
4. Count Subset Sum: 求出有幾種subset的總和為某個數字

## Subset Sum
類型1和類型2其實是一樣的，放在一起講，最具代表性的題目就是: [416. Partition Equal Subset Sum](https://leetcode.com/problems/partition-equal-subset-sum/)

這題要求出是否有辦法將array分成2個subset並且兩個subset的總和相同
```
Input: nums = [1,5,11,5]
Output: true
Explanation: The array can be partitioned as [1, 5, 5] and [11].
```
拿上面這個例子來說，我們的目標就是找出總和為: `sum(nums) / 2` 也就是總和`11`的subset

針對這種`0/1knapsack`的題目，我們的狀態轉移方程式"通常"都是考慮兩東西: 1. 目前的index, 代表我們可以使用`nums` array中第0 ~ i個元素, 2. 目前可能可以達到的總和


一開始，無論使用array中哪個元素，要組合出總和是0都是可能的(什麼都不要拿)，所以`dp[i][0] = true;`
```
   0  1  2  3  4  5  6  7  8  9  10  11
1  T
5  T
```

接下來從第一個元素開始考慮:
如果只拿`1`有辦法組出`1`嗎? 答案是可以的，但此時我們還不確定這個關係是哪來的
如果只拿`1`有辦法組出`2`嗎? 答案是不行的，此時我們還是不確定這個關係是哪來的
接下來後面所有的都是不行的，所以我們大概可以知道，這個關係跟同一列的數字有關
```
   0  1  2  3  4  5  6  7  8  9  10 11
1  T  T  F  F  F  F  F  F  F  F  F  F
5  T
```

接下來考慮第二個元素:
如果拿`1`跟`5`有辦法組出`1`嗎? 答案是可以的，如果我們加入`1`而不加入`5`，那總和就是`1`，這時我們可以知道，dp的關係會跟上列的數字有關，如果`dp[i-1][num] == true`，那代表`dp[i][num]`也會是`true`，因為既然使用前面的元素就能組出目標總和，那代表我們只要**不加入**現在的元素一樣可以組出目標總和


接下來一直看到`5`，如果只拿`1`和`5`有辦法組出`5`嗎? 答案是可以!這時的組合方法就是**不加入**`1`但是**加入**`5`。這時我們看還沒加入`5`之前的總和`num - 5 = 0`是有辦法可以組出來的，那就代表我們可以在這個基礎上**加入**`5`
```
   0  1  2  3  4  5  6  7  8  9  10 11
1  T  T  F  F  F  F  F  F  F  F  F  F
5  T  T  F  F  F  T  ...
```

到這裡已經很清楚數字之間的關係了，轉移方程式寫出來就像下面這樣:
```
dp[i][num] = dp[i-1][num] || dp[i-1][num - nums[i]];
```

接下來我們再把它優化成1維矩陣
```
dp[num] = dp[num] || dp[num - nums[i]]
```
但注意這時如果我們還是從1開始算到target，在計算`dp[num+1]`的時候，前面的值其實都已經是加入了現在這個數字的值了，所以這時我們要用bottom up的方式，從target計算回1，才是正確答案

```cpp
    int n = nums.size();
    // dp[i][num]: possible to combin num with nums[0 ~ i]
    vector<bool> dp(target + 1, false);
    // always possible to combin a sum of 0 (don't pick any element)
    dp[0] = true;
    if (nums[0] <= target) dp[nums[0]] = true;
    for (int i = 1; i < n; ++i) {
        for (int num = target; num >= 1; --num) {
            if (num >= nums[i])
                dp[num] = dp[num] || dp[num - nums[i]];
        }
    }
```

