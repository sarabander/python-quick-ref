# -*- Makefile -*-
# $Id: mpost.mk.in.in,v 1.4 2007/08/26 20:38:26 dan Exp $
#
# Makefile fragment for processing METAPOST files to produce postscript
#
# Copyright (c) 2007 Dan McMahill
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
#	MPOSTSRCS	= the METAPOST input files (.mp files)
# in your top level Makefile.  You can also specify
# MPOSTDIRS which is a list of directories containing
# METAPOST files.  All mpost files in the specified directories
# are added to MPOSTSRCS
#
# The following variables may be overridden in your top level Makefile
#
#  MPOST	  = the METAPOST executable
#  MPOST_FLAGS	  = flags passed to ${MPOST}
#
#######################################


# how to call METAPOST
MPOST?=		/usr/texbin/mpost
MPOST_FLAGS?=

#######################################
#
# Process MPOSTDIRS, adding to MPOSTSRCS
#
#######################################

.if defined(MPOSTDIRS)
.for __tmp__ in ${MPOSTDIRS}
.if exists(${__tmp__})
_MPOST_ADD_${__tmp__}!=	ls ${__tmp__}/*.mp
MPOSTSRCS+=	${_MPOST_ADD_${__tmp__}}
.endif
.endfor
.endif


#######################################
#
# Process proj_MPOSTDIRS, adding to proj_MPOSTSRCS
#
#######################################

.for __name__ in ${NAME}
.if defined(${__name__}_MPOSTDIRS)
.for __tmp__ in ${${__name__}_MPOSTDIRS}
.if exists(${__tmp__})
_MPOST_ADD2_${__tmp__}!=	ls ${__tmp__}/*.mp
${__name__}_MPOSTSRCS+=	${_MPOST_ADD2_${__tmp__}}
.endif
.endfor
.endif
.endfor


#######################################
# 
# Process proj_MPOSTSRCS to add to
# proj_OTHER dependencies
#
#######################################


MPOSTOBJS?=      $(MPOSTSRCS:.mp=.mpx)
ALLMPOSTOBJS+=	$(MPOSTOBJS)

.for __tmp__ in ${NAME}
.if defined(${__tmp__}_MPOSTSRCS)
${__tmp__}_MPOSTOBJS?=	${${__tmp__}_MPOSTSRCS:.mp=.mpx}
${__tmp__}_OTHER+=	${${__tmp__}_MPOSTOBJS}
ALLMPOSTOBJS+=	${${__tmp__}_MPOSTOBJS}
.endif
${__tmp__}_DIST+=	${${__tmp__}_MPOSTSRCS} ${MPOSTSRCS}
.endfor




#######################################
# 
# Add the dependencies
#
#######################################


OTHER+=	$(MPOSTOBJS)
all::		$(ALLMPOSTOBJS)


# we do this funny thing because neither BSD make nor GNU make
# seem to like make conditionals in the middle of shell code
.if defined(USE_PDFLATEX)
_MPOST_PDF_REMOVE_=	$$fn
.endif

clean::
.for __tmp__ in $(ALLMPOSTOBJS)
	$(RM) -f $(__tmp__:Q)
.endfor
	for mp in $(ALLMPOSTOBJS) ; do \
		mpb=`basename $${mp} .mpx` ; \
		for f in $${mpb}.ps $${mpb}.[0-9]* "" ; do \
			if test "X$$f" != "X" ; then \
				fn=`basename $$f .ps` ; \
				fn=$${fn}.pdf ; \
				$(RM) -f $$f ${_MPOST_PDF_REMOVE_}; \
			fi ; \
		done ; \
	done

#######################################
# 
# The suffix rules
#
#######################################

.SUFFIXES : .mp .mpx 

# if we are using pdflatex, then we probably need to convert our
# postscript output to PDF

.mp.mpx : 
	$(MPOST:Q) $(MPOST_FLAGS) $(MPOST_EPS_FLAGS) $*.mp
.if defined(MPOST_TWICE)
	$(MPOST:Q) $(MPOST_FLAGS) $(MPOST_EPS_FLAGS) $*.mp
.endif
.if defined(USE_PDFLATEX)
	for f in $*.ps $*.[0-9]* "" ; do \
		if test "X$$f" != "X" ; then \
			fn=`basename $$f .ps` ; \
			fn=$${fn}.pdf ; \
			${PS2PDF:Q} ${PS2PDF_FLAGS} $$f $$fn ; \
		fi ; \
	done
.endif


