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


# /opt/public/osmt/bin/bystarPlone3Galleria.libSh
. ${opBinBase}/bystarPlone3Galleria.libSh

startsBaseDir="/libre/ByStar/InitialTemplates/lcaPlone/Starts/galleriaBase/srcSet/htmlSlides"

function examplesHookPost {
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i  htmlSlideStart slideName    # Creates starting point files
---- Initial Templates Development ----
diff ./plone3Proc.sh  ${startsBaseDir}/plone3Proc.sh
cp   ./plone3Proc.sh  ${startsBaseDir}/plone3Proc.sh 
cp   ${startsBaseDir}/plone3Proc.sh  ./plone3Proc.sh 
cp   ./galleriaHtmlSample.*   ${startsBaseDir}
_EOF_
  lpReturn
}


function vis_htmlSlideStart {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_

_EOF_
    }

    EH_assert [[ $# -eq 1 ]]

    slideName=$1

    typeset here=$( pwd )
    bystarAcctPathAnalyze ${here}


    albumName=$( vis_galleriaAlbumNameGet )
    if [ -z "${albumName}" ] ; then
	EH_problem "Missing albumName"
	lpReturn 101
    fi

    echo album=${albumName} bystarUid=${bystarUid}

    opDo bystarPlone3GalleriaManage.sh -p album=${albumName} -p bystarUid=${bystarUid} -i htmlSlideStart ${slideName}

    lpReturn
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
