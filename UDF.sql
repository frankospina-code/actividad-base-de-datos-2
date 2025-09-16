-- UDF
DROP FUNCTION IF EXISTS fn_promedio_presupuesto_por_docente; -- Elimina la función si ya existe para evitar errores al crearla nuevamente
CREATE FUNCTION fn_promedio_presupuesto_por_docente(p_docente_id INT) -- Crear una nueva función almacenada
RETURNS DECIMAL(12,2) -- Especifica que la función retorna un valor decimal con 12 dígitos totales y 2 decimales
DETERMINISTIC -- Indica que la función siempre devuelve el mismo resultado para los mismos parámetros de entrada
READS SQL DATA -- Especifica que la función lee datos SQL pero no los modifica
BEGIN -- Inicio del cuerpo de la función
  DECLARE v_prom DECIMAL(12,2); -- Declara una variable local para almacenar el promedio calculado
  SELECT IFNULL(AVG(presupuesto),0) INTO v_prom  -- Calcula el promedio de presupuesto de los proyectos donde el docente es jefe -- Si no hay proyectos, establece el promedio en 0 usando IFNULL
  FROM proyecto
  WHERE docente_id_jefe = p_docente_id;
  RETURN IFNULL(v_prom,0); -- Retorna el valor calculado, asegurando que si es NULL se convierta a 0
END$$ -- Fin Del Cuerpo