#!/bin/bash

IcmBriefDescription="NOTYET: Short Description Of The Module"

ORIGIN="
* Revision And Libre-Halaal CopyLeft -- Part Of ByStar -- Best Used With Blee
"

####+BEGIN: bx:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+brief"
typeset RcsId="$Id: usgSshAccess.sh,v 1.2 2017-04-09 23:21:06 lsipusr Exp $"
# *CopyLeft*
# Copyright (c) 2011 Neda Communications, Inc. -- http://www.neda.com
# See PLPC-120001 for restrictions.
# This is a Halaal Poly-Existential intended to remain perpetually Halaal.
####+END:

__author__="
* Authors: Mohsen BANAN, http://mohsen.banan.1.byname.net/contact
"

####+BEGIN: bx:bsip:bash:seed-spec :types "seedActions.bash"
SEED="
*  /[dblock]/ /Seed/ :: [[file:/bisos/core/bsip/bin/seedActions.bash]] | 
"
FILE="
*  /This File/ :: /bxo/iso/piu_mbBisosDev/sys/bin/usgBxoSshManage-niche.sh 
"
if [ "${loadFiles}" == "" ] ; then
    /bisos/core/bsip/bin/seedActions.bash -l $0 "$@" 
    exit $?
fi
####+END:

_CommentBegin_
####+BEGIN: bx:dblock:global:file-insert-cond :cond "./blee.el" :file "/libre/ByStar/InitialTemplates/software/plusOrg/dblock/inserts/topControls.org"
*      ================
*  /Controls/:  [[elisp:(org-cycle)][Fold]]  [[elisp:(show-all)][Show-All]]  [[elisp:(org-shifttab)][Overview]]  [[elisp:(progn (org-shifttab) (org-content))][Content]] | [[elisp:(bx:org:run-me)][RunMe]] | [[elisp:(delete-other-windows)][(1)]]  | [[elisp:(progn (save-buffer) (kill-buffer))][S&Q]]  [[elisp:(save-buffer)][Save]]  [[elisp:(kill-buffer)][Quit]] 
** /Version Control/:  [[elisp:(call-interactively (quote cvs-update))][cvs-update]]  [[elisp:(vc-update)][vc-update]] | [[elisp:(bx:org:agenda:this-file-otherWin)][Agenda-List]]  [[elisp:(bx:org:todo:this-file-otherWin)][ToDo-List]] 

####+END:
_CommentEnd_

_CommentBegin_
*      ================
*      ################ CONTENTS-LIST ################
*      ======[[elisp:(org-cycle)][Fold]]====== *[Current-Info:]*  Status, Notes (Tasks/Todo Lists, etc.)
_CommentEnd_

function vis_moduleDescription {  cat  << _EOF_
*      ======[[elisp:(org-cycle)][Fold]]====== *[Related/Xrefs:]*  <<Xref-Here->>  -- External Documents 
**      ====[[elisp:(org-cycle)][Fold]]==== [[file:/libre/ByStar/InitialTemplates/activeDocs/bxServices/versionControl/git/fullUsagePanel-en.org::Xref-VersionControlGit][Panel Roadmap Documentation]]
*      ======[[elisp:(org-cycle)][Fold]]====== *[Module Description:]*

_EOF_
}

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Prefaces (Imports/Libraries)
_CommentEnd_

. ${opBinBase}/opAcctLib.sh
. ${opBinBase}/opDoAtAsLib.sh
. ${opBinBase}/lpParams.libSh
. ${opBinBase}/lpReRunAs.libSh

. ${opBinBase}/unisosAccounts_lib.sh
. ${opBinBase}/bisosGroupAccount_lib.sh
. ${opBinBase}/bisosAccounts_lib.sh

. ${opBinBase}/bpo_lib.sh

. ${opBinBase}/bisosCurrents_lib.sh

. ${opBinBase}/niche_lib.sh


# PRE parameters

# G_IcmParams

sshKeyPath_github=$( FN_absolutePathGet "~piu_mbBisosDev/credentials/github.com/mohsenBanan/sshKeys/mb1_github" )
gitLabel_github=$( FN_nonDirsPart ${sshKeyPath_github} )
gitServer_github="github.com"

sshKeyPath_emacsconf=$( FN_absolutePathGet "~piu_mbBisosDev/credentials/emacsconf.org/anon/sshKeys/anon_emacsconf" )
sshConfLabel_emacsconf=$( FN_nonDirsPart ${sshKeyPath_emacsconf} )
sshServer_emacsconf="emacsconf.org"
sshUser_emacsconf="anon"
sshPort_emacsconf="22"

sshKeyPath_gitShLocal=$( FN_absolutePathGet "~/.ssh/id_rsa" )
gitLabel_gitShLocal="gitShLocal"
gitServer_gitShLocal="localhost "

function G_postParamHook {
    local siteGitServerInfoBaseDir=$( bisosSiteGitServer.sh -i gitServerInfoBaseDir )

    site_gitServerName=$( fileParamManage.py -i fileParamRead ${siteGitServerInfoBaseDir} gitServerName )    
    return 0
}

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Examples
_CommentEnd_


