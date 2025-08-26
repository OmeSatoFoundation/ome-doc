# IT未来塾教科書

## ビルド手順 (Docker)
### Prerequisites

[Docker Engine (または Docker Desktop)](https://docs.docker.com/engine/install/) をインストールする。

### 全章ビルドして book を作る
TODO: top-level source を作成し、すべての chapter を含める。

```
docker build . --output artifacts/
```

これは以下と等価である。

```
docker build . --output artifacts/ --build-args TARGET="."
```

`artifacts/` 以下に PDF や、ビルド時の中間ファイル (`.aux` 等) が出力される。

Note that `--output` must be `artifacts` otherwise latex cannot find intermediate files `.aux`, and it slows typeset time.

### チャプター単体をビルドする
例: 第 3 回をビルドする

```bash
TARGET=03
docker build . --output "${TARGET}/artifacts" --build-arg TARGE="${TARGET}"
```

`artifacts_03` に目的のファイルが生成される。

Note that `--output` must be `${TARGET}/artifacts` otherwise latex cannot find intermediate files `.aux`, and it slows typeset time.

### 全チャプターをそれぞれ単体で一度にビルドする
Linux なら、

```bash
for TARGET in 01 02 03 04 05 06 07 08 ; do docker build . --output ${TARGET}/artifacts --build-arg TARGET="${TARGET}"; done'
```

Note that `--output` must be `${TARGET}/artifacts` otherwise latex cannot find intermediate files `.aux`, and it slows typeset time.

### エラーが出るとき・texlive を自分でビルドしたいとき

何らかの理由でリモートコンテナレジストリからベースイメージを取得するのに失敗して以下のようなメッセージが現れた場合，

```
ERROR: failed to build: failed to solve: ghcr.io/omesatofoundation/ome-doc/ome-doc:latest: failed to resolve source metadata for ghcr.io/omesatofoundation/ome-doc/typsetenv:latest: ghcr.io/omesatofoundation/ome-doc/ome-doc:latest: not found
```

または，texlive をローカル環境でビルドしたい場合は，`docker build` コマンドにオプション

```
--build-arg BASE_IMAGE=buildenv
```

を追加して実行してください．例:

```bash
docker build . --output artifacts/ --build-args TARGET="." --build-args BASE_IMAGE=buildenv
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
CMD、Powershell、bash 等からチャプターディレクトリ (`01/`, `02/`, and so on) で `llmk` コマンドを発行。

```
cd 01/
llmk
```

## 参考
- (非公開) wiki のページ 『未来塾2023に向けた教科書執筆』
