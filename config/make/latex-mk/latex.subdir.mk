# -*- makefile -*-
# $Id: latex.subdir.mk.in.in,v 1.4 2006/01/28 04:43:18 dan Exp $
#
# Copyright (c) 2002, 2006 Dan McMahill
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

ECHO?=		/bin/echo

#
# This Makefile fragment is included at the very end of users custom
# Makefiles in subdirectories of a top level latex-mk Makefile.  This
# makes sure the standard set of targets exist so a recursive make
# will not fail due to undefined targets

# An example is:
#
# SUBDIR+=	document1
# SUBDIR+=	document2
# SUBDIR+=	document3
# .include "/path/to/latex.subdir.mk"
#


# note:  we put "default" first because when we do not specify a target
# we want to use "default" because thats what latex.mk has for its own
# default
_ALL_TARGETS= default all clean dist distclean dvi html pdf print print-all \
	ps rtf show-var view viewall viewpdf viewps

.for __target in ${_ALL_TARGETS}
.if !target(${__target})
.PHONY: ${__target}
${__target}: _SUBDIRUSE
.endif
.endfor

#       
#       Derived from NetBSD Id: bsd.pkg.subdir.mk,v 1.60 2005/11/14 04:44:25 rillig Exp
#       Which in turn says:
#       Derived from: FreeBSD Id: bsd.port.subdir.mk,v 1.19 1997/03/09 23:10:56 wosch Exp
#       from: @(#)bsd.subdir.mk 5.9 (Berkeley) 2/1/91

.if !target(_SUBDIRUSE)
_SUBDIRUSE: .USE
	@for entry in "" ${SUBDIR} ; do \
		if [ "$$entry" != "" ] ; then \
			OK=""; \
			if [ -d ${.CURDIR}/$${entry} ]; then \
				edir=$${entry}; \
			else \
				OK="false"; \
				${ECHO} "===> ${_THISDIR_}$${entry} non-existent"; \
			fi; \
			if [ "$$OK" = "" ]; then \
				cd ${.CURDIR}/$${edir}; \
				${ECHO} "===> ${_THISDIR_}$${edir}"; \
				${MAKE} ${MAKEFLAGS} "_THISDIR_=${_THISDIR_}$${edir}/" \
			   	 ${.TARGET} || true; \
			fi; \
		fi ; \
	done
.endif








