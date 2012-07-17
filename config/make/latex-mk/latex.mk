# -*- Makefile -*-
# $Id: latex.mk.in.in,v 1.68 2010/03/28 05:51:58 dan Exp $ 
#
# Makefile fragment for handling LaTeX projects
#
# Copyright (c) 2001, 2002, 2003, 2004, 2005, 2006, 2007 Dan McMahill
# All rights reserved.
#
# This code is derived from software written by Dan McMahill
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#        This product includes software developed by Dan McMahill
#  4. The name of the author may not be used to endorse or promote products
#     derived from this software without specific prior written permission.
# 
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
#  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
#  AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#  SUCH DAMAGE.
#


#######################################
#
# README:
#
# To use this makefile fragment, set the variable:
#	NAME	= Top level project name.  Your top level LaTeX 
#		  file should be called $(NAME).tex
#
#	TEXSRCS	= Additional LaTeX input files (.tex)
#
# and add the line:
#	.include "latex.mk"
# in your top level Makefile
#
# The following variables may be overridden in your top level Makefile
#
#  BIBTEX	= the BibTeX executable
#  BIBEX_FLAGS	= flags passed to the BibTeX executable
#  CONVERT      = the 'convert' program which is part of ImageMagick
#  DVIPDFM      = the dvipdfm executable
#  DVIPDFM_ENV  = environment variables set when running the dvipdfm executable
#  DVIPDFM_FLAGS= flags passed to the dvipdfm executable
#  DVIPS	= the dvips executable
#  DVIPS_ENV    = environment variables set when running the dvips executable
#  DVIPS_FLAGS	= flags passed to the dvips executable
#  GZIP		= gzip program
#  GV		= a postscript previewer executable
#  GV_FLAGS	= flags passed to the postscript previewer executable
#  JPG2EPS      = program and flags used to convert JPEG files to EPS
#  LATEX	= the LaTeX executable
#  LATEX_ENV	= environment variables set when running the LaTeX executable
#  LATEX_FLAGS	= flags passed to the LaTeX executable
#  LATEX2HTML   = LaTeX2HTML executable
#  LATEX2HTML_ENV
#               = environment variables set when running LATEX2HTML
#  LATEX2HTML_FLAGS
#               = flags passed to LATEX2HTML
#  LATEX2RTF    = LaTeX2RTF executable
#  LATEX2RTF_ENV
#               = environment variables set when running LATEX2RTF
#  LATEX2RTF_FLAGS
#               = flags passed to LATEX2RTF
#  LPR		= executable to print postscript files
#  LPR_FLAGS	= flags passed to the executable to print postscript files
#  MAKEIDX      = the makeindex executable
#  MAKEIDX_FLAGS= flags passed to the makeindex executable
#  MAKEGLS      = executable to create glossary
#  MAKEGLS_FLAGS= flags passed to the executable to create glossary
#  PDFLATEX     = pdflatex executable
#  PDFLATEX_ENV = environment variables set when running the PDFLaTeX executable
#  PDFLATEX_FLAGS= flags passed to the PDFLaTeX executable
#  PNG2EPS      = program and flags used to convert PNG files to EPS
#  PS2PDF	= ps2pdf executable
#  PS2PDF_FLAGS	= flags passed to the ps2pdf executable
#  TAR          = tape archiver program
#  VIEWPDF      = PDF viewer
#  VIEWPDF_FLAGS= PDF viewer flags
#  XDVI		= a .dvi previewer executable
#  XDVI_FLAGS	= flags passed to the .dvi previewer executable
#
#  USE_DVIPDFM  = set to use dvipdfm to create pdf files from dvi
#                 instead of using dvips and ps2pdf
#  USE_PDFLATEX = set to use pdflatex to create pdf files from .tex
#                 files instead of using latex, dvips and ps2pdf
#
#######################################


MAKECONF?=	/usr/local/etc/latex-mk.conf
USER_MAKECONF?=	${HOME}/.latex-mk.conf

.if exists(${MAKECONF})
.include "${MAKECONF}"
.endif

.if exists(${USER_MAKECONF})
.include "${USER_MAKECONF}"
.endif


# Make sure we set at least 1 way for creating html files
.if !defined(USE_HEVEA) && !defined(USE_TEX2PAGE)
USE_LATEX2HTML=	YES
.endif

