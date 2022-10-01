# Inline Function

一般的function call，CPU會依序做這幾件事:
- 把function的arguments存進stack memory
- 跳到function的memory address並開始執行function的指令
- 把return value存進return address
- 跳回function caller的address

正常來說這些操作並不會造成什麼效能上的影響，但要是執行function指令的時間還比這些操作短的話，我們可以使用`inline`關鍵字來降低操作所需的時間

`inline`類似於macro，會在compile time直接把function展開，這樣就不需要上面所說的address跳來跳去以及copy argument / return value的時間

## Properties
- `inline`生效於compile time，但只是一個對於compiler的"建議"，所以下了不一定有用，在某些情況下compiler不會對其做展開，例如: function內有 `for loop`、function是遞迴、function內有`static` variable...等等

## Pros
- 降低function call的overhead (上述記憶體操作)

## Cons
- 由於function會在原地做展開，所以`inline` function會使用更多的變數，也就是需要更多的register
- 同上，如果使用太多`inline`，這等於我們重複寫了很多一樣的code，那binary size就會變大
- 同上，每當修改`inline` function中的內容，每個使用到他的地方都需要重新編譯，增加編譯時間

## Difference between macro
`inline`與C語言中的macro相比比較安全，因為macro真的就是直接展開而已，而`inline` function則可以處理不同的access權限(例如`private member`)
