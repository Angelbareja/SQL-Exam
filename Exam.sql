CREATE DATABASE HospitalManagementDB;
USE HospitalManagementDB;

CREATE TABLE DOCTOR (
    Doctor_Id INT PRIMARY KEY,
    Doctor_Name VARCHAR(50) NOT NULL,
    Specialization VARCHAR(50),
    Joining_Date DATE,
    Salary DECIMAL(10, 2),
    Experience_Years INT
);

CREATE TABLE PATIENT (
    Patient_Id INT PRIMARY KEY,
    Patient_Name VARCHAR(50) NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Address VARCHAR(100),
    Disease VARCHAR(50),
    Doctor_Id INT,
    FOREIGN KEY (Doctor_Id) REFERENCES DOCTOR(Doctor_Id) ON DELETE SET NULL
);

CREATE TABLE ROOM (
    Room_No INT PRIMARY KEY,
    Room_Type VARCHAR(20) CHECK (Room_Type IN ('ICU', 'General', 'Deluxe', 'Private')),
    Status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE ADMIT_PATIENT (
    Admit_Id INT PRIMARY KEY,
    Patient_Id INT,
    Room_No INT,
    Admit_Date DATE,
    Discharge_Date DATE NULL,
    FOREIGN KEY (Patient_Id) REFERENCES PATIENT(Patient_Id) ON DELETE CASCADE,
    FOREIGN KEY (Room_No) REFERENCES ROOM(Room_No) ON DELETE SET NULL
);
CREATE TABLE BILL (
    Bill_No INT PRIMARY KEY,
    Patient_Id INT,
    Doctor_Charges DECIMAL(10,2),
    Room_Charges DECIMAL(10,2),
    Medicine_Charges DECIMAL(10,2),
    Total_Amount DECIMAL(10,2) AS (Doctor_Charges + Room_Charges + Medicine_Charges) STORED,
    FOREIGN KEY (Patient_Id) REFERENCES PATIENT(Patient_Id) ON DELETE CASCADE
);

INSERT INTO DOCTOR VALUES (101, 'Dr. Amit Sharma', 'Cardiologist', '2015-06-12', 120000.00, 11);
INSERT INTO DOCTOR VALUES (102, 'Dr. Priya Patel', 'Neurologist', '2018-09-24', 150000.00, 8);
INSERT INTO DOCTOR VALUES (103, 'Dr. Raj Singh', 'Pediatrician', '2020-02-15', 90000.00, 6);

INSERT INTO PATIENT VALUES (201, 'Rohan Verma', 45, 'Male', 'Delhi', 'Heart Attack', 101);
INSERT INTO PATIENT VALUES (202, 'Anjali Verma', 9, 'Female', 'Mumbai', 'Fever', 103);
INSERT INTO PATIENT VALUES (203, 'Karan Johar', 52, 'Male', 'Delhi', 'Brain Tumor', 102);

INSERT INTO ROOM VALUES (301, 'ICU', 'Occupied');
INSERT INTO ROOM VALUES (302, 'General', 'Available');
INSERT INTO ROOM VALUES (303, 'Deluxe', 'Occupied');

INSERT INTO ADMIT_PATIENT VALUES (401, 201, 301, '2026-03-01', '2026-03-10');
INSERT INTO ADMIT_PATIENT VALUES (402, 202, 302, '2026-03-05', '2026-03-07');
INSERT INTO ADMIT_PATIENT VALUES (403, 203, 303, '2026-03-02', NULL);

INSERT INTO BILL (Bill_No, Patient_Id, Doctor_Charges, Room_Charges, Medicine_Charges) 
VALUES (501, 201, 5000.00, 25000.00, 4500.00);
INSERT INTO BILL (Bill_No, Patient_Id, Doctor_Charges, Room_Charges, Medicine_Charges)
VALUES (502, 202, 1500.00, 2000.00, 800.00);
INSERT INTO BILL (Bill_No, Patient_Id, Doctor_Charges, Room_Charges, Medicine_Charges) 
VALUES (503, 203, 12000.00, 45000.00, 15000.00);

SELECT * FROM DOCTOR;

SELECT Patient_Name FROM PATIENT WHERE Disease = 'Heart Attack';

SELECT * FROM DOCTOR WHERE Specialization = 'Cardiologist';

SELECT COUNT(*) AS Total_Admitted_Patients FROM ADMIT_PATIENT;

SELECT P.Patient_Name 
FROM PATIENT P
JOIN ADMIT_PATIENT A ON P.Patient_Id = A.Patient_Id
WHERE A.Discharge_Date IS NULL;

SELECT Patient_Id, Total_Amount FROM BILL;

SET SQL_SAFE_UPDATES = 0;
UPDATE DOCTOR 
SET Salary = Salary * 1.10 
WHERE Experience_Years > 10;
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM PATIENT 
WHERE Patient_Id IN (
    SELECT Patient_Id FROM ADMIT_PATIENT WHERE Discharge_Date < '2026-03-08'
);
SET SQL_SAFE_UPDATES = 1;

SELECT D.Doctor_Id, D.Doctor_Name, COUNT(P.Patient_Id) AS Patient_Count
FROM DOCTOR D
JOIN PATIENT P ON D.Doctor_Id = P.Doctor_Id
GROUP BY D.Doctor_Id, D.Doctor_Name
ORDER BY Patient_Count DESC
LIMIT 1;

SELECT R.Room_No, R.Room_Type, P.Patient_Name
FROM ROOM R
JOIN ADMIT_PATIENT A ON R.Room_No = A.Room_No
JOIN PATIENT P ON A.Patient_Id = P.Patient_Id
WHERE A.Discharge_Date IS NULL;

SELECT P.Patient_Id, P.Patient_Name, B.Total_Amount
FROM PATIENT P
JOIN BILL B ON P.Patient_Id = B.Patient_Id
WHERE B.Total_Amount > 50000;

SELECT Specialization, AVG(Salary) AS Average_Salary
FROM DOCTOR
GROUP BY Specialization;

SELECT P.* 
FROM PATIENT P
JOIN ADMIT_PATIENT A ON P.Patient_Id = A.Patient_Id
JOIN ROOM R ON A.Room_No = R.Room_No
WHERE R.Room_Type = 'ICU';

SELECT Doctor_Name FROM DOCTOR WHERE Joining_Date > '2015-01-01';

SELECT Room_Type, COUNT(*) AS Available_Count
FROM ROOM
WHERE Status = 'Available'
GROUP BY Room_Type;

SELECT P.Patient_Id, P.Patient_Name, P.Disease, D.Doctor_Name, D.Specialization
FROM PATIENT P
LEFT JOIN DOCTOR D ON P.Doctor_Id = D.Doctor_Id;