# The location of the latex-mk .mk and .gmk files
# we do this instead of hard coding so the package
# can be tested before installation by setting this
# variable in a test config file
LATEX_MK_DIR?=	/usr/local/share/latex-mk

AWK?=		/usr/bin/awk
BIBTEX?=	/usr/texbin/bibtex
CONVERT?=	/usr/local/bin/convert
DVIPDFM?=	/usr/texbin/dvipdfm
DVIPDFM_ENV?=	
DVIPDFM_FLAGS+=	
DVIPDFM_LANDSCAPE_FLAGS?=	-l
DVIPS?=		/usr/texbin/dvips
DVIPS_ENV?=	
DVIPS_FLAGS+=	-j0
DVIPS_LANDSCAPE_FLAGS?=	-t landscape
ECHO?=		/bin/echo
ENV_PROG?=	/usr/bin/env
FALSE?=		/usr/bin/false
FIND?=		/usr/bin/find
GREP?=		/usr/bin/grep
GV?=		gv
GV_FLAGS?=
GV_LANDSCAPE_FLAGS?=	-landscape
GZCAT?=		/usr/bin/gzcat
GZIP?=		/usr/bin/gzip
HACHA?=		hacha
HACHA_ENV?=
HACHA_FLAGS?=
HEVEA?=		hevea
HEVEA_ENV?=
HEVEA_FLAGS?=	-fix
IMAGEN?=	imagen
JPG2EPS?=	${CONVERT} 
LATEX_MK?=	/usr/local/bin/latex-mk
LATEX_MK_FLAGS?=
LATEX?=		/usr/texbin/latex
LATEX_ENV?=	
LATEX2HTML?=	latex2html
LATEX2HTML_ENV?=
LATEX2HTML_FLAGS?=-image_type png -local_icons -show_section_numbers 
LATEX2RTF?=	latex2rtf
LATEX2RTF_ENV?=
LATEX2RTF_FLAGS?=
LPR?=		/usr/bin/lpr
LPR_FLAGS?=	
MAKEIDX?=	/usr/texbin/makeindex
MAKEIDX_FLAGS?=	
MAKEGLS?=	/usr/texbin/makeindex
MAKEGLS_FLAGS?= 
PDFLATEX?=	/usr/texbin/pdflatex
PDFLATEX_ENV?=	
PDFLATEX_FLAGS?=	
PNG2EPS?=	${CONVERT} 
POST_BIBTEX_HOOK?=
RM?=		/bin/rm
RMDIR?=		/bin/rmdir
PS2PDF?=	/usr/local/bin/ps2pdf
PS2PDF_FLAGS?=	
TAR?=		/usr/bin/tar
TEX2PAGE?=	tex2page
TEX2PAGE_ENV?=
TEX2PAGE_FLAGS?=
XDVI?=		/usr/texbin/xdvi
XDVI_FLAGS?=	
XDVI_LANDSCAPE_FLAGS?=	-paper usr
VIEWPDF?=	${GV}
VIEWPDF_FLAGS?=	${GV_FLAGS}
VIEWPDF_LANDSCAPE_FLAGS?=	${GV_LANDSCAPE_FLAGS}


DRAFT_STAMP_PS?=	draft_stamp.ps
DATED_DRAFT_PS?=	${LATEX_MK_DIR}/dated_draft.ps

.if !target(default)
.PHONY: default
default: all
.endif

.if !target(all)
.MAIN: all
.PHONY: all
all:: view-all
.endif

.if defined(LANDSCAPE)
DVIPS_FLAGS+=	${DVIPS_LANDSCAPE_FLAGS}
DVIPDFM_FLAGS+=	${DVIPDFM_LANDSCAPE_FLAGS}
GV_FLAGS+=	${GV_LANDSCAPE_FLAGS}
XDVI_FLAGS+=	${XDVI_LANDSCAPE_FLAGS}
VIEWPDF_FLAGS+=	${VIEWPDF_LANDSCAPE_FLAGS}
.endif

