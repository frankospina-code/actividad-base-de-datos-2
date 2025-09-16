-- 
DELIMITER $$  --permite que el cuerpo del procedimiento, que contiene múltiples sentencias SQL terminadas en ;, no se interprete como el fin del procedimiento
CREATE PROCEDURE sp_docente_crear(  --crear un procedimiento almacenado--nombre del procedimiento
  IN p_numero_documento VARCHAR(20), --recibe el número de documento del docente (máx 20 caracteres)
  IN p_nombres          VARCHAR(120), --recibe el nombre completo del docente (máx 120 caracteres)
  IN p_titulo           VARCHAR(120), --recibe el título profesional 
  IN p_anios_experiencia INT, --recibe los años de experiencia (Tipo entero)
  IN p_direccion        VARCHAR(180),  --recibe la dirección (máx 180 caracteres)
  IN p_tipo_docente     VARCHAR(40)  --recibe el tipo de docente (máx 40 caracteres)
)
BEGIN  --inicio del cuerpo
  INSERT INTO docente (numero_documento, nombres, titulo, anios_experiencia, direccion, tipo_docente) --inserta un nuevo registro en la tabla + columnas que recibirán los valores
  VALUES (p_numero_documento, p_nombres, p_titulo, IFNULL(p_anios_experiencia,0), p_direccion, p_tipo_docente);--arámetros de entrada + si no se envía valor para años de experiencia (NULL), se asigna automáticamente 0.
  SELECT LAST_INSERT_ID() AS docente_id_creado; --retorna el último valor autoincremental generado en la sesión actual ("AS" asigna un alias al resultado)
END$$  --fin del cuerpo

CREATE PROCEDURE sp_docente_leer(IN p_docente_id INT) --indica que vamos a crear un procedimiento almacenado--nombre del procedimiento--define un parámetro de entrada que indica el ID del docente que queremos consultar
BEGIN --inicio del cuerpo
  SELECT * FROM docente WHERE docente_id = p_docente_id; --("*" elecciona todas las columnas del registro --"WHERE docente_id"filtra los resultados para devolver solo el docente cuyo ID coincide con el parámetro de entrada)

CREATE PROCEDURE sp_docente_actualizar(  --creando un procedimiento almacenado
  IN p_docente_id       INT,   --ID del docente que se desea actualizar
  IN p_numero_documento VARCHAR(20), --nuevo número de documento (o el mismo si no cambia)
  IN p_nombres          VARCHAR(120), --nuevo nombre completo (o el mismo si no cambia)
  IN p_titulo           VARCHAR(120),  --nuevo título profesional (o el mismo si no cambia)
  IN p_anios_experiencia INT,     --años de experiencia actualizados
  IN p_direccion        VARCHAR(180), --nueva dirección (o el mismo si no cambia)
  IN p_tipo_docente     VARCHAR(40)  --nuevo tipo de docente (o el mismo si no cambia)
)
BEGIN  --inicio del cuerpo
  UPDATE docente  --instrucción que modifica un registro en la tabla
     SET numero_documento = p_numero_documento, --valores enviados como parámetros.
         nombres = p_nombres,
         titulo = p_titulo,
         anios_experiencia = IFNULL(p_anios_experiencia,0),--si se envía NULL, se asigna 0 como valor por defecto.
         direccion = p_direccion,
         tipo_docente = p_tipo_docente
   WHERE docente_id = p_docente_id; --asegura que solo se actualice el docente con el ID especificado
  SELECT * FROM docente WHERE docente_id = p_docente_id; --Realiza una consulta de confirmación después de actualizar--Devuelve todos los datos del docente actualizado
END$$  --fin del cuerpo

CREATE PROCEDURE sp_docente_eliminar(IN p_docente_id INT)--crear un procedimiento almacenado--eliminar un docente existente--indica el ID del docente que se desea eliminar.
BEGIN  --inicio del cuerpo
  DELETE FROM docente WHERE docente_id = p_docente_id; --instrucción que elimina un registro--asegura que solo se elimine el docente con el ID especificado
END$$  --fin del cuerpo

