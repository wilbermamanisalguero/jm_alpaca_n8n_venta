package com.pe.jm_alpaca_n8n_venta.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ErrorResponseDTO {
    private String error;
    private String mensaje;
    private LocalDateTime timestamp;
    private List<String> detalles;
}
