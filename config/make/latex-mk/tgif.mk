# -*- Makefile -*-
# $Id: tgif.mk.in.in,v 1.15 2006/09/21 13:48:13 dan Exp $
#
# Makefile fragment for processing tgif files to produce postscript
#
# Copyright (c) 2001, 2002, 2003, 2005, 2006 Dan McMahill
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
#	TGIFSRCS	= the tgif drawing files (.obj files)
# in your top level Makefile.  You can also specify
# TGIFDIRS which is a list of directories containing
# tgif files.  All tgif files in the specified directories
# are added to TGIFSRCS
#
# The following variables may be overridden in your top level Makefile
#
#  TGIF		  = the tgif executable
#  TGIF_FLAGS	  = flags passed to tgif for any exporting 
#  TGIF_EPS_FLAGS = flags passed to tgif for exporting to eps
#  TGIF_PDF_FLAGS = flags passed to tgif for exporting to pdf
#
#######################################


# how to call tgif to convert tgif files to postscript
TGIF?=		tgif
TGIF_FLAGS?=		-color -print
TGIF_EPS_FLAGS?=	-eps
TGIF_PDF_FLAGS?=	-pdf

#######################################
#
# Process TGIFDIRS, adding to TGIFSRCS
#
#######################################

.if defined(TGIFDIRS)
.for __tmp__ in ${TGIFDIRS}
.if exists(${__tmp__})
_TGIF_ADD_${__tmp__}!=	ls ${__tmp__}/*.obj
TGIFSRCS+=	${_TGIF_ADD_${__tmp__}}
.endif
.endfor
.endif


#######################################
#
# Process proj_TGIFDIRS, adding to proj_TGIFSRCS
#
#######################################

.for __name__ in ${NAME}
.if defined(${__name__}_TGIFDIRS)
.for __tmp__ in ${${__name__}_TGIFDIRS}
.if exists(${__tmp__})
_TGIF_ADD2_${__tmp__}!=	ls ${__tmp__}/*.obj
${__name__}_TGIFSRCS+=	${_TGIF_ADD2_${__tmp__}}
.endif
.endfor
.endif
.endfor


#######################################
# 
# Process proj_TGIFSRCS to add to
# proj_OTHER dependencies
#
#######################################

# if we are using pdflatex, then don't bother with the .eps files
# but create .pdf files instead

.if defined(USE_PDFLATEX)
TGIFOBJS?=      $(TGIFSRCS:.obj=.pdf)
.else
TGIFOBJS?=      $(TGIFSRCS:.obj=.eps)
.endif
ALLTGIFOBJS+=	$(TGIFOBJS)

.for __tmp__ in ${NAME}
.if defined(${__tmp__}_TGIFSRCS)
.if defined(USE_PDFLATEX)
${__tmp__}_TGIFOBJS?=	${${__tmp__}_TGIFSRCS:.obj=.pdf}
.else
${__tmp__}_TGIFOBJS?=	${${__tmp__}_TGIFSRCS:.obj=.eps}
.endif
${__tmp__}_OTHER+=	${${__tmp__}_TGIFOBJS}
ALLTGIFOBJS+=	${${__tmp__}_TGIFOBJS}
.endif
${__tmp__}_DIST+=	${${__tmp__}_TGIFSRCS} ${TGIFSRCS}
.endfor




#######################################
# 
# Add the dependencies
#
#######################################


OTHER+=	$(TGIFOBJS)
all::		$(ALLTGIFOBJS)

clean::
.for __tmp__ in $(ALLTGIFOBJS)
	$(RM) -f $(__tmp__:Q)
.endfor

#######################################
# 
# The suffix rules
#
#######################################

.SUFFIXES : .obj .eps .pdf

.obj.eps : 
	$(TGIF:Q) $(TGIF_FLAGS) $(TGIF_EPS_FLAGS) $*.obj

.obj.pdf : 
	$(TGIF:Q) $(TGIF_FLAGS) $(TGIF_PDF_FLAGS) $*.obj

