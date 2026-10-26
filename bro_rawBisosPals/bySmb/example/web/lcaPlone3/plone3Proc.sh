#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"
# {{{ DBLOCK-top-of-file
typeset RcsId="$Id: plone3Proc.sh,v 1.2 2013/04/08 19:58:00 lsipusr Exp $"
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

function examplesHookPost {
    #bystarAcctPathAnalyze $( pwd )    # Setsup bystarUid, bystarUidHome ...
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i reBuildDeleteThenBlank        # DELETE then ReCreate a BLANK site
${G_myName} ${extraInfo} -i reBuildDeleteThenFullUpdate   # DELETE then ReBuild 
--- ReBuild Remote Based on Local ---
${G_myName} ${extraInfo} -i reBuildFullUpdate   # BaseSetup + UpdateAll
${G_myName} ${extraInfo} -i reBuildBaseSetup    # Make the symlinks and baseAssembles for .gened
${G_myName} ${extraInfo} -i reBuildUpdateAll    # Generate the ploneSite from scratch
${G_myName} ${extraInfo} -i initialLibrary
--- Clean For VC Upload (export, update) ---
${G_myName} ${extraInfo} -i cleanForVcUpload    # Delete symlinks and remove .gened
--- Version Control ---
${G_myName} ${extraInfo} -i vcUpdate
---- Initial Templates Development ----
diff ./plone3Proc.sh  /libre/ByStar/InitialTemplates/lcaPlone/Base/plone3Proc.sh.start
cp ./plone3Proc.sh  /libre/ByStar/InitialTemplates/lcaPlone/Base/plone3Proc.sh.start
cp /libre/ByStar/InitialTemplates/lcaPlone/Base/plone3Proc.sh.start ./plone3Proc.sh  
_EOF_
 return
}


function vis_reBuildDeleteThenBlank {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    bystarAcctPathAnalyze $( pwd )/ContentTree 

    opDo bystarPlone3Commands.sh -h -v -n showRun -p bystarUid="${bystarUid}" -i ploneSiteDelete

    # ReCreate -- Creates a Blank Site:          
    opDo bystarPlone3Admin.sh -h -v -n showRun -p bystarUid="${bystarUid}" -i fullReCreate
}


function vis_reBuildDeleteThenFullUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_reBuildDeleteThenBlank

    opDo vis_reBuildFullUpdate
}



function vis_reBuildFullUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    opDo pushd ${here}/ContentTree
    opDo ./plone3Proc.sh -v -n showRun -i reBuildFullUpdate
    opDo popd

    opDo pushd ${here}/SiteStyle
    opDo ./plone3Proc.sh -v -n showRun -i reBuildFullUpdate
    opDo popd
}


function vis_reBuildBaseSetup {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]


    typeset here=$( pwd )

    opDo pushd ${here}/ContentTree
    opDo ./plone3Proc.sh -v -n showRun -i reBuildBaseSetup
    opDo popd

    opDo pushd ${here}/SiteStyle
    opDo ./plone3Proc.sh -v -n showRun -i reBuildBaseSetup
    opDo popd
}


function vis_reBuildUpdateAll {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    opDo pushd ${here}/SiteStyle
    opDo ./plone3Proc.sh -v -n showRun -i reBuildUpdateAll
    opDo popd

    opDo pushd ${here}/ContentTree
    opDo ./plone3Proc.sh -v -n showRun -i reBuildUpdateAll
    opDo popd
}


function vis_cleanForVcUpload {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    opDo pushd ${here}/ContentTree
    opDo ./plone3Proc.sh -v -n showRun -i cleanForVcUpload
    opDo popd

    opDo pushd ${here}/SiteStyle
    opDo ./plone3Proc.sh -v -n showRun -i cleanForVcUpload
    opDo popd

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
