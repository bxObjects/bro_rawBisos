#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"
# {{{ DBLOCK-top-of-file
typeset RcsId="$Id: plone3Proc.sh,v 1.1 2013/05/04 01:05:21 lsipusr Exp $"
#  This is a Halaal Poly-Existential. See http://www.freeprotocols.org
# }}} DBLOCK-top-of-file
####+END:

####+BEGIN: bx:dblock:lsip:bash:seed-spec :types "seedPlone3NewProc.sh"
# {{{ DBLOCK-seed-spec
if [ "${loadFiles}X" == "X" ] ; then
    /opt/public/osmt/bin/seedPlone3NewProc.sh -l $0 "$@" 
    exit $?
fi
# }}} DBLOCK-seed-spec
####+END:

leavesExcludes=""

leavesOrdered=""

nodesExcludes=""

nodesOrdered=""

####+BEGIN: bx:dblock:ploneProc:bash:leavesList :types ""
# {{{ DBLOCK-leavesList
leavesList="
index_html
"
# }}} DBLOCK-leavesList
####+END:

####+BEGIN: bx:dblock:ploneProc:bash:nodesList :types ""
# {{{ DBLOCK-nodesList
nodesList="
"
# }}} DBLOCK-nodesList
####+END:

# {{{ EXTRAs

upStreamBase="/libre/ByStar/InitialTemplates/lcaPlone/NewInitialContentTree/mob.gened/Poly/DEFAULT"
targetFile="contentIndex.html"

function examplesHookPost {
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i initialUpdateAll   # = objectGenerate + objectUpdate
${G_myName} ${extraInfo} -i cleanForVcUpload
--- Object Generate/Update ---
${G_myName} ${extraInfo} -i objectGenerate
${G_myName} ${extraInfo} -i objectUpdate
--- Upstream Development Feeds ---
${G_myName} ${extraInfo} -i upstreamPullFrom
${G_myName} ${extraInfo} -i upstreamDevCopyTo
${G_myName} ${extraInfo} -i upstreamDevVcUpdate
pushd "${upStreamBase}"
_EOF_
 return
}

