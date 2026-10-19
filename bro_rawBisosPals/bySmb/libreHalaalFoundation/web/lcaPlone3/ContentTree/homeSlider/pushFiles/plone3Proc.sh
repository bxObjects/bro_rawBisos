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

startsBaseDir="/libre/ByStar/InitialTemplates/lcaPlone/Starts/galleriaBase/galleria"


function examplesHookPost {
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i cleanForVcUpdate
--- Page Method Overwrites ---
${G_myName} ${extraInfo} -i files_method_clean
${G_myName} ${extraInfo} -i files_method_fullClean
--- Custom Processors ---
${G_myName} ${extraInfo} -i cleanItemsListImageFiles
pushd ..; ${G_myName} ${extraInfo} -i fromSrcToPloneBaseUpdate ; popd
---- Initial Templates Development ----
diff ./plone3Proc.sh  ${startsBaseDir}/plone3Proc.sh
cp   ./plone3Proc.sh  ${startsBaseDir}/plone3Proc.sh 
cp   ${startsBaseDir}/plone3Proc.sh  ./plone3Proc.sh  
_EOF_
     vis_plone3GalleriaFacilitiesExamples
     return
}

function vis_cleanForVcUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_files_method_fullClean
    
    lpReturn
}


function vis_cleanItemsListImageFiles {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    galleriaItemsList=$( vis_galleriaItemsListGet )

    for thisFile in ${galleriaItemsList}; do
    	typeset thisPrefix=$( FN_prefix ${thisFile} )
    	typeset thisExtension=$( FN_extension ${thisFile} )

	opDo FN_fileRmIfThere ${thisPrefix}.title
	opDo FN_fileRmIfThere ${thisPrefix}.description
	opDo FN_fileRmIfThere ${thisPrefix}-small.jpg
	opDo FN_fileRmIfThere ${thisPrefix}-medium.jpg
	opDo FN_fileRmIfThere ${thisPrefix}-large.jpg
    done
}


function vis_files_method_clean {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]
    opDo FN_safeKeepsCleanHere
}

function vis_files_method_fullClean {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_files_method_clean
    opDo vis_cleanItemsListImageFiles
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
