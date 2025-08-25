# The MIT License (MIT)
# Copyright (c) 2016 Kaito Udagawa
# Copyright (c) 2016-2018 3846masa
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Modified by Yohei Shimmyo in 2022

FROM ubuntu:24.04 AS texlive

# Install packages being dependent on texlive installation.

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get --no-install-recommends install -y \
    ca-certificates \
    curl \
    perl \
    tar \
    xz-utils \
    ;

WORKDIR /install-tl-unx
RUN --mount=type=bind,source=prod/texlive.profile,target=./texlive.profile \
    curl -LO https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2023/install-tl-unx.tar.gz && \
    tar -xzf ./install-tl-unx.tar.gz --strip-components=1 && \
    ./install-tl \
        --no-interaction \
        --profile ./texlive.profile \
        --repository https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2023/tlnet-final/
RUN --mount=type=bind,source=prod/texlive.profile,target=./texlive.profile \
  tlmgr update --self && \
  tlmgr install \
  bbding \
  collection-fontsrecommended \
  collection-langjapanese \
  collection-latexextra \
  latexmk \
  light-latex-make \
  ;

FROM ubuntu:24.04 AS font
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get --no-install-recommends install -y \
    ca-certificates \
    curl \
    tar \
    xz-utils \
    ;
WORKDIR /root/fonts
RUN mkdir -p /usr/share/fonts/TTF && \
    curl -L --remote-name-all \
        https://github.com/liberationfonts/liberation-fonts/files/7261482/liberation-fonts-ttf-2.1.5.tar.gz \
        https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont00401.zip \
        https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip \
        https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKjp-hinted.zip \
        && \
    tar -xvf liberation-fonts-ttf-2.1.5.tar.gz -C /usr/share/fonts/TTF && \
    unzip IPAexfont00401.zip NotoSansCJKjp-hinted.zip NotoSerifCJKjp-hinted.zip -d /usr/share/fonts/TTF
WORKDIR /usr/share/fonts/TTF
RUN curl -L --remote-name-all  \
        https://github.com/google/fonts/raw/main/ofl/bizudgothic/BIZUDGothic-Bold.ttf \
        https://github.com/google/fonts/raw/main/ofl/bizudgothic/BIZUDGothic-Regular.ttf \
        https://github.com/google/fonts/raw/main/ofl/bizudmincho/BIZUDMincho-Bold.ttf \
        https://github.com/google/fonts/raw/main/ofl/bizudmincho/BIZUDMincho-Regular.ttf \
        https://github.com/google/fonts/raw/main/ofl/bizudpgothic/BIZUDPGothic-Bold.ttf \
        https://github.com/google/fonts/raw/main/ofl/bizudpgothic/BIZUDPGothic-Regular.ttf \
        https://github.com/google/fonts/raw/main/ofl/bizudpmincho/BIZUDPMincho-Bold.ttf \
        https://github.com/google/fonts/raw/main/ofl/bizudpmincho/BIZUDPMincho-Regular.ttf \

RUN echo -e '\
<?xml version="1.0"?>\n\
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">\n\
<fontconfig>\n\
    <alias>\n\
        <family>serif</family>\n\
        <prefer>\n\
            <family>Noto Serif CJK JP</family>\n\
        </prefer>\n\
    </alias>\n\
    <alias>\n\
        <family>sans-serif</family>\n\
        <prefer>\n\
            <family>Noto Sans CJK JP</family>\n\
        </prefer>\n\
    </alias>\n\
</fontconfig>' >> /etc/fonts/local.conf

FROM ubuntu:24.04 AS runtime_dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get --no-install-recommends install -y \
    fontconfig \
    ghostscript \
    inkscape \
    ;

FROM runtime_dependencies AS build
# Specify which source to be built. Default is one at project root.
# For example: --build-arg TARGET=05/
# TODO: make a top-level tex source that includes all chapters as one book.
ARG TARGET=.
# Copy texlive
COPY --from=texlive /opt/texlive/2023 /opt/texlive/2023
COPY --from=font /usr/share/fonts/TTF /usr/share/fonts/TTF
COPY --from=font /etc/fonts/local.conf /etc/fonts/local.conf

RUN fc-cache -f

WORKDIR /build
RUN --mount=type=cache,target=/root/.texlive2023/texmf-var/luatex-cache \
    --mount=type=bind,target=${TARGET},rw=true \
    llmk

FROM scratch AS final
COPY --from=build /build/artifacts /
