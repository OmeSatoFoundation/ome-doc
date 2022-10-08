# IT未来塾教科書
## ビルド手順 (Windows, Linux, Mac)
### Prerequisites
- TeXLive をインストールする
- 依存パッケージをインストールする

```
$ tlmgr install bbding # libreoffice ソースから latex ソースへの自動変換を利用した際に必要。
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

## ビルド手順 (Docker)
### Prerequisites (Docker)

```
docker build . -t ome-doc-latex
```


### 全章ビルドして book を作る
TBD

### チャプター単体をビルドする

```
docker run --rm -v $(pwd):/workdir ome-doc-latex /bin/sh -c 'set -e; for d in 01 02 03 04 05 06 07 08 ; do ( cd $d; llmk ; ) ; done'
```

## 参考
- (非公開) wiki のページ 『未来塾2023に向けた教科書執筆』
