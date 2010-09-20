stdout_orig, stderr_orig = STDOUT.dup, STDERR.dup

      STDOUT.reopen(cl)
      STDERR.reopen(cl)
      duby.compile(*args) 
      STDOUT.flush               
      STDOUT.reopen(stdout_orig) 
      STDERR.flush              
      STDERR.reopen(stderr_orig)

