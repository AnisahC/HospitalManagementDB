-- The following document proposes bussiness requirements for the HospitalManagementDB database
USE HospitalManagementDB;

/* 

Purpose:	 Ensure the hospital can effectively manage patient visits from an appointment sytem.

Problem:     The appointments should only be scheduled during hospital hours.

Challenge:   Make sure appointments are not scheduled outside of working hours, and manage growing 
			 number of requests as the table expands.

Assumptions: Hospital working hours are from 6AM to 6PM. Appointment involve a patient and a doctor.

Implementation Plan:
1. Create a procedure to schedule an appointment
2. Get the hour of the appointment
3. Check if it's within working hours
4. Insert into appointment table if applicable

*/

DELIMITER $$

DROP PROCEDURE IF EXISTS ScheduleAppointment;

CREATE PROCEDURE ScheduleAppointment(IN p_patient_id INT, IN p_doctor_id INT, IN p_reason_for_visit VARCHAR(255), IN p_appointment_date DATETIME)
BEGIN
    DECLARE appt_hour INT;
    
    -- Get the hour of the appointment
    SET appt_hour = HOUR(p_appointment_date);

    -- Check if appointment time is within hospital working hours
    IF appt_hour < 6 OR appt_hour > 18 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Appointment time is outside of working hours (6 AM - 6 PM).';
    ELSE
        -- Insert the appointment
		INSERT INTO Appointments (patient_id, doctor_id, reason_for_visit, date_time)
        VALUES (p_patient_id, p_doctor_id, p_reason_for_visit, p_appointment_date);
    END IF;
END$$
DELIMITER ;
CALL ScheduleAppointment(1, 1, 'Routine Checkup', '2024-12-08 10:30:00');

/* 

Purpose:	 To enable parents or guardians to manage appointments, view medical records,
             and handle billing for their dependent children.

Problem:     The parent-child relationships must be tracked. Parents should only have access
             to their children's information, not unrelated patients.

Challenge:   Ensuring data integrity by validating parent-child relationships before allowing 
			 access to sensitive information. Prevent unauthorized access.

Implementation Plan:
1. Validate Parent-Child relationship
2. Update appointment procedure to allow for appointment scheduling

*/

DELIMITER $$

DROP PROCEDURE IF EXISTS ValidateParentChild;

CREATE PROCEDURE ValidateParentChild(
    IN p_parent_id INT,
    IN p_child_id INT
)
BEGIN
    DECLARE does_exist INT;

    SELECT COUNT(*) INTO does_exist
    FROM Parent
    WHERE parent_id = p_parent_id AND child_id = p_child_id;

    IF does_exist = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid parent-child relationship.';
    END IF;
END$$

CREATE PROCEDURE ScheduleChildAppointment(
    IN p_parent_id INT,
    IN p_child_id INT,
    IN p_datetime DATETIME,
    IN p_reason VARCHAR(255)
)

CALL ScheduleChildAppointment(1, 2, '2024-12-10 14:30:00', 'Routine Checkup');


/* 

Purpose:	 To ensure that each room in the hospital has an assigned nurse who is responsible
			 for patient care in that room.

Problem:     Rooms need to have a designated nurse assigned to for streamlined patient care. 
             The system must allow assigning a nurse to a specific room, ensuring no room is 
             left without coverage.

Challenge:   The challenge lies in ensuring that a nurse is not overburdened by being assigned 
			 to too many rooms and that there is no duplication of assignments. 

Implementation Plan:
1. Create a table structure RoomAssignment
2. Create a stored procedure to assign a nurse to a room

*/
DROP TABLE IF EXISTS RoomAssignment;

