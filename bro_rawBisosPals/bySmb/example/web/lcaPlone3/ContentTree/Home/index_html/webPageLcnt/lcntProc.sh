#!/bin/bash

####+BEGIN: bx:dblock:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+minimal"
# {{{ DBLOCK-top-of-file
typeset RcsId="$Id: lcntProc.sh,v 1.1 2013/05/04 01:20:15 lsipusr Exp $"
#  This is a Halaal Poly-Existential. See http://www.freeprotocols.org
# }}} DBLOCK-top-of-file
####+END:

####+BEGIN: bx:dblock:lsip:bash:seed-spec :types "seedLcntProc.sh"
# {{{ DBLOCK-seed-spec
if [ "${loadFiles}X" == "X" ] ; then
    /opt/public/osmt/bin/seedLcntProc.sh -l $0 "$@" 
    exit $?
fi
# }}} DBLOCK-seed-spec
####+END:


function buildPre {
  #if [[ ! -d tables ]] ; then ln -s ../Q1-2007-BusPlan/tables tables; fi
  #lcntSourceTypeBaseDir="${lcntBaseDir}${lcntAttrGenPub}/${lcntAttrSource}/${lcntAttrPermanence}"
  #if [[ ! -d figures ]] ; then ln -s ${lcntSourceTypeBaseDir}/common/figures figures; fi
    opDo eval echo "\\\\begin{rawhtml}" \> ./galleriaJasonData.tex
    opDo eval "cat ../../../homeSlider/index_html/galleriaJasonData.html  >>  ./galleriaJasonData.tex"
    opDo eval echo "\\\\end{rawhtml}" \>\> ./galleriaJasonData.tex

    opDo bx-dblock -i dblockUpdateFiles ./headSectionInsert.html 
    opDo bx-dblock -i dblockUpdateFiles ./webpage.ttytex

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
# {{{ DBLOCK-end-of-file
#local variables:
#major-mode: shellscript-mode
#fill-column: 90
# end:
# }}} DBLOCK-end-of-file
####+END:

