namespace :db do
  desc "Resets the database and loads it from db/dev_seeds.rb"
  task dev_seed: :environment do
    load(Rails.root.join("db", "dev_seeds.rb"))
  end
desc "Resets the database and loads it from db/sabarca.rb"
  task sabarca: :environment do
    load(Rails.root.join("db", "sabarca.rb"))
  end

end
