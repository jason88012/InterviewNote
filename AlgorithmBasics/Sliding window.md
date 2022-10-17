# Sliding Window Template

Sliding Windows通常用於一個/兩個字串/subarray的比對，通常是要找出string中是否有滿足某個條件的`substring`或`subarray`，或是找有幾個subarray符合題目條件。

## 經典例題:
Find longest substring / subarray
- [3. Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters/)
- [159. Longest Substring with At Most Two Distinct Characters](https://leetcode.com/problems/longest-substring-with-at-most-two-distinct-characters/)
- [340. Longest Substring with At Most K Distinct Characters](https://leetcode.com/problems/longest-substring-with-at-most-k-distinct-characters/)

Compare 2 string
- [76. Minimum Window Substring](https://leetcode.com/problems/minimum-window-substring/)
- [30. Substring with Concatenation of All Words](https://leetcode.com/problems/substring-with-concatenation-of-all-words/)

Fixed size sliding window
- [567. Permutation in String](https://leetcode.com/problems/permutation-in-string/)

Find how many subarray meets the requirement
- [713. Subarray Product Less Than K](https://leetcode.com/problems/subarray-product-less-than-k/)
- [2444. Count Subarrays With Fixed Bounds](https://leetcode.com/problems/count-subarrays-with-fixed-bounds/)



## Find substring / subarray
這種類型的題目就是要找出"一個"array/string中最長/最短的subarray/substring，我們要做的通常是用一個`unordered_map`紀錄window裡面的元素(通常可以被優化成使用`vector<int>(256, 0)`(string內只有ASCII字元)或是`vector<int>(26, 0)`(string內只有小寫英文字母))，並在發現window裡面的條件超出題目要求的時候縮減左邊window大小直到再度滿足題目條件

```cpp
    // 340. Longest Substring with At Most K Distinct Characters
    int lengthOfLongestSubstringKDistinct(string s, int k) {
        int n = s.size();
        int l = 0, r = 0;
        vector<int> count(256, 0);
        int distinct = 0;
        int max_len = 0;
        while (r < n) {
            // Add s[r] to hash map and keep tracking the
            // requirment of the problem (distinct counts)
            char rc = s[r++];
            count[rc]++;
            if (count[rc] == 1) {
                distinct++;
            }
            // when distinct count exceed the requirement (> k)
            // shrink left bound and remove s[l] until meet requirment again
            while (distinct > k) {
                char lc = s[l++];
                count[lc]--;
                if (count[lc] == 0) {
                    distinct--;
                }
            }
            // calculate the answer size
            max_len = max(max_len, r - l);
        }
        return max_len;
    }
```

## Compare 2 string
這類型的題目通常就是要在一個string內找到以某種方式呈現的另一個string，並且找到一個最短或最長的substring，這邊我們就要用"兩個"`unordered_map`(一樣盡量優化成使用`vector`)來記錄`target`和當前找到的組合，並且在所有條件滿足後開始縮減window左半部邊界

這邊要特別注意的是，由於題目給的target string可能會含有重複字元，所以當在搜尋另一個string的時候也必須要注意對應的字元是否也出現過相同次數

```cpp
    // 76. Minimum Window Substring
    string minWindow(string s, string t) {
        int n = s.size();
        vector<int> target(128, 0), search(128, 0);
        // create target map
        // only increase requirement when meet different word
        int requirement = 0;
        for (char c: t) {
            if (target[c] == 0) {
                requirement++;
            }
            target[c]++;
        }
        
        int l = 0, r = 0;
        int pos = -1, min_len = INT_MAX;
        while (r < n) {
            char rc = s[r++];
            // only increase the searching map when meet char in target
            if (target[rc] > 0) {
                search[rc]++;
                // Only decrease requirement when search char appears
                // same times as in target map e.g. ABA vs AAB
                if (search[rc] == target[rc]) {
                    requirement--;
                }
            }
            // when requirement == 0, means we find one valid window
            while (requirement == 0) {
                // calculate ans
                int len = r - l;
                if (len < min_len) {
                    min_len = len;
                    pos = l;
                }
                // shrink window's left bound
                char lc = s[l++];
                if (target[lc] > 0) {
                    if (search[lc] == target[lc]) {
                        requirement++;
                    }
                    search[lc]--;
                }
            }
        }
        return pos == -1 ? "" : s.substr(pos, min_len);
    }
```

## Fixed size sliding window
這類型的題目有點類似前兩種的綜合，但是這邊的window size是固定大小的，所以實際上比較簡單，假設總共`n`個數字或字元，window大小`k`，則只需要檢查`n-k`個window，這裡基本上也是用`unordered_map`或是`vector`紀錄尋找過程，但是縮減左側邊界的條件改為window大小超過`k`
```cpp
    // 567. Permutation in String
    bool checkInclusion(string s1, string s2) {
        int n = s1.size(), m = s2.size();
        vector<int> target(26, 0), search(26, 0);
        int requirment = 0;
        for (char c: s1) {
            int i = c - 'a';
            if (target[i] == 0) {
                requirment++;
            }
            target[i]++;
        }
        
        int l = 0, r = 0;
        while (r < m) {
            int ri = s2[r++] - 'a';
            if (target[ri] > 0) {
                search[ri]++;
                if (search[ri] == target[ri]) {
                    requirment--;
                }
            }
            // only shrink left bound when window size exceed n
            while (r - l > n) {
                int li = s2[l++] - 'a';
                if (target[li] > 0) {
                    if (search[li] == target[li]) {
                        requirment++;
                    }
                    search[li]--;
                }
                
            }
            if (requirment == 0) return true;
        }
        return false;
    }
```

## Count subarray meets requirement
像這種類型的題目通常就是給你一個條件，並要你找出有幾個sub array滿足題目的條件，例如: 相乘不大於某個數字，相加不大於某個數字，最大最小值的範圍限制在x ~ y等等，這時我們要做的就是利用sliding window去找出滿足的subarray長度，再透過長度去計算總共有幾種可能，計算sub array數量的方法每題都不一樣，不過基本上有兩種概念:
1. 最短符合長度的sub array長度是1 --> 計算方式就是每增加一個就多當前window長度的個數，例如:
```
[1,2,3,4] 符合條件，那要計算的可能性就有
[1]
[1,2] [2]
[1,2,3] [2,3] [3]
[1,2,3,4] [2,3,4] [3,4] [4]
```
所以就等同於: 1 + 2 + 3 + 4，實際上就是計算"若加入最新的這個數字會多幾種可能"

2. 最短符合長度的sub array長度不只1 --> 計算方式就是先找出最短符合長度的sub array起始的index，每當右側長度增加，就增加左側長度個個數。例如:
```
[ j, ... lb-3, lb-2, lb-1, lb ... rb, rb+1, rb+2, rb+3 ..., k]
最短符合條件的長度是arr[lb:rb]
但在lb(left bound)之前又有一些數字也符合，假設長度是j
這代表在rb(right bound)之後每增加一個數字，就會多j種可能(把left bound的數字逐一拔掉，共j種可能)
```
所以計算方法等同於: `for (i in range(rb+1, k)): res += j`
實際上計算出來的結果等同於: `j * k`，也符合通常計算這種東西的原理
