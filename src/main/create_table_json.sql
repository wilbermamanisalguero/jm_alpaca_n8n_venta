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


---
--





Realizar una aplicacion adaptable para web, tablet y celular , una aplicacion moderna y adaptable 

Revisar imagen y realizar un prompt  

🔴 Paso 1: Identificar el clasificador y la fecha
🔴 Paso 2: Conversión del esquema a texto
  Encabezados / columnas (parte superior)
  
  Primera Sección Huacayo
		Royal
		BL-B
		BL-X
		FS-B
		FS-X
		HZ-B
		HZ-X
		AG
		STD	

   Segunda Sección Suri		
		SURI-BL
		SURI-FS
		SURI-HZ
 
		
🔴 Paso 3: Anota los Peso por cada columna o encabezado 
🔴 Paso 4: Suma cada columna por cada calidad
🔴 Paso 5: Realiza suma agrupada
   
    (total BL-B) suma (total BL-X) es igual BL
    (total FS-B) suma (total FS-X) es igual FS
    (total HZ-B) suma (total HZ-X)  suma (total AG) es igual HZ		
	(total SURI-BL) suma (total SURI-FS) es igual SURI
	
	
🔴 Paso 6: Poner precio y multiplicar

  Primera Sección Huacayo
  
    Royal * precio = importe subtotal
    BL * precio = importe subtotal
    FS * precio = importe subtotal
    HZ * precio = importe subtotal
	STD * precio= importe subtotal

Segunda Sección Suri	
	
	SURI * precio= importe subtotal
	SURI-HZ * precio= importe subtotal
	
	
🔴 Paso 7: Suma  de todos importe subtotal	, el cual debe ser importe total

		Parte inferior izquierda – Flujo de clasificado
		Clasificado  ↓
		Clasificado_detalle
		(Dentro del cuadro: Producto)
		 ↓
		Clasificado_calculo
		(Dentro del cuadro: precio)
		
Mejorar el json 

{
  "fuente": null,
  "metadatos": {
    "clasificador": null,
    "fecha": null
  },
  "secciones": {
    "huacayo": {
      "calidades": {
        "Royal": {
          "pesos": [],
          "total_kg": null
        },
        "BL-B": {
          "pesos": [],
          "total_kg": null
        },
        "BL-X": {
          "pesos": [],
          "total_kg": null
        },
        "FS-B": {
          "pesos": [],
          "total_kg": null
        },
        "FS-X": {
          "pesos": [],
          "total_kg": null
        },
        "HZ-B": {
          "pesos": [],
          "total_kg": null
        },
        "HZ-X": {
          "pesos": [],
          "total_kg": null
        },
        "AG": {
          "pesos": [],
          "total_kg": null
        },
        "STD": {
          "pesos": [],
          "total_kg": null
        }
      }
    },
    "suri": {
      "calidades": {
        "SURI-BL": {
          "pesos": [],
          "total_kg": null
        },
        "SURI-FS": {
          "pesos": [],
          "total_kg": null
        },
        "SURI-HZ": {
          "pesos": [],
          "total_kg": null
        },
        "SURI-STD": {
          "pesos": [],
          "total_kg": null
        }
      }
    }
  },
  "agrupaciones": {
    "BL": {
      "componentes": ["BL-B", "BL-X"],
      "total_kg": null,
      "precio_kg": null,
      "importe": null
    },
    "FS": {
      "componentes": ["FS-B", "FS-X"],
      "total_kg": null,
      "precio_kg": null,
      "importe": null
    },
    "HZ": {
      "componentes": ["HZ-B", "HZ-X", "AG"],
      "total_kg": null,
      "precio_kg": null,
      "importe": null
    },
    "SURI": {
      "componentes": ["SURI-BL", "SURI-FS"],
      "total_kg": null
    }
  },
  "calculos": {
    "importe_total": null,
    "moneda": null
  },
  "adelantos": {
    "items": [],
    "total": null
  },
  "saldos": {
    "total_calculado": null,
    "saldo_final": null
  },
  "flujo_proceso": [
    "Clasificado",
    "Clasificado_detalle (Producto)",
    "Clasificado_calculo (Precio)"
  ]
}







{  
  "clasificado": {
    "clasificador": null,
    "fecha": null,   
    "observaciones": null,
	"importe_total": null
  },
  "clasificado_calidad": {
    "huacayo": {
      "calidades": {
        "Royal": { "pesos": [], "total_kg": null },
        "BL-B": { "pesos": [], "total_kg": null },
        "BL-X": { "pesos": [], "total_kg": null },
        "FS-B": { "pesos": [], "total_kg": null },
        "FS-X": { "pesos": [], "total_kg": null },
        "HZ-B": { "pesos": [], "total_kg": null },
        "HZ-X": { "pesos": [], "total_kg": null },
        "AG": { "pesos": [], "total_kg": null },
        "STD": { "pesos": [], "total_kg": null }
      }
    },
    "suri": {
      "calidades": {
        "SURI-BL": { "pesos": [], "total_kg": null },
        "SURI-FS": { "pesos": [], "total_kg": null },
        "SURI-HZ": { "pesos": [], "total_kg": null },
        "SURI-STD": { "pesos": [], "total_kg": null }
      }
    }
  },
  "clasificado_detalle": {
    "huacayo": {
      "Royal": {
        "componentes": ["Royal"],
        "total_kg": null,
        "precio_kg": null,
        "sub_total_importe": null
      },
      "BL": {
        "componentes": ["BL-B", "BL-X"],
        "total_kg": null,
        "precio_kg": null,
        "sub_total_importe": null
      },
      "FS": {
        "componentes": ["FS-B", "FS-X"],
        "total_kg": null,
        "precio_kg": null,
        "sub_total_importe": null
      },
      "HZ": {
        "componentes": ["HZ-B", "HZ-X", "AG"],
        "total_kg": null,
        "precio_kg": null,
        "sub_total_importe": null
      },
      "STD": {
        "componentes": ["STD"],
        "total_kg": null,
        "precio_kg": null,
        "sub_total_importe": null
      }
    },
    "suri": {
      "SURI": {
        "componentes": ["SURI-BL", "SURI-FS"],
        "total_kg": null,
        "precio_kg": null,
        "sub_total_importe": null
      },
      "SURI-HZ": {
        "componentes": ["SURI-HZ"],
        "total_kg": null,
        "precio_kg": null,
        "sub_total_importe": null
      },
      "SURI-STD": {
        "componentes": ["SURI-STD"],
        "total_kg": null,
        "precio_kg": null,
        "sub_total_importe": null
      }
    }
  }
}



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

