/* =========================================================
   VISTA AUXILIAR: V_SUCURSAL_UBICACION
   Objetivo:
   - Identificar en qué esquema/fragmento está cada sucursal
   - Facilitar la implementación de actualizaciones distribuidas
   ========================================================= */

CREATE OR REPLACE VIEW V_SUCURSAL_UBICACION AS
SELECT 'MARGARITA1' AS ESQUEMA,
       cod_sucursal,
       nombre,
       ciudad,
       comunidad_autonoma,
       cod_director
FROM MARGARITA1.SUCURSAL1
UNION ALL
SELECT 'MARGARITA2' AS ESQUEMA,
       cod_sucursal,
       nombre,
       ciudad,
       comunidad_autonoma,
       cod_director
FROM MARGARITA2.SUCURSAL2
UNION ALL
SELECT 'MARGARITA3' AS ESQUEMA,
       cod_sucursal,
       nombre,
       ciudad,
       comunidad_autonoma,
       cod_director
FROM MARGARITA3.SUCURSAL3
UNION ALL
SELECT 'MARGARITA4' AS ESQUEMA,
       cod_sucursal,
       nombre,
       ciudad,
       comunidad_autonoma,
       cod_director
FROM MARGARITA4.SUCURSAL4;

commit;

/* =========================================================
   PROCEDIMIENTO 1: P_ALTA_EMPLEADO
   Objetivo:
   - Dar de alta un nuevo empleado
   - Insertándolo en el fragmento correspondiente
     según la sucursal asignada
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_ALTA_EMPLEADO (
  p_cod_empleado          IN NUMBER,
  p_dni                   IN VARCHAR2,
  p_nombre                IN VARCHAR2,
  p_fecha_inicio          IN DATE,
  p_salario               IN NUMBER,
  p_direccion             IN VARCHAR2,
  p_cod_sucursal          IN NUMBER
) IS
  v_esquema  VARCHAR2(30);
BEGIN
  -- 1. Localizar el fragmento de la sucursal
  BEGIN
    SELECT ESQUEMA
      INTO v_esquema
      FROM V_SUCURSAL_UBICACION
     WHERE cod_sucursal = p_cod_sucursal;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(
        -20001,
        'ALTA_EMPLEADO: La sucursal ' || p_cod_sucursal || ' no existe.'
      );
  END;

  -- 2. Insertar en el fragmento correspondiente
  IF v_esquema = 'MARGARITA1' THEN
    INSERT INTO MARGARITA1.EMPLEADO1
    VALUES (p_cod_empleado, p_dni, p_nombre,
            p_fecha_inicio, p_salario, p_direccion, p_cod_sucursal);

  ELSIF v_esquema = 'MARGARITA2' THEN
    INSERT INTO MARGARITA2.EMPLEADO2
    VALUES (p_cod_empleado, p_dni, p_nombre,
            p_fecha_inicio, p_salario, p_direccion, p_cod_sucursal);

  ELSIF v_esquema = 'MARGARITA3' THEN
    INSERT INTO MARGARITA3.EMPLEADO3
    VALUES (p_cod_empleado, p_dni, p_nombre,
            p_fecha_inicio, p_salario, p_direccion, p_cod_sucursal);

  ELSIF v_esquema = 'MARGARITA4' THEN
    INSERT INTO MARGARITA4.EMPLEADO4
    VALUES (p_cod_empleado, p_dni, p_nombre,
            p_fecha_inicio, p_salario, p_direccion, p_cod_sucursal);

  ELSE
    raise_application_error(
      -20002,
      'ALTA_EMPLEADO: No se pudo determinar el fragmento destino.'
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    raise_application_error(
      -20003,
      'ALTA_EMPLEADO: Ya existe un empleado con ese código o DNI.'
    );
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'ALTA_EMPLEADO: Error inesperado -> ' || SQLERRM
    );
END;
/



/* =========================================================
   PROCEDIMIENTO 2: P_BAJA_EMPLEADO
   Objetivo:
   - Dar de baja a un empleado del sistema
   - Si era director, dejar la sucursal sin director
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_BAJA_EMPLEADO (
  p_cod_empleado IN NUMBER
) IS
  v_encontrado BOOLEAN := FALSE;
BEGIN
  /* 1. Quitar al empleado como director (si lo es) */
  UPDATE MARGARITA1.SUCURSAL1
     SET cod_director = NULL
   WHERE cod_director = p_cod_empleado;

  UPDATE MARGARITA2.SUCURSAL2
     SET cod_director = NULL
   WHERE cod_director = p_cod_empleado;

  UPDATE MARGARITA3.SUCURSAL3
     SET cod_director = NULL
   WHERE cod_director = p_cod_empleado;

  UPDATE MARGARITA4.SUCURSAL4
     SET cod_director = NULL
   WHERE cod_director = p_cod_empleado;

  /* 2. Borrar al empleado del fragmento donde esté */
  DELETE FROM MARGARITA1.EMPLEADO1
   WHERE cod_empleado = p_cod_empleado;

  IF SQL%ROWCOUNT > 0 THEN
    v_encontrado := TRUE;
  END IF;

  DELETE FROM MARGARITA2.EMPLEADO2
   WHERE cod_empleado = p_cod_empleado;

  IF SQL%ROWCOUNT > 0 THEN
    v_encontrado := TRUE;
  END IF;

  DELETE FROM MARGARITA3.EMPLEADO3
   WHERE cod_empleado = p_cod_empleado;

  IF SQL%ROWCOUNT > 0 THEN
    v_encontrado := TRUE;
  END IF;

  DELETE FROM MARGARITA4.EMPLEADO4
   WHERE cod_empleado = p_cod_empleado;

  IF SQL%ROWCOUNT > 0 THEN
    v_encontrado := TRUE;
  END IF;

  /* 3. Si no existía el empleado, error */
  IF NOT v_encontrado THEN
    ROLLBACK;
    raise_application_error(
      -20010,
      'BAJA_EMPLEADO: No existe ningún empleado con código ' || p_cod_empleado
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'BAJA_EMPLEADO: Error inesperado -> ' || SQLERRM
    );
