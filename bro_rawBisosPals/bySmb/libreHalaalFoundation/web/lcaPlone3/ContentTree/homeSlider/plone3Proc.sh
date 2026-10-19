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

leavesOrdered="
index_html
pushFiles
"

nodesExcludes=""

nodesOrdered=""

####+BEGIN: bx:dblock:ploneProc:bash:leavesList :types ""
# {{{ DBLOCK-leavesList
leavesList="
index_html
pushFiles
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

startsBaseDir="/libre/ByStar/InitialTemplates/lcaPlone/Starts/galleriaBase"

function examplesHookPost {
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i reBuildFullUpdate
${G_myName} ${extraInfo} -i cleanForVcUpdate
---- Initial Templates Development ----
diff ./plone3Proc.sh  ${startsBaseDir}/plone3Proc.sh
cp   ./plone3Proc.sh  ${startsBaseDir}/plone3Proc.sh 
cp   ${startsBaseDir}/plone3Proc.sh  ./plone3Proc.sh  
diff -r -q . ${startsBaseDir}
_EOF_
     vis_plone3GalleriaFacilitiesExamples
     return
}

function vis_reBuildFullUpdate {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    # Create This Folder on Plone Site
    opDo vis_fullUpdate

    inBaseDirDo ./index_html ./plone3Proc.sh -i reBuildFullUpdate

    lpReturn
}


function vis_cleanForVcUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_fullClean

    inBaseDirDo ./index_html ./plone3Proc.sh -i cleanForVcUpdate

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
