--Create Tables
CREATE TABLE students (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  goverment_code VARCHAR(30),
  gender VARCHAR(1),
  birth_date TIMESTAMP,
  class_id INT,

  CONSTRAINT fk_class_id
    FOREIGN KEY (class_id) REFERENCES classes(id)
);

CREATE TABLE teacher(
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  goverment_code VARCHAR(30),
  gender VARCHAR(1),
  birth_date TIMESTAMP
);

CREATE TABLE classes (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  location VARCHAR(100),
  teacher_id INT,

  CONSTRAINT fk_teacher_id
    FOREIGN KEY (teacher_id) REFERENCES teacher(id)
);

CREATE TABLE subjects (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  description VARCHAR(255),
  teacher_id INT,

  CONSTRAINT fk_subject_teacher
    FOREIGN KEY (teacher_id) REFERENCES teacher(id)
);

CREATE TABLE grades (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_id INT UNSIGNED,
  subject_id INT UNSIGNED,
  grade DECIMAL(5,2),
  grade_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_grade_student
    FOREIGN KEY (student_id) REFERENCES students(id),

  CONSTRAINT fk_grade_subject
    FOREIGN KEY (subject_id) REFERENCES subjects(id)
);

--Inserts

INSERT INTO teacher
  (name, goverment_code, gender, birth_date)
VALUES
  ('Ana Silva', 'T1001', 'F', '1985-04-12 00:00:00'),
  ('Carlos Santos', 'T1002', 'M', '1978-09-23 00:00:00'),
  ('Mariana Costa', 'T1003', 'F', '1990-01-15 00:00:00');

INSERT INTO classes (name, location, teacher_id)
VALUES
  ('Class 10A', 'Room 101', 1),
  ('Class 10B', 'Room 102', 2),
  ('Class 11A', 'Room 201', 3);

INSERT INTO students
  (name, goverment_code, gender, birth_date, class_id)
VALUES
  ('Lucas Oliveira', 'S2001', 'M', '2009-03-10 00:00:00', 1),
  ('Beatriz Almeida', 'S2002', 'F', '2008-07-22 00:00:00', 2),
  ('Pedro Ferreira', 'S2003', 'M', '2009-11-05 00:00:00', 3);

INSERT INTO subjects (name, description, teacher_id)
VALUES
  ('Mathematics', 'Algebra, geometry, and arithmetic', 1),
  ('English', 'English grammar and literature', 2),
  ('Science', 'Biology, physics, and chemistry', 3);

INSERT INTO grades (student_id, subject_id, grade)
VALUES
  (1, 1, 8.50),
  (2, 2, 9.00),
  (3, 3, 7.75);
