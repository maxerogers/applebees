working_directory '/Users/maxrogers/Dev/applebees'

      pid '/Users/maxrogers/Dev/applebees/pids/unicorn.pid'

      stderr_path '/Users/maxrogers/Dev/applebees/logs/unicorn.log'
      stdout_path '/Users/maxrogers/Dev/applebees/logs/unicorn.log'

      listen '/tmp/unicorn.applebees.sock'

      # Number of processes
      # worker_processes 4
      worker_processes 1

      # Time-out
      timeout 30