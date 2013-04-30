namespace :db do
  namespace :fixtures do
    desc 'Create YAML test fixtures from data in an existing database.
    Defaults to development database.  Set RAILS_ENV to override.'
    task :dump => :environment do
      sql = "SELECT * FROM %s"
      skip_tables = ["schema_info"]
      ActiveRecord::Base.establish_connection(Rails.env)
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        puts table_name
        i = "000"
        dir = "db/fixtures/development"
        filename = dir + "/" + table_name + ".yml"
        File.open(filename, 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml
        end
      end
    end
  end
end