function vis_upstreamPullFrom {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Makes a proper/customized copy from upStreamBase to current bystarUid.

This happens after bystarPlone3Initial.sh has put this plone3Proc.sh in 
this current directory.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    # NOTYET, VCs eliminate
    opDo cp -r "${upStreamBase}"/* .

    lpReturn
}

function vis_upstreamDevCopyTo {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Makes a proper/customized copy from current bystarUid directory to upStreamBase.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    # NOTYET, VCs eliminate
    opDo cp -r ./* "${upStreamBase}"

    lpReturn
}

function vis_upstreamDevVcUpdate {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Makes a proper/customized copy from current directory to upStreamBase.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    echo "${upStreamBase}"
    echo "NOTYET"

    lpReturn
}


function vis_cleanForVcUpload {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo FN_fileRmIfThere ${targetFile}

    opDo pushd ./index_html
    opDo ./plone3Proc.sh -i cleanForVcUpload
    opDo popd

    lpReturn
}



function vis_initialUpdateAll {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_objectGenerate
    opDo vis_objectUpdate

    opDo pushd ./index_html
    opDo ./plone3Proc.sh -i initialUpdateAll
    opDo popd

}


function vis_objectGenerate {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    bystarAcctPathAnalyze $( pwd )

    destDir=$( pwd )
    opDo bystarServiceSupportHookRun createBannersSpecific bannerGenHtml > ${destDir}/${targetFile}

    opDo ls -l ${destDir}/${targetFile}

    lpReturn
}


function createBannersSpecific_BYSMB_DEFAULT {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Covers createBannersSpecific_BYSMB_COMMITTED and createBannersSpecific_BYSMB_TRIAL
_EOF_
    }

    function bannerGenHtml {
	G_funcEntry
	function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
	}
	EH_assert [[ $# -eq 0 ]]
	
	opDoExit cat <<  _EOF_
<div style="text-align: center;"
   id="portal-logo">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<table style="text-align: left; width: 100%;" border="0" cellspacing="2"
       cellpadding="2">
  <tbody>
    <tr>
      <br>
      <td style="vertical-align: top; width: 600px; text-align: left;">
	<font style="font-weight: bold; font-size: 16pt;">
	  Welcome to the website of ${cp_acctMainBaseDomain}
	</font>
      </td>
      <td style="vertical-align: top; width: 600px; text-align: right;">
	<font style="font-weight: bold; font-size: 16pt;">
	  An Autonomous Service of The Libre By* Digital Ecosystem
	</font>
      </td>
    </tr>
  </tbody>
</table>

<table style="text-align: left; width: 100%;" border="0" cellspacing="2"
       cellpadding="2">
  <tbody>
    <tr>
      <td style="vertical-align: top; width: 600px; text-align: left;">
	<font style="font-weight: bold; font-size: 8pt;">
	  <a href="http://mohsen.1.banan.byname.net/PLPC/120041">
	    Libre/Halaal Internet Services
	  </a>
	  Provided At
	  <a href="http://www.librecenter.net">
	    LibreCenter
	  </a>
	  By
	  <a href="http://www.neda.com">
	    Neda
	  </a>
	</font>
	<br>
	<br>
      </td>
      <td style="vertical-align: top; width: 600px; text-align: right;">
	<font style="font-weight: bold; font-size: 8pt;">
	  Member of 
	</font>
	<a href="http://www.by-star.net">
	  <font style="color: #8B4513; font-weight: bold; font-size: 8pt;"> 
	    By*
	  </font>
	</a>
	<font style="color: #8B4513; font-weight: bold; font-size: 8pt;">
	  Federation Of Autonomous 
	</font>
	<a href="http://www.libreservices.org">
	  <font style="color: #8B4513; font-weight: bold; font-size: 8pt;">
	    Libre Services
	  </font>
	</a>
	<br>
	<br>
      </td>
    </tr>
  </tbody>
</table>
</div>

_EOF_
}

    $1
}

createBannersSpecific_BCA_TRIAL () {
    ANT_raw "createBannersSpecific_BCA_TRIAL"

    createBannersSpecific_BCA_COMMITTED   $@
}


createBannersSpecific_BCA_COMMITTED () {
    ANT_raw "createBannersSpecific_BCA_COMMITTED"

    bannerGenHtmlNOT () {
      opDoExit cat <<  _EOF_
\documentclass[11pt]{article}
\usepackage[usenames,dvipsnames]{color}
\usepackage{arabtex}

\setlength{\textwidth}{9cm}
\setlength{\topmargin}{-2cm}
\setlength{\textheight}{5cm}
\setlength{\oddsidemargin}{0.0cm}
\setlength{\evensidemargin}{0.0cm}

\parindent 0mm

\begin{document}

\pagestyle{empty}

\setfarsi \novocalize 
\vfill

\begin{minipage}[t]{5in}
\colorbox{Plum}{\makebox[4in]{\textcolor{black}{Controlled Account of Master Accout:}}}\\
\colorbox{OliveGreen}{\makebox[4in]{Controlled Account Name Comes Here}}\\
\end{minipage}

\end{document}


_EOF_
}
 
    $1
}

createBannersSpecific_BYALIAS_COMMITTED () {
    bannerGenHtmlNOT () {
      opDoExit cat <<  _EOF_


\documentclass[11pt]{article}
\usepackage[usenames,dvipsnames]{color}
\usepackage{arabtex}

\setlength{\textwidth}{9cm}
\setlength{\topmargin}{-2cm}
\setlength{\textheight}{5cm}
\setlength{\oddsidemargin}{0.0cm}
\setlength{\evensidemargin}{0.0cm}

\parindent 0mm

\begin{document}

\pagestyle{empty}

\setfarsi \novocalize 
\vfill

\begin{minipage}[t]{5in}
\colorbox{Plum}{\makebox[4in]{\textcolor{black}{ByAlias Public Page of}}}\\
\colorbox{OliveGreen}{\makebox[4in]{${cp_AliasName} }}\\
\end{minipage}

\end{document}


_EOF_
}
 
    $1
}


createBannersSpecific_BYALIAS_TRIAL () {
  ANT_raw "createBannersSpecific_BYALIAS_TRIAL"
    bannerGenHtmlNOT () {
      opDoExit cat <<  _EOF_


\documentclass[11pt]{article}
\usepackage[usenames,dvipsnames]{color}
\usepackage{arabtex}

\setlength{\textwidth}{9cm}
\setlength{\topmargin}{-2cm}
\setlength{\textheight}{5cm}
\setlength{\oddsidemargin}{0.0cm}
\setlength{\evensidemargin}{0.0cm}

\parindent 0mm

\begin{document}

\pagestyle{empty}

\setfarsi \novocalize 
\vfill

\begin{minipage}[t]{5in}
\colorbox{Plum}{\makebox[4in]{\textcolor{black}{ByAlias Public Page of}}}\\
\colorbox{Yellow}{\makebox[4in]{${cp_AliasName} }}\\
\end{minipage}

\end{document}


_EOF_
}

 
    $1
}


createBannersSpecific_BYNAME_COMMITTED () {
  ANT_raw "createBannersSpecific_BYNAME_COMMITTED"

    bannerGenHtmlNOT () {
      opDoExit cat <<  _EOF_

\documentclass[11pt]{article}
\usepackage[usenames,dvipsnames]{color}
\usepackage{arabtex}

\setlength{\textwidth}{9cm}
\setlength{\topmargin}{-2cm}
\setlength{\textheight}{5cm}
\setlength{\oddsidemargin}{0.0cm}
\setlength{\evensidemargin}{0.0cm}

\parindent 0mm

\begin{document}

\pagestyle{empty}

\setfarsi \novocalize 
\vfill


\begin{minipage}[t]{5in}
\colorbox{Orange}{\makebox[4in]{\textcolor{black}{ByName Public Web Page of}}}\\
\colorbox{OliveGreen}{\makebox[4in]{${cp_FirstName} ${cp_LastName} }}\\
\end{minipage}

\end{document}

_EOF_
    }

    $1
}


createBannersSpecific_BYNAME_TRIAL () {

    bannerGenHtmlNOT () {
      opDoExit cat <<  _EOF_

\documentclass[11pt]{article}
\usepackage[usenames,dvipsnames]{color}
\usepackage{arabtex}

\setlength{\textwidth}{9cm}
\setlength{\topmargin}{-2cm}
\setlength{\textheight}{5cm}
\setlength{\oddsidemargin}{0.0cm}
\setlength{\evensidemargin}{0.0cm}

\parindent 0mm

\begin{document}

\pagestyle{empty}

\setfarsi \novocalize 
\vfill

\begin{minipage}[t]{5in}
\colorbox{Orange}{\makebox[4in]{\textcolor{black}{ByName Public Web Page of}}}\\
\colorbox{Yellow}{\makebox[4in]{${cp_FirstName} ${cp_LastName} }}\\
\end{minipage}

\end{document}

_EOF_
    }


    $1
}

createBannersSpecific_BYMEMORY_COMMITTED () {

    bannerGenHtmlNOT () {
      opDoExit cat <<  _EOF_

\documentclass[11pt]{article}
\usepackage[usenames,dvipsnames]{color}
\usepackage{arabtex}

\setlength{\textwidth}{9cm}
\setlength{\topmargin}{-2cm}
\setlength{\textheight}{5cm}
\setlength{\oddsidemargin}{0.0cm}
\setlength{\evensidemargin}{0.0cm}

\parindent 0mm

\begin{document}

\pagestyle{empty}

\setfarsi \novocalize 
\vfill


\begin{minipage}[t]{5in}
\colorbox{black}{\makebox[4in]{\textcolor{white}{In Memory of}}}\\
\colorbox{OliveGreen}{\makebox[4in]{${cp_FirstName} ${cp_LastName} }}\\
\end{minipage}

\end{document}

_EOF_
    }

    $1
}

createBannersSpecific_BYMEMORY_TRIAL () {
    ANT_raw "createBannersSpecific_BYNAME_TRIAL"

    bannerGenHtmlNOT () {
      opDoExit cat <<  _EOF_

\documentclass[11pt]{article}
\usepackage[usenames,dvipsnames]{color}
\usepackage{arabtex}

\setlength{\textwidth}{9cm}
\setlength{\topmargin}{-2cm}
\setlength{\textheight}{5cm}
\setlength{\oddsidemargin}{0.0cm}
\setlength{\evensidemargin}{0.0cm}

\parindent 0mm

\begin{document}

\pagestyle{empty}

\setfarsi \novocalize 
\vfill


\begin{minipage}[t]{5in}
\colorbox{black}{\makebox[4in]{\textcolor{white}{In Memory of}}}\\
\colorbox{Yellow}{\makebox[4in]{${cp_FirstName} ${cp_LastName} }}\\
\end{minipage}

\end{document}

_EOF_
    }

    $1
}


createBannersSpecific_DEFAULT_DEFAULT () {
   EH_problem "Not Supported for $1 --${bystarServiceType}_${bystarServiceSupportType}"
}


# }}} EXTRAs


####+BEGIN: bx:dblock:bash:end-of-file :types ""
# {{{ DBLOCK-end-of-file
#local variables:
#major-mode: shellscript-mode
#fill-column: 90
# end:
# }}} DBLOCK-end-of-file
####+END:
