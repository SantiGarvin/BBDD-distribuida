/*CREACION DE TRIGGERS*/
/* ================================================================
   TRIGGERS - MARGARITA 1 
   ================================================================ */

/* ---------------------------------------------------------
   PROCEDIMIENTO AUXILIAR
   --------------------------------------------------------- */
CREATE OR REPLACE PROCEDURE GET_DELEGACION (
  p_delegacion OUT VARCHAR2,
  p_ca         IN  VARCHAR2
) IS
BEGIN
  IF p_ca IN ('Castilla-León','Castilla-La Mancha','Aragón','Madrid','La Rioja') THEN
    p_delegacion := 'Madrid';
  ELSIF p_ca IN ('Cataluña','Baleares','País Valenciano','Murcia') THEN
    p_delegacion := 'Barcelona';
  ELSIF p_ca IN ('Galicia','Asturias','Cantabria','País Vasco','Navarra') THEN
    p_delegacion := 'La Coruña';
  ELSIF p_ca IN ('Andalucía','Extremadura','Canarias','Ceuta','Melilla') THEN
    p_delegacion := 'Granada';
  ELSE
    raise_application_error(-20999, 'Comunidad autónoma no válida para delegación.');
  END IF;
END;
/

/* ---------------------------------------------------------
   TRIGGERS CON PRAGMA (PORQUE LEEN SU PROPIA TABLA GLOBAL)
   --------------------------------------------------------- */

/* (3) Director empleado y (4) Unico en Sucursal 
   (Lee SUCURSAL_GLOBAL -> MUTA) */
CREATE OR REPLACE TRIGGER trg_sucursal1_director
BEFORE INSERT OR UPDATE OF cod_director ON SUCURSAL1
FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION; 
  v_es_empleado     NUMBER;
  v_ya_es_director  NUMBER;
BEGIN
  IF :NEW.cod_director IS NOT NULL THEN
    -- (3) Verificar empleado (Lee EMPLEADO, seguro, pero estamos dentro del Pragma general)
    SELECT COUNT(*) INTO v_es_empleado
    FROM EMPLEADO_GLOBAL
    WHERE cod_empleado = :NEW.cod_director;

    IF v_es_empleado = 0 THEN
      ROLLBACK;
      raise_application_error(-20003, 'ERROR(3): El director debe ser un empleado existente.');
    END IF;

    -- (4) Verificar unicidad (Lee SUCURSAL_GLOBAL -> CAUSA LA MUTACIÓN)
    SELECT COUNT(*) INTO v_ya_es_director
    FROM SUCURSAL_GLOBAL
    WHERE cod_director = :NEW.cod_director
      AND cod_sucursal <> :NEW.cod_sucursal;

    IF v_ya_es_director > 0 THEN
      ROLLBACK;
      raise_application_error(-20004, 'ERROR(4): Un empleado solo puede ser director de una sucursal.');
    END IF;
  END IF;
  ROLLBACK;
END;
/

/* (5) Empleado único en sucursal (Lee EMPLEADO_GLOBAL -> MUTA) */
CREATE OR REPLACE TRIGGER trg_empleado1_reglas
BEFORE INSERT OR UPDATE ON EMPLEADO1
FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION; 
  v_count NUMBER;
BEGIN
  -- (7) La sucursal debe existir (Seguro)
  SELECT COUNT(*) INTO v_count FROM SUCURSAL_GLOBAL WHERE cod_sucursal = :NEW.cod_sucursal;
  IF v_count = 0 THEN
    ROLLBACK;
    raise_application_error(-20007, 'ERROR(7): La sucursal asignada no existe.');
  END IF;

  -- (5) El empleado no puede estar en otra (Lee EMPLEADO_GLOBAL -> CAUSA LA MUTACIÓN)
  SELECT COUNT(*) INTO v_count
  FROM EMPLEADO_GLOBAL
  WHERE cod_empleado = :NEW.cod_empleado
    AND cod_sucursal <> :NEW.cod_sucursal;

  IF v_count > 0 THEN
    ROLLBACK;
    raise_application_error(-20005, 'ERROR(5): Un empleado solo puede trabajar en una sucursal.');
  END IF;

  -- (6) Salario
  IF UPDATING AND :NEW.salario < :OLD.salario THEN
      ROLLBACK;
      raise_application_error(-20006, 'ERROR(6): El salario no puede disminuir.');
  END IF;
  ROLLBACK;
END;
/

/* (12) Un vino, un productor (Lee VINO_GLOBAL -> MUTA) */
CREATE OR REPLACE TRIGGER trg_vino1_un_productor
BEFORE INSERT OR UPDATE ON VINO1
FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION; 
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM VINO_GLOBAL
  WHERE cod_vino = :NEW.cod_vino
    AND cod_productor <> :NEW.cod_productor;

  IF v_count > 0 THEN
    ROLLBACK;
    raise_application_error(-20012, 'ERROR(12): Un vino solo puede tener un productor.');
  END IF;
  ROLLBACK;
END;
/

/* (10) Fecha solicitud histórica (Lee SOLICITA_GLOBAL -> MUTA) */
CREATE OR REPLACE TRIGGER trg_solicita1_fecha
BEFORE INSERT OR UPDATE OF fecha_solicitud ON SOLICITA1
FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION; 
  v_last DATE;
BEGIN
  SELECT MAX(fecha_solicitud) INTO v_last
  FROM SOLICITA_GLOBAL
  WHERE cod_cliente = :NEW.cod_cliente;

  IF v_last IS NOT NULL AND :NEW.fecha_solicitud < v_last THEN
    ROLLBACK;
    raise_application_error(-20010, 'ERROR(10): La fecha de solicitud no puede ser anterior.');
  END IF;
  ROLLBACK;
END;
/

/* (18) Cantidad Pedida vs Solicitada (Lee REALIZA_GLOBAL -> MUTA) */
CREATE OR REPLACE TRIGGER trg_realiza1_cantidad
BEFORE INSERT ON REALIZA1
FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION; 
  v_pedido NUMBER;
  v_solic  NUMBER;
BEGIN
  -- Suma en REALIZA_GLOBAL (CAUSA LA MUTACIÓN)
  SELECT NVL(SUM(cantidad),0) INTO v_pedido
  FROM REALIZA_GLOBAL
  WHERE cod_vino = :NEW.cod_vino
    AND sucursal_origen = :NEW.sucursal_origen;

  -- Suma en SOLICITA_GLOBAL (Seguro)
  SELECT NVL(SUM(cantidad),0) INTO v_solic
  FROM SOLICITA_GLOBAL
  WHERE cod_vino = :NEW.cod_vino
    AND cod_sucursal = :NEW.sucursal_origen;

  IF v_pedido + :NEW.cantidad > v_solic THEN
    ROLLBACK;
    raise_application_error(-20018, 'ERROR(18): La sucursal está pidiendo más vino del que le han solicitado sus clientes.');
  END IF;
  ROLLBACK;
END;
/

/* (20) Fecha pedido histórica (Lee REALIZA_GLOBAL -> MUTA) */
CREATE OR REPLACE TRIGGER trg_realiza1_fecha
BEFORE INSERT OR UPDATE OF fecha_pedido ON REALIZA1
FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION; 
  v_last DATE;
BEGIN
  SELECT MAX(fecha_pedido) INTO v_last
  FROM REALIZA_GLOBAL
  WHERE sucursal_origen  = :NEW.sucursal_origen
    AND sucursal_destino = :NEW.sucursal_destino
    AND cod_vino         = :NEW.cod_vino;

  IF v_last IS NOT NULL AND :NEW.fecha_pedido < v_last THEN
    ROLLBACK;
    raise_application_error(-20020, 'ERROR(20): La fecha del pedido debe ser posterior al último.');
  END IF;
  ROLLBACK;
END;
/


/* ---------------------------------------------------------
   TRIGGERS NORMALES (SIN PRAGMA - LECTURA SEGURA)
   --------------------------------------------------------- */

