LILYDIR = lily
FIGSDIR = figs
DATADIR = data

DIA_PNG= $(patsubst %.dia,%.png,$(wildcard $(FIGSDIR)/*.dia))
DIA_EPS= $(patsubst %.dia,%.eps,$(wildcard $(FIGSDIR)/*.dia))
CLEAN_FILES+= $(DIA_EPS:.dia=.eps)
CLEAN_FILES+= $(DIA_PNG:.dia=.png)

PNG_EPS= $(patsubst %.png,%.eps,$(wildcard $(FIGSDIR)/*.png))
PNG_PDF= $(patsubst %.png,%.pdf,$(wildcard $(FIGSDIR)/*.png))
CLEAN_FILES+= $(PNG_EPS:.plot=.eps)
CLEAN_FILES+= $(PNG_PDF:.plot=.pdf)

EPS_PDF= $(patsubst %.eps,%.pdf,$(wildcard $(FIGSDIR)/*.eps))
CLEAN_FILES+= $(PNG_PDF:.plot=.pdf)

GNUPLOT_PDF= $(patsubst %.plot,%.pdf,$(wildcard $(DATADIR)/*.plot))
GNUPLOT_EPS= $(patsubst %.plot,%.eps,$(wildcard $(DATADIR)/*.plot))
CLEAN_FILES+= $(GNUPLOT_PDF:.plot=.pdf)
CLEAN_FILES+= $(GNUPLOT_EPS:.plot=.eps)

LILY_EPS= $(patsubst %.ly,%.eps,$(wildcard $(LILYDIR)/*.ly))
LILY_PNG= $(patsubst %.ly,%.png,$(wildcard $(LILYDIR)/*.ly))
LILY_PS = $(patsubst %.ly,%.ps,$(wildcard $(LILYDIR)/*.ly))
LILY_PDF= $(patsubst %.ly,%.pdf,$(wildcard $(LILYDIR)/*.ly))
LILY_SVG= $(patsubst %.ly,%.svg,$(wildcard $(LILYDIR)/*.ly))
LILY_WAV= $(patsubst %.ly,%.wav,$(wildcard $(LILYDIR)/*.ly))
CLEAN_FILES+= $(LILY_EPS:.ly=.eps)
CLEAN_FILES+= $(LILY_PNG:.ly=.png)
CLEAN_FILES+= $(LILY_PS:.ly=.ps)
CLEAN_FILES+= $(LILY_PDF:.ly=.pdf)
CLEAN_FILES+= $(LILY_PDF:.ly=.wav)

TXT_HTML= $(patsubst %.txt,%.html,$(wildcard *.txt))
CLEAN_FILES+= $(TXT_HTML:.txt=.html)

SVG_PNG= $(patsubst %.svg,%.png,$(wildcard $(FIGSDIR)/*.svg))
SVG_PDF= $(patsubst %.svg,%.pdf,$(wildcard $(FIGSDIR)/*.svg))
SVG_EPS= $(patsubst %.svg,%.eps,$(wildcard $(FIGSDIR)/*.svg))
CLEAN_FILES+= $(SVG_PNG:.svg=.pdf)
CLEAN_FILES+= $(SVG_PDF:.svg=.png)
CLEAN_FILES+= $(SVG_EPS:.svg=.eps)

CLEAN_BEAMER = .nav .snm .vrb
CLEAN_FILES+= $(foreach suffix,$(CLEAN_BEAMER),$(addsuffix $(suffix),$(NAME)))

vpath %.eps $(FIGSDIR)
vpath %.eps $(DATADIR)
vpath %.pdf $(FIGSDIR)
vpath %.pdf $(DATADIR)
vpath %.ly $(LILYDIR)
vpath %.svg $(FIGSDIR)

#BIBTEXSRCS = 
#USE_HEVEA = 1
#USE_LATEX2HTML = 1
#USE_PDFLATEX = 1
#USE_TEX2PAGE = 1
#USE_DVIPDFM = 1
#VIEWPDF

doc: pdf

%.html: %.tex
	htlatex $<

%.pdf: %.eps
	epstopdf $<

%.txt:  %.html
	lynx -dump $< > $@

%.eps: %.plot %.dat
	gnuplot $<

%.pdf: %.plot %.dat
	gnuplot $<
	epstopdf --outfile=$@ $(patsubst %.plot,%.eps, $<)

%.eps: %.svg
	inkscape -T --export-eps=$@ $<

%.png: %.svg
	inkscape -T --export-area-drawing --export-png=$@ $<

%.pdf: %.svg
	inkscape -T --export-area-snap --export-pdf=$@ $<

%.pdf: %.plot
	gnuplot $<
	convert $(subst plot,eps, $<) $@

%.eps: %.dia
	dia --export=$@ $<

%.eps: %.png
	convert $< $@

%.png: %.dia
	dia --export=$@ $<

%.png: %.ly
	lilypond --png -o  $(basename $@) $<

%.eps: %.ly
	lilypond -dbackend=eps -dno-gs-load-fonts -dinclude-eps-fonts -o $(basename $@) $<

%.ps: %.ly
	lilypond -f ps -o  $(basename $@) $<

%.pdf: %.ly
	lilypond --pdf -o  $(basename $@) $<

%.svg: %.ly
	lilypond -b svg -o  $(basename $@) $<

%.wav: %.midi
	timidity -Ow $<

%.wav: %.mid
	timidity -Ow $<
