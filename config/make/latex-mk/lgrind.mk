# -*- Makefile -*-
# $Id: lgrind.mk.in.in,v 1.7 2010/09/21 12:14:58 dan Exp $
#
# Makefile fragment for processing lgrind files to produce postscript
#
# Copyright (c) 2005, 2010 Dan McMahill
#
# Copyright (c) 2005 Peter Bex
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
# TODO:
# - Add a way to deal with specifying the language on a per-file
#   or maybe per-directory basis.  Maybe per-directory is a good
#   start.
#
# - Add support for files with no extension.  Need to make sure
#   we don't have problems with CVS/ directories.  In fact, we
#   need to make sure we don't have issues with foo.bar directories.
#
# - Add support for inline lgrind sources using the %(...)% notation
#
# README:
#
# To use this makefile fragment, set the variable:
#	LGRINDSRCS	= the source files to process
# in your top level Makefile.  You can also specify
# LGRINDDIRS which is a list of directories containing
# source files.  All source files in the specified directories
# are added to LGRINDSRCS
#
# The following variables may be overridden in your top level Makefile
#
#  LGRIND	= the lgrind executable
#  LGRIND_FLAGS	= flags passed to lgrind for exporting to tex
#
#######################################


# how to call lgrind to convert source files to TeX
LGRIND?=	lgrind
LGRIND_FLAGS?=	-i

#######################################
#
# Process LGRINDDIRS, adding to LGRINDSRCS
#
#######################################

# pick out $(LGRINDDIRS)/*.* except for *.tex for each
# specified directory.  This is how we will
# deal with basically any source code file type.  The
# exception will be things like Makefiles which do not
# have an extension usually.

# While we're processing these directories, check for a directory
# specific LGRIND_FLAGS (i.e. mydir_LGRIND_FLAGS).  If it is defined
# then assign it to the file specific lgrind flags for each source
# file if the source file does not already have its own file specific
# flags

.if defined(LGRINDDIRS)
.for __tmp__ in ${LGRINDDIRS}
.if exists(${__tmp__})
_LGRIND_ADDALL_${__tmp__}!=	ls ${__tmp__}/*.*
_LGRIND_ADD_${__tmp__}=	${_LGRIND_ADDALL_${__tmp__}:C/.*.tex$//g}
LGRINDSRCS+=	${_LGRIND_ADD_${__tmp__}}
.  if defined(${__tmp__}_LGRIND_FLAGS)
.    for __tmp2__ in ${_LGRIND_ADD_${__tmp__}}
${__tmp2__}_LGRIND_FLAGS?=	${${__tmp__}_LGRIND_FLAGS}
.    endfor
.  endif
.endif
.endfor
.endif






#######################################
#
# Process proj_LGRINDDIRS, adding to proj_LGRINDSRCS
#
#######################################

.for __name__ in ${NAME}
.if defined(${__name__}_LGRINDDIRS)
.for __tmp__ in ${${__name__}_LGRINDDIRS}
.if exists(${__tmp__})
_LGRIND_ADDALL2_${__tmp__}!=ls ${__tmp__}/*.*
_LGRIND_ADD2_${__tmp__}=	${_LGRIND_ADDALL2_${__tmp__}:C/.*.tex$//g}
${__name__}_LGRINDSRCS+=	${_LGRIND_ADD2_${__tmp__}}
.  if defined(${__tmp__}_LGRIND_FLAGS)
.    for __tmp2__ in ${_LGRIND_ADD2_${__tmp__}}
${__tmp2__}_LGRIND_FLAGS?=	${${__tmp__}_LGRIND_FLAGS}
.    endfor
.  endif
.endif
.endfor
.endif
${__name__}_DIST+=	${${__name__}_LGRINDSRCS} ${LGRINDSRCS}
.endfor






#######################################
# 
# Process proj_LGRINDSRCS to add to
# prog_OTHER dependencies
#
#######################################

LGRINDOBJS?=	$(LGRINDSRCS:=.tex)
ALLLGRINDOBJS+=	$(LGRINDOBJS)

.for __tmp__ in ${NAME}
.if defined(${__tmp__}_LGRINDSRCS)
${__tmp__}_LGRINDOBJS?=	${${__tmp__}_LGRINDSRCS:=.tex}
${__tmp__}_OTHER+=	${${__tmp__}_LGRINDOBJS}
ALLLGRINDOBJS+=	${${__tmp__}_LGRINDOBJS}
.endif
.endfor




#######################################
# 
# Add the dependencies
#
#######################################


OTHER+=	$(LGRINDOBJS)
all::		$(ALLLGRINDOBJS)

clean::
.for __tmp__ in $(ALLLGRINDOBJS)
	$(RM) -f $(__tmp__:Q)
.endfor


#######################################
#
# And add the build rules.
# 
# Note that we do this as a loop with explicit
# rules for each file rather than a suffix
# rule because we want to work on any input 
# file that lgrind can deal with
#
#######################################

.for __tmp__ in ${ALLLGRINDOBJS}
${__tmp__}: ${__tmp__:.tex=}
	$(LGRIND:Q) $(LGRIND_FLAGS) ${${__tmp__:.tex=}_LGRIND_FLAGS} \
		-o $@ ${__tmp__:.tex=}
.endfor


