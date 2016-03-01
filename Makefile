pkgname := jpmicro

sty := $(pkgname).sty
pdf := $(pkgname).pdf
ins := $(pkgname).ins
dtx := $(pkgname).dtx

LATEX := pdflatex -interaction=nonstopmode

all: $(pdf)


%.pdf: %.sty 
	$(LATEX) $*.dtx
	makeindex -s gind.ist -o $*.ind $*.idx
	makeindex -s gglo.ist -o $*.gls $*.glo
	$(LATEX) $*.dtx

%.sty: %.ins %.dtx  
	$(LATEX) $<


