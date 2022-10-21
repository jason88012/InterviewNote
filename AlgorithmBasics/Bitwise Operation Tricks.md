# Bitwise Operation

紀錄一些bitwise計算的特殊用法

## low bit
假設有一個數字`0b00100110`，所謂low bit就是最低有效位代表的數字，在這裡就是`0b00000010`也就是`2`，計算low bit會被應用於fenwik tree中，計算方法如下:
```cpp
inline int lowbit(int x) {
    return x & (-x);
}
```
要計算low bit的方法其實就是把除了最低位的數字全部都消掉，我們首先知道怎麼把全部的數字消掉，也就是:
```
x & (~x)
```
而為了保留最後一位，我們就把`(~x)`減1，也就是`(~x - 1)`，而這其實就等同於`x`的補數`-x`，所以計算的公式才會如上所示。

## remove low bit
在計算一個int中有幾個`0b1`時，除了對32個bit都做`AND`計算，我們還可以透過每次都把low bit移除掉來計算，移除的方法跟low bit很像:
```cpp
inline int removeLowBit(int x) {
    return x & (x - 1);
}
```
這個原理是，假設有一個數字`0b00100000`，對其做減一後，會把lowbit之後的數字"100000"變成"011111"，這樣再去做`AND`計算後就會把後面整串全部抵銷了。

## Bitwise operation Laws
這邊說的Laws指的是"交換率"與"結合率"，`AND`, `OR`, `XOR`都具有交換率與結合率的特性。

## Inclusion-Exclusion Principle 排容原理
```
bits(num1 OR num2) + bits(num1 AND num2) = bits(num1) + bits(num2)
```
