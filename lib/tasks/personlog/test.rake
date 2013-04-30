namespace :personlog do
  desc "PERSONLOG | Run both spinach and rspec"
  task :test => ['cucumber', 'spec']
end