function vis_examples {
    typeset extraInfo="-h -v -n showRun"
    #typeset extraInfo="
    typeset runInfo="-p ri=lsipusr:passive"

    lpCurrentsGet
    
    #typeset examplesInfo="${extraInfo} ${runInfo}"
    typeset examplesInfo="${extraInfo}"

    local oneBxoId=${currentBxoId}
    #local oneGitBxSeLn="git.bysource.org"
    local oneGitBxSeLn="${site_gitServerName}"

    #local oneUsg=${currentUsgUname}
    local oneUsg=$(id -u -n)

    local oneBxosBase="/bisos/var/bxo/construct"

    local gitConfigBasePath=$( dirname ${sshKeyPath_github} )/gitConfig.fps

    local userEmail=$( fileParamManage.py -i fileParamRead ${gitConfigBasePath} userEmail )
    local userName=$( fileParamManage.py -i fileParamRead ${gitConfigBasePath} userName )
    

    visLibExamplesOutput ${G_myUnNicheName} 
  cat  << _EOF_
$( examplesSeperatorTopLabel "${G_myUnNicheName}" )
${G_myName} ${examplesInfo} -i bxoInit
${G_myName} ${examplesInfo} -i gitLabel
${G_myName} ${examplesInfo} -i sysSetup
$( examplesSeperatorSection "BxO Ssh Keys Full Actions" )
${G_myUnNicheName} ${examplesInfo} -p usg=${oneUsg} -i usgCustomFullUpdate ${gitLabel_gitShLocal} ${sshKeyPath_gitShLocal} ${gitServer_gitShLocal} gitSh 22
${G_myUnNicheName} ${examplesInfo} -p usg=${oneUsg} -i usgCustomFullDelete ${gitLabel_gitShLocal}
${G_myUnNicheName} ${examplesInfo} -p usg=${oneUsg} -i usgCustomFullUpdate ${gitLabel_github} ${sshKeyPath_github} ${gitServer_github}
${G_myUnNicheName} ${examplesInfo} -p usg=${oneUsg} -i usgCustomFullDelete ${gitLabel_github}
${G_myUnNicheName} ${examplesInfo} -p usg=${oneUsg} -i usgCustomFullUpdate ${sshConfLabel_emacsconf} ${sshKeyPath_emacsconf} ${sshServer_emacsconf} ${sshUser_emacsconf} ${sshPort_emacsconf}
${G_myUnNicheName} ${examplesInfo} -p usg=${oneUsg} -i usgCustomFullDelete ${sshConfLabel_emacsconf}
$( examplesSeperatorSection "USG Custom Ssh Invoker Keys Install" )
${G_myUnNicheName} ${examplesInfo} -p usg=${oneUsg} -i usgAcctCustomCredentialsUpdate ${gitLabel_github} ${sshKeyPath_github}
${G_myUnNicheName} ${examplesInfo} -p usg=${oneUsg} -i usgAcctCustomCredentialsDelete ${gitLabel_github}
$( examplesSeperatorSection "USG Ssh Custom Config Segment File Update" )
${G_myUnNicheName} -i customConfigSegStdout ${gitLabel_github} ${gitServer_github}
${G_myUnNicheName} ${extraInfo} -i customConfigSegStdout ${gitLabel_github} ${gitServer_github}  # Verbose
${G_myUnNicheName} ${extraInfo} -i customConfigSegFileName ${gitLabel_github} ${gitServer_github}
${G_myUnNicheName} ${extraInfo} -i customConfigSegUpdate ${gitLabel_github} ${gitServer_github}
${G_myUnNicheName} ${extraInfo} -i customConfigSegDelete ${gitLabel_github}
${G_myUnNicheName} ${extraInfo} -i customConfigSegExists ${gitLabel_github}
${G_myUnNicheName} ${extraInfo} -p usg=${oneUsg} -i usgAcctCustomGitInfoUpdate ${gitLabel_github} "${userName}" "${userEmail}"
$( examplesSeperatorChapter "This Niche Script" )
${G_myName}
${G_myFullName}
_EOF_
}

noArgsHook() {
  vis_examples
}

function vis_gitLabel {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]
    echo ${gitLabel}
}

function vis_sysSetup {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    typeset extraInfo="-h -v -n showRun"

    local currentUser=$(id -u -n)

    lpDo ${G_myUnNicheName} ${extraInfo} -p usg=${currentUser} -i usgCustomFullUpdate ${gitLabel} ${sshKeyPath} ${gitServer}

    local gitConfigBasePath=$( dirname ${sshKeyPath} )/gitConfig.fps

    local userEmail=$( fileParamManage.py -i fileParamRead ${gitConfigBasePath} userEmail )
    local userName=$( fileParamManage.py -i fileParamRead ${gitConfigBasePath} userName )

    lpDo ${G_myUnNicheName} ${extraInfo} -p usg=${currentUser} -i usgAcctCustomGitInfoUpdate "${gitLabel}" "${userName}" "${userEmail}"
    
    lpReturn
}



####+BEGIN: bx:dblock:bash:end-of-file :type "basic"
_CommentBegin_
*      ================ /[dblock] -- End-Of-File Controls/
_CommentEnd_
#+STARTUP: showall
#local variables:
#major-mode: sh-mode
#fill-column: 90
# end:
####+END:
