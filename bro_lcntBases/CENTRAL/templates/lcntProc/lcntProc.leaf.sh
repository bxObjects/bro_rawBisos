#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"
####+END:

####+BEGIN: bx:dblock:lsip:bash:seed-spec :types "seedLcntProc.sh"
####+END:


function buildPre {
  #if [[ ! -d tables ]] ; then ln -s ../Q1-2007-BusPlan/tables tables; fi
  lcntSourceTypeBaseDir="${lcntBaseDir}${lcntAttrGenPub}/${lcntAttrSource}/${lcntAttrPermanence}"
  if [[ ! -d figures ]] ; then ln -s ${lcntSourceTypeBaseDir}/common/figures figures; fi
  return
}

function buildPost {
  #if [[ -L tables ]] ; then /bin/rm tables; fi
  return
}


function cleanPost {
  #if [[ -L tables ]] ; then /bin/rm tables; fi
  #if [[ -L figures ]] ; then /bin/rm figures; fi
  return
}

function examplesHookPost {
 return
}


####+BEGIN: bx:dblock:bash:end-of-file :types ""
####+END:

