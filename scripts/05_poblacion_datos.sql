/* ==========================================================================
   SCRIPT DE POBLACIÓN DE DATOS - VERSIÓN FINAL CORREGIDA (PDF 2025-2026)
   Ejecutar SOLAMENTE en MARGARITA 1 (Madrid)
   ========================================================================== */
SET SERVEROUTPUT ON;
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

/* --------------------------------------------------------------------------
   1. ALTA DE SUCURSALES (Ordenadas por Código 1-12)
   -------------------------------------------------------------------------- */
BEGIN
  -- SUR (Margarita 4)
  P_ALTA_SUCURSAL(1, 'Santa Cruz',        'Sevilla', 'Andalucía', NULL);
  P_ALTA_SUCURSAL(2, 'Palacios Nazaríes', 'Granada', 'Andalucía', NULL);
  P_ALTA_SUCURSAL(3, 'Tacita de Plata',   'Cádiz',   'Andalucía', NULL);
  
  -- CENTRO (Margarita 1)
  P_ALTA_SUCURSAL(4, 'Almudena',        'Madrid',  'Madrid',        NULL);
  P_ALTA_SUCURSAL(5, 'El Cid',          'Burgos',  'Castilla-León', NULL);
  P_ALTA_SUCURSAL(6, 'Puente la Reina', 'Logroño', 'La Rioja',      NULL);
  
  -- LEVANTE (Margarita 2)
  P_ALTA_SUCURSAL(7, 'Catedral del Mar', 'Barcelona',         'Cataluña',        NULL);
  P_ALTA_SUCURSAL(8, 'Dama de Elche',    'Alicante',          'País Valenciano', NULL);
  P_ALTA_SUCURSAL(9, 'La Cartuja',       'Palma de Mallorca', 'Baleares',        NULL);

  -- NORTE (Margarita 3)
  P_ALTA_SUCURSAL(10, 'Meigas',     'La Coruña',     'Galicia',    NULL);
  P_ALTA_SUCURSAL(11, 'La Concha',  'San Sebastián', 'País Vasco', NULL);
  P_ALTA_SUCURSAL(12, 'Don Pelayo', 'Oviedo',        'Asturias',   NULL);
  
  DBMS_OUTPUT.PUT_LINE('1. Sucursales insertadas.');
END;
/

/* --------------------------------------------------------------------------
   2. ALTA DE EMPLEADOS (Datos exactos del PDF)
   -------------------------------------------------------------------------- */
