--Este Trigger sirve para insertar en copia_actualizados_docente después de una actualizacion realizada en docente cualquiera de los campos

DELIMITER $$-- Cambiamos el delimitador para definir el trigger
CREATE TRIGGER tr_docente_after_update -- Nombre del trigger
AFTER UPDATE ON docente-- Se activa después de una actualización en la tabla docente
FOR EACH ROW
BEGIN-- Aquí se define la acción que se realizará después de una actualización
  INSERT INTO copia_actualizados_docente
    (docente_id, numero_documento, nombres, titulo, anios_experiencia, direccion, tipo_docente)
  VALUES-- Se usan los valores NEW para referirse a los datos después de la actualización
    (NEW.docente_id, NEW.numero_documento, NEW.nombres, NEW.titulo, NEW.anios_experiencia, NEW.direccion, NEW.tipo_docente);
END$$

-- Este trigger sirve para insertar en copia_eliminados_docente después de una realizada en la tabla docente de cual quiera de los campos

CREATE TRIGGER tr_docente_after_delete-- Nombre del trigger
AFTER DELETE ON docente-- Se activa después de una eliminación en la tabla docente
FOR EACH ROW
BEGIN -- Aquí se define la acción que se realizará después de una eliminación
  INSERT INTO copia_eliminados_docente
    (docente_id, numero_documento, nombres, titulo, anios_experiencia, direccion, tipo_docente)
  VALUES-- Se usan los valores OLD para referirse a los datos antes de la eliminación
    (OLD.docente_id, OLD.numero_documento, OLD.nombres, OLD.titulo, OLD.anios_experiencia, OLD.direccion, OLD.tipo_docente);
END$$

DELIMITER ;-- Restauramos el delimitador original

--ejemplo de inserción en la tabla docente para probar el trigger de actualziacion
--UPDATE pinformaticos.docente SET numero_documento = 'CC3087', nombres = 'Frank Ospina', titulo = 'ing.Software' WHERE docente_id = 4;

--ejemplo de eliminación en la tabla docente para probar el trigger de eliminación
--DELETE FROM pinformaticos.docente WHERE docente_id = 4;
