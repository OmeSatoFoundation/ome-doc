#make for platex
.SUFFIXES: .pdf .png .tex .dvi .check
.tex.dvi:
	platex $<
	platex $<
	platex $<
.dvi.pdf:
	dvipdfmx `basename $<`
.pdf.png:
	mkdir -p $*
	convert -density 600 $< $*/$@

%.shrink:
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$*s.pdf $*.pdf

clean:
	rm -f *.aux *.log *.nav *.out *.snm *.toc *.dvi *.vrb

.tex.check:
	aspell check $<
