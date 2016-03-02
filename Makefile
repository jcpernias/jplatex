pkgnames := jpmicro jpmath
docnames := test

rootdir := .
builddir := $(rootdir)/build

MKDIR := mkdir -p
LATEX := pdflatex -interaction=nonstopmode -output-directory $(builddir)
RM := rm -f

pkgs := $(addsuffix .sty, $(pkgnames))
pdfs := $(addsuffix .pdf, $(pkgnames) $(docnames))

all: $(pdfs)

%.pdf: %.tex $(pkgs) | dirs
	$(LATEX) $<
	mv -f $(builddir)/$@ $(rootdir)


%.pdf: %.sty | dirs
	$(LATEX) $*.dtx
	makeindex -s gind.ist -o $(builddir)/$*.ind $(builddir)/$*.idx
	makeindex -s gglo.ist -o $(builddir)/$*.gls $(builddir)/$*.glo
	$(LATEX) $*.dtx
	mv -f $(builddir)/$@ $(rootdir)

%.sty: %.ins %.dtx | dirs 
	$(LATEX) $<
	mv -f $(builddir)/$@ $(rootdir)

jpmicro.pdf: jpmath.sty

.PRECIOUS: %.sty

.PHONY:
dirs:
	$(MKDIR) $(builddir)


.PHONY:
clean:
	$(RM) -r $(builddir)

.PHONY:
veryclean: clean
	$(RM) $(pdfs) $(pkgs) 