END;
/


/* =========================================================
   PROCEDIMIENTO 3: P_MODIFICAR_SALARIO
   Objetivo:
   - Modificar el salario de un empleado existente
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_MODIFICAR_SALARIO (
  p_cod_empleado IN NUMBER,
  p_nuevo_salario IN NUMBER
) IS
  v_actualizado BOOLEAN := FALSE;
BEGIN
  /* Intentar actualizar en cada fragmento */

  UPDATE MARGARITA1.EMPLEADO1
     SET salario = p_nuevo_salario
   WHERE cod_empleado = p_cod_empleado;

  IF SQL%ROWCOUNT > 0 THEN
    v_actualizado := TRUE;
  END IF;

  UPDATE MARGARITA2.EMPLEADO2
     SET salario = p_nuevo_salario
   WHERE cod_empleado = p_cod_empleado;

  IF SQL%ROWCOUNT > 0 THEN
    v_actualizado := TRUE;
  END IF;

  UPDATE MARGARITA3.EMPLEADO3
     SET salario = p_nuevo_salario
   WHERE cod_empleado = p_cod_empleado;

  IF SQL%ROWCOUNT > 0 THEN
    v_actualizado := TRUE;
  END IF;

  UPDATE MARGARITA4.EMPLEADO4
     SET salario = p_nuevo_salario
   WHERE cod_empleado = p_cod_empleado;

  IF SQL%ROWCOUNT > 0 THEN
    v_actualizado := TRUE;
  END IF;

  /* Si no se ha encontrado el empleado */
  IF NOT v_actualizado THEN
    ROLLBACK;
    raise_application_error(
      -20020,
      'MODIFICAR_SALARIO: No existe ningún empleado con código ' || p_cod_empleado
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'MODIFICAR_SALARIO: Error inesperado -> ' || SQLERRM
    );
END;
/

/* =========================================================
   PROCEDIMIENTO 4: P_TRASLADAR_EMPLEADO
   Objetivo:
   - Trasladar un empleado a otra sucursal
   - Moviendo el registro entre fragmentos si es necesario
   ========================================================= */
CREATE OR REPLACE PROCEDURE P_TRASLADAR_EMPLEADO (
  p_cod_empleado    IN NUMBER,
  p_cod_sucursal    IN NUMBER,
  p_nueva_direccion IN VARCHAR2 DEFAULT NULL
) IS
  -- Datos del empleado
  v_dni        VARCHAR2(15);
  v_nombre     VARCHAR2(100);
  v_fecha_ini  DATE;
  v_salario    NUMBER;
  v_dir        VARCHAR2(120);

  v_esquema_destino VARCHAR2(30);
  v_encontrado      BOOLEAN := FALSE;
BEGIN
  /* 1. Obtener el fragmento destino */
  BEGIN
    SELECT ESQUEMA
      INTO v_esquema_destino
      FROM V_SUCURSAL_UBICACION
     WHERE cod_sucursal = p_cod_sucursal;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(
        -20030,
        'TRASLADO_EMPLEADO: La sucursal destino no existe.'
      );
  END;

  /* 2. Buscar y borrar al empleado (fragmento origen) */
  BEGIN
    SELECT dni, nombre, fecha_inicio_contrato, salario, direccion
      INTO v_dni, v_nombre, v_fecha_ini, v_salario, v_dir
      FROM MARGARITA1.EMPLEADO1
     WHERE cod_empleado = p_cod_empleado;

    DELETE FROM MARGARITA1.EMPLEADO1
     WHERE cod_empleado = p_cod_empleado;

    v_encontrado := TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
  END;

  IF NOT v_encontrado THEN
    BEGIN
      SELECT dni, nombre, fecha_inicio_contrato, salario, direccion
        INTO v_dni, v_nombre, v_fecha_ini, v_salario, v_dir
        FROM MARGARITA2.EMPLEADO2
       WHERE cod_empleado = p_cod_empleado;

      DELETE FROM MARGARITA2.EMPLEADO2
       WHERE cod_empleado = p_cod_empleado;

      v_encontrado := TRUE;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
    END;
  END IF;

  IF NOT v_encontrado THEN
    BEGIN
      SELECT dni, nombre, fecha_inicio_contrato, salario, direccion
        INTO v_dni, v_nombre, v_fecha_ini, v_salario, v_dir
        FROM MARGARITA3.EMPLEADO3
       WHERE cod_empleado = p_cod_empleado;

      DELETE FROM MARGARITA3.EMPLEADO3
       WHERE cod_empleado = p_cod_empleado;

      v_encontrado := TRUE;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
    END;
  END IF;

  IF NOT v_encontrado THEN
    BEGIN
      SELECT dni, nombre, fecha_inicio_contrato, salario, direccion
        INTO v_dni, v_nombre, v_fecha_ini, v_salario, v_dir
        FROM MARGARITA4.EMPLEADO4
       WHERE cod_empleado = p_cod_empleado;

      DELETE FROM MARGARITA4.EMPLEADO4
       WHERE cod_empleado = p_cod_empleado;

      v_encontrado := TRUE;
      COMMIT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
    END;
  END IF;

  IF NOT v_encontrado THEN
    ROLLBACK;
    raise_application_error(
      -20031,
      'TRASLADO_EMPLEADO: No existe el empleado indicado.'
    );
  END IF;

  /* 3. Insertar en el fragmento destino */
  IF v_esquema_destino = 'MARGARITA1' THEN
    INSERT INTO MARGARITA1.EMPLEADO1
    VALUES (
      p_cod_empleado, v_dni, v_nombre,
      v_fecha_ini, v_salario,
      NVL(p_nueva_direccion, v_dir),
      p_cod_sucursal
    );

  ELSIF v_esquema_destino = 'MARGARITA2' THEN
    INSERT INTO MARGARITA2.EMPLEADO2
    VALUES (
      p_cod_empleado, v_dni, v_nombre,
      v_fecha_ini, v_salario,
      NVL(p_nueva_direccion, v_dir),
      p_cod_sucursal
    );

  ELSIF v_esquema_destino = 'MARGARITA3' THEN
    INSERT INTO MARGARITA3.EMPLEADO3
    VALUES (
      p_cod_empleado, v_dni, v_nombre,
      v_fecha_ini, v_salario,
      NVL(p_nueva_direccion, v_dir),
      p_cod_sucursal
    );

  ELSIF v_esquema_destino = 'MARGARITA4' THEN
    INSERT INTO MARGARITA4.EMPLEADO4
    VALUES (
      p_cod_empleado, v_dni, v_nombre,
      v_fecha_ini, v_salario,
      NVL(p_nueva_direccion, v_dir),
      p_cod_sucursal
    );

  ELSE
    ROLLBACK;
    raise_application_error(
      -20032,
      'TRASLADO_EMPLEADO: Fragmento destino no válido.'
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'TRASLADO_EMPLEADO: Error inesperado -> ' || SQLERRM
    );
