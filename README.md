#はこウォーク(仮)

##運用ルール
* 1人がStoryBoardを編集する
* branch名は「名前/処理内容」や「名前/処理内容_処理内容」とする
 - 例1 : kawabe/hoge
 - 例2 : kawabe/hoge＿hoge
* コードレビューは全員で行う
* ○人が承認すればmergeする
* PullRequestのmergeは河辺が行う
* **rebaseはしないこと**
 -  ```git
`git merge --no-ff branch`を利用する
```