-- Procedimientos PROYECTO
--crear un procedimiento almacenado
CREATE PROCEDURE sp_proyecto_crear(
  IN p_nombre           VARCHAR(120), --nombre del proyecto (máximo 120 caracteres)
  IN p_descripcion      VARCHAR(400),--escripción del proyecto (máximo 400 caracteres)
  IN p_fecha_inicial    DATE,--fecha de inicio del proyecto
  IN p_fecha_final      DATE,--fecha de finalización del proyecto
  IN p_presupuesto      DECIMAL(12,2), --presupuesto asignado al proyecto (tipo decimal con 12 dígitos y 2 decimales)
  IN p_horas            INT, --cantidad de horas estimadas para el proyecto (tipo entero)
  IN p_docente_id_jefe  INT--ID del docente responsable del proyecto
)
BEGIN  --inicio del cuerpo
  INSERT INTO proyecto (nombre, descripcion, fecha_inicial, fecha_final, presupuesto, horas, docente_id_jefe)--valores que se insertan en la tabla
  VALUES (p_nombre, p_descripcion, p_fecha_inicial, p_fecha_final, IFNULL(p_presupuesto,0), IFNULL(p_horas,0), p_docente_id_jefe);--si loa parámetros son NULL, se asigna automáticamente 0.
  SELECT LAST_INSERT_ID() AS proyecto_id_creado;--retorna el último valor autoincremental generado
END$$  --fin del cuerpo

--crea un nuevo procedimiento almacenado
CREATE PROCEDURE sp_proyecto_leer(IN p_proyecto_id INT) --función es consultar (leer) un proyecto específico
BEGIN
  SELECT p.*, d.nombres AS nombre_docente_jefe --selecciona todas las columnas de la tabla (usando el alias p
  FROM proyecto p--indica la tabla principal
  JOIN docente d ON d.docente_id = p.docente_id_jefe --hace una unión interna con la tabla
  WHERE p.proyecto_id = p_proyecto_id;--filtra el resultado para que solo muestre el proyecto cuyo ID coincide con el parámetro recibido.
END$$

--crear un procedimiento almacenado
CREATE PROCEDURE sp_proyecto_actualizar(
  IN p_proyecto_id      INT,--D del proyecto que se desea actualizar
  IN p_nombre           VARCHAR(120), --nuevo nombre del proyecto (o el mismo si no cambia)
  IN p_descripcion      VARCHAR(400),--nueva descripción del proyecto (o el mismo si no cambia)
  IN p_fecha_inicial    DATE,--nueva fecha de inicio del proyecto (o el mismo si no cambia)
  IN p_fecha_final      DATE,--nueva fecha de finalización del proyecto (o el mismo si no cambia)
  IN p_presupuesto      DECIMAL(12,2),--nuevo presupuesto (acepta hasta 12 dígitos y 2 decimales).
  IN p_horas            INT,--nueva cantidad de horas estimadas para el proyecto 
  IN p_docente_id_jefe  INT --nuevo docente jefe responsable
)
BEGIN--inicio del cuerpo
  UPDATE proyecto --instrucción que modifica un registro en la tabla
     SET nombre = p_nombre,--se actualizan con los valores recibidos en los parámetros.
         fecha_inicial = p_fecha_inicial,
         fecha_final = p_fecha_final,
         presupuesto = IFNULL(p_presupuesto,0),--si se recibe NULL, se asigna 0 como valor por defecto
         horas = IFNULL(p_horas,0),--si se recibe NULL, se asigna 0 como valor por defecto
         docente_id_jefe = p_docente_id_jefe
   WHERE proyecto_id = p_proyecto_id;
  CALL sp_proyecto_leer(p_proyecto_id);--condición para que solo se actualice el proyecto con el ID especificado
END$$  --fin del cuerpo

--crear un procedimiento almacenado
CREATE PROCEDURE sp_proyecto_eliminar(IN p_proyecto_id INT)
BEGIN--inicio del cuerpo
  DELETE FROM proyecto WHERE proyecto_id = p_proyecto_id;--elimina registros de la tabla--condición para que solo se elimine el proyecto cuyo ID coincide con el parámetro recibido, evitando borrar toda la tabla por error
END$$--fin del cuerpo
