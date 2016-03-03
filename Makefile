pkgname := jp

stynames := jpdoc jpmath jpmicro

rootdir := .
builddir := $(rootdir)/build
tdsrootdir := $(rootdir)/texmf
pkgdir := $(tdsrootdir)/tex/latex/$(pkgname)
sourcedir := $(tdsrootdir)/source/latex/$(pkgname)
docdir := $(tdsrootdir)/doc/latex/$(pkgname)

MKDIR := mkdir -p
LATEXBATCH := pdflatex -interaction=nonstopmode
texinputs := TEXINPUTS=$(pkgdir):
LATEX := $(texinputs) $(LATEXBATCH) -output-directory $(builddir)
LATEXINS := $(LATEXBATCH) -output-directory $(builddir)
RM := rm -f

pkgs := $(addprefix $(pkgdir)/, $(addsuffix .sty, $(stynames)))
docs := $(addprefix $(docdir)/, $(addsuffix .pdf, $(stynames)))

all: $(docs) test.pdf

%.pdf: %.tex $(pkgs) 
	$(LATEX) $<
	mv -f $(builddir)/$(@F) $(rootdir)

$(docdir)/%.pdf: $(pkgdir)/%.sty $(pkgdir)/jpdoc.sty 
	$(LATEX) $*.dtx
	makeindex -s gind.ist -o $(builddir)/$*.ind $(builddir)/$*.idx
	makeindex -s gglo.ist -o $(builddir)/$*.gls $(builddir)/$*.glo
	$(LATEX) $*.dtx
	mv -f $(builddir)/$(@F) $(docdir)

$(pkgdir)/%.sty: %.ins %.dtx | dirs 
	$(LATEXINS) $<
	cp -a -f $^ $(sourcedir)
	mv -f $(builddir)/$(@F) $(pkgdir)

$(docdir)/jpmicro.pdf: $(pkgdir)/jpmath.sty

.PRECIOUS: $(pkgdir)/%.sty

zip: $(pkgname).tds.zip

$(pkgname).tds.zip: $(docs)
	$(RM) $@
	cd $(tdsrootdir) && find  -type f | zip -q -@  ../$@

.PHONY:
install: zip
	unzip -q -o $(pkgname).tds.zip -d ${TEXMFHOME} 
	texhash ${TEXMFHOME}

.PHONY:
dirs:
	$(MKDIR) $(builddir)
	$(MKDIR) $(pkgdir)
	$(MKDIR) $(sourcedir)
	$(MKDIR) $(docdir)


.PHONY:
clean:
	$(RM) -r $(builddir) 

.PHONY:
veryclean: clean
	$(RM) -r $(tdsrootdir) test.pdf
