#!/bin/osmtKsh

typeset RcsId="$Id: ploneProc.sh,v 1.1.1.1 2013/04/08 16:43:38 lsipusr Exp $"


if [ "${loadFiles}X" == "X" ] ; then
  seedPloneProc.sh -l $0 "$@"
  exit $?
fi


sitePages="
"


siteFolders="
"


#
#
#

function examplesHookPost {
cat  << _EOF_
--- EXTRAs ---
${G_myName} ${extraInfo} -i runFunc fullUpdateHookPre
${G_myName} ${extraInfo} -i bystarInitialPrep
_EOF_
 return
}

fullUpdateHookPre () {
    vis_bystarInitialPrep
}



vis_bystarInitialPrep () {
    bystarAcctPathAnalyze `pwd`

    typeset here=$( pwd )
  
    bystarServiceSupportHookRun bystarInitialSpecific pageTitleStdout > ${here}/index_html/pageTitle 

    bystarServiceSupportHookRun bystarInitialSpecific pageContentStdout > ${here}/index_html/content
}


todayString=$( date +'%B %d, %G at %X %Z ' )

bystarInitialSpecific_BYSMB_COMMITED () {
    $1
}


bystarInitialSpecific_BCA_COMMITED () {
    ANT_raw "bystarInitialSpecific_BCA_COMMITED"

    $1
}

bystarInitialSpecific_BYALIAS_COMMITED () {
    bannerGenLatex () {
      opDoExit cat <<  _EOF_


_EOF_
}
 
    $1
}


bystarInitialSpecific_BYNAME_COMMITED () {
  ANT_raw "bystarInitialSpecific_BYNAME_COMMITED"
 
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

bystarInitialSpecific_BYMEMORY_COMMITED () {

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

