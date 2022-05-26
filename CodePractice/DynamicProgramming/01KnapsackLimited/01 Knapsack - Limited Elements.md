# 0/1 Knapsack with Limited Elements

這種類型的題目，大意就是給定一些元素，元素可能會重複或不重複，並且我們透過從這些元素挑選出一個組合並且達成一個目標，題目會要求我們**不能使用同一個元素**，最常看到的關鍵字大概就是"Subset Sum"

## 經典題目:
- [416. Partition Equal Subset Sum](https://leetcode.com/problems/partition-equal-subset-sum/)
- [518. Coin Change 2](https://leetcode.com/problems/coin-change-2/)

## 解法
這類型的題目，我們的思考方法是，**假設總共有`n`個元素，如果我們使用前`i`個元素，有沒有辦法組合成某些數字**，以`Partition Equal Subset Sum`為例就是給一個長度為`n`的int array，有沒有辦法用前`i`個數字組合出目標`target`


## 2D array DP
考慮以下數字，我們目標是找出有沒有辦法平分這個array，而這個array總和是22，也就是我們的目標是找出subset sum為11的一組subset。
```
Input: nums = [1,5,11,5]
```

假設我們可以使用前`i`個數字，那同時也包含了"使用0個數字"，假設我們想組出`target=11`，也包含了組出`0`，所以我們的DP array大小應該如下:
```
// consider use 0 numbers and sum == 0 as well
vector<vector<bool>> dp(n+1, vector<bool>(target+1, false));
```

首先決定Base case，無論使用array中前幾個數字，要組合出總和是0都是可能的(什麼都不要拿就好)，所以:
```
for (int i = 0; i <= n; ++i) {
   dp[i][0] = true;
}
```

接著逐一加入數字，檢查用前i個數字有辦法組出那些數字，首先看第一個數字`1`，我們可以用`1`組合出`1`，所以針對`dp[1][1] = true`
```
   0  1  2  3  4  5  6  7  8  9  10  11
x  T  F  F  F  F  F  F  F  F  F   F   F
1  T [T] F  F  F  F  F  F  F  F   F   F
```

接著看使用前2個數字時的條件，這裡有三個地方需要注意:
1. 只要前`i-1`個數字組出有辦法組出某個數字，那使用前`i`個數字一定也可以得到相同結果，因為我們只要不使用當前數字即可，所以當我們看到`dp[2-1][1] == true`時，`dp[2][1]`直接就是`true`
2. 再來我們只使用`5`一樣可以組合出`5`，所以`dp[2][5] = true`
3. 再來就是我們同時使用`1`跟`5`，就可以組合出`6`，所以`dp[2][6] = true`，但這邊的想法是，因為使用前`i-1`個數字已經有辦法組合出`1`，所以當我們看到`dp[i-1][1] == true`時我們就可以知道`dp[i][1 + 5]`也應該要辦的到
```
   0  1  2  3  4  5  6  7  8  9  10  11
x  T  F  F  F  F  F  F  F  F  F   F   F
1  T  T  F  F  F  F  F  F  F  F   F   F
5  T [T] F  F  F [T][T] F  F  F   F   F
```

其實上面第2點跟第3點是完全相同的意思，因為無論如何我們可以都組合出`0`，所以`dp[i][0 + nums[i]]`一定都是`true`

這樣我們就可以寫出二維DP的模板:
```cpp
bool subsetSum(vector<int>& nums, int target) {
   int n = nums.size();
   vector<vector<bool>> dp(n + 1, vector<bool>(target + 1, false));
   for (int i = 0; i <= n; ++i) {
      dp[i][0] = true;
   }
   // using first i numbers
   for (int i = 1; i <= n; ++i) {
      // can compose subset sum == t?
      for (int t = 1; t <= target; ++t) {
         dp[i][t] = dp[i-1][t] || 
                    (t >= nums[i-1]) ? dp[i-1][t - nums[i-1]] : false;
      }
   }
   return dp[n][target];
}
```

## 1D array DP
接著我們發現其實`dp[i][t]`只跟`dp[i-1][t]`和`dp[i-1][t - nums[i-1]]`有關，在二維關係中代表只跟上一列的數字有關，那這代表我們可以只使用1d array來儲存DP的計算過程。

但是這邊我們不能直接無腦取代直接把`[i-1]`全部拔掉，如果是這樣的話，`dp[i-1][t - nums[i-1]]`變成`dp[t - nums[i-1]]`，如果我們第二層`for`一樣是由`1`算到`target`的話，在更新`dp[t - nums[i-1]]`時其實已經是計算到`dp[i][t - nums[i-1]]`了，這樣結果就會不對，所以我們第二層`for`要反過來由高至低計算:
```cpp
bool subsetSum(vector<int>& nums, int target) {
   int n = nums.size();
   vector<bool> dp(target + 1, false);
   dp[0] = true;
   // using first i numbers
   for (int i = 1; i <= n; ++i) {
      // can compose subset sum == t?
      for (int t = target; t >= 1; --t) {
         // This is the code with same concept above
         // dp[t] = dp[t] || (t >= nums[i-1]) ? dp[t - nums[i-1]] : false;

         // a better way to write it
         if (t >= nums[i-1]) {
            dp[t] = dp[t] || dp[t - nums[i-1]];
         }
      }
   }
   return dp.back();
}
```
