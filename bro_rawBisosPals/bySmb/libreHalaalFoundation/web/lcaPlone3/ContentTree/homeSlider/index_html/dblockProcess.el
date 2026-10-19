(defun bx:dblock:process ()
  ""
  (goto-char (point-min))
  (replace-string  "@urlMobDest@"
		   (shell-command-to-string (concat "echo -n $( plone3Proc.sh -v -n showRun  -i bystarAcctPathInfo bystarSiteFqdn )" "/mob"))
		   )
  )
