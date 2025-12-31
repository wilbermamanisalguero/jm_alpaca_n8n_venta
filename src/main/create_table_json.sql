/* ==========================================================
   YOJO LANAS - MODELO CLASIFICADO (MySQL)
   - Sin auditoría
   - SECCION y AGRUPACION como catálogos
   - CALIDAD mapea SECCION + AGRUPACION
   - CLASIFICADO_PESO: pesos[] por calidad (N filas)
   - CLASIFICADO_RESUMEN: total_kg por calidad (1 fila)
   - CLASIFICADO_DETALLE: totales por agrupación (1 fila)
   ========================================================== */

SET NAMES utf8mb4;
SET time_zone = 'America/Lima';

-- ==========================================================
-- LIMPIEZA (eliminar si existen)
-- ==========================================================
DROP TABLE IF EXISTS CLASIFICADO_DETALLE;
DROP TABLE IF EXISTS CLASIFICADO_RESUMEN;
DROP TABLE IF EXISTS CLASIFICADO_PESO;
DROP TABLE IF EXISTS CLASIFICADO;
DROP TABLE IF EXISTS CALIDAD;
DROP TABLE IF EXISTS AGRUPACION;
DROP TABLE IF EXISTS SECCION;

-- ==========================================================
-- CATALOGO: SECCION
-- ==========================================================
CREATE TABLE SECCION (
  ID_SECCION VARCHAR(20) NOT NULL,
  CONSTRAINT PK_SECCION PRIMARY KEY (ID_SECCION)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_spanish_ci;

INSERT INTO SECCION (ID_SECCION) VALUES
('HUACAYO'),
('SURI');

-- ==========================================================
-- CATALOGO: AGRUPACION (DETALLE)
-- ==========================================================
CREATE TABLE AGRUPACION (
  ID_AGRUPACION VARCHAR(30) NOT NULL,
  CONSTRAINT PK_AGRUPACION PRIMARY KEY (ID_AGRUPACION)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_spanish_ci;

INSERT INTO AGRUPACION (ID_AGRUPACION) VALUES
('ROYAL'),
('BL'),
('FS'),
('HZ'),
('STD'),
('SURI'),
('SURI-HZ'),
('SURI-STD');

-- ==========================================================
-- CATALOGO: CALIDAD (relaciona SECCION + AGRUPACION)
-- ==========================================================
CREATE TABLE CALIDAD (
  ID_CALIDAD    VARCHAR(30) NOT NULL,
  ID_SECCION    VARCHAR(20) NOT NULL,
  ID_AGRUPACION VARCHAR(30) NOT NULL,

  CONSTRAINT PK_CALIDAD PRIMARY KEY (ID_CALIDAD),

  CONSTRAINT FK_CALIDAD_SECCION
    FOREIGN KEY (ID_SECCION) REFERENCES SECCION(ID_SECCION),

  CONSTRAINT FK_CALIDAD_AGRUPACION
    FOREIGN KEY (ID_AGRUPACION) REFERENCES AGRUPACION(ID_AGRUPACION)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_spanish_ci;

INSERT INTO CALIDAD (ID_CALIDAD, ID_SECCION, ID_AGRUPACION) VALUES
-- HUACAYO
('ROYAL', 'HUACAYO', 'ROYAL'),
('BL-B',  'HUACAYO', 'BL'),
('BL-X',  'HUACAYO', 'BL'),
('FS-B',  'HUACAYO', 'FS'),
('FS-X',  'HUACAYO', 'FS'),
('HZ-B',  'HUACAYO', 'HZ'),
('HZ-X',  'HUACAYO', 'HZ'),
('AG',    'HUACAYO', 'HZ'),
('STD',   'HUACAYO', 'STD'),
-- SURI
('SURI-BL',  'SURI', 'SURI'),
('SURI-FS',  'SURI', 'SURI'),
('SURI-HZ',  'SURI', 'SURI-HZ'),
('SURI-STD', 'SURI', 'SURI-STD');

-- ==========================================================
-- TABLA: CLASIFICADO (cabecera)
-- ==========================================================
CREATE TABLE CLASIFICADO (
  ID_CLASIFICADO  VARCHAR(20) NOT NULL,
  CLASIFICADOR    VARCHAR(60) NOT NULL,
  FECHA           DATE NULL,
  IMPORTE_TOTAL   DECIMAL(14,2) NULL,
  OBSERVACIONES   VARCHAR(500) NULL,

  CONSTRAINT PK_CLASIFICADO PRIMARY KEY (ID_CLASIFICADO)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_spanish_ci;

-- ==========================================================
-- TABLA: CLASIFICADO_PESO (pesos[] por calidad)
-- ==========================================================
CREATE TABLE CLASIFICADO_PESO (
  ID_PESO         BIGINT NOT NULL AUTO_INCREMENT,
  ID_CLASIFICADO  VARCHAR(20) NOT NULL,
  ID_CALIDAD      VARCHAR(30) NOT NULL,
  PESO_KG         DECIMAL(10,2) NOT NULL,

  CONSTRAINT PK_CLASIFICADO_PESO PRIMARY KEY (ID_PESO),

  CONSTRAINT FK_CP_CLASIFICADO
    FOREIGN KEY (ID_CLASIFICADO)
    REFERENCES CLASIFICADO(ID_CLASIFICADO)
    ON DELETE RESTRICT,

  CONSTRAINT FK_CP_CALIDAD
    FOREIGN KEY (ID_CALIDAD)
    REFERENCES CALIDAD(ID_CALIDAD)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_spanish_ci;

-- ==========================================================
-- TABLA: CLASIFICADO_RESUMEN (total_kg por calidad)
-- ==========================================================
CREATE TABLE CLASIFICADO_RESUMEN (
  ID_CLASIFICADO VARCHAR(20) NOT NULL,
  ID_CALIDAD     VARCHAR(30) NOT NULL,
  TOTAL_KG       DECIMAL(10,2) NOT NULL,

  CONSTRAINT PK_CLASIFICADO_RESUMEN PRIMARY KEY (ID_CLASIFICADO, ID_CALIDAD),

  CONSTRAINT FK_CR_CLASIFICADO
    FOREIGN KEY (ID_CLASIFICADO)
    REFERENCES CLASIFICADO(ID_CLASIFICADO)
    ON DELETE RESTRICT,

  CONSTRAINT FK_CR_CALIDAD
    FOREIGN KEY (ID_CALIDAD)
    REFERENCES CALIDAD(ID_CALIDAD)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_spanish_ci;

-- ==========================================================
-- TABLA: CLASIFICADO_DETALLE (totales por agrupación)
-- ==========================================================
CREATE TABLE CLASIFICADO_DETALLE (
  ID_CLASIFICADO    VARCHAR(20) NOT NULL,
  ID_AGRUPACION     VARCHAR(30) NOT NULL,
  TOTAL_KG          DECIMAL(10,2) NOT NULL,
  PRECIO_KG         DECIMAL(10,2) NOT NULL,
  SUBTOTAL_IMPORTE  DECIMAL(12,2) NOT NULL,

  CONSTRAINT PK_CLASIFICADO_DETALLE PRIMARY KEY (ID_CLASIFICADO, ID_AGRUPACION),

  CONSTRAINT FK_CD_CLASIFICADO
    FOREIGN KEY (ID_CLASIFICADO)
    REFERENCES CLASIFICADO(ID_CLASIFICADO)
    ON DELETE RESTRICT,

  CONSTRAINT FK_CD_AGRUPACION
    FOREIGN KEY (ID_AGRUPACION)
    REFERENCES AGRUPACION(ID_AGRUPACION)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_spanish_ci;

-- ==========================================================
-- INDICES RECOMENDADOS
-- ==========================================================
CREATE INDEX IX_CALIDAD_SECCION   ON CALIDAD (ID_SECCION);
CREATE INDEX IX_CALIDAD_AGRUP     ON CALIDAD (ID_AGRUPACION);

CREATE INDEX IX_CP_CLASIF_CALIDAD ON CLASIFICADO_PESO (ID_CLASIFICADO, ID_CALIDAD);
CREATE INDEX IX_CR_ID_CALIDAD     ON CLASIFICADO_RESUMEN (ID_CALIDAD);
CREATE INDEX IX_CD_ID_AGRUPACION  ON CLASIFICADO_DETALLE (ID_AGRUPACION);

-- ==========================================================
-- FIN DEL SCRIPT
-- ==========================================================


--- JSON


{
  "id_clasificado": "CLAS-001",
  "clasificador": "ROGER",
  "fecha": "2025-01-15",
  "importe_total": 12500.75,
  "observaciones": "Clasificado de campaña enero",

  "calidades": [
    {
      "seccion": "HUACAYO",
      "calidad": "ROYAL",
      "total_kg": 320.50
    },
    {
      "seccion": "HUACAYO",
      "calidad": "BL-B",
      "total_kg": 210.00
    },
    {
      "seccion": "SURI",
      "calidad": "SURI-FS",
      "total_kg": 150.75
    }
  ],

  "detalles": [
    {
      "seccion": "HUACAYO",
      "agrupacion": "ROYAL",
      "total_kg": 320.50,
      "precio_kg": 18.50,
      "subtotal_importe": 5929.25
    },
    {
      "seccion": "HUACAYO",
      "agrupacion": "BL",
      "total_kg": 210.00,
      "precio_kg": 15.00,
      "subtotal_importe": 3150.00
    },
    {
      "seccion": "SURI",
      "agrupacion": "SURI",
      "total_kg": 150.75,
      "precio_kg": 22.50,
      "subtotal_importe": 3391.50
    }
  ]
}

