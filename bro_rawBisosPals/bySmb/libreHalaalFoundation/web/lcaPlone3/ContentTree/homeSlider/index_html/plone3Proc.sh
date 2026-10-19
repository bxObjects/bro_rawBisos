#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"
# {{{ DBLOCK-top-of-file
typeset RcsId="$Id: plone3Proc.sh,v 1.1 2013/05/04 01:32:41 lsipusr Exp $"
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

startsBaseDir="/libre/ByStar/InitialTemplates/lcaPlone/Starts/galleriaBase/index_html"

function examplesHookPost {
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i reBuildFullUpdate
${G_myName} ${extraInfo} -i cleanForVcUpdate
--- SrcSet Preparations ---
${G_myName} ${extraInfo} -i srcSetUpdate
${G_myName} ${extraInfo} -i srcSetClean
--- Page Method Overwrites ---
${G_myName} ${extraInfo} -i page_method_prep
${G_myName} ${extraInfo} -i page_method_clean
${G_myName} ${extraInfo} -i page_method_fullClean
--- content.html Generators ---
${G_myName} ${extraInfo} -i contentDblockUpdate           # Producesa Ready to Use content.html
${G_myName} ${extraInfo} -i contentStartDblockBlank       # dblock Blank the contentStart.html
---  Galleria Data Creation/Update ---
${G_myName} ${extraInfo} -i galleriaHtmlDivJasonDataOutput  ./galleriaItemsList
${G_myName} ${extraInfo} -i galleriaHtmlDivJasonDataUpdate   # Produces the complete galleriaJasonData.html for insertion
---- Initial Templates Development ----
diff ./plone3Proc.sh  ${startsBaseDir}/plone3Proc.sh
cp   ./plone3Proc.sh  ${startsBaseDir}/plone3Proc.sh 
cp   ${startsBaseDir}/plone3Proc.sh  ./plone3Proc.sh  
cp   ./content.html ${startsBaseDir}
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

    opDo vis_srcSetUpdate

    inBaseDirDo ../pushFiles ./plone3Proc.sh -i fullUpdate

    opDo vis_fullUpdate

    lpReturn
}


function vis_cleanForVcUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_page_method_clean

    opDo vis_srcSetClean

    inBaseDirDo ../pushFiles ./plone3Proc.sh -i fullClean
    
    lpReturn
}

function vis_srcSetUpdate {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    inBaseDirDo ../srcSet/htmlSlides ./plone3Proc.sh -i fullUpdate

    inBaseDirDo ../srcSet/images ./plone3Proc.sh -v -n showRun -i toPloneBaseUpdate

    lpReturn
}

function vis_srcSetClean {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    inBaseDirDo ../srcSet/htmlSlides ./plone3Proc.sh -i fullClean

    inBaseDirDo ../srcSet/images ./plone3Proc.sh  -i fullClean

    lpReturn
}

function vis_contentDblockUpdate {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset albumName=$( vis_galleriaAlbumNameGet )

    if [ ! -s ./content.html ] ; then 
	EH_assert [[ -f ./contentStart.html ]]
	opDo eval "cat ./contentStart.html | sed  -e s:@GalleryTitle@:${albumName}: > ./content.html"
    fi

    opDo bx-dblock -i dblockUpdateFiles ./content.html

    lpReturn
}

function vis_contentStartDblockBlank {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    EH_assert [[ -f ./contentStart.html ]]

    opDo bx-dblock -h -v -n showRun -i dblockBlankFiles ./contentStart.html

    lpReturn
}



function vis_galleriaHtmlDivJasonDataOutput {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    #opDoExit pushd .. > /dev/null
    typeset here=$( pwd )
    bystarAcctPathAnalyze ${here}
    #opDo popd > /dev/null

    opDo bystarPlone3GalleriaManage.sh -h -v -n showRun -p bystarUid=${bystarUid} -i galleriaHtmlDivJasonOutput $1

    lpReturn
}


function vis_galleriaHtmlDivJasonDataUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset outputFile="$( pwd )/galleriaJasonData.html"

    FN_fileSafeKeep ${outputFile}

    opDo eval "vis_galleriaHtmlDivJasonDataOutput  ./galleriaItemsList > ${outputFile}" 

    opDo ls -l ${outputFile}

    lpReturn
}


function vis_page_method_prep {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
When this function overloads the preparation.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset cwd=$( pwd )
    bystarAcctPathAnalyze ${cwd}

    ploneSiteFqdn=${bystarSiteFqdn}

    opDo vis_page_method_varsPrep

    thisOutFile="./content.html"

    FN_fileSafeKeep ${thisOutFile}

    #opDo vis_srcSetUpdate

    opDo vis_galleriaHtmlDivJasonDataUpdate

    opDo vis_contentDblockUpdate 

    opDo ls -l ${thisOutFile}

    opDo vis_page_method_prep_basic

    lpReturn
}

function vis_page_method_clean {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]
    opDo FN_safeKeepsClean content.html
    opDo FN_safeKeepsClean galleriaJasonData.html
}

function vis_page_method_fullClean {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_page_method_clean

    opDo FN_fileRmIfThere ./content.html ./galleriaJasonData.html
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