REAL_LATEX_ENV+=	LATEX=${LATEX:Q}
REAL_LATEX_ENV+=	LATEX_FLAGS=${LATEX_FLAGS}
REAL_LATEX_ENV+=	BIBTEX=${BIBTEX:Q}
REAL_LATEX_ENV+=	BIBTEX_FLAGS=${BIBTEX_FLAGS}
REAL_LATEX_ENV+=	MAKEIDX=${MAKEIDX:Q}
REAL_LATEX_ENV+=	MAKEIDX_FLAGS=${MAKEIDX_FLAGS}
REAL_LATEX_ENV+=	MAKEGLS=${MAKEGLS:Q}
REAL_LATEX_ENV+=	MAKEGLS_FLAGS=${MAKEGLS_FLAGS}
REAL_LATEX_ENV+=	POST_BIBTEX_HOOK=${POST_BIBTEX_HOOK}
REAL_LATEX_ENV+=	${LATEX_ENV}

REAL_PDFLATEX_ENV+=	PDFLATEX=${PDFLATEX:Q}
REAL_PDFLATEX_ENV+=	PDFLATEX_FLAGS=${PDFLATEX_FLAGS}
REAL_PDFLATEX_ENV+=	BIBTEX=${BIBTEX:Q}
REAL_PDFLATEX_ENV+=	BIBTEX_FLAGS=${BIBTEX_FLAGS}
REAL_PDFLATEX_ENV+=	MAKEIDX=${MAKEIDX:Q}
REAL_PDFLATEX_ENV+=	MAKEIDX_FLAGS=${MAKEIDX_FLAGS}
REAL_PDFLATEX_ENV+=	MAKEGLS=${MAKEGLS:Q}
REAL_PDFLATEX_ENV+=	MAKEGLS_FLAGS=${MAKEGLS_FLAGS}
REAL_PDFLATEX_ENV+=	POST_BIBTEX_HOOK=${POST_BIBTEX_HOOK}
REAL_PDFLATEX_ENV+=	${PDFLATEX_ENV}

REAL_TEX2PAGE_ENV+=	TEX2PAGE=${TEX2PAGE:Q}
REAL_TEX2PAGE_ENV+=	TEX2PAGE_FLAGS=${TEX2PAGE_FLAGS}
REAL_TEX2PAGE_ENV+=	BIBTEX=${BIBTEX:Q}
REAL_TEX2PAGE_ENV+=	BIBTEX_FLAGS=${BIBTEX_FLAGS}
REAL_TEX2PAGE_ENV+=	MAKEIDX=${MAKEIDX:Q}
REAL_TEX2PAGE_ENV+=	MAKEIDX_FLAGS=${MAKEIDX_FLAGS}
REAL_TEX2PAGE_ENV+=	MAKEGLS=${MAKEGLS:Q}
REAL_TEX2PAGE_ENV+=	MAKEGLS_FLAGS=${MAKEGLS_FLAGS}
REAL_TEX2PAGE_ENV+=	POST_BIBTEX_HOOK=${POST_BIBTEX_HOOK}
REAL_TEX2PAGE_ENV+=	${TEX2PAGE_ENV}


# Include other .mk files often times used with LaTeX

#######################################
#
# Check for lgrind
#
#######################################

# Check for LGRINDSRCS and LGRINDDIRS

.if defined(LGRINDSRCS) || defined(LGRINDDIRS)
_USE_LGRIND_MK=	YES
.endif


# Check for proj_LGRINDSRCS and proj_LGRINDDIRS

.for __tmp__ in ${NAME}
.if defined(${__tmp__}_LGRINDSRCS) || defined(${__tmp__}_LGRINDDIRS)
_USE_LGRIND_MK=	YES
.endif
.endfor


# pull in lgrind.[g]mk if needed

.if defined(_USE_LGRIND_MK)
.include "${LATEX_MK_DIR}/lgrind.mk"
.endif

#######################################
#
# Check for METAPOST
#
#######################################

# Check for MPOSTSRCS and MPOSTDIRS

.if defined(MPOSTSRCS) || defined(MPOSTDIRS)
_USE_MPOST_MK=	YES
.endif


# Check for proj_MPOSTSRCS and proj_MPOSTDIRS

.for __tmp__ in ${NAME}
.if defined(${__tmp__}_MPOSTSRCS) || defined(${__tmp__}_MPOSTDIRS)
_USE_MPOST_MK=	YES
.endif
.endfor


# pull in mpost.[g]mk if needed

