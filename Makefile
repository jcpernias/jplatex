pkgname := jp

stynames := jpdoc jpmath jpmicro
clsnames := jptest
cfg := ltxdoc.cfg hyperref.cfg

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
clss := $(addprefix $(pkgdir)/, $(addsuffix .cls, $(clsnames)))
docs := $(addprefix $(docdir)/, $(addsuffix .pdf, $(stynames) $(clsnames)))

all: $(docs) test.pdf

%.pdf: %.tex $(pkgs) 
	$(LATEX) $<
	mv -f $(builddir)/$(@F) $(rootdir)

$(docdir)/%.pdf: $(pkgdir)/%.sty $(pkgdir)/jpdoc.sty $(cfg)
	$(LATEX) $*.dtx
	makeindex -s gind.ist -o $(builddir)/$*.ind $(builddir)/$*.idx
	makeindex -s gglo.ist -o $(builddir)/$*.gls $(builddir)/$*.glo
	$(LATEX) $*.dtx
	mv -f $(builddir)/$(@F) $(docdir)

$(docdir)/%.pdf: $(pkgdir)/%.cls $(pkgdir)/jpdoc.sty $(cfg)
	$(LATEX) $*.dtx
	makeindex -s gind.ist -o $(builddir)/$*.ind $(builddir)/$*.idx
	makeindex -s gglo.ist -o $(builddir)/$*.gls $(builddir)/$*.glo
	$(LATEX) $*.dtx
	mv -f $(builddir)/$(@F) $(docdir)


$(pkgdir)/%.cls: %.ins %.dtx | dirs
	$(LATEXINS) $<
	cp -a -f $^ $(sourcedir)
	mv -f $(builddir)/$(@F) $(pkgdir)


$(pkgdir)/%.sty: %.ins %.dtx | dirs 
	$(LATEXINS) $<
	cp -a -f $^ $(sourcedir)
	mv -f $(builddir)/$(@F) $(pkgdir)

$(docdir)/jpmicro.pdf: $(pkgdir)/jpmath.sty

$(pkgdir)/jptest.cls: jptest.ins jptest.dtx | dirs

.PRECIOUS: $(pkgdir)/%.sty $(pkgdir)/%.cls

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