END;
/

/* =========================================================
   PROCEDIMIENTO 5: P_ALTA_SUCURSAL
   Objetivo:
   - Dar de alta una nueva sucursal
   - Insertándola en el fragmento correspondiente
     según la comunidad autónoma
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_ALTA_SUCURSAL (
  p_cod_sucursal       IN NUMBER,
  p_nombre             IN VARCHAR2,
  p_ciudad             IN VARCHAR2,
  p_comunidad          IN VARCHAR2,
  p_cod_director       IN NUMBER DEFAULT NULL
) IS
BEGIN
  /* CENTRO */
  IF p_comunidad IN ('Madrid','Castilla-León','Castilla-La Mancha','Aragón','La Rioja') THEN
    INSERT INTO MARGARITA1.SUCURSAL1
      (cod_sucursal, nombre, ciudad, comunidad_autonoma, cod_director)
    VALUES
      (p_cod_sucursal, p_nombre, p_ciudad, p_comunidad, p_cod_director);

  /* LEVANTE */
  ELSIF p_comunidad IN ('Cataluña','País Valenciano','Murcia','Baleares') THEN
    INSERT INTO MARGARITA2.SUCURSAL2
      (cod_sucursal, nombre, ciudad, comunidad_autonoma, cod_director)
    VALUES
      (p_cod_sucursal, p_nombre, p_ciudad, p_comunidad, p_cod_director);

  /* NORTE */
  ELSIF p_comunidad IN ('Galicia','Asturias','Cantabria','País Vasco','Navarra') THEN
    INSERT INTO MARGARITA3.SUCURSAL3
      (cod_sucursal, nombre, ciudad, comunidad_autonoma, cod_director)
    VALUES
      (p_cod_sucursal, p_nombre, p_ciudad, p_comunidad, p_cod_director);

  /* SUR */
  ELSIF p_comunidad IN ('Andalucía','Extremadura','Canarias','Ceuta','Melilla') THEN
    INSERT INTO MARGARITA4.SUCURSAL4
      (cod_sucursal, nombre, ciudad, comunidad_autonoma, cod_director)
    VALUES
      (p_cod_sucursal, p_nombre, p_ciudad, p_comunidad, p_cod_director);

  ELSE
    raise_application_error(
      -20040,
      'ALTA_SUCURSAL: Comunidad autónoma no válida o no asignada a ninguna delegación.'
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    raise_application_error(
      -20041,
      'ALTA_SUCURSAL: Ya existe una sucursal con ese código.'
    );
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'ALTA_SUCURSAL: Error inesperado -> ' || SQLERRM
    );
END;
/

/* =========================================================
   PROCEDIMIENTO 6: P_CAMBIAR_DIRECTOR
   Objetivo:
   - Nombrar o cambiar el director de una sucursal
   ========================================================= */
CREATE OR REPLACE PROCEDURE P_CAMBIAR_DIRECTOR (
  p_cod_sucursal IN NUMBER,
  p_cod_empleado IN NUMBER
) IS
  v_esquema VARCHAR2(30);
  v_count   NUMBER;
BEGIN
  -- (4) Un empleado no puede dirigir 2 sucursales (comprobación GLOBAL)
  SELECT COUNT(*) INTO v_count
  FROM SUCURSAL_GLOBAL
  WHERE cod_director = p_cod_empleado;

  IF v_count > 0 THEN
    raise_application_error(-20004,
      'ERROR(4): Un empleado solo puede ser director de una sucursal.');
  END IF;

  -- localizar fragmento
  SELECT ESQUEMA INTO v_esquema
  FROM V_SUCURSAL_UBICACION
  WHERE cod_sucursal = p_cod_sucursal;

  -- update en su fragmento
  IF v_esquema = 'MARGARITA1' THEN
    UPDATE MARGARITA1.SUCURSAL1
       SET cod_director = p_cod_empleado
     WHERE cod_sucursal = p_cod_sucursal;

  ELSIF v_esquema = 'MARGARITA2' THEN
    UPDATE MARGARITA2.SUCURSAL2
       SET cod_director = p_cod_empleado
     WHERE cod_sucursal = p_cod_sucursal;

  ELSIF v_esquema = 'MARGARITA3' THEN
    UPDATE MARGARITA3.SUCURSAL3
       SET cod_director = p_cod_empleado
     WHERE cod_sucursal = p_cod_sucursal;

  ELSE
    UPDATE MARGARITA4.SUCURSAL4
       SET cod_director = p_cod_empleado
     WHERE cod_sucursal = p_cod_sucursal;
  END IF;

  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    raise_application_error(-20050,
      'CAMBIAR_DIRECTOR: La sucursal indicada no existe.');
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(-20099,
      'CAMBIAR_DIRECTOR: Error inesperado -> ' || SQLERRM);
