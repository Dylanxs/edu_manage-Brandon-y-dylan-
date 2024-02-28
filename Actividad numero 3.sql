-- Eliminar la base de datos si existe para evitar conflictos
DROP DATABASE IF EXISTS EduManage;

-- Crear la base de datos
CREATE DATABASE EduManage;
USE EduManage;

-- Crear las tablas
CREATE TABLE profesores (
    id_profesor BINARY(16) PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    correo_electronico VARCHAR(100),
    UNIQUE (correo_electronico)
);

CREATE TABLE alumnos (
    id_alumno BINARY(16) PRIMARY KEY,
    carnet_alumno VARCHAR(10),
    nombre_alumno VARCHAR(50),
    apellido_alumno VARCHAR(50),
    edad_alumno INT
);

CREATE TABLE materias (
    id_materia BINARY(16) PRIMARY KEY,
    nombre_materia VARCHAR(100),
    grupo_materia INT,
    id_profesor BINARY(16),
    cupos INT CHECK (cupos >= 0),
    UNIQUE (nombre_materia, grupo_materia),
    CONSTRAINT fk_profesor FOREIGN KEY (id_profesor) REFERENCES profesores(id_profesor)
);

CREATE TABLE inscripciones (
    id_inscripcion BINARY(16) PRIMARY KEY,
    id_alumno BINARY(16),
    id_materia BINARY(16),
    fecha_inscripcion DATE,
    estado ENUM('Activo','Inactivo') CHECK (estado IN ('Activo', 'Inactivo')),
    CONSTRAINT fk_alumno FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    CONSTRAINT fk_materia FOREIGN KEY (id_materia) REFERENCES materias(id_materia)
);

CREATE TABLE calificaciones (
    id_calificacion BINARY(16) PRIMARY KEY,
    id_inscripcion BINARY(16),
    calificacion_final DECIMAL(5,2),
    fecha_calificacion DATE,
    CONSTRAINT fk_inscripcion FOREIGN KEY (id_inscripcion) REFERENCES inscripciones(id_inscripcion)
);

-- Procedimiento almacenado para insertar registros en todas las tablas
DELIMITER //

CREATE PROCEDURE InsertarRegistros(
    IN p_carnet_alumno VARCHAR(10),
    IN p_nombre_alumno VARCHAR(50),
    IN p_apellido_alumno VARCHAR(50),
    IN p_edad_alumno INT,
    IN p_nombre_profesor VARCHAR(100),
    IN p_apellido_profesor VARCHAR(100),
    IN p_correo_profesor VARCHAR(100),
    IN p_nombre_materia VARCHAR(100),
    IN p_grupo_materia INT,
    IN p_cupos INT,
    IN p_estado_inscripcion ENUM('Activo','Inactivo'),
    IN p_calificacion_final DECIMAL(5,2),
    IN p_fecha_inscripcion DATE,
    IN p_fecha_calificacion DATE
)
BEGIN
    DECLARE profesor_id BINARY(16);
    DECLARE alumno_id BINARY(16);
    DECLARE materia_id BINARY(16);
    DECLARE inscripcion_id BINARY(16);
    
    -- Insertar profesor
    INSERT INTO profesores (id_profesor, nombre, apellido, correo_electronico)
    VALUES (UUID(), p_nombre_profesor, p_apellido_profesor, p_correo_profesor);
    SET profesor_id = LAST_INSERT_ID();

    -- Insertar alumno
    INSERT INTO alumnos (id_alumno, carnet_alumno, nombre_alumno, apellido_alumno, edad_alumno)
    VALUES (UUID(), p_carnet_alumno, p_nombre_alumno, p_apellido_alumno, p_edad_alumno);
    SET alumno_id = LAST_INSERT_ID();

    -- Insertar materia
    INSERT INTO materias (id_materia, nombre_materia, grupo_materia, id_profesor, cupos)
    VALUES (UUID(), p_nombre_materia, p_grupo_materia, profesor_id, p_cupos);
    SET materia_id = LAST_INSERT_ID();

    -- Insertar inscripción
    INSERT INTO inscripciones (id_inscripcion, id_alumno, id_materia, fecha_inscripcion, estado)
    VALUES (UUID(), alumno_id, materia_id, p_fecha_inscripcion, p_estado_inscripcion);
    SET inscripcion_id = LAST_INSERT_ID();

    -- Insertar calificación
    INSERT INTO calificaciones (id_calificacion, id_inscripcion, calificacion_final, fecha_calificacion)
    VALUES (UUID(), inscripcion_id, p_calificacion_final, p_fecha_calificacion);
