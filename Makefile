pkgname := jpmicro

sty := $(pkgname).sty
pdf := $(pkgname).pdf
ins := $(pkgname).ins
dtx := $(pkgname).dtx

all: $(pdf)

$(sty): $(ins) $(dtx)  
	tex $<

$(pdf): $(dtx) $(sty)
	pdflatex -interaction=nonstopmode $<
	makeindex -s gind.ist -o $(pkgname).ind $(pkgname).idx 
	makeindex -s gglo.ist -o jpmicro.gls jpmicro.glo
	pdflatex -interaction=nonstopmode $<