END;
/

/* =========================================================
   PROCEDIMIENTO 7: P_ALTA_CLIENTE
   Objetivo:
   - Dar de alta un nuevo cliente
   - Insertándolo en el fragmento correspondiente
     según su comunidad autónoma
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_ALTA_CLIENTE (
  p_cod_cliente        IN NUMBER,
  p_dni_cif            IN VARCHAR2,
  p_nombre             IN VARCHAR2,
  p_direccion          IN VARCHAR2,
  p_tipo               IN CHAR,
  p_comunidad          IN VARCHAR2
) IS
BEGIN
  /* CENTRO */
  IF p_comunidad IN ('Madrid','Castilla-León','Castilla-La Mancha','Aragón','La Rioja') THEN
    INSERT INTO MARGARITA1.CLIENTE1
      (cod_cliente, dni_cif, nombre, direccion, tipo_cliente, comunidad_autonoma)
    VALUES
      (p_cod_cliente, p_dni_cif, p_nombre, p_direccion, p_tipo, p_comunidad);

  /* LEVANTE */
  ELSIF p_comunidad IN ('Cataluña','País Valenciano','Murcia','Baleares') THEN
    INSERT INTO MARGARITA2.CLIENTE2
      (cod_cliente, dni_cif, nombre, direccion, tipo_cliente, comunidad_autonoma)
    VALUES
      (p_cod_cliente, p_dni_cif, p_nombre, p_direccion, p_tipo, p_comunidad);

  /* NORTE */
  ELSIF p_comunidad IN ('Galicia','Asturias','Cantabria','País Vasco','Navarra') THEN
    INSERT INTO MARGARITA3.CLIENTE3
      (cod_cliente, dni_cif, nombre, direccion, tipo_cliente, comunidad_autonoma)
    VALUES
      (p_cod_cliente, p_dni_cif, p_nombre, p_direccion, p_tipo, p_comunidad);

  /* SUR */
  ELSIF p_comunidad IN ('Andalucía','Extremadura','Canarias','Ceuta','Melilla') THEN
    INSERT INTO MARGARITA4.CLIENTE4
      (cod_cliente, dni_cif, nombre, direccion, tipo_cliente, comunidad_autonoma)
    VALUES
      (p_cod_cliente, p_dni_cif, p_nombre, p_direccion, p_tipo, p_comunidad);

  ELSE
    raise_application_error(
      -20060,
      'ALTA_CLIENTE: Comunidad autónoma no válida o no asignada a ninguna delegación.'
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    raise_application_error(
      -20061,
      'ALTA_CLIENTE: Ya existe un cliente con ese código o DNI/CIF.'
    );
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'ALTA_CLIENTE: Error inesperado -> ' || SQLERRM
    );
END;
/