END;
//

DELIMITER ;

-- Insertar datos en la tabla profesores
CALL InsertarRegistros('1234567890', 'Juan', 'Pérez', 35, 'Maria', 'González', 'maria@example.com', 'Matemáticas', 1, 20, 'Activo', 85.5, '2024-01-15', '2024-02-25');
CALL InsertarRegistros('2345678901', 'Ana', 'Martínez', 40, 'Pedro', 'García', 'pedro@example.com', 'Física', 2, 18, 'Activo', 78.3, '2024-01-20', '2024-02-28');
CALL InsertarRegistros('3456789012', 'Carlos', 'López', 30, 'Laura', 'Sánchez', 'laura@example.com', 'Química', 1, 25, 'Activo', 90.2, '2024-02-01', '2024-02-25');
CALL InsertarRegistros('4567890123', 'Elena', 'Gómez', 38, 'Andrés', 'Fernández', 'andres@example.com', 'Historia', 2, 22, 'Activo', 88.7, '2024-02-05', '2024-02-27');
CALL InsertarRegistros('5678901234', 'Sofía', 'Díaz', 32, 'Luis', 'Rodríguez', 'luis@example.com', 'Inglés', 1, 20, 'Activo', 83.4, '2024-02-10', '2024-02-28');
CALL InsertarRegistros('6789012345', 'Miguel', 'Hernández', 37, 'Ana', 'Martínez', 'ana@example.com', 'Biología', 2, 18, 'Activo', 76.8, '2024-02-15', '2024-02-27');
CALL InsertarRegistros('7890123456', 'Laura', 'Torres', 29, 'Pedro', 'Gómez', 'pedro@example.com', 'Geografía', 1, 22, 'Activo', 91.5, '2024-02-20', '2024-02-26');
CALL InsertarRegistros('8901234567', 'David', 'Sánchez', 33, 'María', 'López', 'maria@example.com', 'Economía', 2, 20, 'Activo', 85.9, '2024-02-25', '2024-02-25');
CALL InsertarRegistros('9012345678', 'Carla', 'García', 36, 'Juan', 'Martínez', 'juan@example.com', 'Arte', 1, 25, 'Activo', 87.2, '2024-03-01', '2024-02-28');
CALL InsertarRegistros('0123456789', 'Diego', 'Pérez', 31, 'Ana', 'González', 'ana@example.com', 'Música', 2, 18, 'Activo', 82.6, '2024-03-05', '2024-02-27');
CALL InsertarRegistros('1234567890', 'Isabel', 'Fernández', 34, 'Luis', 'Hernández', 'luis@example.com', 'Educación Física', 1, 20, 'Activo', 89.4, '2024-03-10', '2024-02-28');
CALL InsertarRegistros('2345678901', 'Daniel', 'Martínez', 39, 'María', 'Fernández', 'maria@example.com', 'Ciencias Sociales', 2, 22, 'Activo', 81.7, '2024-03-15', '2024-02-27');
CALL InsertarRegistros('3456789012', 'Lucía', 'Sánchez', 28, 'Pedro', 'García', 'pedro@example.com', 'Informática', 1, 25, 'Activo', 86.3, '2024-03-20', '2024-02-26');
CALL InsertarRegistros('4567890123', 'Javier', 'López', 41, 'Ana', 'Martínez', 'ana@example.com', 'Psicología', 2, 18, 'Activo', 80.5, '2024-03-25', '2024-02-27');
CALL InsertarRegistros('5678901234', 'Marina', 'Gómez', 27, 'Luis', 'Rodríguez', 'luis@example.com', 'Filosofía', 1, 20, 'Activo', 88.1, '2024-03-30', '2024-02-28');

-- Agrega más llamadas a InsertarRegistros con diferentes datos según sea necesario

