# Hospital Management Database

<hr style="border: 5px solid black;" />

## Introduction
This project is an SQL-based hospital management database that includes all necessary entities to support hospital operations. The database is designed to store and manage information related to patients, doctors, appointments, medical records, billing, and more. Additionally, it includes business requirements such as triggers and stored procedures to handle concurrency issues and ensure data integrity.

## Features
**Patient Management** – Stores patient details such as name, date of birth, contact information, and medical history.

**Doctor Management** – Maintains records of doctors, their specializations, assigned departments, and availability.

**Appointments Scheduling** – Tracks and manages patient appointments with doctors, preventing double booking through constraints and stored procedures.

**Concurrency Handling** – Implements triggers and stored procedures to prevent data conflicts, such as duplicate entries or overlapping appointments.

**Data Integrity & Security** – Enforces primary keys, foreign keys, and constraints to maintain accuracy and consistency across all tables.

**Data Normalization** – The database follows normalization techniques (up to 3NF) to eliminate redundancy, ensure efficient data storage, and improve query performance.

## Repository Contents
#### This repository contains the following files and folders:
- Documentation.pdf: includes the project description, detailing the purpose and design of the database, as well as the functional requirements, which outline the key features the database must support. The document also covers non-functional requirements, including performance, security, and scalability expectations. Additionally, it contains diagrams, including the Entity Relationship Diagram (ERD), to visually represent the database schema and the relationships between different entities.
-  Files/: contains the necessary scripts and diagrams to manage the database
     - databasemodel.sql
     - inserts.sql
     - eer.mwb
     - erd.drawio.png
     - inserts.sql




