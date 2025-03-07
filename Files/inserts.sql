-- Populate database
SET SQL_SAFE_UPDATES = 0;
USE HospitalManagementDB;

SET FOREIGN_KEY_CHECKS = 1;

INSERT IGNORE INTO `Account` (creation_date)
VALUES 
  ('2024-01-15'),
  ('2024-06-10'),
  ('2024-11-03');
  
SELECT * FROM `Account`;

INSERT IGNORE INTO `Certifications` (name, description)
VALUES 
  ('Registered Nurse (RN)', 'passed the national licensing examination.'),
  ('Critical Care Nurse (CCRN)', 'works in intensive care units (ICUs)'),
  ('Nurse Practitioner (CNP)', 'diagnose/treat patients in certain healthcare settings.');
  
SELECT * FROM `Certifications`;

INSERT IGNORE INTO `Nurse` (first_name, last_name, certs_id)
VALUES
('Emily', 'Smith', 2),
('John', 'Doe', 1),
('Sara', 'Johnson', 3);

SELECT * FROM `Nurse`;

INSERT IGNORE INTO `Department` (name, phone_number)
VALUES 
('Radiology', '555-0101'),
('Billing', '555-0102'),
('Information Technology', '555-0103'),
('Emergency', '555-0105');
  
SELECT * FROM `Department`;

INSERT IGNORE INTO `Rooms` (nurse_id, number, dept_id)
VALUES 
(2, 302, 3),
(3, 109, 4),
(1, 114, 1);

SELECT * FROM `Rooms`;

INSERT IGNORE INTO `Specialization` (name, description)
VALUES 
('Cardiology', 'diagnosing and treating diseases of the heart and blood vessels.'),
('Neurology', 'disorders of the nervous system, including the brain and spinal cord.'),
('Pediatrics', 'medical care to infants, children, and adolescents.');

SELECT * FROM `Specialization`;

INSERT IGNORE INTO `Doctor` (last_name, first_name, specialization_id)
VALUES 
  ('Sanna', 'Justin', 1),
  ('James', 'Nabeeha', 3),
  ('Quentin', 'Yara', 2),
  ('Charvi', 'Gian', 1);
  
SELECT * FROM `Doctor`;

INSERT IGNORE INTO `Payment` (full_name, card_number, account_id)
VALUES 
  ('Joey King', '12345678', 2),
  ('James Charles', '87654321', 3),
  ('Sabrina Carpenter', '54637281', 1);
  
SELECT * FROM `Payment`;

INSERT IGNORE INTO `Patient` (full_name, DOB, age, account_id, emergency_contact_id, medical_record_id, doctor_id, nurse_id)
VALUES 
  ('Joey King', '1997-09-23', '27', '2', '2', '3', '1', '2'),
  ('James Charles', '2004-06-13', '20', '1', '1', '2', '3', '2'),
  ('Sabrina Carpenter', '2014-02-18', '10', '3', '3', '1', '2', '1');
  
SELECT * FROM `Patient`;

INSERT IGNORE INTO `EmergencyContact` (patient_id, phone_number, relationship, full_name)
VALUES 
	(1, 1234567890, 'Spouse', 'John Doe'),
	(2, 9876543210, 'Parent', 'Jane Smith'),
	(3, 5551234567, 'Sibling', 'Alice Brown');

SELECT * FROM `EmergencyContact`;

INSERT INTO Medication (name, instructions)
VALUES
('Ibuprofen', 'Take 1 tablet every 6-8 hours with food'),
('Amoxicillin', 'Take 1 capsule every 12 hours for 7 days'),
('Cetirizine', 'Take 1 tablet daily for allergy relief');

SELECT * FROM `Medication`;

INSERT IGNORE INTO Appointments (patient_id, doctor_id, reason_for_visit, date_time)
VALUES
(1, 3, 'Amputations on all four limbs', '2024-12-05 10:00:00'),
(2, 2, 'Flu Symptoms', '2024-12-06 14:30:00'),
(3, 1, 'Heavily Constipated', '2024-12-07 09:15:00');

SELECT * FROM `Appointments`;

INSERT INTO Roles (role_name) 
VALUES 
('Patient'), 
('Doctor'), 
('Nurse');


INSERT IGNORE INTO Prescription (doctor_id, medication_id, patient_id, dosage)
VALUES
(2, 1, 1, '200mg twice daily for 5 days'),
(1, 2, 2, '500mg once daily for 7 days'),
(3, 3, 3, '10mg daily for 14 days');

SELECT * FROM `Prescription`;

INSERT IGNORE INTO Parent (patient_id, occupation, relationship_to_child)
VALUES
(1, 'Engineer', 'Mother'),
(2, 'Teacher', 'Father'),
(3, 'Lawyer', 'Mother');

SELECT * FROM `Parent`;

INSERT IGNORE INTO `Medical Records` (patient_id, doctor_id, date)
VALUES
(1, 3, '2024-12-01'),
(2, 2, '2024-12-03'),
(3, 1, '2024-12-04');

SELECT * FROM `Medical Records`;

INSERT IGNORE INTO Child (patient_id, parent_id, grade_level)
VALUES
(1, 2, 5),
(2, 1, 8),
(3, 3, 12);

SELECT * FROM `Child`;

INSERT IGNORE INTO Allergies (patient_id, severity, allergen)
VALUES
(1, 'Mild', 'Peanuts'),
(2, 'Severe', 'Bee Stings'),
(3, 'Moderate', 'Pollen');

SELECT * FROM `Allergies`;

INSERT IGNORE INTO `Lab Test` (patient_id, doctor_id, result, type)
VALUES
(1, 2, 'Low Iron', 'Blood Test'),
(2, 1, 'High Cholesterol', 'Cholesterol Test'),
(3, 2, 'Positive', 'Pregnancy Test');

SELECT * FROM `Lab Test`;

INSERT IGNORE INTO `Bill` (appt_id, payment_id, due_date)
VALUES
(1, 3, '2024-12-10'),
(2, 2, '2024-12-15'),
(3, 1, '2024-12-20');

SELECT * FROM `Bill`;

INSERT IGNORE INTO `Diagnosis` (`patient_id`, `doctor_id`, `name`)
VALUES 
  (1, 1, 'Flu'),
  (2, 2, 'Diabetes'),
  (3, 1, 'Asthma');

SELECT * FROM `Diagnosis`;






