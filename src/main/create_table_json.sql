-- Modelo de base de datos

-- =========================================
-- 1. TABLA: CLASIFICADO
-- =========================================
CREATE TABLE CLASIFICADO (
    ID_CLASIFICADO VARCHAR(20) PRIMARY KEY,

    CLASIFICADOR VARCHAR(60) NOT NULL
        CHECK (CLASIFICADOR IN ('ROGER', 'YOLA', 'ISIDORA')),

    FECHA DATE,
    IMPORTE_TOTAL DECIMAL(14,2),
    OBSERVACIONES VARCHAR(500)
);

-- =========================================
-- 2. CLASIFICADO POR CALIDAD
-- =========================================
CREATE TABLE CLASIFICADO_CALIDAD (
    ID_CLASIFICADO VARCHAR(20) NOT NULL,

    SECCION VARCHAR(20)
        CHECK (SECCION IN ('HUACAYO', 'SURI')),

    CALIDAD VARCHAR(30)
        CHECK (CALIDAD IN (
            'ROYAL','BL-B','BL-X','FS-B','FS-X',
            'HZ-B','HZ-X','AG','STD',
            'SURI-BL','SURI-FS','SURI-HZ','SURI-STD'
        )),

    TOTAL_KG DECIMAL(10,2) NOT NULL
        CHECK (TOTAL_KG >= 0),

    PRIMARY KEY (ID_CLASIFICADO, SECCION, CALIDAD),

    FOREIGN KEY (ID_CLASIFICADO)
        REFERENCES CLASIFICADO(ID_CLASIFICADO)
        ON DELETE RESTRICT
);

-- =========================================
-- 3. CLASIFICADO DETALLE
-- =========================================
CREATE TABLE CLASIFICADO_DETALLE (
    ID_CLASIFICADO VARCHAR(20) NOT NULL,

    SECCION VARCHAR(20)
        CHECK (SECCION IN ('HUACAYO', 'SURI')),

    AGRUPACION VARCHAR(30)
        CHECK (AGRUPACION IN (
            'ROYAL','BL','FS','HZ','STD',
            'SURI','SURI-HZ','SURI-STD'
        )),

    TOTAL_KG DECIMAL(10,2) NOT NULL
        CHECK (TOTAL_KG >= 0),

    PRECIO_KG DECIMAL(10,2) NOT NULL
        CHECK (PRECIO_KG >= 0),

    SUBTOTAL_IMPORTE DECIMAL(12,2) NOT NULL
        CHECK (SUBTOTAL_IMPORTE >= 0),

    PRIMARY KEY (ID_CLASIFICADO, SECCION, AGRUPACION),

    FOREIGN KEY (ID_CLASIFICADO)
        REFERENCES CLASIFICADO(ID_CLASIFICADO)
        ON DELETE RESTRICT
);


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

