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

#Silence those pesky migration messages
ActiveRecord::Migration.verbose = false

# Finally!  Let's test the thing.
class ApplicationTest < Minitest::Test

  # Gotta run migrations before we can run tests.  Down will fail the first time,
  # so we wrap it in a begin/rescue.
  def setup
    ApplicationMigration.migrate(:up)
  end

  def teardown
    ApplicationMigration.migrate(:down)
  end

  def test_truth
    assert true
  end

  def test_false
    refute false
  end

# <<<<<<< HEAD
  #Part A:

  def test_school_has_many_terms
    school = School.create(name: "string")
    summer = Term.create(name: "string", starts_on: 2013-04-12, ends_on: 2015-05-21, school_id: school.id)
    fall = Term.create(name: "string", starts_on: 2013-04-12, ends_on: 2015-05-21, school_id: school.id)
    spring = Term.create(name: "string", starts_on: 2013-04-12, ends_on: 2015-05-21, school_id: school.id)
    school.reload
    assert_equal 3, school.terms.count
  end

  def test_term_have_many_courses
    fall = Term.create(name: "string", starts_on: 2013-04-12, ends_on: 2015-05-21, school_id: 1)
    spring = Term.create(name: "string", starts_on: 2013-04-12, ends_on: 2015-05-21, school_id: 1)

    biology = Course.create(name: "Biology", term_id: fall.id)
    english = Course.create(name: "English", term_id: spring.id)

    assert_equal 1, fall.courses.count
    assert_equal 1, spring.courses.count
  end

  def test_term_with_courses_cannot_be_deleted
    spring = Term.create(name: "string", starts_on: 2013-04-12, ends_on: 2015-05-21, school_id: 1)
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

    assignment_one = Assignment.create(course_id: biology.id, name: "string", percent_of_grade: 11.11)
    assignment_two = Assignment.create(course_id: biology.id, name: "strong", percent_of_grade: 11.11)

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
    school = School.create(name: "name")

    spring = Term.create(name: "string", starts_on: 2013-04-12, ends_on: 2015-05-21, school_id: school.id)

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






