-- Insertar datos en la tabla alumnos
CALL InsertarRegistros('A001', 'Carlos', 'Pérez', 25, 'Juan', 'González', 'juan@example.com', 'Luis', 'Sánchez', '35');
CALL InsertarRegistros('A002', 'Laura', 'Martínez', 22, 'Pedro', 'García', 'pedro@example.com', 'Ana', 'Martínez', '40');
CALL InsertarRegistros('A003', 'Andrés', 'López', 20, 'María', 'González', 'maria@example.com', 'Carlos', 'López', '30');
CALL InsertarRegistros('A004', 'Sara', 'Gómez', 21, 'Luis', 'Hernández', 'luis@example.com', 'Laura', 'Sánchez', '29');
CALL InsertarRegistros('A005', 'Elena', 'Martínez', 23, 'Pedro', 'Gómez', 'pedro@example.com', 'David', 'Sánchez', '33');
CALL InsertarRegistros('A006', 'Pablo', 'Fernández', 24, 'Ana', 'Martínez', 'ana@example.com', 'Diego', 'Pérez', '31');
CALL InsertarRegistros('A007', 'Cristina', 'López', 26, 'Luis', 'Rodríguez', 'luis@example.com', 'Isabel', 'Fernández', '34');
CALL InsertarRegistros('A008', 'Manuel', 'González', 29, 'María', 'Fernández', 'maria@example.com', 'Daniel', 'Martínez', '39');
CALL InsertarRegistros('A009', 'Natalia', 'Pérez', 30, 'Pedro', 'García', 'pedro@example.com', 'Lucía', 'Sánchez', '28');
CALL InsertarRegistros('A010', 'Alejandro', 'Martínez', 27, 'Ana', 'Martínez', 'ana@example.com', 'Javier', 'López', '41');
CALL InsertarRegistros('A011', 'Clara', 'Gómez', 31, 'Luis', 'Rodríguez', 'luis@example.com', 'Marina', 'Gómez', '27');
CALL InsertarRegistros('A012', 'Roberto', 'Hernández', 28, 'Pedro', 'García', 'pedro@example.com', 'Carlos', 'Pérez', '25');
CALL InsertarRegistros('A013', 'Sandra', 'López', 24, 'María', 'González', 'maria@example.com', 'Laura', 'Martínez', '22');
CALL InsertarRegistros('A014', 'Víctor', 'Martínez', 22, 'Luis', 'Hernández', 'luis@example.com', 'Andrés', 'López', '20');
CALL InsertarRegistros('A015', 'Patricia', 'García', 23, 'Pedro', 'Gómez', 'pedro@example.com', 'Sara', 'Gómez', '21');
-- Agrega más llamadas a InsertarRegistros con diferentes datos según sea necesario

-- Insertar datos en la tabla materias
CALL InsertarRegistros('Matemáticas', 1, 20, 'Activo', 85.5, '2024-01-15', '2024-02-25');
CALL InsertarRegistros('Física', 2, 18, 'Activo', 78.3, '2024-01-20', '2024-02-28');
CALL InsertarRegistros('Química', 1, 25, 'Activo', 90.2, '2024-02-01', '2024-02-25');
CALL InsertarRegistros('Historia', 2, 22, 'Activo', 88.7, '2024-02-05', '2024-02-27');
CALL InsertarRegistros('Inglés', 1, 20, 'Activo', 83.4, '2024-02-10', '2024-02-28');
CALL InsertarRegistros('Biología', 2, 18, 'Activo', 76.8, '2024-02-15', '2024-02-27');
CALL InsertarRegistros('Geografía', 1, 22, 'Activo', 91.5, '2024-02-20', '2024-02-26');
CALL InsertarRegistros('Economía', 2, 20, 'Activo', 85.9, '2024-02-25', '2024-02-25');
CALL InsertarRegistros('Arte', 1, 25, 'Activo', 87.2, '2024-03-01', '2024-02-28');
CALL InsertarRegistros('Música', 2, 18, 'Activo', 82.6, '2024-03-05', '2024-02-27');
CALL InsertarRegistros('Educación Física', 1, 20, 'Activo', 89.4, '2024-03-10', '2024-02-28');
CALL InsertarRegistros('Ciencias Sociales', 2, 22, 'Activo', 81.7, '2024-03-15', '2024-02-27');
CALL InsertarRegistros('Informática', 1, 25, 'Activo', 86.3, '2024-03-20', '2024-02-26');
CALL InsertarRegistros('Psicología', 2, 18, 'Activo', 80.5, '2024-03-25', '2024-02-27');
CALL InsertarRegistros('Filosofía', 1, 20, 'Activo', 88.1, '2024-03-30', '2024-02-28');
-- Agrega más llamadas a InsertarRegistros con diferentes datos según sea necesario

