(defun bx:dblock:process ()
  ""
  (goto-char (point-min))
  (replace-string  "@urlMobDest@"
		   (shell-command-to-string (concat "echo -n $( seedPlone3NewProc.sh -v -n showRun  -i bystarAcctPathInfo bystarSiteFqdn )" "/mob"))
		   )
  )
