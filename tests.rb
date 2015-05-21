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

  def test_assignments_destroyed_when_course_is_destroyed#test not passing after adding test school has many courses through school terms!
    biology = Course.create(name: "Biology")

    assignment_one = Assignment.create(course_id: biology.id)
    assignment_two = Assignment.create(course_id: biology.id)

    biology.destroy
    assert_equal 0, Assignment.count
  end

  # def test_lessons_should_have_many_preclass_assignments
  #   atp = Lesson.create(name: "ATP")
  #
  #   assignment_one = Lesson.create(pre_class_assignment_id: atp.id)
  #   assignment_two = Lesson.create(pre_class_assignment_id: atp.id)
  #
  #   assert_equal 2, Lesson(:pre_class_assignment_id).count
  # end
  def test_school_has_many_course_through_school_terms
    school = School.create

    spring = Term.create(school_id: school.id)

    biology = Course.create(name: "Biology", term_id: spring.id)
    history = Course.create(name: "History", term_id: spring.id)

    assert_equal 2, school.courses.count
  end

  def test_validate_that_lessons_have_names

    assert_raises(ActiveRecord::RecordInvalid) do
      Lesson.create!(name: nil)
    end
  end

  def test_validate_readings

    reading_one = Reading.create(order_number: 3, lesson_id: 2, url: "http://reading_one.com")

    assert reading_one

    assert_raises(ActiveRecord::RecordInvalid) do
      reading_two = Reading.create!(order_number: 3, lesson_id: 2, url: nil)
    end
  end

  def test_validate_that_the_readings_url_must_start_with_http
    reading_one = Reading.create(order_number: 3, lesson_id: 2, url: "http://reading_one.com")
    reading_two = Reading.create(order_number: 3, lesson_id: 2, url: "https://reading_one.com")

    assert reading_one
    assert reading_two

    assert_raises(ActiveRecord::RecordInvalid) do
      reading_two = Reading.create!(order_number: 3, lesson_id: 2, url: "reading.com")
    end
  end

  # def test_courses_have_course_code_and_name
  #   biology = Course.create(name: "Biology", course_code: "bio101")
  #   history = Course.create(name: "History", course_code: "hist101")
  #
  #   assert biology
  #   assert history
  #
  #   assert_raises(ActiveRecord::RecordInvalid) do
  #     english = Course.create(name: nil, course_code: nil)
  #   end
  # end






























end
