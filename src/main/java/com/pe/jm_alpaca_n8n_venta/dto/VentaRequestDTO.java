package com.pe.jm_alpaca_n8n_venta.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VentaRequestDTO {

    @Valid
    @NotNull(message = "Los datos de venta son obligatorios")
    private VentaDTO venta;
}