BEGIN
  -- Sucursal 1
  P_ALTA_EMPLEADO(1, '11111111A', 'Raúl',     '21-09-2010', 2000, 'Sierpes 37, Sevilla', 1);
  P_ALTA_EMPLEADO(2, '22222222B', 'Federico', '25-08-2009', 1800, 'Emperatriz 25, Sevilla', 1);
  -- Sucursal 2
  P_ALTA_EMPLEADO(3, '33333333C', 'Natalia',  '30-01-2012', 2000, 'Ronda 126, Granada', 2);
  P_ALTA_EMPLEADO(4, '44444444D', 'Amalia',   '13-02-2013', 1800, 'San Matías 23, Granada', 2);
  -- Sucursal 3
  P_ALTA_EMPLEADO(5, '55555555E', 'Susana',   '01-10-2018', 2000, 'Zoraida 5, Cádiz', 3);
  P_ALTA_EMPLEADO(6, '66666666F', 'Gonzalo',  '01-01-2007', 1800, 'Tartesios 9, Cádiz', 3);
  -- Sucursal 4
  P_ALTA_EMPLEADO(7, '77777777G', 'Agustín',  '05-05-2019', 2000, 'Pablo Neruda 84, Madrid', 4);
  P_ALTA_EMPLEADO(8, '88888888H', 'Eduardo',  '06-06-2019', 1800, 'Alcalá 8, Madrid', 4);
  -- Sucursal 5
  P_ALTA_EMPLEADO(9, '99999999I', 'Alberto',  '05-09-2020', 2000, 'Las Huelgas 15, Burgos', 5);
  P_ALTA_EMPLEADO(10,'10101010J', 'Soraya',   '04-10-2017', 1800, 'Jimena 2, Burgos', 5);
  -- Sucursal 6
  P_ALTA_EMPLEADO(11,'01010101K', 'Manuel',   '06-07-2016', 2000, 'Estrella 26, Logroño', 6);
  P_ALTA_EMPLEADO(12,'12121212L', 'Emilio',   '05-11-2018', 1800, 'Constitución 3, Logroño', 6);
  -- Sucursal 7
  P_ALTA_EMPLEADO(13,'13131313M', 'Patricia', '04-12-2019', 2000, 'Diagonal 132, Barcelona', 7);
  P_ALTA_EMPLEADO(14,'14141414N', 'Inés',     '07-03-2018', 1800, 'Colón 24, Barcelona', 7);
  -- Sucursal 8
  P_ALTA_EMPLEADO(15,'15151515O', 'Carlos',   '16-06-2019', 2000, 'Palmeras 57, Alicante', 8); 
  P_ALTA_EMPLEADO(16,'16161616P', 'Dolores',  '14-05-2018', 1800, 'Calatrava 9, Alicante', 8);
  -- Sucursal 9
  P_ALTA_EMPLEADO(17,'17171717Q', 'Elías',    '13-06-2019', 2000, 'Arenal 17, P. Mallorca', 9);
  P_ALTA_EMPLEADO(18,'18181818R', 'Concepción','18-08-2020',1800, 'Campastilla 14, P. Mallorca', 9);
  -- Sucursal 10
  P_ALTA_EMPLEADO(19,'19191919S', 'Gabriel',  '19-09-2015', 2000, 'Hércules 19, La Coruña', 10);
  P_ALTA_EMPLEADO(20,'20202020T', 'Octavio',  '20-10-2017', 1800, 'María Pita 45, La Coruña', 10);
  -- Sucursal 11
  P_ALTA_EMPLEADO(21,'21212121V', 'Cesar',    '13-11-2021', 2000, 'Las Peñas 41, San Sebastián', 11);
  P_ALTA_EMPLEADO(22,'23232323W', 'Julia',    '24-03-2020', 1800, 'San Cristóbal 5, San Sebastián', 11);
  -- Sucursal 12
  P_ALTA_EMPLEADO(23,'24242424X', 'Claudia',  '13-02-2022', 2000, 'Santa Cruz 97, Oviedo', 12);
  P_ALTA_EMPLEADO(24,'25252525Z', 'Mario',    '23-04-2017', 1800, 'Naranco 21, Oviedo', 12);

  DBMS_OUTPUT.PUT_LINE('2. Empleados insertados.');
END;
/

/* --------------------------------------------------------------------------
   3. ASIGNACIÓN DE DIRECTORES (Según columna 'Director' en Datos Sucursales)
   -------------------------------------------------------------------------- */
BEGIN
  P_CAMBIAR_DIRECTOR(1, 1);
  P_CAMBIAR_DIRECTOR(2, 3);
  P_CAMBIAR_DIRECTOR(3, 5);
  P_CAMBIAR_DIRECTOR(4, 7);
  P_CAMBIAR_DIRECTOR(5, 9);
  P_CAMBIAR_DIRECTOR(6, 11);
  P_CAMBIAR_DIRECTOR(7, 13);
  P_CAMBIAR_DIRECTOR(8, 15);
  P_CAMBIAR_DIRECTOR(9, 17);
  P_CAMBIAR_DIRECTOR(10, 19);
  P_CAMBIAR_DIRECTOR(11, 21);
  P_CAMBIAR_DIRECTOR(12, 23);
  
  DBMS_OUTPUT.PUT_LINE('3. Directores asignados.');
END;
/

/* --------------------------------------------------------------------------
   4. ALTA DE PRODUCTORES
   -------------------------------------------------------------------------- */
BEGIN
  P_ALTA_PRODUCTOR(1, '35353535A', 'Justiniano Briñón', 'Ramón y Cajal 9, Valladolid');
  P_ALTA_PRODUCTOR(2, '36363636B', 'Marcelino Peña',    'San Francisco 7, Pamplona');
  P_ALTA_PRODUCTOR(3, '37373737C', 'Paloma Riquelme',   'Antonio Gaudí 23, Barcelona');
  P_ALTA_PRODUCTOR(4, '38383838D', 'Amador Laguna',     'Juan Ramón Jiménez 17, Córdoba');
  P_ALTA_PRODUCTOR(5, '39393939E', 'Ramón Esteban',     'Gran Vía de Colón 121, Madrid');
  P_ALTA_PRODUCTOR(6, '40404040F', 'Carlota Fuentes',   'Cruz de los Ángeles 29, Oviedo');
  
  DBMS_OUTPUT.PUT_LINE('4. Productores insertados.');
