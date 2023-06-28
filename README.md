# IT未来塾教科書

## ビルド手順 (Docker)
### Prerequisites (Docker)

[Docker Engine (または Docker Desktop)](https://docs.docker.com/engine/install/) をインストールする。

タイプセットのための Docker Image をビルドする。

```
# ome-doc を clone したディレクトリに移動する。
cd /path/to/ome-doc
# タイプセットのための Docker Image をビルドする。 1GB のストレージ使用と 1 時間程度の時間がかかる。
docker build . -t ome-doc-latex
```

### 全章ビルドして book を作る
TBD

### チャプター単体をビルドする
例: 第三回の教科書をタイプセットする

```
cd 03
docker run --rm -v $(pwd):/workdir ome-doc-latex llmk
```

中間ファイルを消去する

```
cd 03
docker run --rm -v $(pwd):/workdir ome-doc-latex llmk -c
```

その他 llmk の詳しい使い方: https://ftp.yz.yamagata-u.ac.jp/pub/CTAN/support/light-latex-make/llmk.pdf

### 全チャプターをそれぞれ単体で一度にビルドする
```
docker run --rm -v $(pwd):/workdir ome-doc-latex /bin/sh -c 'set -e; for d in 01 02 03 04 05 06 07 08 ; do ( cd $d; llmk ; ) ; done'
```

## ビルド手順 (Windows, Linux, Mac)
### Prerequisites
- TeXLive をインストールする (full scheme を選択する)
    - windows https://www.tug.org/texlive/windows.html
    - linux https://www.tug.org/texlive/quickinstall.html
    - mac https://www.tug.org/mactex/
- 依存パッケージをインストールする
    - 最新に必要なパッケージは  [Dockerfile:49 あたり](https://github.com/OmeSatoFoundation/ome-doc/blob/master/Dockerfile#L49) を参照。

```
$ tlmgr install bbding # libreoffice ソースから latex ソースへの自動変換を利用した際に必要。その他必要なパッケージは [Dockerfile:49 あたり](https://github.com/OmeSatoFoundation/ome-doc/blob/master/Dockerfile#L49) を参照。
```

- `llmk` をインストールする

```
$ tlmgr install light-latex-mk
```

### 全章ビルドして book を作る
TBD

### チャプター単体をビルドする
CMD、Powershell、bash 等からセクションディレクトリ (`01/`, `02/`, and so on) で `llmk` コマンドを発行。

```
cd 01/
llmk
```

## 参考
- (非公開) wiki のページ 『未来塾2023に向けた教科書執筆』