.if defined(_USE_MPOST_MK)
.include "${LATEX_MK_DIR}/mpost.mk"
.endif

#######################################
#
# Check for tgif
#
#######################################

# Check for TGIFSRCS and TGIFDIRS

.if defined(TGIFSRCS) || defined(TGIFDIRS)
_USE_TGIF_MK=	YES
.endif


# Check for proj_TGIFSRCS and proj_TGIFDIRS

.for __tmp__ in ${NAME}
.if defined(${__tmp__}_TGIFSRCS) || defined(${__tmp__}_TGIFDIRS)
_USE_TGIF_MK=	YES
.endif
.endfor


# pull in tgif.[g]mk if needed

.if defined(_USE_TGIF_MK)
.include "${LATEX_MK_DIR}/tgif.mk"
.endif

#######################################
#
# Check for xfig
#
#######################################

# Check for XFIGSRCS and XFIGDIRS

.if defined(XFIGSRCS) || defined(XFIGDIRS)
_USE_XFIG_MK=	YES
.endif


# Check for proj_XFIGSRCS and proj_XFIGDIRS

.for __tmp__ in ${NAME}
.if defined(${__tmp__}_XFIGSRCS) || defined(${__tmp__}_XFIGDIRS)
_USE_XFIG_MK=	YES
.endif
.endfor


# pull in xfig.[g]mk if needed

.if defined(_USE_XFIG_MK)
.include "${LATEX_MK_DIR}/xfig.mk"
.endif

#######################################
#
# Targets
#
#######################################

#######################################
# target:  view_<proj>
#######################################

.for __tmp__ in ${NAME}
.PHONY: view_${__tmp__}
.if defined(USE_PDFLATEX)
view_${__tmp__}: viewpdf_${__tmp__}
.else
view_${__tmp__}: ${__tmp__}.dvi
	${XDVI:Q} ${XDVI_FLAGS} ${__tmp__}.dvi
.endif
DEFAULTVIEW?=	view_${__tmp__}
ALLVIEW+=	view_${__tmp__}
.endfor


#######################################
# target:  viewps_<proj>
#######################################

.for __tmp__ in ${NAME}
.PHONY: viewps_${__tmp__}
viewps_${__tmp__}: ${__tmp__}.ps
	${GV:Q} ${GV_FLAGS}  ${__tmp__}.ps
DEFAULTVIEWPS?=	viewps_${__tmp__}
ALLVIEWPS+=	viewps_${__tmp__}
.PHONY: viewps_${__tmp__}-draft
viewps_${__tmp__}-draft: ${__tmp__}-draft.ps
	${GV:Q} ${GV_FLAGS}  ${__tmp__}-draft.ps
DEFAULTVIEWPS_DRAFT?=	viewps_${__tmp__}-draft
ALLVIEWPS_DRAFT+=	viewps_${__tmp__}-draft
${__tmp__}-draft.ps: ${__tmp__}.dvi ${DATED_DRAFT_PS}
	sed "s;DATE;`date`;g" ${DATED_DRAFT_PS:Q} > ${DRAFT_STAMP_PS:Q}
	${ENV_PROG:Q} ${DVIPS_ENV} ${DVIPS:Q} -h ${DRAFT_STAMP_PS:Q} ${$*_DVIPS_FLAGS} ${DVIPS_FLAGS} -o $@ ${__tmp__}.dvi
.endfor


#######################################
# target:  viewpdf_<proj>
#######################################

.for __tmp__ in ${NAME}
.PHONY: viewpdf_${__tmp__}
viewpdf_${__tmp__}: ${__tmp__}.pdf
	${VIEWPDF:Q} ${VIEWPDF_FLAGS}  ${__tmp__}.pdf
DEFAULTVIEWPDF?=	viewpdf_${__tmp__}
ALLVIEWPDF+=	viewpdf_${__tmp__}
.PHONY: viewpdf_${__tmp__}-draft
viewpdf_${__tmp__}-draft: ${__tmp__}-draft.pdf
	${VIEWPDF:Q} ${VIEWPDF_FLAGS}  ${__tmp__}-draft.pdf
DEFAULTVIEWPDF_DRAFT?=	viewpdf_${__tmp__}-draft
ALLVIEWPDF_DRAFT+=	viewpdf_${__tmp__}-draft
.endfor


