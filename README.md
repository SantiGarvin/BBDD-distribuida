# 🍷 Sistema de Base de Datos Distribuida: Red de Distribución Vitivinícola

## 📝 Descripción del Proyecto
Proyecto de ingeniería de datos centrado en el modelado, fragmentación e implementación de una **Base de Datos Distribuida** para una empresa de distribución de vinos a nivel nacional. 

El sistema simula 4 nodos geográficos (Margarita 1, 2, 3 y 4) correspondientes a las delegaciones Centro, Levante, Norte y Sur de España, garantizando la integridad de los datos, la replicación de tablas maestras y el enrutamiento automático de transacciones.

## 🛠 Stack Tecnológico
* **Gestor de BD:** Oracle Database
* **Lenguaje:** SQL y PL/SQL avanzado
* **Entorno:** Oracle SQL Developer
* **Arquitectura:** DDB (Distributed Database) con Fragmentación Horizontal y Replicación.

## 🚀 Arquitectura y Logros Técnicos
Este proyecto demuestra habilidades avanzadas en el manejo de bases de datos relacionales:

1. **Fragmentación y Vistas Globales:** Uso de `UNION ALL` para unificar fragmentos de tablas (Sucursales, Empleados, Solicitudes) distribuidas geográficamente, permitiendo consultas globales transparentes.
2. **Replicación de Datos:** Tablas maestras (como `PRODUCTOR`) replicadas en todos los nodos con sincronización mediante procedimientos.
3. **Procedimientos Almacenados (Enrutamiento Automático):** Desarrollo de lógica de negocio (PL/SQL) que evalúa variables (ej. Comunidad Autónoma) para enrutar los comandos `INSERT/UPDATE` al esquema físico correspondiente (Margarita 1, 2, 3 o 4).
4. **Triggers Avanzados y Control de Transacciones:** Resolución del clásico problema de "Tablas Mutantes" en Oracle mediante el uso de `PRAGMA AUTONOMOUS_TRANSACTION` para validar reglas de negocio complejas (ej. control de stock y jerarquías de directores) antes del `COMMIT`.
5. **Reporting:** Consultas analíticas usando `JOINs` múltiples y funciones de agregación para extraer KPIs de negocio.

## 📁 Estructura del Repositorio
* `/scripts/01_ddl_esquemas_tablas.sql`: Definición de esquemas y DDL.
* `/scripts/02_seguridad_y_vistas_globales.sql`: Asignación de permisos y creación de vistas distribuidas.
* `/scripts/03_triggers_reglas_negocio.sql`: Lógica transaccional (Triggers).
* `/scripts/04_procedimientos_enrutamiento.sql`: Stored Procedures (CRUD).
* `/scripts/05_poblacion_datos.sql`: Script de inserción masiva de datos (Mock data).
* `/scripts/06_consultas_reporting.sql`: Consultas SQL para extracción de métricas.

## 💻 Muestra de Código: Enrutamiento Geográfico
Ejemplo del procedimiento que inserta clientes físicamente en el servidor/esquema correcto dependiendo de su ubicación:

```sql
  /* CENTRO */
  IF p_comunidad IN ('Madrid','Castilla-León','Castilla-La Mancha','Aragón','La Rioja') THEN
    INSERT INTO MARGARITA1.CLIENTE1
      (cod_cliente, dni_cif, nombre, direccion, tipo_cliente, comunidad_autonoma)
    VALUES
      (p_cod_cliente, p_dni_cif, p_nombre, p_direccion, p_tipo, p_comunidad);

  /* LEVANTE */
  ELSIF p_comunidad IN ('Cataluña','País Valenciano','Murcia','Baleares') THEN
    INSERT INTO MARGARITA2.CLIENTE2 [...]