END;
/

/* --------------------------------------------------------------------------
   5. ALTA DE VINOS
   (Se omite el Vino 12 por indicación expresa de la profesora)
   -------------------------------------------------------------------------- */
BEGIN
  -- Prod 1
  P_ALTA_VINO(1, 'Vega Sicilia', 2008, 'Ribera del Duero', 12.5, 'Castillo Blanco', 'Castilla-León', 200, 1);
  P_ALTA_VINO(2, 'Vega Sicilia', 2015, 'Ribera del Duero', 12.5, 'Castillo Blanco', 'Castilla-León', 100, 1);
  
  -- Prod 2
  P_ALTA_VINO(3, 'Marqués de Cáceres', 2019, 'Rioja', 11, 'Santo Domingo', 'La Rioja', 200, 2);
  P_ALTA_VINO(4, 'Marqués de Cáceres', 2022, 'Rioja', 11.5, 'Santo Domingo', 'La Rioja', 250, 2);
  
  -- Prod 3
  P_ALTA_VINO(5, 'René Barbier', 2023, 'Penedés', 11.5, 'Virgen de Estrella', 'Cataluña', 200, 3);
  P_ALTA_VINO(6, 'René Barbier', 2020, 'Penedés', 11, 'Virgen de Estrella', 'Cataluña', 250, 3);
  
  -- Prod 4
  P_ALTA_VINO(7, 'Rias Baixas', 2024, 'Albariño', 9.5, 'Santa Compaña', 'Galicia', 150, 4);
  P_ALTA_VINO(8, 'Rias Baixas', 2023, 'Albariño', 9, 'Santa Compaña', 'Galicia', 100, 4);
  P_ALTA_VINO(9, 'Córdoba Bella', 2018, 'Montilla', 12, 'Mezquita Roja', 'Andalucía', 200, 4);
  P_ALTA_VINO(10,'Tío Pepe', 2020, 'Jerez', 12.5, 'Campo Verde', 'Andalucía', 200, 4);

  -- Prod 5
  P_ALTA_VINO(13,'Vega Murciana', 2023, 'Jumilla', 11.5, 'Vega Verde', 'Murcia', 250, 5);
  P_ALTA_VINO(14,'Tablas de Daimiel', 2018, 'Valdepeñas', 11.5, 'Laguna Azul', 'Castilla-La Mancha', 300, 5);
  P_ALTA_VINO(18,'Uva dorada', 2023, 'Málaga', 13, 'Axarquía', 'Andalucía', 200, 5);
  
  -- Prod 6
  P_ALTA_VINO(15,'Santa María', 2023, 'Tierra de Cangas', 10, 'Monte Astur', 'Asturias', 200, 6);
  P_ALTA_VINO(16,'Freixenet', 2024, 'Cava', 7.5, 'Valle Dorado', 'Cataluña', 250, 6);
  P_ALTA_VINO(19,'Meigas Bellas', 2024, 'Ribeiro', 8.5, 'Mayor Santiago', 'Galicia', 250, 6);

  -- Otros
  P_ALTA_VINO(17,'Estela', 2022, 'Cariñena', 10.5, 'San Millán', 'Aragón', 200, 3);
  P_ALTA_VINO(20,'Altamira', 2024, 'Tierra de Liébana', 9.5, 'Cuevas', 'Cantabria', 300, 1);
  P_ALTA_VINO(21,'Virgen negra', 2024, 'Islas Canarias', 10.5, 'Guanche', 'Canarias', 300, 3);
  
  DBMS_OUTPUT.PUT_LINE('5. Vinos insertados.');
END;
/

/* --------------------------------------------------------------------------
   6. TABLA DISTRIBUYE (Directo con INSERT, no hay Proc)
   Lógica: La sucursal distribuye vinos de SU zona (Margarita 1, 2, 3 o 4)
   -------------------------------------------------------------------------- */