#######################################
# target:  print_<proj>
#######################################

.for __tmp__ in ${NAME}
.PHONY: print_${__tmp__}
print_${__tmp__}: ${__tmp__}.ps
	${LPR:Q} ${LPR_FLAGS} ${__tmp__}.ps
DEFAULTPRINT?=	print_${__tmp__}
ALLPRINT+=	print_${__tmp__}
.PHONY: print_${__tmp__}-draft
print_${__tmp__}-draft: ${__tmp__}-draft.ps
	${LPR:Q} ${LPR_FLAGS} ${__tmp__}-draft.ps
DEFAULTPRINT_DRAFT?=	print_${__tmp__}-draft
ALLPRINT_DRAFT+=	print_${__tmp__}-draft
.endfor



#######################################

ALLTEXSRCS=	${TEXSRCS}
ALLBIBTEXSRCS=	${BIBTEXSRCS}

#######################################
#
# master name for the distfile
#
#######################################

.for __tmp__ in ${NAME}
.if defined(ALLNAME)
ALLNAME:=       ${ALLNAME}_${__tmp__}
.else
ALLNAME=        ${__tmp__}
.endif
.endfor


.if ${ALLNAME} != ${NAME}
dist:	${ALLNAME}.tar.gz
${ALLNAME}.tar.gz: ${NAME:=.tar.gz}
	${RM:Q} -fr ${ALLNAME:Q}
	mkdir ${ALLNAME:Q}
	for f in ${NAME:=.tar.gz} ; do \
		${GZCAT:Q} $$f | (cd ${ALLNAME:Q} && ${TAR:Q} xpf -) ; \
	done
	${TAR:Q} cf - ${ALLNAME:Q} | ${GZIP:Q} > $@
	${RM:Q} -fr ${ALLNAME:Q}
	@${ECHO:Q} "******* Distfile left in ${ALLNAME}.tar.gz *******"
.endif

#######################################
#
# add the dependencies for each documents .dvi file
#
#######################################

.for __tmp__ in ${NAME}
${__tmp__}.dvi:	${__tmp__}.tex ${TEXSRCS} ${${__tmp__}_TEXSRCS} ${OTHER} ${${__tmp__}_OTHER}
# some older bmake versions will fail on the empty test if these variables
# do not already exist
BIBTEXSRCS?=
${__tmp__}_BIBTEXSRCS?=
.if !empty(BIBTEXSRCS) || !empty(${__tmp__}_BIBTEXSRCS)
${__tmp__}.dvi:		${__tmp__}.bib-stamp
${__tmp__}.html-stamp:	${__tmp__}.bib-stamp
.endif
.if defined(USE_PDFLATEX)
${__tmp__}.pdf:	${__tmp__}.tex ${TEXSRCS} ${${__tmp__}_TEXSRCS} ${OTHER} ${${__tmp__}_OTHER}
.  if !empty(BIBTEXSRCS) || !empty(${__tmp__}_BIBTEXSRCS)
${__tmp__}.pdf:	${__tmp__}.bib-stamp
.  endif
.endif
${__tmp__}.html-stamp:	${__tmp__}.tex ${TEXSRCS} ${${__tmp__}_TEXSRCS} ${OTHER} ${${__tmp__}_OTHER}
${__tmp__}.bib-stamp:	${BIBTEXSRCS} ${${__tmp__}_BIBTEXSRCS}
.if defined(USE_PDFLATEX)
	${ENV_PROG:Q} ${REAL_PDFLATEX_ENV} ${LATEX_MK:Q} ${LATEX_MK_FLAGS} --pdflatex --bibtex ${__tmp__}.tex
.else
	${ENV_PROG:Q} ${REAL_LATEX_ENV} ${LATEX_MK:Q} ${LATEX_MK_FLAGS} --bibtex ${__tmp__}.tex
.endif
	touch $@

ALLTEXSRCS+=	${__tmp__}.tex ${${__tmp__}_TEXSRCS}
ALLBIBTEXSRCS+=	${${__tmp__}_BIBTEXSRCS}
dist:	${__tmp__}.tar.gz
dvi:	${__tmp__}.dvi
html:	${__tmp__}.html-stamp
.PHONY: ${__tmp__}.html
${__tmp__}.html:	${__tmp__}.html-stamp

