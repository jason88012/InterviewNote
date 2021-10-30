## String Stream用法

## 字串分割
在c++做字串處理的時候很常會用到`stringstream`，基本上比較常用到的是`istringsteam`，用來分割字串

```cpp
#include <string>
#include <sstream>

string s = "go to google";
istringstream iss(s);

string tmp;
while (getline(iss, tmp, ' ')) {
    cout << tmp << '\n';
}
```
```
output:

go
to
google
```

其中`getline`的第三個input是delimiter(分割符)，**必須**是一個**字元**，不能輸入`string`或是`const char*`

## 字串合併(不太常用到)
另一個用法就是利用`ostringstream`做字串的合併
但因為`string`自帶了`operator+`，所以通常用比較簡便易懂的`+`就好了
```cpp
#include <string>
#include <sstream>
ostringstream oss;

oss << "go ";
oss << "to ";
oss << "google";

cout << oss.str();
```

```
output:

go to google
```

特別需要注意的是在分割字串的時候如果不特別指定分隔符的話，預設就是以一個空白字元做分割，但是在合併字串的時候沒有這個預設分隔符，所以空格要自己打進去。

## Read / Write
在[297. Serialize and Deserialize Binary Tree](https://leetcode.com/problems/serialize-and-deserialize-binary-tree/)中我們可以不把value的值轉成string,直接用stringstream的read/write去讀取int的binary資料，如此一來我們就省去了serialize時把int轉成string，deserialize時把string再轉回int的時間
用法如下:
```
ostringstream oss;
oss.write(char* ptr, int size);

istringstream iss;
oss.read(char* dest, int size);
```

如此我們整段string stream都是代表了數值，也省去了分割空格或`null`的空間
