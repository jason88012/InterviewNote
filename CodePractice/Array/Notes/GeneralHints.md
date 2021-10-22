# General Hint About Solving Array Problem

## Maximun Subarray Sum
Kadane's Algorithm:

```cpp
int maximunSubarraySum(vector<int>& nums) {
    int n = nums.size();
    int local_max = 0, total_max = 0;
    for (int i = 0; i < n; ++i) {
        local_max = max(0, local_max + nums[i]);
        total_max = max(local_max, total_max);
    }
    return total_max;
}
```

## Longest Increasing Subsequence Length
Patience sort:

```
Input: [0,3,1,6,2,2,7]

0
0->3
0->1    (1 is less than 3, greater than 0, replace 3 to 1)
0->1->6
0->1->2 (2 is less than 6, greater than 1, replace 6 to 2)
0->1->2
0->1->2->7

ans = 4
```

```cpp
int LongestIncreasingSubsequence(vector<int>& nums) {
    vector<int> lis;
    for (int num: nums) {
        auto insert_positon = lower_bound(lis.begin(), lis.end(), num);
        if (insert_positon == lis.end()) {
            lis.push_back(num);
        } else {
            *insert_positon = num;
        }
    }
    return lis.size();
}
```

## Longest Increasing Subarray Length
Use linear scan is better than double pointer (double pointer is more error prone)
```cpp
int longestIncreasingSubarray(vector<int>& nums) {
    int n = nums.size();
    // consider a special case for empty array and only one element
    if (n <= 1) return n;
    int len = 1, max_len = 1;
    for (int i = 1; i < n; ++i) {
        if (nums[i] > nums[i-1]) {
            len++;
        } else {
            len = 1;
        }
        max_len = max(max_len, len);
    }
    return max_len;
}
```