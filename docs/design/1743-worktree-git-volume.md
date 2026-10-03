# worktree で web コンテナが起動しない問題の解消 (#1743)

## 結論
`docker-compose.yml` の web サービスから `/work/app/.git` の匿名ボリュームを削除する。
worktree の `.git` はファイルなので、ディレクトリの匿名ボリュームを重ねられずコンテナが起動しない。
この除外は taskleaf の設定を移植した際 (2c6412f) に入ったもので理由がなく、外しても支障がない。

## 設計
外しても支障がないと判断した根拠:
- `.git` は 6.6MB で、bind mount による性能劣化は無視できる
- app / lib / config / packs / bin にコンテナ内で git を呼ぶ処理はない
- イメージビルドは `.dockerignore` で `.git` を除外済みで、この変更の影響を受けない

## 検討した代替案
| 案 | 却下理由 |
|---|---|
| worktree 用 `compose.override.yml` の例を用意する | Claude Code は Issue ごとに worktree を作るため、毎回設定が必要になる |

## Non-goals
- worktree のコンテナ内で git を使えるようにすること（`.git` が指すホストの絶対パスはコンテナにマウントされない。git はホストで実行する）
- README / CLAUDE.md の更新
