/* ===========================
   PRODUCTOR (replicada)
   =========================== */
CREATE TABLE PRODUCTOR (
  cod_productor    NUMBER PRIMARY KEY,
  dni_cif          VARCHAR2(15) NOT NULL UNIQUE,
  nombre           VARCHAR2(100) NOT NULL,
  direccion        VARCHAR2(120) NOT NULL
);

/* ===========================
   SUCURSAL1  (fragmento)
   =========================== */
CREATE TABLE SUCURSAL1 (
  cod_sucursal        NUMBER PRIMARY KEY,
  nombre              VARCHAR2(50) NOT NULL,
  ciudad              VARCHAR2(50) NOT NULL,
  comunidad_autonoma  VARCHAR2(50) NOT NULL,
  cod_director        NUMBER   -- se validará con trigger global
);

/* ===========================
   CLIENTE1  (fragmento)
   =========================== */
CREATE TABLE CLIENTE1 (
  cod_cliente         NUMBER PRIMARY KEY,
  dni_cif             VARCHAR2(15) NOT NULL UNIQUE,
  nombre              VARCHAR2(100) NOT NULL,
  direccion           VARCHAR2(120) NOT NULL,
  comunidad_autonoma  VARCHAR2(50) NOT NULL,
  tipo_cliente        CHAR(1) NOT NULL
);

/* ===========================
   EMPLEADO1  (fragmento)
   =========================== */
CREATE TABLE EMPLEADO1 (
  cod_empleado           NUMBER PRIMARY KEY,
  dni                    VARCHAR2(15) NOT NULL UNIQUE,
  nombre                 VARCHAR2(100) NOT NULL,
  fecha_inicio_contrato  DATE NOT NULL,
  salario                NUMBER(10,2) NOT NULL,
  direccion              VARCHAR2(120),
  cod_sucursal           NUMBER NOT NULL,
  CONSTRAINT fk_emp1_sucursal
       FOREIGN KEY (cod_sucursal)
       REFERENCES SUCURSAL1(cod_sucursal)
);

/* ===========================
   VINO1 (fragmento)
   =========================== */
CREATE TABLE VINO1 (
  cod_vino             NUMBER PRIMARY KEY,
  marca                VARCHAR2(100) NOT NULL,
  anio_cosecha         NUMBER NOT NULL,
  denominacion_origen  VARCHAR2(100),
  graduacion           NUMBER(4,2) NOT NULL,
  vinedo               VARCHAR2(100) NOT NULL,
  comunidad_autonoma   VARCHAR2(50) NOT NULL,
  cant_producida       NUMBER NOT NULL,
  cant_stock           NUMBER NOT NULL,
  cod_productor        NUMBER NOT NULL,
  CONSTRAINT fk_vino1_productor
       FOREIGN KEY (cod_productor)
       REFERENCES PRODUCTOR(cod_productor)
);

/* ===========================
   DISTRIBUYE1 (fragmento)
   =========================== */
CREATE TABLE DISTRIBUYE1 (
  cod_sucursal NUMBER NOT NULL,
  cod_vino     NUMBER NOT NULL,
  PRIMARY KEY (cod_sucursal, cod_vino),
  CONSTRAINT fk_dis1_sucursal FOREIGN KEY (cod_sucursal)
       REFERENCES SUCURSAL1(cod_sucursal),
  CONSTRAINT fk_dis1_vino FOREIGN KEY (cod_vino)
       REFERENCES VINO1(cod_vino)
);

/* ===========================
   SOLICITA1 (fragmento)
   =========================== */
CREATE TABLE SOLICITA1 (
  cod_cliente      NUMBER NOT NULL,
  cod_sucursal     NUMBER NOT NULL,
  cod_vino         NUMBER NOT NULL, -- VALIDADO POR TRIGGER
  fecha_solicitud  DATE NOT NULL,
  cantidad         NUMBER NOT NULL,
  PRIMARY KEY (cod_cliente, cod_sucursal, cod_vino, fecha_solicitud),
  CONSTRAINT fk_sol1_cliente
    FOREIGN KEY (cod_cliente) REFERENCES CLIENTE1(cod_cliente),
  CONSTRAINT fk_sol1_sucursal
    FOREIGN KEY (cod_sucursal) REFERENCES SUCURSAL1(cod_sucursal)
);


/* ===========================
   REALIZA1 (fragmento)
   =========================== */
CREATE TABLE REALIZA1 (
  sucursal_origen  NUMBER NOT NULL,
  sucursal_destino NUMBER NOT NULL, -- VALIDADO POR TRIGGER
  cod_vino         NUMBER NOT NULL, -- VALIDADO POR TRIGGER
  fecha_pedido     DATE NOT NULL,
  cantidad         NUMBER NOT NULL,
  PRIMARY KEY (sucursal_origen, sucursal_destino, cod_vino, fecha_pedido),
  CONSTRAINT fk_real1_origen
    FOREIGN KEY (sucursal_origen) REFERENCES SUCURSAL1(cod_sucursal)
);

commit;
