# Codecov のアップロードを rspec_job に統合する (#1755)

## 結論
`codecov_job` と artifact の受け渡しをやめ、rspec_job の最後のステップで Codecov にアップロードする。`continue-on-error: true` と `fail_ci_if_error: false` を付け、別ジョブにした目的（af73dcf: Codecov の障害で CI を落とさない）は保つ。壁時計は約 7〜8s 縮む見込み。

## 設計
```yaml
- name: Codecov
  if: ${{ !cancelled() && hashFiles('coverage/lcov.info') != '' }}
  continue-on-error: true
  uses: codecov/codecov-action@v7.1.1
  with:
    token: ${{ secrets.CODECOV_TOKEN }}
    files: coverage/lcov.info
    fail_ci_if_error: false
    disable_file_fixes: true
    verbose: true
```

- **`!cancelled()`**: テストが失敗してもアップロードする（従来の `always()` と同じ）。キャンセル時はアップロードしない（従来の `result != 'cancelled'` と同じ）
- **短縮量の内訳**（#1749・#1750 の実測）: `Upload Coverage` ジョブの 8〜9s と、ジョブ間の待ち約 2s がなくなる。artifact のアップロードの 1s も減る。代わりに Codecov のステップ 2〜3s が rspec_job に加わる
- **required checks**: develop の必須チェックは `rspec_job`・`rubocop`・`erb-lint` で、`Upload Coverage` は含まれない。ジョブを消しても、マージがブロックされることはない

## 検討した代替案
| 案 | 却下理由 |
|---|---|
| 別ジョブのまま残す | 別ジョブの利点は「Codecov の障害で rspec_job を落とさない」ことだけで、`continue-on-error` でも同じ効果が得られる |
| `if: always()` にする | キャンセルされた run でもアップロードが走る。従来の挙動から変わる |

## Non-goals
- #1754・#1756・#1757（#1744 の残りの案）
- Codecov の設定（フラグやカバレッジの閾値）の見直し
