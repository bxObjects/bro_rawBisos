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

startsBaseDir="/libre/ByStar/InitialTemplates/lcaPlone/Starts/galleriaBase/srcSet/images"


function examplesHookPost {
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i inFilesListGen
lcnFileParamsAdmin.sh -i absoluteFilesListStdout ./galleriaPhotoSample.jpg > ./inFilesList
lcnFileParamsAdmin.sh -i absoluteFilesListStdout ./galleriaPhotoSample.jpg
echo ./galleriaPhotoSample.jpg | lcnFileParamsAdmin.sh -i absoluteFilesListStdout 
---
${G_myName} ${extraInfo} -i toPloneBaseUpdate
---- Initial Templates Development ----
diff ./plone3Proc.sh  ${startsBaseDir}/plone3Proc.sh
cp   ./plone3Proc.sh  ${startsBaseDir}/plone3Proc.sh 
cp   ${startsBaseDir}/plone3Proc.sh  ./plone3Proc.sh  
cp   ./galleriaPhotoSample.jpg  ${startsBaseDir}
_EOF_
     vis_plone3GalleriaFacilitiesExamples
     return
}

function vis_inFilesListGen {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if [ -f ./inFilesList ] ; then
	ANT_cooked "./inFilesList In Place, inFilesListGen Skipped"
    else
	opDo lcnFileParamsAdmin.sh -i absoluteFilesListStdout ./galleriaPhotoSample.jpg > ./inFilesList
	opDo ls -l  ./inFilesList
    fi

    lpReturn
}


function vis_absoluteFilesListStdoutObsoleted {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
If there are any args, process those.
If there are no args, process stdin.
_EOF_
    }

    if [ $# -gt 0 ] ; then
	typeset thisOne=""
	for thisOne in ${@} ; do
	    typeset thisFile=$( FN_absolutePathGet ${thisOne} )
	    echo ${thisFile}
	done
    else
	typeset thisLine=""
    
	while read thisLine ; do
	    if [ "${thisLine}" != "" ] ; then
		typeset thisFile=$( FN_absolutePathGet ${thisLine} )
		echo ${thisFile}
	    fi
	done
    fi

    lpReturn
}


function vis_toPloneBaseUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset inFilesList=""

    if [ -f "./inFilesList" ] ; then
	inFilesList=$( cat ./inFilesList )
	
    else
	opDo vis_inFilesListGen
	inFilesList=$( cat ./inFilesList )
    fi

    typeset here=$( pwd )

    bystarAcctPathAnalyze ${here}

    typeset inFilesListReady=$( echo ${inFilesList} )

    typeset albumName=$( vis_galleriaAlbumNameGet  )
 
    opDo eval "echo ${inFilesListReady} | bystarPlone3GalleriaManage.sh -h -v -n showRun -p bystarUid=${bystarUid} -p album=${albumName} -i galleriaToPloneBaseUpdateStdin"

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