BEGIN
  -- LIMPIEZA PREVIA (Por si había basura)
  DELETE FROM DISTRIBUYE1;
  DELETE FROM MARGARITA2.DISTRIBUYE2;
  DELETE FROM MARGARITA3.DISTRIBUYE3;
  DELETE FROM MARGARITA4.DISTRIBUYE4;

  -- 1. DELEGACIÓN CENTRO (Sucursales 4, 5, 6)
  -- Distribuyen vinos de: Madrid, C-León, Rioja, Aragón, C-Mancha
  -- Vinos IDs: 1, 2 (Ribera), 3, 4 (Rioja), 14 (Valdepeñas), 17 (Cariñena)
  -- Nota: El vino 12 no existe, así que lo quitamos.
  FOR suc IN 4..6 LOOP
     INSERT INTO DISTRIBUYE1 VALUES (suc, 1);
     INSERT INTO DISTRIBUYE1 VALUES (suc, 2);
     INSERT INTO DISTRIBUYE1 VALUES (suc, 3);
     INSERT INTO DISTRIBUYE1 VALUES (suc, 4);  -- ¡AQUÍ ESTÁ LA RIOJA!
     INSERT INTO DISTRIBUYE1 VALUES (suc, 14);
     INSERT INTO DISTRIBUYE1 VALUES (suc, 17);
  END LOOP;

  -- 2. DELEGACIÓN LEVANTE (Sucursales 7, 8, 9)
  -- Distribuyen vinos de: Cataluña, Baleares, Valencia, Murcia
  -- Vinos IDs: 5, 6 (Penedés), 13 (Jumilla), 16 (Cava), 21 (Canarias/Cataluña según PDF?)
  -- OJO: El PDF pone al vino 21 (Virgen Negra) en Canarias en prod, pero a veces hay lío.
  -- Asumimos lo estándar de Levante:
  FOR suc IN 7..9 LOOP
     INSERT INTO MARGARITA2.DISTRIBUYE2 VALUES (suc, 5);
     INSERT INTO MARGARITA2.DISTRIBUYE2 VALUES (suc, 6);
     INSERT INTO MARGARITA2.DISTRIBUYE2 VALUES (suc, 13);
     INSERT INTO MARGARITA2.DISTRIBUYE2 VALUES (suc, 16);
  END LOOP;

  -- 3. DELEGACIÓN NORTE (Sucursales 10, 11, 12)
  -- Distribuyen vinos de: Galicia, Asturias, Cantabria, País Vasco
  -- Vinos IDs: 7, 8 (Albariño), 15 (Cangas), 19 (Ribeiro), 20 (Liébana)
  FOR suc IN 10..12 LOOP
     INSERT INTO MARGARITA3.DISTRIBUYE3 VALUES (suc, 7);
     INSERT INTO MARGARITA3.DISTRIBUYE3 VALUES (suc, 8);
     INSERT INTO MARGARITA3.DISTRIBUYE3 VALUES (suc, 15);
     INSERT INTO MARGARITA3.DISTRIBUYE3 VALUES (suc, 19);
     INSERT INTO MARGARITA3.DISTRIBUYE3 VALUES (suc, 20);
  END LOOP;

  -- 4. DELEGACIÓN SUR (Sucursales 1, 2, 3)
  -- Distribuyen vinos de: Andalucía, Extremadura, Canarias
  -- Vinos IDs: 9 (Montilla), 10 (Jerez), 18 (Málaga), 21 (Canarias - Virgen Negra)
  FOR suc IN 1..3 LOOP
     INSERT INTO MARGARITA4.DISTRIBUYE4 VALUES (suc, 9);
     INSERT INTO MARGARITA4.DISTRIBUYE4 VALUES (suc, 10);
     INSERT INTO MARGARITA4.DISTRIBUYE4 VALUES (suc, 18);
     INSERT INTO MARGARITA4.DISTRIBUYE4 VALUES (suc, 21);
  END LOOP;

  COMMIT; -- ¡CRUCIAL! Sin esto, la vista global no ve los datos.
  DBMS_OUTPUT.PUT_LINE('Tablas DISTRIBUYE recargadas y confirmadas (COMMIT).');
END;
/


/* --------------------------------------------------------------------------
   7. ALTA DE CLIENTES
   -------------------------------------------------------------------------- */