# latex2html needs latex to run first because it makes use of the
# .aux file.  It seems that tex2page and hevea do not require this.
.if defined(USE_LATEX2HTML)
${__tmp__}.html-stamp:	${__tmp__}.dvi
.endif
ps:	${__tmp__}.ps
pdf:	${__tmp__}.pdf
ps-draft:	${__tmp__}-draft.ps
pdf-draft:	${__tmp__}-draft.pdf
${__tmp__}.rtf:	${__tmp__}.dvi
rtf:	${__tmp__}.rtf
clean::
	if [ -f ${__tmp__}.www_files ]; then  \
		for f in `${AWK:Q} '{print $$2}' ${__tmp__}.www_files` ; do \
			if [ -f $$f ]; then ${RM:Q} -f $$f ; fi ;\
		done ;\
	fi
	${RM:Q} -f ${__tmp__}.www_files
.if defined(USE_LATEX2HTML)
	${RM:Q} -f ${__tmp__}.html_dir/images.aux
	${RM:Q} -f ${__tmp__}.html_dir/images.bbl
	${RM:Q} -f ${__tmp__}.html_dir/images.log
	${RM:Q} -f ${__tmp__}.html_dir/images.out
	${RM:Q} -f ${__tmp__}.html_dir/images.tex
.endif
	if [ -d ${__tmp__}.html_dir ]; then ${RMDIR:Q} ${__tmp__}.html_dir ; fi

# And add dependencies for a source tarball
${__tmp__}_DIST+=	${__tmp__}.tex ${TEXSRCS} ${${__tmp__}_TEXSRCS} ${BIBTEXSRCS} ${${__tmp__}_BIBTEXSRCS} ${OTHER} ${${__tmp__}_OTHER} ${MAKEFILE} ${${__tmp__}_EXTRA_DIST} ${EXTRA_DIST}
ALL_DIST+=	${${__tmp__}_DIST}

${__tmp__}.tar.gz: ${${__tmp__}_DIST}
	${TAR:Q} cf - ${${__tmp__}_DIST} | ${GZIP:Q} > $@
	@${ECHO:Q} "******* Distfile left in $@ *******"
.endfor



#######################################
# target:  view, view-all
#######################################

.PHONY: view
view: ${DEFAULTVIEW}
.PHONY: view-all
view-all: ${ALLVIEW}


#######################################
# target:  viewps, viewps-all
#######################################

.PHONY: viewps
viewps: ${DEFAULTVIEWPS}
.PHONY: viewps-all
viewps-all: ${ALLVIEWPS}

#######################################
# target:  viewpdf, viewpdf-all
#######################################

.PHONY: viewpdf
viewpdf: ${DEFAULTVIEWPDF}
.PHONY: viewpdf-all
viewpdf-all: ${ALLVIEWPDF}

#######################################
# target:  viewps-draft, viewps-all-draft
#######################################

.PHONY: viewps-draft
viewps-draft: ${DEFAULTVIEWPS_DRAFT}
.PHONY: viewps-all-draft
viewps-all-draft: ${ALLVIEWPS_DRAFT}

#######################################
# target:  viewpdf-draft, viewpdf-all-draft
#######################################

.PHONY: viewpdf-draft
viewpdf-draft: ${DEFAULTVIEWPDF_DRAFT}
.PHONY: viewpdf-all-draft
viewpdf-all-draft: ${ALLVIEWPDF_DRAFT}

#######################################
# target:  print, print-all
#######################################

.PHONY: print
print: ${DEFAULTPRINT}
.PHONY: print-all
print-all: ${ALLPRINT}

#######################################
# target:  print-draft, print-all-draft
#######################################

.PHONY: print-draft
print-draft: ${DEFAULTPRINT_DRAFT}
.PHONY: print-all-draft
print-all-draft: ${ALLPRINT_DRAFT}

#######################################
#
#######################################

.SUFFIXES : .tex .dvi .ps .pdf .rtf .html-stamp .png .jpg .eps

.if defined(IGNORE_LATEX_ERRORS)
LATEX_MK_FLAGS+=	--ignore-errors
.endif

