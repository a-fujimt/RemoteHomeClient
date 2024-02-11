# RemoteHome Client

## What's this?

家電の操作をGUIで行えるようにするもの

バックエンドは[こちら](https://github.com/a-fujimt/remotehome_backend)

## 動作要件

- iOS 15+ / macOS 11+

## Setup

- Xcodeでビルド
- アプリ起動後，左上の`Settings`をタップ
  - URL: サービスを起動しているサーバのURL
    - Ex: `https://example.com`（末尾の`/`は入れない）
  - Pass Phrase: 操作実行時に要求されるパスフレーズ
    - サーバ側で`passphrase`として設定している値

## 画面構成

- 家電リスト
- 操作リスト（家電ごとに異なる）

- 設定画面