/* =========================================================
   PROCEDIMIENTO 8: P_ALTA_ACTUALIZAR_SUMINISTRO
   Objetivo:
   - Insertar o actualizar un suministro (SOLICITA)
   - Descontar el stock real del vino
   - Controlar existencia de sucursal, vino y stock suficiente
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_ALTA_ACTUALIZAR_SUMINISTRO (
  p_cod_cliente   IN NUMBER,
  p_cod_sucursal  IN NUMBER,
  p_cod_vino      IN NUMBER,
  p_fecha         IN DATE,
  p_cantidad      IN NUMBER
) IS
  v_esquema_suc     VARCHAR2(30);
  v_comunidad_vino  VARCHAR2(50);
  v_stock_actual    NUMBER;
  v_existe          NUMBER;
BEGIN
  /* =========================================================
     1. LOCALIZAR FRAGMENTO DE LA SUCURSAL
     ========================================================= */
  BEGIN
    SELECT esquema
    INTO v_esquema_suc
    FROM V_SUCURSAL_UBICACION
    WHERE cod_sucursal = p_cod_sucursal;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(
        -20070,
        'SUMINISTRO: La sucursal indicada no existe.'
      );
  END;

  /* =========================================================
     2. COMPROBAR EXISTENCIA DEL VINO Y SU COMUNIDAD
     ========================================================= */
  BEGIN
    SELECT comunidad_autonoma
    INTO v_comunidad_vino
    FROM VINO_GLOBAL
    WHERE cod_vino = p_cod_vino;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(
        -20071,
        'SUMINISTRO: El vino indicado no existe.'
      );
  END;

  /* =========================================================
     3. COMPROBAR STOCK DISPONIBLE
     ========================================================= */
  IF v_comunidad_vino IN ('Madrid','Castilla-León','Castilla-La Mancha','Aragón','La Rioja') THEN
    SELECT cant_stock INTO v_stock_actual
    FROM MARGARITA1.VINO1
    WHERE cod_vino = p_cod_vino;

  ELSIF v_comunidad_vino IN ('Cataluña','País Valenciano','Murcia','Baleares') THEN
    SELECT cant_stock INTO v_stock_actual
    FROM MARGARITA2.VINO2
    WHERE cod_vino = p_cod_vino;

  ELSIF v_comunidad_vino IN ('Galicia','Asturias','Cantabria','País Vasco','Navarra') THEN
    SELECT cant_stock INTO v_stock_actual
    FROM MARGARITA3.VINO3
    WHERE cod_vino = p_cod_vino;

  ELSE
    SELECT cant_stock INTO v_stock_actual
    FROM MARGARITA4.VINO4
    WHERE cod_vino = p_cod_vino;
  END IF;

  IF v_stock_actual < p_cantidad THEN
    raise_application_error(
      -20072,
      'SUMINISTRO: No hay stock suficiente del vino.'
    );
  END IF;

  /* =========================================================
     4. INSERTAR O ACTUALIZAR SOLICITA
     ========================================================= */
  IF v_esquema_suc = 'MARGARITA1' THEN
    SELECT COUNT(*) INTO v_existe
    FROM MARGARITA1.SOLICITA1
    WHERE cod_cliente = p_cod_cliente
      AND cod_sucursal = p_cod_sucursal
      AND cod_vino = p_cod_vino
      AND fecha_solicitud = p_fecha;

    IF v_existe = 0 THEN
      INSERT INTO MARGARITA1.SOLICITA1
      VALUES (p_cod_cliente, p_cod_sucursal, p_cod_vino, p_fecha, p_cantidad);
    ELSE
      UPDATE MARGARITA1.SOLICITA1
      SET cantidad = cantidad + p_cantidad
      WHERE cod_cliente = p_cod_cliente
        AND cod_sucursal = p_cod_sucursal
        AND cod_vino = p_cod_vino
        AND fecha_solicitud = p_fecha;
    END IF;

  ELSIF v_esquema_suc = 'MARGARITA2' THEN
    SELECT COUNT(*) INTO v_existe
    FROM MARGARITA2.SOLICITA2
    WHERE cod_cliente = p_cod_cliente
      AND cod_sucursal = p_cod_sucursal
      AND cod_vino = p_cod_vino
      AND fecha_solicitud = p_fecha;

    IF v_existe = 0 THEN
      INSERT INTO MARGARITA2.SOLICITA2
      VALUES (p_cod_cliente, p_cod_sucursal, p_cod_vino, p_fecha, p_cantidad);
    ELSE
      UPDATE MARGARITA2.SOLICITA2
      SET cantidad = cantidad + p_cantidad
      WHERE cod_cliente = p_cod_cliente
        AND cod_sucursal = p_cod_sucursal
        AND cod_vino = p_cod_vino
        AND fecha_solicitud = p_fecha;
    END IF;

  ELSIF v_esquema_suc = 'MARGARITA3' THEN
    SELECT COUNT(*) INTO v_existe
    FROM MARGARITA3.SOLICITA3
    WHERE cod_cliente = p_cod_cliente
      AND cod_sucursal = p_cod_sucursal
      AND cod_vino = p_cod_vino
      AND fecha_solicitud = p_fecha;

    IF v_existe = 0 THEN
      INSERT INTO MARGARITA3.SOLICITA3
      VALUES (p_cod_cliente, p_cod_sucursal, p_cod_vino, p_fecha, p_cantidad);
    ELSE
      UPDATE MARGARITA3.SOLICITA3
      SET cantidad = cantidad + p_cantidad
      WHERE cod_cliente = p_cod_cliente
        AND cod_sucursal = p_cod_sucursal
        AND cod_vino = p_cod_vino
        AND fecha_solicitud = p_fecha;
    END IF;

  ELSE
    SELECT COUNT(*) INTO v_existe
    FROM MARGARITA4.SOLICITA4
    WHERE cod_cliente = p_cod_cliente
      AND cod_sucursal = p_cod_sucursal
      AND cod_vino = p_cod_vino
      AND fecha_solicitud = p_fecha;

    IF v_existe = 0 THEN
      INSERT INTO MARGARITA4.SOLICITA4
      VALUES (p_cod_cliente, p_cod_sucursal, p_cod_vino, p_fecha, p_cantidad);
    ELSE
      UPDATE MARGARITA4.SOLICITA4
      SET cantidad = cantidad + p_cantidad
      WHERE cod_cliente = p_cod_cliente
        AND cod_sucursal = p_cod_sucursal
        AND cod_vino = p_cod_vino
        AND fecha_solicitud = p_fecha;
    END IF;
  END IF;

  /* =========================================================
     5. DESCONTAR STOCK REAL DEL VINO
     ========================================================= */
  IF v_comunidad_vino IN ('Madrid','Castilla-León','Castilla-La Mancha','Aragón','La Rioja') THEN
    UPDATE MARGARITA1.VINO1
    SET cant_stock = cant_stock - p_cantidad
    WHERE cod_vino = p_cod_vino;

  ELSIF v_comunidad_vino IN ('Cataluña','País Valenciano','Murcia','Baleares') THEN
    UPDATE MARGARITA2.VINO2
    SET cant_stock = cant_stock - p_cantidad
    WHERE cod_vino = p_cod_vino;

  ELSIF v_comunidad_vino IN ('Galicia','Asturias','Cantabria','País Vasco','Navarra') THEN
    UPDATE MARGARITA3.VINO3
    SET cant_stock = cant_stock - p_cantidad
    WHERE cod_vino = p_cod_vino;

  ELSE
    UPDATE MARGARITA4.VINO4
    SET cant_stock = cant_stock - p_cantidad
    WHERE cod_vino = p_cod_vino;
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'SUMINISTRO: Error inesperado -> ' || SQLERRM
    );
END;
/



