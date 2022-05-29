# Monotonic Stack for NGE and PGE

所謂monotonic stack(mono stack)就是單調遞增或遞減的一個stack，在這個stack裡面的所有元素，由`top()`到`bottom()`只會逐漸增加或減少，例如:
```
s = [1, 3, 5, 10] <-- top (monotonic increasing stack)
s = [10, 5, 3, 1] <-- top (monotonic decreasing stack)
```

建構一個mono stack的主要想法如下:
- 所有數字都必須要被加入stack中
- 只要stack中的數字被`pop`掉後就不會再被考慮
- 當要加入一個新的數字時，如果加入這個數字會讓monotone消失(讓stack違反單調遞增或遞減的規則)，`stack.pop()`直到加入新數字可以滿足monotone為止(最多就是pop到empty)

所以我們以monotonic decreasing stack舉例，程式範本如下，這邊我們會用index代表數字，因為index同時也可以用來計算subarray大小而單純數字則不行
```cpp
vector<int> nums;
stack<int> s;
for (int i = 0; i < nums.size(); ++i) {
    while (!s.empty() && nums[s.top()] < nums[i]) {
        s.pop();
    }
    s.push(i);
}
```

## Next Greater Element (NGE) / Next Less Element (NLE)
mono stack其中一種應用就是找出array中所有數字的"Next Greater Element"(NGE)，所謂`NGE of nums[x]`就是index比`x`大且第一個比`nums[x]`更大的數字，例如:
```
nums = [3, 2, 6, 7, 5]
NGE of 3 = 6
NGE of 2 = 6
NGE of 6 = 7
NGE of 7 not exist (no greater next element)
NGE of 5 not exist (no next element)
```

如何利用mono stack找出NGE呢，先不論要使用increasing還是decreasing，我們先從建構mono stack的過程開始思考: 在建構mono stack的時候，如果新加進來的數字(右邊)比`stack.top()`(左邊)的數字大或小，我們就需要`pop`，而這時若我們想要找NGE，也就是對於"左邊"數字來說第一個在"右邊"且更大的數字，剛好我們需要在`nums[i] > stack.top()`時進行pop，也就是說我們得使用"decreasing stack"，而同時被pop掉的數字的NGE就是新加進來的這個數字。
```cpp
vector<int> nums;
int n = nums.size();
vector<int> nge(n, -1);
stack<int> s;
for (int i = 0; i < n; ++i) {
    while (!s.empty() && nums[s.top()] < nums[i]) {
        // the NGE of the poped number is nums[i]
        int left = s.top(); s.pop();
        nge[left] = i;
    }
    s.push(i);
}
```

反之如果我們想要找NLE，就把pop時的條件從"<"換成">"就可以(也就是改成使用mono increasing stack)

## Previous Greater Element (PGE) / Previous Less Element (PLE)
NGE是要找在某個數字`nums[x]`右邊第一個大於`nums[x]`的數字，那麼PGE就反過來是找在`nums[x]`左邊地一個大於`nums[x]`的數字。
```
nums = [3, 2, 6, 7, 5]
PGE of 3 not exist
PGE of 2 = 3
PGE of 6 not exist
PGE of 7 not exist
PGE of 5 = 7
```

這邊我們同樣使用decreasing stack來找PGE，在結束pop後，我們可以保證stack的top一定比`nums[i]`大(這樣在`nums[i]`加入後才能繼續維持monotone)，所以這時`nums[i]`的PGE就是`stack.top()`，不過我們也要考慮stack在建構過程中被pop到空的情況，所以code如下:
```cpp
vector<int> nums;
int n = nums.size();
vector<int> pge(n, -1);
stack<int> s;
for (int i = 0; i < n; ++i) {
    while (!s.empty() && nums[s.top()] < nums[i]) {
        s.pop();
    }
    pge[i] = stack.empty() ? -1 : stack.top();
    s.push(i);
}
```

同理找NLE則使用increasing stack
