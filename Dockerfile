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

FROM alpine:3.15.0
ENV PATH /usr/local/bin/texlive:$PATH
RUN apk add --no-cache \
  fontconfig \
  ghostscript \
  inkscape \
  perl \
  tar \
  wget \
  xz

# Install fonts
RUN mkdir /usr/share/fonts/TTF \
    && mkdir ~/fonts
WORKDIR ~/fonts
RUN wget https://github.com/liberationfonts/liberation-fonts/files/7261482/liberation-fonts-ttf-2.1.5.tar.gz \
    && tar -zxvf liberation-fonts-ttf-2.1.5.tar.gz \
    && mv liberation-fonts-ttf-2.1.5/LiberationMono*.ttf /usr/share/fonts/TTF \
    && wget https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont00401.zip \
    && unzip -o IPAexfont00401.zip \
    && mv IPAexfont00401/*.ttf /usr/share/fonts/TTF \
    && wget https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip \
    && unzip NotoSansCJKjp-hinted.zip \
    && wget https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKjp-hinted.zip \
    && unzip -o NotoSerifCJKjp-hinted.zip \
    && mv *.otf /usr/share/fonts/TTF \
    && rm -r ~/fonts

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
</fontconfig>\
' >> /etc/fonts/local.conf

RUN cd ~/ \
    && rm -rf fonts \
    && fc-cache -f

WORKDIR /install-tl-unx
COPY ./prod/texlive.profile ./
RUN wget -nv https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xzf ./install-tl-unx.tar.gz --strip-components=1
RUN ./install-tl --profile=texlive.profile
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
RUN tlmgr install \
  collection-fontsrecommended \
  collection-langjapanese \
  collection-latexextra \
  latexmk \
  light-latex-make

WORKDIR /workdir

RUN tlmgr update --self && \
    tlmgr install bbding
CMD ["bash"]
