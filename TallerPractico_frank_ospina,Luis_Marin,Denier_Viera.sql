CREATE DATABASE pinformaticos;

use pinformaticos;
/* ============================
   schema.sql  (MySQL 8.0+)
   ============================ */

-- Tablas base
CREATE TABLE docente (
  docente_id        INT AUTO_INCREMENT PRIMARY KEY,
  numero_documento  VARCHAR(20)  NOT NULL,
  nombres           VARCHAR(120) NOT NULL,
  titulo            VARCHAR(120),
  anios_experiencia INT          NOT NULL DEFAULT 0,
  direccion         VARCHAR(180),
  tipo_docente      VARCHAR(40),
  CONSTRAINT uq_docente_documento UNIQUE (numero_documento),
  CONSTRAINT ck_docente_anios CHECK (anios_experiencia >= 0)
) ENGINE=InnoDB;

CREATE TABLE proyecto (
  proyecto_id      INT AUTO_INCREMENT PRIMARY KEY,
  nombre           VARCHAR(120) NOT NULL,
  descripcion      VARCHAR(400),
  fecha_inicial    DATE NOT NULL,
  fecha_final      DATE,
  presupuesto      DECIMAL(12,2) NOT NULL DEFAULT 0,
  horas            INT           NOT NULL DEFAULT 0,
  docente_id_jefe  INT NOT NULL,
  CONSTRAINT ck_proyecto_horas CHECK (horas >= 0),
  CONSTRAINT ck_proyecto_pres CHECK (presupuesto >= 0),
  CONSTRAINT ck_proyecto_fechas CHECK (fecha_final IS NULL OR fecha_final >= fecha_inicial),
  CONSTRAINT fk_proyecto_docente FOREIGN KEY (docente_id_jefe) REFERENCES docente(docente_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tablas de auditoría
CREATE TABLE copia_actualizados_docente (
  auditoria_id       INT AUTO_INCREMENT PRIMARY KEY,
  docente_id         INT NOT NULL,
  numero_documento   VARCHAR(20)  NOT NULL,
  nombres            VARCHAR(120) NOT NULL,
  titulo             VARCHAR(120),
  anios_experiencia  INT          NOT NULL,
  direccion          VARCHAR(180),
  tipo_docente       VARCHAR(40),
  accion_fecha       DATETIME     NOT NULL DEFAULT (UTC_TIMESTAMP()),
  usuario_sql        VARCHAR(128) NOT NULL DEFAULT (CURRENT_USER())
) ENGINE=InnoDB;

CREATE TABLE copia_eliminados_docente (
  auditoria_id       INT AUTO_INCREMENT PRIMARY KEY,
  docente_id         INT NOT NULL,
  numero_documento   VARCHAR(20)  NOT NULL,
  nombres            VARCHAR(120) NOT NULL,
  titulo             VARCHAR(120),
  anios_experiencia  INT          NOT NULL,
  direccion          VARCHAR(180),
  tipo_docente       VARCHAR(40),
  accion_fecha       DATETIME     NOT NULL DEFAULT (UTC_TIMESTAMP()),
  usuario_sql        VARCHAR(128) NOT NULL DEFAULT (CURRENT_USER())
) ENGINE=InnoDB;

--TRIGGERS
--Este Trigger sirve para insertar en copia_actualizados_docente después de una actualizacion realizada en docente cualquiera de los campos

DELIMITER $$-- se cambia el delimitador para definir el trigger
CREATE TRIGGER tr_docente_after_update -- Nombre del trigger
AFTER UPDATE ON docente-- Se activa después de una actualización en la tabla docente
FOR EACH ROW
BEGIN-- Aquí se define la acción que se realizará después de una actualización
  INSERT INTO copia_actualizados_docente
    (docente_id, numero_documento, nombres, titulo, anios_experiencia, direccion, tipo_docente)
  VALUES-- Se usan los valores NEW para referirse a los datos después de la actualización
    (NEW.docente_id, NEW.numero_documento, NEW.nombres, NEW.titulo, NEW.anios_experiencia, NEW.direccion, NEW.tipo_docente);
END$$--Fin del trigger

-- Este trigger sirve para insertar en copia_eliminados_docente después de una realizada en la tabla docente de cual quiera de los campos

CREATE TRIGGER tr_docente_after_delete-- Nombre del trigger
AFTER DELETE ON docente-- Se activa después de una eliminación en la tabla docente
FOR EACH ROW
BEGIN -- Aquí se define la acción que se realizará después de una eliminación
  INSERT INTO copia_eliminados_docente
    (docente_id, numero_documento, nombres, titulo, anios_experiencia, direccion, tipo_docente)
  VALUES-- Se usan los valores OLD para referirse a los datos antes de la eliminación
    (OLD.docente_id, OLD.numero_documento, OLD.nombres, OLD.titulo, OLD.anios_experiencia, OLD.direccion, OLD.tipo_docente);
END$$-- Fin del trigger

DELIMITER ;-- Restauramos el delimitador original

--ejemplo de inserción en la tabla docente para probar el trigger de actualziacion
--UPDATE pinformaticos.docente SET numero_documento = 'CC3087', nombres = 'Frank Ospina', titulo = 'ing.Software' WHERE docente_id = 4;

--ejemplo de eliminación en la tabla docente para probar el trigger de eliminación
--DELETE FROM pinformaticos.docente WHERE docente_id = 4;