#######################################
#
# Graphic file conversions
#
#######################################
.jpg.eps : 
	${JPG2EPS:Q} $< $@

.png.eps : 
	${PNG2EPS:Q} $< $@

#######################################
#
# Distribution output (tarfile)
#
#######################################
.PHONY: dist

#######################################
#
# DVI Output (latex)
#
#######################################
.PHONY: dvi
.tex.dvi : 
	${ENV_PROG:Q} ${REAL_LATEX_ENV} ${LATEX_MK:Q} ${LATEX_MK_FLAGS} $<

#######################################
#
# HTML Output (latex2html or HeVeA)
#
#######################################

# note:  we have to use a time stamp file here to keep track of what files
# get created by the html conversion.  Neither latex2html nor hevea provide
# a convenient way to get a list of files to clean.  In addition, hevea
# does not currently provide a DESTDIR type functionality which is needed
# for dealing with multiple top level documents.


.PHONY: html
.tex.html-stamp : 
	touch $@1
.if defined(USE_LATEX2HTML)
	@${ECHO:Q} LaTeX-Mk:  Creating HTML output using latex2html
	${ENV_PROG:Q} ${LATEX2HTML_ENV} ${LATEX2HTML:Q} ${LATEX2HTML_FLAGS} -mkdir -dir $*.html_dir $<
.elif defined(USE_TEX2PAGE)
	@${ECHO:Q} LaTeX-Mk:  Creating HTML output using tex2page
	${ECHO:Q} "$*.html_dir" > $*.hdir
	${ENV_PROG:Q} ${REAL_TEX2PAGE_ENV} ${LATEX_MK:Q} --tex2page ${LATEX_MK_FLAGS} $<
.elif defined(USE_HEVEA)
	@${ECHO:Q} LaTeX-Mk:  Creating HTML output using HeVeA
	mkdir -p $*.html_dir
	-${ENV_PROG:Q} ${HEVEA_ENV} ${HEVEA:Q} $(HEVEA_FLAGS) $< 
	-${ENV_PROG:Q} ${HEVEA_ENV} ${IMAGEN:Q}  `basename $< .tex`
	-${ENV_PROG:Q} ${HEVEA_ENV} ${HEVEA:Q} $(HEVEA_FLAGS) $< 
.endif
	if [ ! -f $*.www_files ]; then touch $*.www_files ; fi
	for f in `${FIND:Q} . -type f \( -name \*.html -o -name \*.htm -o -name \*.gif \
		-o -name \*.png -o -name \*.css -o -name \*.pl -o -name WARNINGS \
		-o -name \*.scm -o -name \*.hlog \) \
		-newer $@1 -print` ; do \
		fn=`basename $$f` ; \
		if ${GREP:Q} "^$$f " $*.www_files >/dev/null ; then \
			echo "$$f already recorded" ; \
		else \
			echo "recording file $$f ($*.html_dir/$$fn)" ; \
			echo "$$f $*.html_dir/$$fn" >> $*.www_files ; \
		fi ;\
	done
.if defined(USE_TEX2PAGE)
	for f in `${FIND} . -type f \( -name \*-Z-G-\*.tex -o -name \*-Z-G-\*.aux \
		-o -name \*-Z-G-\*.log -o -name \*-Z-G-\*.dvi -o -name \*-Z-G-\*.ps \
		-o -name .Z\*.tex \) -newer $@1 -print` ; do \
		fn=`basename $$f` ; \
		if ${GREP:Q} "^$$f " $*.www_files >/dev/null ; then \
			echo "$$f already recorded" ; \
		elif test "`dirname $$f`" != "." ; then \
			echo "$$f is not in this directory, skipping" ; \
		else \
			echo "recording file $$f (./$$fn)" ; \
			echo "$$f ./$$fn" >> $*.www_files ; \
		fi ;\
	done
.endif
.if defined(USE_HEVEA)
	for f in `${AWK:Q} '{print $$1}' $*.www_files` ; do \
		${ECHO:Q} "Moving $$f to $*.html_dir" ; mv $$f $*.html_dir ; \
	done
.endif
	mv $@1 $@

#######################################
#
# Postscript Output (dvips)
#
#######################################
.PHONY:  ps

# if we're doing a *-draft target, then add the 
# DRAFT watermark and time stamp
.if make(*-draft)
__DRAFT=	yes
.endif