# =======
  def test_associate_lessons_with_readings
    # Associate lessons with readings (both directions).
    lesson = Lesson.create(name: "Addition")
    r1 = Reading.create(caption: "1", lesson_id: lesson.id)
    r2 = Reading.create(caption: "2", lesson_id: lesson.id)
    r3 = Reading.create(caption: "3", lesson_id: lesson.id)
    assert_equal lesson, r1.lesson
    assert_equal lesson, r2.lesson
    assert_equal lesson, r3.lesson
  end

  def test_lesson_destroyed_destroys_readings
    # When a lesson is destroyed, its readings should be automatically destroyed
    lesson = Lesson.create(name: "Addition")
    r1 = Reading.create(caption: "1", lesson_id: lesson.id, order_number: 3, url: "http://reading_one.com")
    r2 = Reading.create(caption: "1", lesson_id: lesson.id, order_number: 3, url: "http://reading_one.com")
    r3 = Reading.create(caption: "1", lesson_id: lesson.id, order_number: 3, url: "http://reading_one.com")
    assert_equal 1, Lesson.count
    assert_equal 3, Reading.count
    lesson.destroy
    assert_equal 0, Lesson.count
    assert_equal 0, Reading.count
  end

  def test_associate_lessons_with_courses_and_dependecy
    # Associate lessons with courses (both directions). When a course is destroyed, its lessons should be automatically destroyed.
    course = Course.create(name: "Mexican History")
    l1 = Lesson.create(course_id: course.id, name: "l1")
    l2 = Lesson.create(course_id: course.id, name: "l2")
    l3 = Lesson.create(course_id: course.id, name: "l3")
    assert_equal course, l1.course
    assert_equal course, l2.course
    assert_equal course, l3.course
    assert_equal 1, Course.count
    assert_equal 3, Lesson.count
    course.destroy
    assert_equal 0, Course.count
    assert_equal 0, Lesson.count
  end

  def test_associate_courses_with_course_instructors
    # Associate courses with course_instructors (both directions). If the course has any students associated with it, the course should not be deletable.
    biology = Course.create(name: "Biology")
    gym = Course.create(name: "Gym Class")

    student = CourseStudent.create(course_id: biology.id)

    instructor1 = CourseInstructor.create(course_id: biology.id)
    instructor2 = CourseInstructor.create(course_id: gym.id)

    assert_equal biology, instructor1.course
    assert_equal gym, instructor2.course
    assert gym.destroy
    refute biology.destroy
  end

  # def test_associate_lessons_with_their_in_class_assignments
  #   # Associate lessons with their in_class_assignments (both directions).
  #   assignment = Assignment.create(name: "Write your name.")
  #   lesson = Lesson.create(in_class_assignments_id: assignment.id)
  #
  # end

  def test_course_has_many_readings_through_course_lessons
    # Set up a Course to have many readings through the Course's lessons.
    biology = Course.create(name: "Integer Math")
    lesson = Lesson.create(name: "Addition", course_id: biology.id)
    r1 = Reading.create(caption: "1", lesson_id: lesson.id, order_number: 3, url: "http://reading_one.com")
    r2 = Reading.create(caption: "2", lesson_id: lesson.id, order_number: 3, url: "http://reading_one.com")
    r3 = Reading.create(caption: "3", lesson_id: lesson.id, order_number: 3, url: "http://reading_one.com")

    assert_equal [r1, r2, r3], biology.readings
    assert_equal biology, r1.course
    assert_equal biology, r2.course
    assert_equal biology, r3.course
  end

  def test_validate_that_schools_must_have_name
    school1 = School.new
    school2 = School.new(name: "TIYD")
    refute school1.save
    assert school2.save
  end

  def test_validate_that_terms_must_have_name_starts_on_ends_on_and_school_id
    # Validate that Terms must have name, starts_on, ends_on, and school_id.
    school = School.create(name: "TIYD")
    term1 = Term.new
    term2 = Term.new(name: "string",
        starts_on: 2013-04-12,
        ends_on: 2015-05-21,
        school_id: school.id
    )
    refute term1.save
    assert term2.save
  end

  def test_validate_that_the_user_has_a_first_name_a_last_name_and_an_email
    # Validate that the User has a first_name, a last_name, and an email.
    user1 = User.new
    user2 = User.new(first_name: "Big", last_name: "Bad", email: "Bob@example.com")
    refute user1.save
    assert user2.save!
  end

  def test_validate_that_the_users_email_is_unique_and_has_email_form
    user1 = User.new(first_name: "Big", last_name: "Bad", email: "Bob@example.com")
    user2 = User.new(first_name: "Big", last_name: "Bad", email: "Bob@example.com")
    assert user1.save
    refute user2.save
  end

  def test_validate_that_the_users_photo_url
    # Validate that the User's photo_url must start with http:// or https://. Use a regular expression
    user1 = User.new(first_name: "Big", last_name: "Bad", email: "Bob@example.com", photo_url: "http://facebook.org")
    user2 = User.new(first_name: "Big", last_name: "Bad", email: "Blob@yahoo.com", photo_url: "https://facebook.com")
    user3 = User.new(first_name: "Big", last_name: "Bad", email: "Blob@yahoo.com", photo_url: "htt://facebook.com")

    assert user1.save
    assert user2.save
    refute user3.save
  end

  def test_validate_that_assignments_have_a_course_id_name_and_percent_of_grade
    assignment1 = Assignment.new
    assignment2 = Assignment.new(course_id: 1, name: "string", percent_of_grade: 11.11)
    refute assignment1.save
    assert assignment2.save
  end

  def test_validate_that_the_assignment_name_is_unique_within_a_given_course_id
    assignment1 = Assignment.new(course_id: 1, name: "string", percent_of_grade: 11.11)
    assignment2 = Assignment.new(course_id: 1, name: "string", percent_of_grade: 11.11)
    assignment3 = Assignment.new(course_id: 2, name: "string", percent_of_grade: 11.11)
    assert assignment1.save
    refute assignment2.save
    assert assignment3.save
  end
# >>>>>>> cruz
end
