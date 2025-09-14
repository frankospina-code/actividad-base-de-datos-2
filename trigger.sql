-- Trigger para insertar en copia_nuevos_docente después de una inserción en docente
DELIMITER $$
CREATE TRIGGER tr_docente_after_update
AFTER UPDATE ON docente
FOR EACH ROW
BEGIN
  INSERT INTO copia_actualizados_docente
    (docente_id, numero_documento, nombres, titulo, anios_experiencia, direccion, tipo_docente)
  VALUES
    (NEW.docente_id, NEW.numero_documento, NEW.nombres, NEW.titulo, NEW.anios_experiencia, NEW.direccion, NEW.tipo_docente);
END$$

-- trigger para insertar en copia_eliminados_docente después de una eliminación en docente
CREATE TRIGGER tr_docente_after_delete
AFTER DELETE ON docente
FOR EACH ROW
BEGIN
  INSERT INTO copia_eliminados_docente
    (docente_id, numero_documento, nombres, titulo, anios_experiencia, direccion, tipo_docente)
  VALUES
    (OLD.docente_id, OLD.numero_documento, OLD.nombres, OLD.titulo, OLD.anios_experiencia, OLD.direccion, OLD.tipo_docente);
END$$

DELIMITER ;

--ejemplo de inserción en la tabla docente para probar el trigger de actualziacion
--UPDATE pinformaticos.docente SET numero_documento = 'CC3087', nombres = 'Frank Ospina', titulo = 'ing.Software' WHERE docente_id = 4;

--ejemplo de eliminación en la tabla docente para probar el trigger de eliminación
--DELETE FROM pinformaticos.docente WHERE docente_id = 4;
