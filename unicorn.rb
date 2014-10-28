working_directory '/var/www/applebees'

      pid '/var/www/applebees/pids/unicorn.pid'

      stderr_path '/var/www/applebees/logs/unicorn.log'
      stdout_path '/var/www/applebees/logs/unicorn.log'

      listen '/tmp/unicorn.applebees.sock'

      # Number of processes
      # worker_processes 4
      worker_processes 1

      # Time-out
      timeout 30