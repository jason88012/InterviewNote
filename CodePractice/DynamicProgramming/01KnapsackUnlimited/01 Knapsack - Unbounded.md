# 0/1 Knapsack with Unlimited Elements

這種類型的題目就是給你一堆不重複的數字，求出有幾種方法組合出某個數字，這類型的題目會有幾點限制:
1. 若組合的順序"不同"則視為"不同方法"
2. 同樣元素可以使用無限次(這就是為什麼給的數字不會重複，重複沒有意義)

## 經典題目:
- [322. Coin Change](https://leetcode.com/problems/coin-change/)
- [377. Combination Sum IV](https://leetcode.com/problems/combination-sum-iv/)

## 解法: 1D array DP
這種題目的解題想法是: 針對每一個目標組合，檢查每一個我們可以使用的元素看有沒有辦法組合出來，我們以coin change的範例舉例如下。

假設`coins`代表所有我們擁有的硬幣面額，目標是要用最少的硬幣數量組合出`target`的金額
```
coins = [1, 2, 5], target = 11
```

我們要確認的是針對每個金額，我們有沒有辦法用這些硬幣組合出來，並且最少使用多少個硬幣(當然針對這個範例，因為有面額=1的硬幣所以一定有辦法組合所有數字)，首先是基本的總合為"0"，當目標總合為0的時候，我們只要不使用任何硬幣就能組出0，所以需要的硬幣數量是0個
```
  0  1  2  3  4  5  6  ...
1 0  ?
2 0  ?
5 0  ?
```

再來看`target = 1`的時候，我們依序檢查所有可用選項然後發現可以使用面額`1`的硬幣來組出`target = 1`，需要幾個硬幣呢? 先不看DP的關係，反正我們知道要用`1`個，而面額`2`跟`5`是沒辦法組出`1`的，所以目前我們知道了: "組出1最少需要**1**個硬幣"
```
  0  1  2  3  4  5  6  ...
1 0  1  ?
2 0  x  ?
5 0  x  ?
```

接下來看`target = 2`的時候，依序檢查所有可用的選項，首先我們看到面額`1`，我們用直覺就能知道可以組出`2`，但為什麼可以呢? 因為我們知道前面我們已經可以組出`1`，所以我們只要對前面已經組出`target = 1`的硬幣需求數數再加一個面額=1的硬幣，就可以組出`2`了，這下我們發現了dp的關係如下:
```
dp[target] = dp[target - coin] + 1
```
接下來看面額`2`，同理我們知道因為可以用`0`個硬幣組出`0`，所以我們可以用`0+1`個面額`2`的硬幣組出`target = 2`，而這就是上面面額`1`組出`target  = 1`需要`1`個硬幣的理由。
```
  0  1  2  3  4  5  6  ...
1 0  1  2  ?
2 0  x  1  ?
5 0  x  x  ?
```

由於我們不需要計算`coin`比當前`target`還大的情況(因為根本不可能組不出來)，並且對於同一個target，我們只想取最小值，所以我們DP的轉移函數就可以改成這樣:
```
if (target >= coin)
    dp[target] = min(dp[target], dp[target - coin] + 1);
```

再加上一些題目的條件例如如果找不到組合就回傳`-1`之類的，這題的答案如下
```cpp
int coinChange(vector<int>& coins, int target) {
    int max_exchange = amount + 1;
    vector<int> exchange(amount + 1, max_exchange);
    exchange[0] = 0;
    for (int sum = 1; sum <= amount; ++sum) {
        for (int coin: coins) {
            if (sum >= coin) {
                exchange[sum] = min(exchange[sum], exchange[sum - coin]+1);
            }
        }
    }
    return exchange.back() == max_exchange ? -1 : exchange.back();
}
```

我們又可以延伸出這種題目的模板如下:
```cpp
bool unboundedKnapsack(vector<int>& options, int target) {
    vector<int> can_comb(target + 1, false);
    combinations[0] = true;
    for (int sum = 1; sum <= target; ++sum) {
        for (int option: options) {
            if (sum >= option) {
                can_comb[sum] = can_comb[sum] || can_comb[sum - option];
            }
        }
    }
    return can_comb.back();
}
```

如果要計算組合的種類數量，直接把`bool`改成`int`，`||`改成`+`就差不多了，例如`combination sum 4`:
```cpp
    int combinationSum4(vector<int>& nums, int target) {
        int n = nums.size();
        vector<double> ways(target + 1, 0);
        ways[0] = 1;
        for (int sum = 1; sum <= target; ++sum) {
            for (int num: nums) {
                if (sum >= num) {
                    ways[sum] += ways[sum - num];
                }
            }
        }
        return ways[target];
    }
```