/* =========================================================
   PROCEDIMIENTO 9: P_BAJA_SUMINISTRO
   Objetivo:
   - Dar de baja uno o varios suministros
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_BAJA_SUMINISTRO (
  p_cod_cliente   IN NUMBER,
  p_cod_sucursal  IN NUMBER,
  p_cod_vino      IN NUMBER,
  p_fecha         IN DATE DEFAULT NULL
) IS
  v_esquema VARCHAR2(30);
  v_borrados NUMBER;
BEGIN
  /* 1. Localizar el fragmento según la sucursal */
  BEGIN
    SELECT ESQUEMA
      INTO v_esquema
      FROM V_SUCURSAL_UBICACION
     WHERE cod_sucursal = p_cod_sucursal;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(
        -20080,
        'BAJA_SUMINISTRO: La sucursal indicada no existe.'
      );
  END;

  /* 2. Borrado condicionado por fecha */
  IF v_esquema = 'MARGARITA1' THEN
    IF p_fecha IS NULL THEN
      DELETE FROM MARGARITA1.SOLICITA1
       WHERE cod_cliente  = p_cod_cliente
         AND cod_sucursal = p_cod_sucursal
         AND cod_vino     = p_cod_vino;
    ELSE
      DELETE FROM MARGARITA1.SOLICITA1
       WHERE cod_cliente  = p_cod_cliente
         AND cod_sucursal = p_cod_sucursal
         AND cod_vino     = p_cod_vino
         AND fecha_solicitud = p_fecha;
    END IF;

  ELSIF v_esquema = 'MARGARITA2' THEN
    IF p_fecha IS NULL THEN
      DELETE FROM MARGARITA2.SOLICITA2
       WHERE cod_cliente  = p_cod_cliente
         AND cod_sucursal = p_cod_sucursal
         AND cod_vino     = p_cod_vino;
    ELSE
      DELETE FROM MARGARITA2.SOLICITA2
       WHERE cod_cliente  = p_cod_cliente
         AND cod_sucursal = p_cod_sucursal
         AND cod_vino     = p_cod_vino
         AND fecha_solicitud = p_fecha;
    END IF;

  ELSIF v_esquema = 'MARGARITA3' THEN
    IF p_fecha IS NULL THEN
      DELETE FROM MARGARITA3.SOLICITA3
       WHERE cod_cliente  = p_cod_cliente
         AND cod_sucursal = p_cod_sucursal
         AND cod_vino     = p_cod_vino;
    ELSE
      DELETE FROM MARGARITA3.SOLICITA3
       WHERE cod_cliente  = p_cod_cliente
         AND cod_sucursal = p_cod_sucursal
         AND cod_vino     = p_cod_vino
         AND fecha_solicitud = p_fecha;
    END IF;

  ELSIF v_esquema = 'MARGARITA4' THEN
    IF p_fecha IS NULL THEN
      DELETE FROM MARGARITA4.SOLICITA4
       WHERE cod_cliente  = p_cod_cliente
         AND cod_sucursal = p_cod_sucursal
         AND cod_vino     = p_cod_vino;
    ELSE
      DELETE FROM MARGARITA4.SOLICITA4
       WHERE cod_cliente  = p_cod_cliente
         AND cod_sucursal = p_cod_sucursal
         AND cod_vino     = p_cod_vino
         AND fecha_solicitud = p_fecha;
    END IF;
  END IF;

  v_borrados := SQL%ROWCOUNT;

  IF v_borrados = 0 THEN
    ROLLBACK;
    raise_application_error(
      -20081,
      'BAJA_SUMINISTRO: No existe ningún suministro que cumpla las condiciones.'
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'BAJA_SUMINISTRO: Error inesperado -> ' || SQLERRM
    );
END;
/

/* =========================================================
   PROCEDIMIENTO 10: P_ALTA_PEDIDO
   Objetivo:
   - Dar de alta un pedido entre sucursales
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_ALTA_PEDIDO (
  p_sucursal_origen   IN NUMBER,
  p_sucursal_destino  IN NUMBER,
  p_cod_vino          IN NUMBER,
  p_fecha_pedido      IN DATE,
  p_cantidad          IN NUMBER
) IS
  v_esquema VARCHAR2(30);
BEGIN
  /* 1. Localizar el fragmento según la sucursal origen */
  BEGIN
    SELECT ESQUEMA
      INTO v_esquema
      FROM V_SUCURSAL_UBICACION
     WHERE cod_sucursal = p_sucursal_origen;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(
        -20090,
        'ALTA_PEDIDO: La sucursal origen no existe.'
      );
  END;

  /* 2. Insertar el pedido en el fragmento correspondiente */
  IF v_esquema = 'MARGARITA1' THEN
    INSERT INTO MARGARITA1.REALIZA1
    VALUES (
      p_sucursal_origen,
      p_sucursal_destino,
      p_cod_vino,
      p_fecha_pedido,
      p_cantidad
    );

  ELSIF v_esquema = 'MARGARITA2' THEN
    INSERT INTO MARGARITA2.REALIZA2
    VALUES (
      p_sucursal_origen,
      p_sucursal_destino,
      p_cod_vino,
      p_fecha_pedido,
      p_cantidad
    );

  ELSIF v_esquema = 'MARGARITA3' THEN
    INSERT INTO MARGARITA3.REALIZA3
    VALUES (
      p_sucursal_origen,
      p_sucursal_destino,
      p_cod_vino,
      p_fecha_pedido,
      p_cantidad
    );

  ELSIF v_esquema = 'MARGARITA4' THEN
    INSERT INTO MARGARITA4.REALIZA4
    VALUES (
      p_sucursal_origen,
      p_sucursal_destino,
      p_cod_vino,
      p_fecha_pedido,
      p_cantidad
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    raise_application_error(
      -20091,
      'ALTA_PEDIDO: Ya existe un pedido con esos datos.'
    );
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'ALTA_PEDIDO: Error inesperado -> ' || SQLERRM
    );
END;
/