BEGIN
  P_ALTA_CLIENTE(1, '26262626A', 'Hipercor',                 'Virgen de la Capilla 32, Jaén', 'A', 'Andalucía');
  P_ALTA_CLIENTE(2, '27272727B', 'Restaurante Cacereño',     'San Marcos 41, Cáceres',        'C', 'Extremadura');
  P_ALTA_CLIENTE(3, '28282828C', 'Continente',               'San Francisco 37, Vigo',        'A', 'Galicia');
  P_ALTA_CLIENTE(4, '29292929D', 'Restaurante El Asturiano', 'Covadonga 24, Luarca',          'C', 'Asturias');
  P_ALTA_CLIENTE(5, '30303030E', 'Restaurante El Payés',     'San Lucas 33, Mahón',           'C', 'Baleares');
  P_ALTA_CLIENTE(6, '31313131F', 'Mercadona',                'Desamparados 29, Castellón',    'A', 'País Valenciano');
  P_ALTA_CLIENTE(7, '32323232G', 'Restaurante Cándido',      'Acueducto 1, Segovia',          'C', 'Castilla-León');
  P_ALTA_CLIENTE(8, '34343434H', 'Restaurante Las Vidrieras','Cervantes 16, Almagro',         'C', 'Castilla-La Mancha');
  
  DBMS_OUTPUT.PUT_LINE('7. Clientes insertados.');
END;
/

-- 1. Borrar suministros
DELETE FROM margarita1.solicita1;
DELETE FROM margarita2.solicita2;
DELETE FROM margarita3.solicita3;
DELETE FROM margarita4.solicita4;

-- 2. Restaurar stock = producción
UPDATE margarita1.vino1 SET cant_stock = cant_producida;
UPDATE margarita2.vino2 SET cant_stock = cant_producida;
UPDATE margarita3.vino3 SET cant_stock = cant_producida;
UPDATE margarita4.vino4 SET cant_stock = cant_producida;

COMMIT;


select * from solicita_global;



/* --------------------------------------------------------------------------
   8. SOLICITA (Suministros a Clientes) - Datos exactos del PDF
   (Se omite el pedido del Cliente 7 por el Vino 12)
   -------------------------------------------------------------------------- */
BEGIN
  -- Cliente 1 (Jaén)
  P_ALTA_ACTUALIZAR_SUMINISTRO(1, 1, 4, '12-06-2025', 100);
  P_ALTA_ACTUALIZAR_SUMINISTRO(1, 2, 5, '11-07-2025', 150);
  P_ALTA_ACTUALIZAR_SUMINISTRO(1, 3, 14,'15-07-2025', 200);

  -- Cliente 2 (Cáceres)
  P_ALTA_ACTUALIZAR_SUMINISTRO(2, 2, 2, '03-04-2025', 20);
  P_ALTA_ACTUALIZAR_SUMINISTRO(2, 1, 7, '04-05-2025', 50);
  P_ALTA_ACTUALIZAR_SUMINISTRO(2, 2, 6, '15-09-2025', 40);
  P_ALTA_ACTUALIZAR_SUMINISTRO(2, 3, 16,'20-09-2025', 100);

  -- Cliente 3 (Vigo)
  P_ALTA_ACTUALIZAR_SUMINISTRO(3, 10, 3, '21-02-2025', 100);
  P_ALTA_ACTUALIZAR_SUMINISTRO(3, 10, 6, '02-08-2025', 90);
  P_ALTA_ACTUALIZAR_SUMINISTRO(3, 11, 13,'03-10-2025', 200);
  P_ALTA_ACTUALIZAR_SUMINISTRO(3, 12, 20,'04-11-2025', 150);

  -- Cliente 4 (Luarca)
  P_ALTA_ACTUALIZAR_SUMINISTRO(4, 12, 8, '01-03-2025', 50);
  P_ALTA_ACTUALIZAR_SUMINISTRO(4, 12, 17,'03-05-2025', 70);

  -- Cliente 5 (Mahón)
  P_ALTA_ACTUALIZAR_SUMINISTRO(5, 7, 16, '14-08-2025', 50);
  P_ALTA_ACTUALIZAR_SUMINISTRO(5, 9, 18, '01-10-2025', 100);

  -- Cliente 6 (Castellón)
  P_ALTA_ACTUALIZAR_SUMINISTRO(6, 8, 15, '13-01-2025', 100);
  P_ALTA_ACTUALIZAR_SUMINISTRO(6, 8, 9,  '19-02-2025', 150);
  P_ALTA_ACTUALIZAR_SUMINISTRO(6, 9, 19, '27-06-2025', 160);
  P_ALTA_ACTUALIZAR_SUMINISTRO(6, 7, 21, '17-09-2025', 200);

  -- Cliente 7 (Segovia)
  P_ALTA_ACTUALIZAR_SUMINISTRO(7, 4, 1,  '15-02-2025', 80);
  P_ALTA_ACTUALIZAR_SUMINISTRO(7, 5, 7,  '17-04-2025', 50);
  P_ALTA_ACTUALIZAR_SUMINISTRO(7, 4, 10, '21-06-2025', 70);
  -- [ELIMINADO] Pedido de Vino 12 borrado.

  -- Cliente 8 (Almagro)
  P_ALTA_ACTUALIZAR_SUMINISTRO(8, 6, 14, '11-01-2025', 50);
  P_ALTA_ACTUALIZAR_SUMINISTRO(8, 6, 4,  '14-03-2025', 60);
  P_ALTA_ACTUALIZAR_SUMINISTRO(8, 4, 6,  '21-05-2025', 70);
  
  DBMS_OUTPUT.PUT_LINE('9. Suministros a clientes insertados.');
