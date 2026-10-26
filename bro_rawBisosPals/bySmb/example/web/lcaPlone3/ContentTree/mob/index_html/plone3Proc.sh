#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"
# {{{ DBLOCK-top-of-file
typeset RcsId="$Id: plone3Proc.sh,v 1.1 2013/05/04 01:28:28 lsipusr Exp $"
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

upStreamBase="/libre/ByStar/InitialTemplates/lcaPlone/NewInitialContentTree/mob.gened/Poly/DEFAULT/index_html"

function examplesHookPost {
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i initialUpdateAll   # = objectGenerate + objectUpdate
${G_myName} ${extraInfo} -i cleanForVcUpload
--- Object Generate/Update ---
${G_myName} ${extraInfo} -i objectGenerate
${G_myName} ${extraInfo} -i objectUpdate
--- Misc / Development ---
${G_myName} ${extraInfo} -i runFunc fullUpdateHookPre
${G_myName} ${extraInfo} -i page_method_prep_basic
${G_myName} ${extraInfo} -i bystarInitialSpecific pageContentStdout
--- Upstream Development Feeds ---
${G_myName} ${extraInfo} -i upstreamPullFrom
${G_myName} ${extraInfo} -i upstreamDevCopyTo
${G_myName} ${extraInfo} -i upstreamDevVcUpdate
pushd "${upStreamBase}"
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
    opDo cp -r "${upStreamBase}"/* .

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
    opDo cp -r ./* "${upStreamBase}"

    lpReturn
}

function vis_upstreamDevVcUpdate {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Makes a proper/customized copy from current directory to upStreamBase.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    echo "${upStreamBase}"
    echo "NOTYET"

    lpReturn
}

function vis_cleanForVcUpload {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo FN_fileRmIfThere content.html pageTitle content.html.[0-9]* pageTitle.[0-9]*

    lpReturn
}



function vis_initialUpdateAll {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo vis_objectGenerate
    opDo vis_objectUpdate
}


function vis_objectGenerate {
    opDo vis_page_method_prep_basic
}

function fullUpdateHookPre {
    opDo vis_page_method_prep_basic
}

function vis_bystarInitialSpecific {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    bystarAcctPathAnalyze $( pwd )

    bystarServiceSupportHookRun bystarInitialSpecific "$1"

    lpReturn
}


vis_page_method_prep_basic () {
    bystarAcctPathAnalyze `pwd`

    typeset here=$( pwd )
  
    opDo FN_fileSafeKeep ${here}/pageTitle 
    bystarServiceSupportHookRun bystarInitialSpecific pageTitleStdout > ${here}/pageTitle 

    opDo ls -l ${here}/pageTitle 

    opDo FN_fileSafeKeep ${here}/content.html
    opDo cp ../../Home/index_html/content.html ./content.html

    opDo ls -l ${here}/content.html
}



todayString=$( date +'%B %d, %G at %X %Z ' )

bystarInitialSpecific_BYSMB_TRIAL () {
  bystarInitialSpecific_BYSMB_COMMITTED  $@
}

bystarInitialSpecific_BYSMB_COMMITTED () {

    pageTitleStdout () {
      opDoExit cat <<  _EOF_
${cp_acctMainBaseDomain}
_EOF_
    }

    pageContentStdout () {


	pageContentHeadStdout
	cat ./plone3WelcomeSegment.html
	pageContentTailStdout
    }

    function pageContentHeadStdout {
	G_funcEntry
	function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
	}
	EH_assert [[ $# -eq 0 ]]

	opDoExit cat <<  _EOF_
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META NAME="generator" CONTENT="HTML::TextToHTML v2.23">
</HEAD>
<BODY>
<P>Welcome to the BySmb web site of ${cp_acctMainBaseDomain}.

<P>This website belongs to ${cp_acctMainBaseDomain}.
It was created on ${todayString} and for the moment is rather minimalist.

<h2>This Page Is Under Construction - Coming Soon!</h2>

<P>It awaits its owner, to configure it.

<P>For now, you can:

<UL>
  <LI>Reach ${cp_acctMainBaseDomain} through the contact facility

  <LI>You can read the documents as they are added

  <LI>You can get the site's public key.

</UL>

<p>This web site is an autonomous service of the libre by* digital ecosystem.</p>

<p>The following information assists the web site's owner to get started on
developing this web site.</p>


<h2>About Plone -- ByStar's Web Services Platform</h2>

<p>ByStar uses the Plone Content Management System as its web services platform.

<p>You can customize this frontpage by clicking the edit tab on this document if you
have the correct permissions. Create folders and put content in those folders.
Folders will show up in the navigation box if they are published. It's a very
simple and powerful system.</p>

<p>For more information:</p>
<p><a href="http://www.plone.org">Plone website</a></p>
<p><a href="http://www.zope.org">Zope community</a></p>
<p><a href="http://cmf.zope.org">CMF website</a></p>
<p>There are <a href="http://plone.org/development/lists">mailing lists</a> and
<a href="http://www.zopelabs.com">recipe websites</a>
available to provide assistance to you and your new-found Content Management System.
<a href="http://plone.org/development/chat">Online chat</a> is also a nice way
of getting advice and help.</p>

<p>Please contribute your experiences at the <a href="http://www.plone.org">Plone website</a></p>
<p>Thanks for using our product.</p>
<p><a href="http://plone.org/about/team">The Plone Team</a></p>
_EOF_
    } 

    function pageContentTailStdout {
	G_funcEntry
	function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
	}
	EH_assert [[ $# -eq 0 ]]

	opDoExit cat <<  _EOF_

</BODY>
</HTML>
_EOF_
    } 


    $1
}


bystarInitialSpecific_BCA_COMMITTED () {
    ANT_raw "bystarInitialSpecific_BCA_COMMITTED"

    $1
}

bystarInitialSpecific_BYALIAS_COMMITTED () {
    bannerGenLatex () {
      opDoExit cat <<  _EOF_


_EOF_
}
 
    $1
}


bystarInitialSpecific_BYNAME_COMMITTED () {
  ANT_raw "bystarInitialSpecific_BYNAME_COMMITTED"
 
    $1
}

bystarInitialSpecific_BYNAME_TRIAL () {

    pageTitleStdout () {
      opDoExit cat <<  _EOF_
${cp_acctFactoryBaseDomain}
_EOF_
    }

    pageContentStdout () {
      opDoExit cat <<  _EOF_
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
<META NAME="generator" CONTENT="HTML::TextToHTML v2.23">
</HEAD>
<BODY>
<P>Welcome to ${cp_FirstName} ${cp_LastName}'s ByName Trial website.

<P>This website is brand new as of ${todayString} and for the moment is rather minimalist.

<P>It awaits its owner, to configure it.


<P>For now, you can:

<UL>
  <LI>Reach Me through the contact facility

  <LI>See my photos as I update the Gallery

  <LI>Read the documents as I put them in the Library

  <LI>You can get my public key ...

</UL>

<P>ByName is part of a bigger picture.

<h2>Getting Started With Plone</h2>

<p>This welcome page is used to introduce you to the Plone Content Management System.

<p>You can customize this frontpage by clicking the edit tab on this document if you
have the correct permissions. Create folders and put content in those folders.
Folders will show up in the navigation box if they are published. It's a very
simple and powerful system.</p>

<p>For more information:</p>
<p><a href="http://www.plone.org">Plone website</a></p>
<p><a href="http://www.zope.org">Zope community</a></p>
<p><a href="http://cmf.zope.org">CMF website</a></p>
<p>There are <a href="http://plone.org/development/lists">mailing lists</a> and
<a href="http://www.zopelabs.com">recipe websites</a>
available to provide assistance to you and your new-found Content Management System.
<a href="http://plone.org/development/chat">Online chat</a> is also a nice way
of getting advice and help.</p>

<p>Please contribute your experiences at the <a href="http://www.plone.org">Plone website</a></p>
<p>Thanks for using our product.</p>
<p><a href="http://plone.org/about/team">The Plone Team</a></p>


</BODY>
</HTML>
_EOF_
   } 

    $1
}

bystarInitialSpecific_BYMEMORY_COMMITTED () {

    bannerGenLatex () {
      opDoExit cat <<  _EOF_

_EOF_
    }

    $1
}

bystarInitialSpecific_BYMEMORY_TRIAL () {
    ANT_raw "bystarInitialSpecific_BYNAME_TRIAL"
}


bystarInitialSpecific_DEFAULT_DEFAULT () {
   ANT_raw "${bystarServiceType}_${bystarServiceSupportType}"
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