/* =========================================================
   PROCEDIMIENTO 11: P_BAJA_PEDIDO
   Objetivo:
   - Dar de baja uno o varios pedidos entre sucursales
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_BAJA_PEDIDO (
  p_sucursal_origen   IN NUMBER,
  p_sucursal_destino  IN NUMBER,
  p_cod_vino          IN NUMBER,
  p_fecha_pedido      IN DATE DEFAULT NULL
) IS
  v_esquema  VARCHAR2(30);
  v_borrados NUMBER;
BEGIN
  /* 1. Localizar el fragmento según la sucursal origen */
  BEGIN
    SELECT ESQUEMA
      INTO v_esquema
      FROM V_SUCURSAL_UBICACION
     WHERE cod_sucursal = p_sucursal_origen;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(
        -20100,
        'BAJA_PEDIDO: La sucursal origen no existe.'
      );
  END;

  /* 2. Borrado condicionado por fecha */
  IF v_esquema = 'MARGARITA1' THEN
    IF p_fecha_pedido IS NULL THEN
      DELETE FROM MARGARITA1.REALIZA1
       WHERE sucursal_origen  = p_sucursal_origen
         AND sucursal_destino = p_sucursal_destino
         AND cod_vino         = p_cod_vino;
    ELSE
      DELETE FROM MARGARITA1.REALIZA1
       WHERE sucursal_origen  = p_sucursal_origen
         AND sucursal_destino = p_sucursal_destino
         AND cod_vino         = p_cod_vino
         AND fecha_pedido     = p_fecha_pedido;
    END IF;

  ELSIF v_esquema = 'MARGARITA2' THEN
    IF p_fecha_pedido IS NULL THEN
      DELETE FROM MARGARITA2.REALIZA2
       WHERE sucursal_origen  = p_sucursal_origen
         AND sucursal_destino = p_sucursal_destino
         AND cod_vino         = p_cod_vino;
    ELSE
      DELETE FROM MARGARITA2.REALIZA2
       WHERE sucursal_origen  = p_sucursal_origen
         AND sucursal_destino = p_sucursal_destino
         AND cod_vino         = p_cod_vino
         AND fecha_pedido     = p_fecha_pedido;
    END IF;

  ELSIF v_esquema = 'MARGARITA3' THEN
    IF p_fecha_pedido IS NULL THEN
      DELETE FROM MARGARITA3.REALIZA3
       WHERE sucursal_origen  = p_sucursal_origen
         AND sucursal_destino = p_sucursal_destino
         AND cod_vino         = p_cod_vino;
    ELSE
      DELETE FROM MARGARITA3.REALIZA3
       WHERE sucursal_origen  = p_sucursal_origen
         AND sucursal_destino = p_sucursal_destino
         AND cod_vino         = p_cod_vino
         AND fecha_pedido     = p_fecha_pedido;
    END IF;

  ELSIF v_esquema = 'MARGARITA4' THEN
    IF p_fecha_pedido IS NULL THEN
      DELETE FROM MARGARITA4.REALIZA4
       WHERE sucursal_origen  = p_sucursal_origen
         AND sucursal_destino = p_sucursal_destino
         AND cod_vino         = p_cod_vino;
    ELSE
      DELETE FROM MARGARITA4.REALIZA4
       WHERE sucursal_origen  = p_sucursal_origen
         AND sucursal_destino = p_sucursal_destino
         AND cod_vino         = p_cod_vino
         AND fecha_pedido     = p_fecha_pedido;
    END IF;
  END IF;

  v_borrados := SQL%ROWCOUNT;

  IF v_borrados = 0 THEN
    ROLLBACK;
    raise_application_error(
      -20101,
      'BAJA_PEDIDO: No existe ningún pedido que cumpla las condiciones.'
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'BAJA_PEDIDO: Error inesperado -> ' || SQLERRM
    );
END;
/


/* =========================================================
   PROCEDIMIENTO 12: P_ALTA_VINO
   Objetivo:
   - Dar de alta un nuevo vino
   - Inicializar el stock con la cantidad producida
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_ALTA_VINO (
  p_cod_vino        IN NUMBER,
  p_marca           IN VARCHAR2,
  p_anio_cosecha    IN NUMBER,
  p_denom_origen    IN VARCHAR2,
  p_graduacion      IN NUMBER,
  p_vinedo          IN VARCHAR2,
  p_comunidad       IN VARCHAR2,
  p_cant_producida  IN NUMBER,
  p_cod_productor   IN NUMBER
) IS
BEGIN
  /* CENTRO */
  IF p_comunidad IN ('Madrid','Castilla-León','Castilla-La Mancha','Aragón','La Rioja') THEN
    INSERT INTO MARGARITA1.VINO1
      (cod_vino, marca, anio_cosecha, denominacion_origen,
       graduacion, vinedo, comunidad_autonoma,
       cant_producida, cant_stock, cod_productor)
    VALUES
      (p_cod_vino, p_marca, p_anio_cosecha, p_denom_origen,
       p_graduacion, p_vinedo, p_comunidad,
       p_cant_producida, p_cant_producida, p_cod_productor);

  /* LEVANTE */
  ELSIF p_comunidad IN ('Cataluña','País Valenciano','Murcia','Baleares') THEN
    INSERT INTO MARGARITA2.VINO2
      (cod_vino, marca, anio_cosecha, denominacion_origen,
       graduacion, vinedo, comunidad_autonoma,
       cant_producida, cant_stock, cod_productor)
    VALUES
      (p_cod_vino, p_marca, p_anio_cosecha, p_denom_origen,
       p_graduacion, p_vinedo, p_comunidad,
       p_cant_producida, p_cant_producida, p_cod_productor);

  /* NORTE */
  ELSIF p_comunidad IN ('Galicia','Asturias','Cantabria','País Vasco','Navarra') THEN
    INSERT INTO MARGARITA3.VINO3
      (cod_vino, marca, anio_cosecha, denominacion_origen,
       graduacion, vinedo, comunidad_autonoma,
       cant_producida, cant_stock, cod_productor)
    VALUES
      (p_cod_vino, p_marca, p_anio_cosecha, p_denom_origen,
       p_graduacion, p_vinedo, p_comunidad,
       p_cant_producida, p_cant_producida, p_cod_productor);

  /* SUR */
  ELSIF p_comunidad IN ('Andalucía','Extremadura','Canarias','Ceuta','Melilla') THEN
    INSERT INTO MARGARITA4.VINO4
      (cod_vino, marca, anio_cosecha, denominacion_origen,
       graduacion, vinedo, comunidad_autonoma,
       cant_producida, cant_stock, cod_productor)
    VALUES
      (p_cod_vino, p_marca, p_anio_cosecha, p_denom_origen,
       p_graduacion, p_vinedo, p_comunidad,
       p_cant_producida, p_cant_producida, p_cod_productor);

  ELSE
    raise_application_error(
      -20110,
      'ALTA_VINO: Comunidad autónoma no válida o no asignada a ninguna delegación.'
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    raise_application_error(
      -20111,
      'ALTA_VINO: Ya existe un vino con ese código.'
    );
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'ALTA_VINO: Error inesperado -> ' || SQLERRM
    );