/* (8) Tipo cliente */
CREATE OR REPLACE TRIGGER trg_cliente1_tipo
BEFORE INSERT OR UPDATE OF tipo_cliente ON CLIENTE1
FOR EACH ROW
BEGIN
  IF :NEW.tipo_cliente NOT IN ('A','B','C') THEN
    raise_application_error(-20008, 'ERROR(8): Tipo de cliente inválido (solo A, B o C).');
  END IF;
END;
/

/* (13) Productor existe y (14) Stock válido */
CREATE OR REPLACE TRIGGER trg_vino1_reglas
BEFORE INSERT OR UPDATE ON VINO1
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  -- (13) Productor (Local)
  SELECT COUNT(*) INTO v_count FROM PRODUCTOR WHERE cod_productor = :NEW.cod_productor;
  IF v_count = 0 THEN
    raise_application_error(-20013, 'ERROR(13): El productor no existe.');
  END IF;

  -- (14) Stock
  IF :NEW.cant_stock < 0 THEN
    raise_application_error(-20014, 'ERROR(14): El stock no puede ser negativo.');
  END IF;
  IF :NEW.cant_stock > :NEW.cant_producida THEN
    raise_application_error(-20014, 'ERROR(14): El stock no puede superar la producción.');
  END IF;
END;
/

/* (15) No borrar vino suministrado */
CREATE OR REPLACE TRIGGER trg_vino1_delete
BEFORE DELETE ON VINO1
FOR EACH ROW
DECLARE
  v_total NUMBER;
BEGIN
  SELECT NVL((SELECT SUM(cantidad) FROM SOLICITA_GLOBAL WHERE cod_vino = :OLD.cod_vino),0)
  INTO v_total FROM dual;

  IF v_total > 0 THEN
    raise_application_error(-20015, 'ERROR(15): No se puede borrar un vino suministrado.');
  END IF;
END;
/

/* (16) No borrar productor con vinos suministrados */
CREATE OR REPLACE TRIGGER trg_productor_delete
BEFORE DELETE ON PRODUCTOR
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM VINO_GLOBAL v
  WHERE v.cod_productor = :OLD.cod_productor
    AND NVL((SELECT SUM(s.cantidad) FROM SOLICITA_GLOBAL s WHERE s.cod_vino = v.cod_vino),0) > 0;

  IF v_count > 0 THEN
    raise_application_error(-20016, 'ERROR(16): No se puede borrar un productor con vinos suministrados.');
  END IF;
END;
/

/* (9) Delegación Cliente-Sucursal y (11) Existencia Vino */
CREATE OR REPLACE TRIGGER trg_solicita1_delegacion
BEFORE INSERT OR UPDATE ON SOLICITA1
FOR EACH ROW
DECLARE
  v_ca_cli VARCHAR2(50);
  v_ca_suc VARCHAR2(50);
  v_del_cli VARCHAR2(50);
  v_del_suc VARCHAR2(50);
  v_existe_vino NUMBER;
BEGIN
  -- Validar Vino (Global, pero tabla distinta -> OK sin Pragma)
  SELECT COUNT(*) INTO v_existe_vino FROM VINO_GLOBAL WHERE cod_vino = :NEW.cod_vino;
  IF v_existe_vino = 0 THEN
     raise_application_error(-20011, 'ERROR(11): El vino solicitado no existe en la base de datos.');
  END IF;

  -- Delegaciones
  SELECT comunidad_autonoma INTO v_ca_cli FROM CLIENTE_GLOBAL WHERE cod_cliente = :NEW.cod_cliente;
  SELECT comunidad_autonoma INTO v_ca_suc FROM SUCURSAL_GLOBAL WHERE cod_sucursal = :NEW.cod_sucursal;

  GET_DELEGACION(v_del_cli, v_ca_cli);
  GET_DELEGACION(v_del_suc, v_ca_suc);

  IF v_del_cli <> v_del_suc THEN
    raise_application_error(-20009, 'ERROR(9): Cliente y sucursal deben ser de la misma delegación.');
  END IF;
END;
/

