#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"
# {{{ DBLOCK-top-of-file
typeset RcsId="$Id: plone3Proc.sh,v 1.6 2013/05/04 01:32:19 lsipusr Exp $"
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
lcntLists
"
# }}} DBLOCK-leavesList
####+END:

####+BEGIN: bx:dblock:ploneProc:bash:nodesList :types ""
# {{{ DBLOCK-nodesList
nodesList="
contentImages
announcements
projects
Home
participate
mob
homeSlider
"
# }}} DBLOCK-nodesList
####+END:

# {{{ EXTRAs

function examplesHookPost {
    bystarAcctPathAnalyze $( pwd )    # Setsup bystarUid, bystarUidHome ...
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i reBuildFullUpdate          # reBuildBaseSetup + reBuildUpdateAll
${G_myName} ${extraInfo} -i reBuildBaseSetup           # Make the symlinks and baseAssembles for .gened
${G_myName} ${extraInfo} -i reBuildUpdateAll           # Generate ALL of the ploneSite from scratch
${G_myName} ${extraInfo} -i reBuildUpdateHomePlus      # Rebuilds Home and homeSlider and mob
${G_myName} ${extraInfo} -i reBuildUpdateSiteSpecific  # Rebuilds What is Site Specific
${G_myName} ${extraInfo} -i reBuildUpdateCommonTop     # Rebuilds Top Common Part
${G_myName} ${extraInfo} -i reBuildUpdateCommonBottom  # Rebuilds Bottom Common Part
${G_myName} ${extraInfo} -i reBuildUpdateCommonAll     # Rebuilds What is Site Specific
---
${G_myName} ${extraInfo} -i initialLibrary             # Does lcntList Upload first
--- Clean For VC Upload (export, update) ---
${G_myName} ${extraInfo} -i cleanForVcUpload    # Delete symlinks and remove .gened
--- Version Control ---
${G_myName} ${extraInfo} -i vcUpdate
---- Example Over Write Of .common  ----
cp -r -H footer.common footer
deCvs footer
---- Initial Templates Development ----
diff ./plone3Proc.sh  /libre/ByStar/InitialTemplates/lcaPlone/NewInitialContentTree/Base/Poly/DEFAULT/plone3Proc.sh.start 
cp ./plone3Proc.sh  /libre/ByStar/InitialTemplates/lcaPlone/NewInitialContentTree/Base/Poly/DEFAULT/plone3Proc.sh.start 
cp /libre/ByStar/InitialTemplates/lcaPlone/NewInitialContentTree/Base/Poly/DEFAULT/plone3Proc.sh.start  ./plone3Proc.sh  
_EOF_
 return
}


function vis_reBuildFullUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_reBuildBaseSetup

    opDo vis_reBuildUpdateAll
}


function vis_reBuildBaseSetup {
    G_funcEntry
    function describeF {  cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    bystarAcctPathAnalyze $( pwd ) 

    opDo bystarPlone3Initial.sh -h -v -n showRun -p bystarUid=${bystarUid} -i linkToInitialContentTree

    opDo bystarPlone3Initial.sh -h -v -n showRun -p bystarUid=${bystarUid} -i baseAssembleContentTreeBody 
}


function vis_reBuildUpdateAll {
    G_funcEntry
    function describeF {  cat  << _EOF_
Update means, do to remote the latest local.
The order is important. We want to make sure that we get
the desired order in the left navigation.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    opDo vis_reBuildUpdateHomePlus

    opDo vis_reBuildUpdateCommonTop

    opDo vis_reBuildUpdateSiteSpecific

    opDo vis_reBuildUpdateCommonBottom
}

function vis_reBuildUpdateHomePlus {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
The order is important. We want to make sure that we get
the desired order in the left navigation.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    vis_inPloneBaseDirAccordinglyDo ${here}/galleria plone3Proc.sh -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo  ${here}/homeSlider  ./plone3Proc.sh -v -n showRun  -i reBuildFullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/Home plone3Proc.sh -v -n showRun  -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/mob plone3Proc.sh -v -n showRun  -i treeRecurse fullUpdate

    lpReturn
}


function vis_reBuildUpdateCommonAll {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
The order is important. We want to make sure that we get
the desired order in the left navigation.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_reBuildUpdateCommonTop

    opDo vis_reBuildUpdateCommonBottom

    lpReturn
}

function vis_reBuildUpdateCommonTop {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
The order is important. We want to make sure that we get
the desired order in the left navigation.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    # ./images.common
    vis_inPloneBaseDirAccordinglyDo ${here}/images plone3Proc.sh -i initialUpdateAll

    # ./contentImages
    vis_inPloneBaseDirAccordinglyDo ${here}/contentImages plone3Proc.sh -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/contact plone3Proc.sh -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/siteSearch plone3Proc.sh -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/bystarSearch plone3Proc.sh -i treeRecurse fullUpdate

    lpReturn
}

function vis_reBuildUpdateCommonBottom {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
The order is important. We want to make sure that we get
the desired order in the left navigation.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    # ./library.common
    vis_inPloneBaseDirAccordinglyDo ${here}/library plone3Proc.sh -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/pgp plone3Proc.sh -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/aboutThisWebsite plone3Proc.sh -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/help plone3Proc.sh -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/siteControl plone3Proc.sh -i treeRecurse fullUpdate

    lpReturn
}


function vis_reBuildUpdateSiteSpecific {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
The order is important. We want to make sure that we get
the desired order in the left navigation.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    vis_inPloneBaseDirAccordinglyDo ${here}/projects plone3Proc.sh -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/participate plone3Proc.sh -i treeRecurse fullUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/announcements plone3Proc.sh -i treeRecurse fullUpdate

    lpReturn
}



function vis_initialLibrary {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
1) Run ./lcntLists/plone3Proc.sh  -- 2) Run vis_lcntExcludeFromNav -- 3) Run ./library.Common/plone3Proc.sh
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    bystarAcctPathAnalyze ${here}

    vis_inPloneBaseDirAccordinglyDo ${here}/lcntLists plone3Proc.sh -i initialUpdateAll
    #opDo bystarLcntProc.sh -h -v -n showRun -p bystarUid=${bystarUid} -i plone3Upload PLPC-100101 PLPC-110001 PLPC-110020
 
    opDo bystarPlone3Initial.sh -h -v -n showRun -p bystarUid=${bystarUid} -i lcntExcludeFromNavExport

    vis_inPloneBaseDirAccordinglyDo ${here}/library plone3Proc.sh -i initialUpdateAll

    lpReturn
}


function vis_cleanForVcUpload {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo plone3Proc.sh.gened -i cleanForVcExport

    opDo plone3Proc.sh -v -n showRun  -i treeRecurse fullClean

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
