# Basic test requires
require 'minitest/autorun'
require 'minitest/pride'

# Include both the migration and the app itself
require './migration'
require './application'

# Overwrite the development database connection with a test connection.
ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'test.sqlite3'
)

# Gotta run migrations before we can run tests.  Down will fail the first time,
# so we wrap it in a begin/rescue.
begin ApplicationMigration.migrate(:down); rescue; end
ApplicationMigration.migrate(:up)


# Finally!  Let's test the thing.
class ApplicationTest < Minitest::Test

  def test_truth
    assert true
  end

  def test_false
    refute false
  end

#Part A:

def test_school_has_many_terms
  school = School.create
  summer = Term.create
  fall = Term.create
  spring = Term.create

  summer.update(school_id: school.id)
  fall.update(school_id: school.id)
  spring.update(school_id: school.id)

  assert_equal 3, school.terms.count
end

def test_terms_have_many_courses
  




end