/* (17) Delegaciones Pedido y (+) Existencias */
CREATE OR REPLACE TRIGGER trg_realiza1_delegacion
BEFORE INSERT OR UPDATE ON REALIZA1
FOR EACH ROW
DECLARE
  v_ca_o VARCHAR2(50); v_ca_d VARCHAR2(50);
  v_del_o VARCHAR2(50); v_del_d VARCHAR2(50);
  v_check NUMBER;
BEGIN
  -- Existencia Sucursal Destino (Global, distinta tabla -> OK sin Pragma)
  SELECT COUNT(*) INTO v_check FROM SUCURSAL_GLOBAL WHERE cod_sucursal = :NEW.sucursal_destino;
  IF v_check = 0 THEN raise_application_error(-20002, 'ERROR: La sucursal destino no existe.'); END IF;

  -- Existencia Vino
  SELECT COUNT(*) INTO v_check FROM VINO_GLOBAL WHERE cod_vino = :NEW.cod_vino;
  IF v_check = 0 THEN raise_application_error(-20011, 'ERROR: El vino pedido no existe.'); END IF;

  -- Delegaciones
  SELECT comunidad_autonoma INTO v_ca_o FROM SUCURSAL_GLOBAL WHERE cod_sucursal = :NEW.sucursal_origen;
  SELECT comunidad_autonoma INTO v_ca_d FROM SUCURSAL_GLOBAL WHERE cod_sucursal = :NEW.sucursal_destino;

  GET_DELEGACION(v_del_o, v_ca_o);
  GET_DELEGACION(v_del_d, v_ca_d);

  IF v_del_o = v_del_d THEN
    raise_application_error(-20017, 'ERROR(17): No se permiten pedidos dentro de la misma delegación.');
  END IF;
END;
/

/* (19) Destino distribuye vino */
CREATE OR REPLACE TRIGGER trg_realiza1_distribuye
BEFORE INSERT OR UPDATE ON REALIZA1
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  -- Lee DISTRIBUYE_GLOBAL -> Distinta de REALIZA -> OK sin Pragma
  SELECT COUNT(*) INTO v_count
  FROM DISTRIBUYE_GLOBAL
  WHERE cod_sucursal = :NEW.sucursal_destino
    AND cod_vino     = :NEW.cod_vino;

  IF v_count = 0 THEN
    raise_application_error(-20019, 'ERROR(19): La sucursal destino no distribuye ese vino.');
  END IF;
END;
/

/* (21) Pedido posterior a solicitud */
CREATE OR REPLACE TRIGGER trg_realiza1_vs_solicita
BEFORE INSERT OR UPDATE OF fecha_pedido ON REALIZA1
FOR EACH ROW
DECLARE
  v_last DATE;
BEGIN
  -- Lee SOLICITA_GLOBAL -> Distinta de REALIZA -> OK sin Pragma
  SELECT MAX(fecha_solicitud) INTO v_last
  FROM SOLICITA_GLOBAL
  WHERE cod_sucursal = :NEW.sucursal_origen
    AND cod_vino     = :NEW.cod_vino;

  IF v_last IS NOT NULL AND :NEW.fecha_pedido < v_last THEN
    raise_application_error(-20021, 'ERROR(21): El pedido debe ser posterior a la última solicitud.');
  END IF;
END;
/

/* (22) Cantidad de suministro positiva */
CREATE OR REPLACE TRIGGER trg_solicita1_cantidad
BEFORE INSERT OR UPDATE OF cantidad ON SOLICITA1
FOR EACH ROW
BEGIN
  IF :NEW.cantidad <= 0 THEN
    raise_application_error(
      -20022,
      'ERROR(22): La cantidad suministrada debe ser mayor que cero.'
    );
  END IF;
END;
/

/* (23) Cantidad de pedido positiva */
CREATE OR REPLACE TRIGGER trg_realiza1_cantidad_pos
BEFORE INSERT OR UPDATE OF cantidad ON REALIZA1
FOR EACH ROW
BEGIN
  IF :NEW.cantidad <= 0 THEN
    raise_application_error(
      -20023,
      'ERROR(23): La cantidad del pedido debe ser mayor que cero.'
    );
  END IF;
END;
/

