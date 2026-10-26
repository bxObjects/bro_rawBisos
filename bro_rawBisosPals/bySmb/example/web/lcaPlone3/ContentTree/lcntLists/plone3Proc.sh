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

# {{{ EXTRAs

upStreamBase="/libre/ByStar/InitialTemplates/lcaPlone/NewInitialContentTree/lcntLists.gened/Poly/DEFAULT"
targetFile=""


function examplesHookPost {
    extraInfo="-h -v -n showRun"
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i cleanForVcUpload
--- Upstream Development Feeds ---
${G_myName} ${extraInfo} -i upstreamPullFrom
${G_myName} ${extraInfo} -i upstreamDevCopyTo
pushd "${upStreamBase}"
--- Verify LCNTs ---
${G_myName} ${extraInfo} -i verifyLcntNu ./Upload.lcntNu
--- Upload LCNTs ---
${G_myName} ${extraInfo} -i uploadLcntNu ./New.lcntNu
${G_myName} ${extraInfo} -i uploadLcntNu ./Primary.lcntNu
${G_myName} ${extraInfo} -i localFullUpdateLcntNu ./Primary.lcntNu
${G_myName} ${extraInfo} -i uploadLcntNu ./Upload.lcntNu
--- Category Filters ---
lcnLcntSelect.sh -h -v -n showRun -p inListLcntNu="/lcnt/outputs/all/lists/nuBaseDir" -p outListLcntNu="./Example.lcntNu" -i siftLcntFunc isPublisher fpf 
--- Based on this site being publication site ---
lcnLcntSelect.sh -h -v -n showRun -p inListLcntNu="${fullListLcntNu}" -p outListLcntNu="${pubSiteLcntList}" -i siftLcntFunc isPubSite ${ploneSiteFqdn}
--- Primary.lcntNy creation ---
lcnLcntSelect.sh -h -v -n showRun -p inListLcntNu="/lcnt/outputs/all/lists/nuBaseDir" -p outListLcntNu="./Example.lcntNu" -i siftLcntFunc isPublisher fpf 
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
    #opDo cp -r "${upStreamBase}"/* .
    opDo cp  "${upStreamBase}"/* .

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
    #opDo cp -r ./* "${upStreamBase}
    opDo cp  ./* "${upStreamBase}"

    lpReturn
}


function vis_cleanForVcUpload {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_custom_method_clean

    lpReturn
}



function vis_uploadLcntNu {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    bystarAcctPathAnalyze $( pwd )

    opDo bystarLcntProc.sh -h -v -n showRun -p bystarUid=${bystarUid}  -p inListLcntNu="$1" -i plone3Upload all
}

function vis_verifyLcntNu {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    bystarAcctPathAnalyze $( pwd )

    opDo bystarLcntProc.sh -h -v -n showRun -p bystarUid=${bystarUid}  -p inListLcntNu="$1" -i plone3EntriesVerify all
}


function vis_localFullUpdateLcntNu {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    bystarAcctPathAnalyze $( pwd )

    opDo bystarLcntProc.sh -h -v -n showRun  -p inListLcntNu="$1" -i lcntFullUpdate all
}


# }}}


# {{{ Object Definition (custom)

typeset -A object_custom=(
    [startGen]=vis_custom_method_startGen
    [startUpdate]=vis_custom_method_startUpdate
    [varsPrep]=vis_custom_method_varsPrep
    [info]=vis_custom_method_info
    [prePrep]=vis_custom_method_prePrep
    [prep]=vis_custom_method_prep
    [update]=vis_custom_method_update
    [clean]=vis_custom_method_clean
    [fullUpdate]=vis_custom_method_fullUpdate
    [fullClean]=vis_custom_method_clean
)

function vis_custom_method_startGen {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
Generate initial links at \$1 for each named in REST.
\$1: is "there" -- location where initial links should be created.
shift - \$*: is list of links to create initial environment for.
_EOF_
    }
    EH_assert [[ $# -gt 0 ]]
    describeF
}

function vis_custom_method_startUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset cwd=$( pwd )

    vis_leafThereTag ${cwd} "plone3Proc.sh"

    if [ -f plone3Proc.sh ] ; then
	ANT_raw "plone3Proc.sh  Already exists -- Doing Nothing"
    else
	opDo cp /libre/ByStar/InitialTemplates/lcaPlone/Starts/plone3NewProc.sh plone3Proc.sh
	opDo vis_dblockUpdateFile plone3Proc.sh
	opDo chmod 775 plone3Proc.sh
    fi
}

function vis_custom_method_varsPrep {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]
}


function vis_custom_method_info {
    G_funcEntry
    function describeF {  cat  << _EOF_
${G_myName}:${G_thisFunc}:Usage: 
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]
    describeF
}

function vis_custom_method_prep {
    G_funcEntry
    function describeF {  cat  << _EOF_
Given Upload.lcntNu, Regenerate Plpc.lcntNu Records.lcntNu Draft.lcntNu Repub.lcntNu
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    opDoRet bystarAcctPathAnalyze ${here}
    EH_retOnFail

    bystarUidHome=${bystarAcctBase}

    typeset fullListFile="${here}/Upload.lcntNu"

    typeset plpcListFile="${here}/Plpc.lcntNu"
    typeset recordsListFile="${here}/Records.lcntNu"
    typeset draftListFile="${here}/Draft.lcntNu"
    typeset repubListFile="${here}/Repub.lcntNu"

    opDo lcnLcntOutputs.sh -n showRun -p inListLcntNu=${fullListFile} -p sortByCategory=plpc -p outFile=${plpcListFile}  -i lcntNuSort

    opDo lcnLcntOutputs.sh -n showRun -p inListLcntNu=${fullListFile} -p sortByCategory=records -p outFile=${recordsListFile}  -i lcntNuSort

    opDo lcnLcntOutputs.sh -n showRun -p inListLcntNu=${fullListFile} -p sortByCategory=draft -p outFile=${draftListFile}  -i lcntNuSort

    opDo lcnLcntOutputs.sh -n showRun -p inListLcntNu=${fullListFile} -p sortByCategory=repub -p outFile=${repubListFile}  -i lcntNuSort
}


function vis_custom_method_clean {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    typeset plpcListFile="${here}/Plpc.lcntNu"
    typeset recordsListFile="${here}/Records.lcntNu"
    typeset draftListFile="${here}/Draft.lcntNu"
    typeset repubListFile="${here}/Repub.lcntNu"

    opDo FN_fileRmIfThere ${plpcListFile} ${recordsListFile} ${draftListFile} ${repubListFile}

}


function vis_custom_method_update {
    G_funcEntry
    function describeF {  cat  << _EOF_
Given Upload.lcntNu, upload them all to this site.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    opDoRet bystarAcctPathAnalyze ${here}
    EH_retOnFail

    bystarUidHome=${bystarAcctBase}

    # /acct/smb/org/persoarabic/lcaPlone/ContentTree/lcntLists/Upload.lcntNu
    typeset uploadsListFile="${here}/Upload.lcntNu"

    if [ ! -f ${uploadsListFile} ] ; then
	EH_problem "Missing ${uploadsListFile}"
	lpReturn 101
    else
	opDo bystarLcntProc.sh -p bystarUid=${bystarUid} -p inListLcntNu="${uploadsListFile}" -i plone3Upload all
    fi
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
