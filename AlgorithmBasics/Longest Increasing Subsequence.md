# [300. Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/)

所謂Longest Increasing Subsequence就是在array中一個最長的遞增序列，假設有一個array如下所示:

```
Input: nums = [10,9,2,5,3,7,101,18]
Output: 4
Explanation: The longest increasing subsequence is [2,3,7,101], therefore the length is 4.
```

## DP O(n<sup>2</sup>)
我們想在所有數字裡面挑出一組subset，同時我們的subset必須滿足兩個條件: (1)必須考慮加入順序，所以其實是subsequence (2) 後加入的數字必須比前加入的數字大

針對這種類似於`limited element 0/1 Knapsack`的題目，思考邏輯就是能否用前`i`個數字組出我們想要的答案，所以我們每層迴圈都新加入一個數字檢查，並且每次都考慮前面已經被加入的結果

考慮範例:
```
10 9 2 5 3 7 101 18
```
Base case: LIS初始條件都是1，因為只算上自己的話長度就是1

考慮`i=1`時，`9`並沒有比`10`大，所以LIS的長度此時還是1
```
nums: 10  9
LIS:   1  1
```

當考慮`i=2`時，`2`沒有比`10`大，也沒有比`9`大，所以LIS的長度此時還是1
```
nums: 10  9  2
LIS:   1  1  1
```

當考慮`i=3`，`nums[4] = 5`，`5`沒有比`10`大，也沒有比`9`大，但是`5`比`2`大，所以當加入`5`的時候LIS的長度就是2，而這個長度2是因為我們把"2"包含在LIS裡面，所以我們計算的方式是: `if (nums[i] > nums[j]) lis[i] = lis[j] + 1`
```
nums: 10  9  2  5
LIS:   1  1  1 2
```

當考慮`i=4`，`nums[4] = 3`，對於所有前面的數字，`3`只比`2`大，所以跟`i=3`的時候一樣，對於加入3之後的LIS長度是`2`並且這個數字是因為在`3`的前面加入了`2`
```
nums: 10  9  2  5  3
LIS:   1  1  1  2  2
```

當考慮`i=5`，`nums[5] = 7`，對於所有前面的數字，`7`比`2`大，所以對於在`7`的前面加入`2`來說，LIS的長度就是2，但同時`7`也比`5`和`3`大，如果我們在`7`的前面加入`5`或`3`，從前面的結果知道，我們同時也可以把`2`考慮進去，也就是說實際上我們LIS的更新方式是:
```
lis[i] = max(lis[i], lis[j] + 1);
```
這時LIS就會變成底下這樣
```
nums: 10  9  2  5  3  7
LIS:   1  1  1  2  2  3

compare: max(2 -> 7: 1+1 and 5 -> 7: 2+1 and 3 -> 7: 2+1) = 3
```

接下來就以此類推，可以把程式寫出來如下:
```cpp
    int lengthOfLIS(vector<int>& nums) {
        // for lis[i] means the lis length when using nums[0] ~ nums[i]
        int n = nums.size();
        // base class, all length is 1
        vector<int> lis(n, 1);
        int lis_length = 1;
        // add one number to check each time
        for (int i = 1; i < n; ++i) {
            // check all previous numbers
            for (int j = 0; j < i; ++j) {
                if (nums[i] > nums[j]) {
                    lis[i] = max(lis[i], lis[j] + 1);
                    lis_length = max(lis_length, lis[i]);
                }
            }
        }
        return lis_length;
    }
```

這樣時間複雜度是O(n<sup>2</sup>)，並且我們使用了一個array去儲存答案，空間需求為O(n)

## Patient Sort (With Binary Search)
參考: 

我們換一個比較直覺的方式去想，如果我們想要組出一個最長的LIS，在不知道後面的數字會有什麼的情況下，我們會希望LIS中的數字"越小越好"，這樣在後面找到更大的數字的機率就會比較高，也比較容易找出更長的LIS，假設有一個數列如下所示:
```
1  4  2  3
```
如果我們只看前三個數字，雖然`1 4`跟`1 2`的長度都是`2`，但明顯我們更希望是`1 2`，因為要找到比`2`大的數字比找到比`4`大的數字更容易，所以這時我們要做的就是把當前LIS中的4用2取代掉，也就是說每當我們想檢查一個新的數字，我們得檢查這個數字有沒有辦法取代掉當前LIS中的哪個數字，如果沒有，這代表當前數字比所有數字都大，那就把這個數字加到LIS的最後

同時我們組成的LIS是一個遞增數列，也就是他是已經"排序"好的，所以我們可以很容易的利用binary search找到可以取代掉的數字，而可以取代掉的數字是"在LIS中第一個比現在這個數字還要大的數字"，也就是`lower_bound`(lower_bound：找出vector中「大於或等於」val的「最小值」的位置)，就算是等於也沒關係，替換相同的數字結果是一樣的。

所以我們可以把答案寫出來
```cpp
    int lengthOfLIS(vector<int>& nums) {
        int n = nums.size();
        vector<int> lis;
        for (int i = 0; i < n; ++i) {
            auto pos = lower_bound(lis.begin(), lis.end(), nums[i]);
            if (pos == lis.end()) {
                lis.push_back(nums[i]);
            } else {
                *pos = nums[i];
            }
        }
        return lis.size();
    }
```

參考:
- [Wiki: Patient Sort](https://zh.wikipedia.org/wiki/%E8%80%90%E5%BF%83%E6%8E%92%E5%BA%8F)
- [花花酱 LeetCode 300 Longest Increasing Subsequence O(nlogn)](https://www.youtube.com/watch?v=l2rCz7skAlk)

## Conclusion
針對這題而言，使用patient sort是最佳的解法，但同時這題的DP概念也非常重要
