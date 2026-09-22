-- =====================================================================
-- Equivalente SQLite de: 0-arma_base_de_datos.sql (SQL Server 2005)
-- =====================================================================
-- NOTA: En SQLite la base de datos ES un archivo. No existe
--       CREATE DATABASE ni USE. Para crear la base basta con ejecutar
--       estos scripts apuntando a un archivo nuevo, por ejemplo:
--
--       sqlite3 hospital.db < 0-crear-tablas.sql
--
-- IMPORTANTE: SQLite NO valida claves foráneas por defecto.
--             Esta línea la activa para esta conexión:
-- =====================================================================

PRAGMA foreign_keys = ON;

-- Crear la tabla province_names primero (porque será referenciada por patients)
CREATE TABLE province_names (
    province_id   TEXT         PRIMARY KEY,
    province_name TEXT         NOT NULL
);

-- Crear la tabla doctors (porque será referenciada por admissions)
CREATE TABLE doctors (
    doctor_id    INTEGER      PRIMARY KEY,
    first_name   TEXT         NOT NULL,
    last_name    TEXT         NOT NULL,
    specialty    TEXT         NOT NULL
);

-- Ahora crear la tabla patients que hace referencia a province_names
CREATE TABLE patients (
    patient_id    INTEGER      PRIMARY KEY,
    first_name    TEXT         NOT NULL,
    last_name     TEXT         NOT NULL,
    gender        TEXT         NOT NULL,
    birth_date    TEXT         NOT NULL,
    city          TEXT,
    province_id   TEXT         NOT NULL,
    allergies     TEXT,
    height        INTEGER,
    weight        INTEGER,
    CONSTRAINT FK_patients_province FOREIGN KEY (province_id) REFERENCES province_names(province_id)
);

-- Finalmente, crear la tabla admissions que referencia a patients y doctors
CREATE TABLE admissions (
    patient_id          INTEGER      NOT NULL,
    admission_date      TEXT         NOT NULL,
    discharge_date      TEXT,
    diagnosis           TEXT,
    attending_doctor_id INTEGER      NOT NULL,
    CONSTRAINT FK_admissions_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT FK_admissions_doctor FOREIGN KEY (attending_doctor_id) REFERENCES doctors(doctor_id)
);

-- =====================================================================
-- Mapeo de tipos de SQL Server 2005 a SQLite:
--   CHAR(2)      -> TEXT   (SQLite no respeta tamaños de texto)
--   VARCHAR(n)   -> TEXT
--   INTEGER/INT  -> INTEGER
--   DECIMAL(3,0) -> INTEGER (escala 0: números enteros, ej. 156 cm)
--   DATE         -> TEXT   (formato ISO 'YYYY-MM-DD' ordena correctamente)
-- =====================================================================