.dvi.ps :
.if defined(__DRAFT)
	sed "s;DATE;`date`;g" ${DATED_DRAFT_PS:Q} > ${DRAFT_STAMP_PS:Q}
	${DVIPS:Q} -h ${DRAFT_STAMP_PS:Q} ${$*_DVIPS_FLAGS} ${DVIPS_FLAGS} -o $*-draft.ps $<
.else
	${ENV_PROG:Q} ${DVIPS_ENV} ${DVIPS:Q} ${$*_DVIPS_FLAGS} ${DVIPS_FLAGS} -o $@ $<
.endif

#######################################
#
# PDF Output (ps2pdf)
#
#######################################
.PHONY:  pdf

.if defined(USE_DVIPDFM)
.dvi.pdf :
	${ENV_PROG:Q} ${DVIPDFM_ENV} ${DVIPDFM:Q} ${$*_DVIPDFM_FLAGS} ${DVIPDFM_FLAGS} $<
.elif defined(USE_PDFLATEX)
.tex.pdf : 
	${ENV_PROG:Q} ${REAL_PDFLATEX_ENV} ${LATEX_MK:Q} --pdflatex ${LATEX_MK_FLAGS} $<
.else
.ps.pdf :
	${PS2PDF:Q} ${PS2PDF_FLAGS} $<
.endif

#######################################
#
# RTF (Rich Text Format) output (latex2rtf)
#
#######################################
.PHONY:  rtf

.dvi.rtf :
	${ENV_PROG:Q} ${LATEX2RTF_ENV} ${LATEX2RTF:Q} ${LATEX2RTF_FLAGS} -o $@ $*.tex

#######################################
#
# Clean up (clean)
#
#######################################
CLEAN_FILES+=	${ALLTEXSRCS:.tex=.aux}
CLEAN_FILES+=	${BIBTEXSRCS:.bib=.aux}
CLEAN_FILES+=	${NAME:=.ps}
CLEAN_FILES+=	${NAME:=-draft.ps}
CLEAN_FILES+=	${NAME:=.pdf}
CLEAN_FILES+=	${NAME:=-draft.pdf}
CLEAN_FILES+=	${NAME:=.rtf}
CLEAN_FILES+=	${NAME:=.aux}
CLEAN_FILES+=	${NAME:=.log}
CLEAN_FILES+=	${NAME:=.dvi}
CLEAN_FILES+=	${NAME:=.log}
CLEAN_FILES+=	${NAME:=.bbl}
CLEAN_FILES+=	${NAME:=.blg}
CLEAN_FILES+=	${NAME:=.glo}
CLEAN_FILES+=	${NAME:=.gls}
CLEAN_FILES+=	${NAME:=.ilg}
CLEAN_FILES+=	${NAME:=.idx}
CLEAN_FILES+=	${NAME:=.ind}
CLEAN_FILES+=	${NAME:=.lof}
CLEAN_FILES+=	${NAME:=.lot}
CLEAN_FILES+=	${NAME:=.toc}
CLEAN_FILES+=	${NAME:=.out}
CLEAN_FILES+=	$(DRAFT_STAMP_PS)
CLEAN_FILES+=	${NAME:=.bib-stamp}

# HTML generation
CLEAN_FILES+=	${NAME:=.html-stamp}
CLEAN_FILES+=	${NAME:=.www_files}

.ifdef USE_HEVEA
CLEAN_FILES+=	${NAME:=.haux}
CLEAN_FILES+=	${NAME:=.image.tex}
.endif

.ifdef USE_LATEX2HTML
CLEAN_FILES+=	${NAME:=.haux}
CLEAN_FILES+=	${NAME:=.image.tex}
.endif


.ifdef USE_TEX2PAGE
CLEAN_FILES+=	${NAME:=.hdir}
.endif


.PHONY: clean

clean::

clean::
.for __tmp__ in ${NAME}
	${LATEX_MK:Q} --clean ${__tmp__}
.endfor
	${RM:Q} -f *~ texput.log ${CLEAN_FILES}

.PHONY: distclean
distclean: clean

#######################################
#
# Some helpful debugging targets
#
#######################################
.PHONY: show-var
show-var:
	@${ECHO:Q} ${${VARNAME}}

