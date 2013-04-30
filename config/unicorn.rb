#unicorn.rb
worker_processes 3
timeout 30

@qc_pid = nil

before_fork do |server, worker|
  @qc_pid ||= spawn( "bundle exec rake qc:work" )
end