END;
/


/* =========================================================
   PROCEDIMIENTO 13: P_BAJA_VINO
   Objetivo:
   - Dar de baja un vino del sistema
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_BAJA_VINO (
  p_cod_vino IN NUMBER
) IS
  v_borrado BOOLEAN := FALSE;
BEGIN
  /* Intentar borrar en cada fragmento */

  DELETE FROM MARGARITA1.VINO1
   WHERE cod_vino = p_cod_vino;

  IF SQL%ROWCOUNT > 0 THEN
    v_borrado := TRUE;
  END IF;

  DELETE FROM MARGARITA2.VINO2
   WHERE cod_vino = p_cod_vino;

  IF SQL%ROWCOUNT > 0 THEN
    v_borrado := TRUE;
  END IF;

  DELETE FROM MARGARITA3.VINO3
   WHERE cod_vino = p_cod_vino;

  IF SQL%ROWCOUNT > 0 THEN
    v_borrado := TRUE;
  END IF;

  DELETE FROM MARGARITA4.VINO4
   WHERE cod_vino = p_cod_vino;

  IF SQL%ROWCOUNT > 0 THEN
    v_borrado := TRUE;
  END IF;

  IF NOT v_borrado THEN
    ROLLBACK;
    raise_application_error(
      -20120,
      'BAJA_VINO: No existe ningún vino con ese código.'
    );
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'BAJA_VINO: Error inesperado -> ' || SQLERRM
    );
END;
/

/* =========================================================
   PROCEDIMIENTO 14: P_ALTA_PRODUCTOR
   Objetivo:
   - Dar de alta un productor
   - Replicando el registro en todos los nodos
   ========================================================= */

CREATE OR REPLACE PROCEDURE P_ALTA_PRODUCTOR (
  p_cod_productor IN NUMBER,
  p_dni_cif       IN VARCHAR2,
  p_nombre        IN VARCHAR2,
  p_direccion     IN VARCHAR2
) IS
BEGIN
  /* Insertar en todas las bases de datos */

  INSERT INTO MARGARITA1.PRODUCTOR
  VALUES (p_cod_productor, p_dni_cif, p_nombre, p_direccion);

  INSERT INTO MARGARITA2.PRODUCTOR
  VALUES (p_cod_productor, p_dni_cif, p_nombre, p_direccion);

  INSERT INTO MARGARITA3.PRODUCTOR
  VALUES (p_cod_productor, p_dni_cif, p_nombre, p_direccion);

  INSERT INTO MARGARITA4.PRODUCTOR
  VALUES (p_cod_productor, p_dni_cif, p_nombre, p_direccion);

  COMMIT;

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    raise_application_error(
      -20130,
      'ALTA_PRODUCTOR: Ya existe un productor con ese código o DNI/CIF.'
    );
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(
      -20099,
      'ALTA_PRODUCTOR: Error inesperado -> ' || SQLERRM
    );
END;
/


/* =========================================================
   PROCEDIMIENTO 15: P_BAJA_PRODUCTOR
   Objetivo:
   - Dar de baja un productor
   - Eliminando el registro de todas las réplicas
   ========================================================= */
CREATE OR REPLACE PROCEDURE P_BAJA_PRODUCTOR (
  p_cod_productor IN NUMBER
) IS
  v_borrado BOOLEAN := FALSE;
BEGIN
  /* Borrar en todas las réplicas */
  DELETE FROM MARGARITA1.PRODUCTOR WHERE cod_productor = p_cod_productor;
  IF SQL%ROWCOUNT > 0 THEN v_borrado := TRUE; END IF;

  DELETE FROM MARGARITA2.PRODUCTOR WHERE cod_productor = p_cod_productor;
  IF SQL%ROWCOUNT > 0 THEN v_borrado := TRUE; END IF;

  DELETE FROM MARGARITA3.PRODUCTOR WHERE cod_productor = p_cod_productor;
  IF SQL%ROWCOUNT > 0 THEN v_borrado := TRUE; END IF;

  DELETE FROM MARGARITA4.PRODUCTOR WHERE cod_productor = p_cod_productor;
  IF SQL%ROWCOUNT > 0 THEN v_borrado := TRUE; END IF;

  IF NOT v_borrado THEN
    ROLLBACK;
    raise_application_error(-20140, 'BAJA_PRODUCTOR: No existe ningún productor con ese código.');
  END IF;

  COMMIT; 

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    raise_application_error(-20099, 'BAJA_PRODUCTOR: Error inesperado -> ' || SQLERRM);
END;
/

