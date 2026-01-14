# くだもの ぽん！

子供向けフルーツマージゲーム

## セットアップ

### 1. 画像ファイルの配置

以下の画像ファイルを `assets/images/` フォルダに配置してください：

- `cherry.png` - さくらんぼ
- `grape.png` - ぶどう
- `orange.png` - みかん
- `apple.png` - りんご
- `pear.png` - なし
- `watermelon.png` - すいか
- `melon.png` - メロン

**推奨サイズ**: 各画像は正方形で、100x100px〜200x200px程度が最適です。
背景は透明（PNG）にしてください。

### 2. BGM・効果音ファイルの配置

以下の音声ファイルを `assets/sounds/` フォルダに配置してください：

- `bgm.mp3` - ゲーム中のBGM（ループ再生されます）
- `merge.mp3` - フルーツが合体した時の効果音
- `drop.mp3` - フルーツを落とした時の効果音

**注意**: 音声ファイルが見つからない場合でも、ゲームは正常に動作します（音声なしで動作）。

### 3. アプリの実行

```bash
flutter pub get
flutter run
```

## 機能

- ✅ 7段階のフルーツ進化システム
- ✅ スライド＆タップ操作
- ✅ かわいい合体演出
- ✅ スコアシステム
- ✅ BGM・効果音対応
- ✅ 実際のフルーツ画像表示（画像がない場合は絵文字で表示）

## 画像の入手方法

以下のサイトから無料のフルーツ画像をダウンロードできます：

- [Pixabay](https://pixabay.com/) - 無料画像
- [Unsplash](https://unsplash.com/) - 無料写真
- [Flaticon](https://www.flaticon.com/) - アイコン

検索キーワード: "cherry", "grape", "orange", "apple", "pear", "watermelon", "melon"

## 音声の入手方法

以下のサイトから無料のBGM・効果音をダウンロードできます：

- [Freesound](https://freesound.org/) - 無料音声
- [Zapsplat](https://www.zapsplat.com/) - 無料効果音
- [Incompetech](https://incompetech.com/music/) - 無料BGM

**BGM推奨**: 明るく楽しい、ループできる音楽
**効果音推奨**: 短い「ポン」「ピッ」などの音