CREATE TABLE RoomAssignment (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    nurse_id INT NOT NULL,
    room_id INT NOT NULL,
    FOREIGN KEY (nurse_id) REFERENCES Nurse(nurse_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    UNIQUE (room_id) 
);

DELIMITER $$

DROP PROCEDURE IF EXISTS AssignNurseToRoom$$

CREATE PROCEDURE AssignNurseToRoom(
	IN p_nurse_id INT, 
    IN p_room_id INT)
BEGIN
    DECLARE room_count INT;

    -- Check if the nurse is already assigned to 3 rooms
    SELECT COUNT(*) INTO room_count
    FROM RoomAssignment
    WHERE nurse_id = p_nurse_id;

    IF room_count >= 3 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Nurse is already assigned to 5 rooms.';
    ELSE
        -- Check if the room already has an assigned nurse
        IF EXISTS (
            SELECT 1 FROM RoomAssignment WHERE room_id = p_room_id
        ) THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Room is already assigned to another nurse.';
        ELSE
            -- Assign the nurse to the room
            INSERT INTO RoomAssignment (nurse_id, room_id)
            VALUES (p_nurse_id, p_room_id);
        END IF;
    END IF;
END$$

CALL AssignNurseToRoom(2, 3);

/* 

Purpose:	 To maintain an accurate and detailed record of patient diagnoses, including the 
			 date of diagnosis, associated symptoms, and the doctor who provided the diagnosis.

Problem:     Hospitals must record each patient's diagnoses along with relevant details, such 
             as the diagnosis name, associated symptoms, and the responsible doctor.

Challenge:   ensuring that diagnoses are accurately recorded without duplication while maintaining
			 proper links to patients and doctors. Another challenge is to allow secure updates to 
             diagnosis records without compromising historical data integrity.

Implementation Plan:
1. Create a table structure DiagnosisNotes
2. Create a stored procedure to record the diagnosis
3. Validate the patient and doctor by ID

*/
DROP TABLE IF EXISTS DiagnosisNotes;

CREATE TABLE DiagnosisNotes (
    note_id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_id INT NOT NULL,
    note_text TEXT NOT NULL,
    note_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (diagnosis_id) REFERENCES Diagnosis(diagnosis_id)
);

DELIMITER $$
DROP PROCEDURE IF EXISTS RecordDiagnosis$$

CREATE PROCEDURE RecordDiagnosis(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_diagnosis_name VARCHAR(255),
    IN p_symptoms TEXT
)
BEGIN
    -- Make sure patient and doctor ID's exist
    IF NOT EXISTS (SELECT 1 FROM Patient WHERE patient_id = p_patient_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid patient ID.';
    ELSEIF NOT EXISTS (SELECT 1 FROM Doctor WHERE doctor_id = p_doctor_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid doctor ID.';
    ELSE
        -- Make sure duplicate diagnosis gets flagged
        IF EXISTS (
            SELECT 1
            FROM Diagnosis
            WHERE patient_id = p_patient_id
            AND name = p_diagnosis_name
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Duplicate diagnosis for this patient.';
        ELSE
            -- Add diagnosis to the table
            INSERT INTO Diagnosis (patient_id, doctor_id, diagnosis_name, symptoms)
            VALUES (p_patient_id, p_doctor_id, p_diagnosis_name, p_symptoms);
        END IF;
    END IF;
END$$

CALL RecordDiagnosis(1, 1, 'High blood pressure, fatigue, headaches');

/* 

Purpose:     Ensure lab tests with pending results are assigned to doctors for review and 
			 update the status once reviewed.

Problem:     Lab tests must be assessed by doctors to give proper diagnosis. Patients cannot
			 interpret the results themselves.

Challenge:   Need to prvent unathorized updates. System needs to also keep up with pending 
			 statuses to make sure it's resolved.

Implementation Plan:
1. Add a column called 'status' to track
2. Create a procedure to update test results 

*/

DELIMITER $$

DROP PROCEDURE IF EXISTS AddStatusColumn$$

CREATE PROCEDURE AddStatusColumn()
BEGIN
    -- Check if the 'status' column exists in the 'Lab Test' table
    IF NOT EXISTS (SELECT 1 
                   FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE table_name = 'Lab Test' 
                     AND column_name = 'status' 
                     AND table_schema = 'HospitalManagementDB') THEN

        -- Add the 'status' column if it does not exist
        ALTER TABLE `Lab Test`
        ADD COLUMN `status` ENUM('Pending', 'Reviewed') DEFAULT 'Pending';
    END IF;
END$$


DELIMITER ;

CALL AddStatusColumn();


DELIMITER $$
DROP PROCEDURE IF EXISTS UpdateLabTestResult$$

CREATE PROCEDURE UpdateLabTestResult(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_result VARCHAR(255)
)

BEGIN
	DECLARE lab_status VARCHAR(20);

    -- Retrieve the test
    SELECT `status`
    INTO lab_status
    FROM `Lab Test`
    WHERE `patient_id` = p_patient_id AND `doctor_id` = p_doctor_id;

    -- Validate the test and status
    IF lab_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not found';
    ELSEIF lab_status = 'Reviewed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Already reviewed';
    ELSE
        -- Update and change status
        UPDATE `Lab Test`
        SET `result` = p_result,
            `status` = 'Reviewed'
        WHERE `patient_id` = p_patient_id AND `doctor_id` = p_doctor_id;
    END IF;
END$$

CALL UpdateLabTestResult(2, 1, 'Blood Test: Normal.');



