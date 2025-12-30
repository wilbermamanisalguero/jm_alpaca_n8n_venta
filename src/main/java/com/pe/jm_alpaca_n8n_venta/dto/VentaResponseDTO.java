package com.pe.jm_alpaca_n8n_venta.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VentaResponseDTO {
    private String idVenta;
    private String mensaje;
    private Integer detallesRegistrados;
    private LocalDateTime timestamp;
}
