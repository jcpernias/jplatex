pkgname := jpmicro

sty := $(pkgname).sty
pdf := $(pkgname).pdf
ins := $(pkgname).ins
dtx := $(pkgname).dtx

LATEX := pdflatex -interaction=nonstopmode

all: test.pdf jpmath.pdf jpmicro.pdf 

test.pdf: test.tex jpmath.sty jpmicro.sty
	$(LATEX) $<


%.pdf: %.sty 
	$(LATEX) $*.dtx
	makeindex -s gind.ist -o $*.ind $*.idx
	makeindex -s gglo.ist -o $*.gls $*.glo
	$(LATEX) $*.dtx

%.sty: %.ins %.dtx  
	$(LATEX) $<


