#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"
# {{{ DBLOCK-top-of-file
typeset RcsId="$Id: plone3Proc.sh,v 1.4 2013/04/10 06:07:21 lsipusr Exp $"
#  This is a Halaal Poly-Existential. See http://www.freeprotocols.org
# }}} DBLOCK-top-of-file
####+END:

####+BEGIN: bx:dblock:lsip:bash:seed-spec :types "seedPlone3NewStyles.sh"
# {{{ DBLOCK-seed-spec
if [ "${loadFiles}X" == "X" ] ; then
    /opt/public/osmt/bin/seedPlone3NewStyles.sh -l $0 "$@"
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
    bystarAcctPathAnalyze $( pwd )    # Setsup bystarUid, bystarUidHome ...
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i reBuildFullUpdate   # initialBaseSetup + initialUpdateAll
${G_myName} ${extraInfo} -i reBuildBaseSetup    # Make the symlinks and baseAssembles for .gened
${G_myName} ${extraInfo} -i reBuildUpdateAll    # Generate the ploneSite from scratch
---
${G_myName} ${extraInfo} -i reBuildIdempotents
${G_myName} ${extraInfo} -i topUpdate
${G_myName} ${extraInfo} -i bottomUpdate
${G_myName} ${extraInfo} -i navigationUpdate
${G_myName} ${extraInfo} -i bodyAdjustUpdate
${G_myName} ${extraInfo} -i siteAdjustUpdate
${G_myName} ${extraInfo} -i cssUpdate
${G_myName} ${extraInfo} -i tabsTopSetup        # Non-Idempotent
${G_myName} ${extraInfo} -i siteSpecificUpdate
--- Clean For VC Upload (export, update) ---
${G_myName} ${extraInfo} -i cleanForVcUpload    # Delete symlinks and remove .gened
--- Version Control ---
${G_myName} ${extraInfo} -i vcUpdate
---- Example Over Write Of .common  ----
cp -r -H footer.common footer
deCvs footer
---- Initial Templates Development ----
diff ./plone3Proc.sh /libre/ByStar/InitialTemplates/lcaPlone/InitialSiteStyle/Base/Poly/DEFAULT/plone3Proc.sh.start
cp ./plone3Proc.sh /libre/ByStar/InitialTemplates/lcaPlone/InitialSiteStyle/Base/Poly/DEFAULT/plone3Proc.sh.start
cp /libre/ByStar/InitialTemplates/lcaPlone/InitialSiteStyle/Base/Poly/DEFAULT/plone3Proc.sh.start ./plone3Proc.sh
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

    opDo bystarPlone3Initial.sh -h -v -n showRun -p bystarUid=${bystarUid} -i linkToInitialSiteStyle

    opDo bystarPlone3Initial.sh -h -v -n showRun -p bystarUid=${bystarUid} -i baseAssembleSiteStyleBody
}


function vis_reBuildUpdateAll {
    G_funcEntry
    function describeF {  cat  << _EOF_
Update means, do to remote the latest local.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    opDo vis_cssUpdate
    opDo vis_topUpdate
    opDo vis_bottomUpdate
    opDo vis_tabsTopSetup        # Non-Idempotent
    opDo vis_navigationUpdate
    opDo vis_bodyAdjustUpdate
    opDo vis_siteAdjustUpdate

    opDo vis_siteSpecificUpdate  # logoText ...
}


function vis_reBuildIdempotents {
    G_funcEntry
    function describeF {  cat  << _EOF_
Update means, do to remote the latest local.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    opDo vis_cssUpdate
    opDo vis_topUpdate
    opDo vis_bottomUpdate
    opDo vis_navigationUpdate
    opDo vis_bodyAdjustUpdate
    opDo vis_siteAdjustUpdate

    opDo vis_siteSpecificUpdate  # logoText ...
}


function vis_topUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
Update means, do to remote the latest local.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    # ./personal_bar.common
    vis_inPloneBaseDirAccordinglyDo ${here}/personal_bar plone3Proc.sh -i objectUpdate

    # Removes the top actions links from the banner area
    vis_inPloneBaseDirAccordinglyDo ${here}/site_actions plone3Proc.sh -i objectUpdate

    # Remove the SearchBox from the banner area
    vis_inPloneBaseDirAccordinglyDo ${here}/searchbox plone3Proc.sh -i objectUpdate
}

function vis_bottomUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
Update means, do to remote the latest local.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    vis_inPloneBaseDirAccordinglyDo ${here}/footer plone3Proc.sh -i objectUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/colophon plone3Proc.sh -i objectUpdate
}

