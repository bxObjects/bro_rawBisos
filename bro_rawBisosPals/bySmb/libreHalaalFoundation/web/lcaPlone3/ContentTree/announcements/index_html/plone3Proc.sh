#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"
# {{{ DBLOCK-top-of-file
typeset RcsId="$Id: plone3Proc.sh,v 1.1.1.1 2013/04/08 16:43:38 lsipusr Exp $"
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

function examplesHookPost {
cat  << _EOF_
--- EXTRAs ---
OLD ${G_myName} ${extraInfo} -i updateSitePages $( echo ${sitePages} )
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

    # /acct/smb/org/persoarabic/lcaPlone/ContentTree/lcntLists/Announcements.lcntNu
    pubSiteLcntList="${bystarAcctBase}/lcaPlone3/ContentTree/lcntLists/Announcements.lcntNu"

    thisOutFile="./contentBody.html"

    FN_fileSafeKeep ${thisOutFile}
    opDo lcnLcntOutputs.sh -n showRun -p format=short -p useThisSite=${ploneSiteFqdn} -p inListLcntNu="${pubSiteLcntList}" -p outFile="${thisOutFile}" -i fullHtmlTable
    opDo ls -l ${thisOutFile}
    #opDo htmlcat -o ./index_html/content  ./index_html/contentPreface.html ${thisOutFile}
    cat  ./contentPreface.html ${thisOutFile} > ./content.html

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
 
    opDo /bin/rm contentBody.html.[0-9]*
}

function vis_page_method_fullClean {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_page_method_clean
 
    opDo /bin/rm contentBody.html contentPlus.html content.html
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
