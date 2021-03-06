require "colorize"

class Db::Migrate::One < LuckyCli::Task
  summary "Run the next pending migration"

  def call
    LuckyRecord::Migrator.run do
      LuckyRecord::Migrator::Runner.new.run_next_migration
    end
  end
end
