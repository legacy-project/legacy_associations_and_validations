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

def test_term_have_many_courses
  fall = Term.create
  spring = Term.create

  biology = Course.create(name: "Biology", term_id: fall.id)
  english = Course.create(name: "English", term_id: spring.id)

  assert_equal 1, fall.courses.count
  assert_equal 1, spring.courses.count
end

def test_term_with_courses_cannot_be_deleted
  spring = Term.create
  biology = Course.create(name: "Biology", term_id: spring.id)
  english = Course.create(name: "English", term_id: spring.id)
  math = Course.create(name: "Math", term_id: spring.id)

  refute spring.destroy
end

def test_course_has_many_course_students
  biology = Course.create(name: "Biology")

  jimmy = CourseStudent.create(course_id: biology.id)
  jill = CourseStudent.create(course_id: biology.id)
  whitney = CourseStudent.create(course_id: biology.id)

  assert_equal 3, biology.course_students.count
end

def test_course_with_many_students_should_not_be_deleted
  biology = Course.create(name: "Biology")

  jimmy = CourseStudent.create(course_id: biology.id)
  jill = CourseStudent.create(course_id: biology.id)
  whitney = CourseStudent.create(course_id: biology.id)

  refute biology.destroy
end

def test_course_has_many_assignments
  biology = Course.create(name: "Biology")

  assignment_one = Assignment.create(course_id: biology.id)
  assignment_two = Assignment.create(course_id: biology.id)

  assert_equal 2, Assignment.count
end

def test_assignments_destroyed_when_course_is_destroyed
  biology = Course.create(name: "Biology")

  assignment_one = Assignment.create(course_id: biology.id)
  assignment_two = Assignment.create(course_id: biology.id)

  biology.destroy
  assert_equal 0, Assignment.count
end








end
