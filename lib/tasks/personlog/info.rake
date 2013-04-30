namespace :personlog do
  namespace :env do
    desc "PERSONLOG | Show information about PersonLog and its environment"
    task info: :environment  do
      # check if there is an RVM environment
      rvm_version = run_and_match("rvm --version", /[\d\.]+/).try(:to_s)
      # check Ruby version
      ruby_version = run_and_match("ruby --version", /[\d\.p]+/).try(:to_s)
      # check Gem version
      gem_version = run("gem --version")
      # check Bundler version
      bunder_version = run_and_match("bundle --version", /[\d\.]+/).try(:to_s)
      # check Bundler version
      rake_version = run_and_match("rake --version", /[\d\.]+/).try(:to_s)

      puts ""
      puts "System information".yellow
      puts "Current User:\t#{`whoami`}"
      puts "Using RVM:\t#{rvm_version.present? ? "yes".green : "no"}"
      puts "RVM Version:\t#{rvm_version}" if rvm_version.present?
      puts "Ruby Version:\t#{ruby_version || "unknown".red}"
      puts "Gem Version:\t#{gem_version || "unknown".red}"
      puts "Bundler Version:#{bunder_version || "unknown".red}"
      puts "Rake Version:\t#{rake_version || "unknown".red}"


      # check database adapter
      database_adapter = ActiveRecord::Base.connection.adapter_name.downcase

      puts ""
      puts "PersonLog information".yellow
      puts "Directory:\t#{Rails.root}"
      puts "DB Adapter:\t#{database_adapter}"
    end
  end
end
