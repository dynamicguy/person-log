namespace :personlog do
  namespace :app do
    desc "PERSONLOG | Setup production application"
    task :setup => [
      'db:setup',
      'db:seed_fu',
      'personlog:enable_automerge'
    ]
  end
end
