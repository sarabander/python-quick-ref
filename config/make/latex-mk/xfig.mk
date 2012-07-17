# -*- Makefile -*-
# $Id: xfig.mk.in.in,v 1.14 2010/03/12 21:21:41 dan Exp $
#
# Makefile fragment for processing xfig files to produce postscript
#
# Copyright (c) 2002, 2003, 2004, 2005, 2006 Dan McMahill
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
#	XFIGSRCS	= the xfig drawing files (.fig files)
# in your top level Makefile.  You can also specify
# XFIGDIRS which is a list of directories containing
# xfig files.  All xfig files in the specified directories
# are added to XFIGSRCS
#
# The following variables may be overridden in your top level Makefile
#
#  FIG2DEV		= the fig2dev executable
#  FIG2DEV_FLAGS	= flags passed to fig2dev for all exporting
#  FIG2DEV_EPS_FLAGS	= flags passed to fig2dev for exporting to eps
#  FIG2DEV_PDF_FLAGS	= flags passed to fig2dev for exporting to pdf
#
#######################################


# how to call fig2dev to convert xfig files to postscript
FIG2DEV?=		fig2dev
FIG2DEV_FLAGS?=
FIG2DEV_EPS_FLAGS?=	-L eps
FIG2DEV_PDF_FLAGS?=	-L pdf

#######################################
#
# Process XFIGDIRS, adding to XFIGSRCS
#
#######################################

.if defined(XFIGDIRS)
.for __tmp__ in ${XFIGDIRS}
.if exists(${__tmp__})
_XFIG_ADD_${__tmp__}!=	ls ${__tmp__}/*.fig
XFIGSRCS+=	${_XFIG_ADD_${__tmp__}}
.endif
.endfor
.endif


#######################################
#
# Process proj_XFIGDIRS, adding to proj_XFIGSRCS
#
#######################################

.for __name__ in ${NAME}
.if defined(${__name__}_XFIGDIRS)
.for __tmp__ in ${${__name__}_XFIGDIRS}
.if exists(${__tmp__})
_XFIG_ADD2_${__tmp__}!=	ls ${__tmp__}/*.fig
${__name__}_XFIGSRCS+=	${_XFIG_ADD2_${__tmp__}}
.endif
.endfor
.endif
.endfor


#######################################
# 
# Process proj_XFIGSRCS to add to
# proj_OTHER dependencies
#
#######################################

# if we are using pdflatex, then don't bother with the .eps files
# but create .pdf files instead

.if defined(USE_PDFLATEX)
XFIGOBJS?=	$(XFIGSRCS:.fig=.pdf)
.else
XFIGOBJS?=	$(XFIGSRCS:.fig=.eps)
.endif
ALLXFIGOBJS+=	$(XFIGOBJS)

.for __tmp__ in ${NAME}
.if defined(${__tmp__}_XFIGSRCS)
.if defined(USE_PDFLATEX)
${__tmp__}_XFIGOBJS?=	${${__tmp__}_XFIGSRCS:.fig=.pdf}
.else
${__tmp__}_XFIGOBJS?=	${${__tmp__}_XFIGSRCS:.fig=.eps}
.endif
${__tmp__}_OTHER+=	${${__tmp__}_XFIGOBJS}
ALLXFIGOBJS+=	${${__tmp__}_XFIGOBJS}
.endif
${__tmp__}_DIST+=	${${__tmp__}_XFIGSRCS} ${XFIGSRCS}
.endfor




#######################################
# 
# Add the dependencies
#
#######################################


OTHER+=	$(XFIGOBJS)
all::		$(ALLXFIGOBJS)

clean::
.for __tmp__ in $(ALLXFIGOBJS)
	$(RM) -f $(__tmp__:Q)
.endfor

#######################################
# 
# The suffix rules
#
#######################################

.SUFFIXES : .fig .eps .pdf

.fig.eps : 
	$(FIG2DEV:Q) $(FIG2DEV_FLAGS) $(FIG2DEV_EPS_FLAGS) $*.fig $*.eps

.fig.pdf : 
	$(FIG2DEV:Q) $(FIG2DEV_FLAGS) $(FIG2DEV_PDF_FLAGS) $*.fig $*.pdf