END;
/


delete from margarita1.realiza1;
delete from margarita2.realiza2;
delete from margarita3.realiza3;
delete from margarita4.realiza4;
commit;

SELECT * 
FROM REALIZA_GLOBAL
ORDER BY fecha_pedido;

SELECT cod_vino, cant_producida, cant_stock
FROM VINO_GLOBAL
ORDER BY cod_vino;

/* ==========================================================================
   9. REALIZA (Pedidos entre sucursales) - ORDEN CRONOLÓGICO
   Ejecutar en MARGARITA 1.
   ========================================================================== */


BEGIN
  -- Suc 1 (Sevilla)
  -- 1º Mayo, 2º Junio (Ordenado por fecha)
  P_ALTA_PEDIDO(1, 10, 7, '05-05-2025', 50);  
  P_ALTA_PEDIDO(1, 4,  4, '13-06-2025', 100);
END;
/

BEGIN
  -- Suc 2 (Granada)
  -- Abril -> Julio -> Septiembre
  P_ALTA_PEDIDO(2, 5, 2, '04-04-2025', 20);
  P_ALTA_PEDIDO(2, 7, 5, '12-07-2025', 150);
  P_ALTA_PEDIDO(2, 8, 6, '16-09-2025', 40);
END;
/



begin
  -- Suc 3 (Cádiz)
  -- Julio -> Septiembre
  P_ALTA_PEDIDO(3, 6, 14, '15-07-2025', 200); 
  P_ALTA_PEDIDO(3, 9, 16, '21-09-2025', 100);
END;
/

begin
  -- Suc 4 (Madrid)
  -- Mayo -> Junio
  P_ALTA_PEDIDO(4, 7, 6,  '22-05-2025', 70);
  P_ALTA_PEDIDO(4, 1, 10, '22-06-2025', 70); 
END;
/

begin
  -- Suc 5 (Burgos)
  P_ALTA_PEDIDO(5, 10, 7, '18-04-2025', 50); 
END;
/

begin
  -- Suc 7 (Barcelona)
  P_ALTA_PEDIDO(7, 2, 21, '18-09-2025', 200);
END;
/

begin
  -- Suc 8 (Alicante)
  -- Enero -> Febrero
  P_ALTA_PEDIDO(8, 11,15, '14-01-2025', 100);
  P_ALTA_PEDIDO(8, 2, 9,  '20-02-2025', 150);
END;
/

begin
  -- Suc 9 (Palma)
  -- Junio -> Octubre
  P_ALTA_PEDIDO(9, 12,19, '28-06-2025', 160);
  P_ALTA_PEDIDO(9, 3, 18, '02-10-2025', 100);
END;
/

begin
  -- Suc 10 (Coruña)
  -- Febrero -> Agosto
  P_ALTA_PEDIDO(10, 4, 3, '22-02-2025', 100);
  P_ALTA_PEDIDO(10, 8, 6, '02-08-2025', 90);
END;
/

begin
  -- Suc 11 (San Sebastián)
  P_ALTA_PEDIDO(11, 9, 13, '04-10-2025', 200);
END;
/
begin
  -- Suc 12 (Oviedo)
  P_ALTA_PEDIDO(12, 4, 17, '04-05-2025', 70);
END;
/

COMMIT;

