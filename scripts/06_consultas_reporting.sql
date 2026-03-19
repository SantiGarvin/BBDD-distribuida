/*1. Listar los clientes (nombre y dirección) de Andalucía o Castilla-La Mancha y las
sucursales (nombre y ciudad), a los que se le ha suministrado vino de marca “Tablas
de Daimiel” entre el 1 de Enero de 2025 y el 1 de septiembre de 2025*/

/*Porque al unir varias tablas, un mismo cliente puede aparecer varias veces.
DISTINCT me permite mostrar cada cliente solo una vez, que es lo que pide el enunciado*/

SELECT DISTINCT
       c.nombre as nombre_cliente,
       c.direccion as direccion_cliente,
       s.nombre as sucursal_nombre,
       s.ciudad as sucursal_ciudad    
        FROM SOLICITA_GLOBAL so
        JOIN CLIENTE_GLOBAL  c ON so.cod_cliente  = c.cod_cliente
        JOIN SUCURSAL_GLOBAL s ON so.cod_sucursal = s.cod_sucursal
        JOIN VINO_GLOBAL     v ON so.cod_vino     = v.cod_vino

WHERE v.marca = 'Tablas de Daimiel' AND so.fecha_solicitud BETWEEN DATE '2025-01-01' AND DATE '2025-09-01' AND c.comunidad_autonoma IN ('Andalucía', 'Castilla-La Mancha');



/*2. Dado por teclado el código de un productor: “Listar la marca, el año de cosecha de
cada uno de los vinos producidos por él y la cantidad total suministrada de cada uno
de ellos a clientes de las comunidades autónomas de Baleares, Extremadura o País
Valenciano*/


select
    v.marca as marca_vino,
    v.anio_cosecha as anio_cosecha_vino,
    SUM(s.cantidad) as cantidad_suministrada
    
    from solicita_global s 
    join cliente_global c on s.cod_cliente = c.cod_cliente
    join vino_global v on s.cod_vino = v.cod_vino
    
where c.comunidad_autonoma IN ('Baleares', 'Extremadura', 'País Valenciano') and v.cod_productor = &cod_productor
GROUP BY v.marca, v.anio_cosecha;
    
    
    
/*3. Dado por teclado el código de una sucursal: “Listar el nombre de cada uno de sus
clientes, su tipo y la cantidad total vino de Rioja o Albariño que se le ha suministrado
a cada uno de ellos (solamente deberán aparecer aquellos clientes a los que se les ha
suministrado vinos con esta denominación de origen)”. */

SELECT
    c.nombre,
    c.tipo_cliente,
    SUM(so.cantidad) AS total_vino
        
    FROM SOLICITA_GLOBAL so
    JOIN CLIENTE_GLOBAL c ON so.cod_cliente = c.cod_cliente
    JOIN VINO_GLOBAL    v ON so.cod_vino    = v.cod_vino

WHERE so.cod_sucursal = &cod_sucursal AND v.denominacion_origen IN ('Rioja', 'Albariño')
GROUP BY c.nombre, c.tipo_cliente;