function vis_navigationUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
Update means, do to remote the latest local.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    vis_inPloneBaseDirAccordinglyDo ${here}/navigationLeftPortlet plone3Proc.sh -i objectUpdate

    # Get rid of Navigation icon in Navigation Box
    vis_inPloneBaseDirAccordinglyDo ${here}/navTreeIcons plone3Proc.sh -i objectUpdate
}

function vis_bodyAdjustUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
Update means, do to remote the latest local.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    # Get Rid of comments boxes at bottom of pages
    vis_inPloneBaseDirAccordinglyDo ${here}/comments plone3Proc.sh -i objectUpdate
}

function vis_siteAdjustUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
Update means, do to remote the latest local.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    vis_inPloneBaseDirAccordinglyDo ${here}/portletsLeftLoginDelete plone3Proc.sh -i objectUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/portletsRightCalendarDelete plone3Proc.sh -i objectUpdate

    # General Retracts -- /Members /news /events
    vis_inPloneBaseDirAccordinglyDo ${here}/adjustments plone3Proc.sh -i objectUpdate

    # Setup Mailhost
    vis_inPloneBaseDirAccordinglyDo ${here}/mailhost plone3Proc.sh -i objectUpdate

    # Setup favicon -- Favorites icon
    vis_inPloneBaseDirAccordinglyDo ${here}/favicon plone3Proc.sh -i objectUpdate

    # Relax Security Filters
    vis_inPloneBaseDirAccordinglyDo ${here}/controlPanel_filter plone3Proc.sh -i objectUpdate

    # Relax Security Filters -- Disable All Transforms -- For JavaScript
    vis_inPloneBaseDirAccordinglyDo ${here}/disableTransform plone3Proc.sh -i objectUpdate
}

function vis_cssUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
Update means, do to remote the latest local.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    # CSS Selections
    vis_inPloneBaseDirAccordinglyDo ${here}/css.common/ByStarSideNavCol3 plone3Proc.sh -i objectUpdate
}

function vis_siteSpecificUpdate {
    G_funcEntry
    function describeF {  cat  << _EOF_
Update means, do to remote the latest local.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    ###########  Custom Initial Generations ##########

    # Setup Banner/Logo
    vis_inPloneBaseDirAccordinglyDo ${here}/logoText plone3Proc.sh -i initialUpdateAll
}

function vis_tabsTopSetup {
    G_funcEntry
    function describeF {  cat  << _EOF_
Note Well: This is not tabsTopUpdate -- It can not be safely re-run.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset here=$( pwd )

    # TabsTopDisable
    vis_inPloneBaseDirAccordinglyDo ${here}/tabsTopDisable plone3Proc.sh -i objectUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/tabsTopSiteSearch plone3Proc.sh -i objectUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/tabsTopSiteMap plone3Proc.sh -i objectUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/tabsTopByStarSearch plone3Proc.sh -i objectUpdate

    # Accessibility NOTYET Spelling Error
    vis_inPloneBaseDirAccordinglyDo ${here}/tabsTopAccessability plone3Proc.sh -i objectUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/tabsTopHelp plone3Proc.sh -i objectUpdate

    vis_inPloneBaseDirAccordinglyDo ${here}/tabsTopContact plone3Proc.sh -i objectUpdate

    #vis_inPloneBaseDirAccordinglyDo ${here}/tabsTopLogin plone3Proc.sh -i objectUpdate
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