-- Insertar datos en la tabla inscripciones
CALL InsertarRegistros('A001', '1234567890', 'Matemáticas', 1, '2024-01-15', 'Activo', 85.5, '2024-01-20', '2024-02-28');
CALL InsertarRegistros('A002', '2345678901', 'Física', 2, '2024-01-20', 'Activo', 78.3, '2024-01-25', '2024-02-27');
CALL InsertarRegistros('A003', '3456789012', 'Química', 1, '2024-02-01', 'Activo', 90.2, '2024-02-05', '2024-02-25');
CALL InsertarRegistros('A004', '4567890123', 'Historia', 2, '2024-02-05', 'Activo', 88.7, '2024-02-10', '2024-02-27');
CALL InsertarRegistros('A005', '5678901234', 'Inglés', 1, '2024-02-10', 'Activo', 83.4, '2024-02-15', '2024-02-28');
CALL InsertarRegistros('A006', '6789012345', 'Biología', 2, '2024-02-15', 'Activo', 76.8, '2024-02-20', '2024-02-27');
CALL InsertarRegistros('A007', '7890123456', 'Geografía', 1, '2024-02-20', 'Activo', 91.5, '2024-02-25', '2024-02-26');
CALL InsertarRegistros('A008', '8901234567', 'Economía', 2, '2024-02-25', 'Activo', 85.9, '2024-03-01', '2024-02-25');
CALL InsertarRegistros('A009', '9012345678', 'Arte', 1, '2024-03-01', 'Activo', 87.2, '2024-03-05', '2024-02-28');
CALL InsertarRegistros('A010', '0123456789', 'Música', 2, '2024-03-05', 'Activo', 82.6, '2024-03-10', '2024-02-27');
CALL InsertarRegistros('A011', '1234567890', 'Educación Física', 1, '2024-03-10', 'Activo', 89.4, '2024-03-15', '2024-02-28');
CALL InsertarRegistros('A012', '2345678901', 'Ciencias Sociales', 2, '2024-03-15', 'Activo', 81.7, '2024-03-20', '2024-02-27');
CALL InsertarRegistros('A013', '3456789012', 'Informática', 1, '2024-03-20', 'Activo', 86.3, '2024-03-25', '2024-02-26');
CALL InsertarRegistros('A014', '4567890123', 'Psicología', 2, '2024-03-25', 'Activo', 80.5, '2024-03-30', '2024-02-27');
CALL InsertarRegistros('A015', '5678901234', 'Filosofía', 1, '2024-03-30', 'Activo', 88.1, '2024-04-05', '2024-02-28');
-- Agrega más llamadas a InsertarRegistros con diferentes datos según sea necesario

-- Insertar datos en la tabla calificaciones
CALL InsertarRegistros('1234567890', 85.5, '2024-01-20');
CALL InsertarRegistros('2345678901', 78.3, '2024-01-25');
CALL InsertarRegistros('3456789012', 90.2, '2024-02-05');
CALL InsertarRegistros('4567890123', 88.7, '2024-02-10');
CALL InsertarRegistros('5678901234', 83.4, '2024-02-15');
CALL InsertarRegistros('6789012345', 76.8, '2024-02-20');
CALL InsertarRegistros('7890123456', 91.5, '2024-02-25');
CALL InsertarRegistros('8901234567', 85.9, '2024-03-01');
CALL InsertarRegistros('9012345678', 87.2, '2024-03-05');
CALL InsertarRegistros('0123456789', 82.6, '2024-03-10');
CALL InsertarRegistros('1234567890', 89.4, '2024-03-15');
CALL InsertarRegistros('2345678901', 81.7, '2024-03-20');
CALL InsertarRegistros('3456789012', 86.3, '2024-03-25');
CALL InsertarRegistros('4567890123', 80.5, '2024-03-30');
CALL InsertarRegistros('5678901234', 88.1, '2024-04-05');
-- Agrega más llamadas a InsertarRegistros con diferentes datos según sea necesario


select * from profesores;



