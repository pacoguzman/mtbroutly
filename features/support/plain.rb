require 'database_cleaner'

# truncate your tables here if you are using the same database as selenium, since selenium doesn't use transactional fixtures
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean
