#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"
# {{{ DBLOCK-top-of-file
typeset RcsId="$Id: plone3Proc.sh,v 1.2 2013/04/10 06:07:09 lsipusr Exp $"
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

# {{{ FoldingSectionTitle

# 
# This Is An PlpcWebPage
# 
controllingPlpc="PLPC-180028"
ContentsReplacement="Projects"

controllingPlpcNu=$( echo ${controllingPlpc} | sed 's/PLPC-//' )


function examplesHookPost {
    bystarAcctPathAnalyze $( pwd )
cat  << _EOF_
--- EXTRAs ---
OLD ${G_myName} ${extraInfo} -i updateSitePages $( echo ${sitePages} )
bystarLcntProc.sh -h -v -n showRun  -i lcntVisit ${controllingPlpc}
bystarLcntProc.sh -h -v -n showRun  -i lcntSrcs ${controllingPlpc}
bystarLcntProc.sh -h -v -n showRun  -i lcntFullUpdate ${controllingPlpc}
bystarLcntProc.sh -h -v -n showRun -p bystarUid=${bystarUid}  -i plone3Upload ${controllingPlpc}
${G_myName} ${extraInfo} -i page_method_prep
${G_myName} ${extraInfo} -i page_method_clean
${G_myName} ${extraInfo} -i page_method_fullClean
_EOF_

    return
}

function vis_page_method_prep {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
When this function is overloaded in ploneProc.sh, then vis_page_method_prep_basic
should be called after content.html is in place.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset cwd=$( pwd )
    bystarAcctPathAnalyze ${cwd}

    ploneSiteFqdn=${bystarSiteFqdn}

    opDo vis_page_method_varsPrep

    FN_fileRmIfThere ./contentPlus.html

    opDo bystarLcntProc.sh -h -v -n showRun  -i lcntFullUpdate ${controllingPlpc}

    # 
    processedContent="/content/generated/doc.free/bystar/PLPC/${controllingPlpcNu}/current/memoEnFa/index.html"

    if [ ! -s "${processedContent}" ] ; then 
	EH_problem "Missing ${processedContent}"
	lpReturn 101
    fi

    thisOutFile="./contentBody.html"

    opDo cp ${processedContent} ${thisOutFile}
    
    opDo elispFilterHtml.sh -i deTitle ${thisOutFile}
    
    if [ -s ./contentPreface.html ] ; then
	contentPreface="./contentPreface.html"
    else
	contentPreface=""
    fi

    
    if [ -z "${ContentsReplacement}" ] ; then
	opDo eval "cat  ${contentPreface} ${thisOutFile} > ./content.html"
    else
	opDo eval "cat  ${contentPreface} ${thisOutFile} | sed  's:--SEC ANCHOR --.Contents./H2:--SEC ANCHOR -->${ContentsReplacement}</H2:' > ./content.html"
    fi

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

    if [ $( echo contentBody.html.[0-9]* ) = "contentBody.html.[0-9]*" ] ; then
	ANT_raw "Skipped: Nothing to Clean"
    else 
	opDo /bin/rm contentBody.html.[0-9]*
    fi
}

function vis_page_method_fullClean {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_page_method_clean
 
}


# }}}


####+BEGIN: bx:dblock:bash:end-of-file :types ""
# {{{ DBLOCK-end-of-file
#local variables:
#major-mode: shellscript-mode
#fill-column: 90
# end:
# }}} DBLOCK-end-of-file
####+END:
