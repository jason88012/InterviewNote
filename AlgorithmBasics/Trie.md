# Trie
Trie(念try)就是字典樹，是可以用來快速搜尋prefix或sufix是否存在於一組字串中的資料結構，所以又被稱為prefix tree。這個資料結構運作的方式就是將每個字串中的字元拆解成樹中的節點，每個節點都用一個hash map去對應下一個有可能出現的字元。如下所示:
```
words = ["abc", "abd"]

trie:
 
   a --> b --> c
          \
           \
            d

```

這樣假設要找一個`prefix = "ab"`是否存在於`words`中，從樹的根結點往後找很快就能發現`"ab"`的確存在於`words`裡，這樣就不需要對整個`words`進行`O(n^2)`的搜尋

## Implementation
實作`Trie`需要先定義節點，上面說每個節點都需要用一個has map去存下一個可能出現的字串，所以首先我們定義`TrieNode`如下(這邊暫時不考慮memory leak的問題，所以不實作destructor或是使用smart pointer):
```cpp
struct TrieNode {
    unordered_map<char, TrieNode> children;
};
```
在每個節點中我們可以依據題目要求加入額外的資料，例如要是我們想判斷到這裡為止是否是一個完整的字串，我們可以加一個`bool is_end;`，或是我們想判斷這個字元原本是屬於`words`中的哪個index的就可以加入一個`int idx;`。

接下來就是開始實作Trie，Trie主要會有兩個介面:`add(string& s)`和`search(string& s)`，這兩個的實作方式幾乎是一模一樣，基本上就是從root節點開始，依據字串中每個字元不斷往後添加/搜尋節點。
```cpp
class Trie {
    TrieNode* root;
public:
    TrieNode() {
        root = new TrieNode();
    }

    void add(string& s) {
        TrieNode* curr = root;
        for (char c: s) {
            if (!curr->children.count(c)) {
                curr->children[c] = new TrieNode();
            }
            curr = curr->children[c];
        }
    }

    bool search(string& s) {
        TrieNode* curr = root;
        for (char c: s) {
            if (!curr->children.count(c)) {
                return false;
            }
            curr = curr->children[c];
        }
        return true;
    }
};
```

再來就是看題目要求我們找什麼東西，再把可能需要的額外資訊放進`TrieNode`中，當然如果題目有說輸入的字串只包含了小寫英文字母的話，可以把`unordered_map`用`vector<TrieNode*>(26)`或是`TrieNode* children[26]`取代
