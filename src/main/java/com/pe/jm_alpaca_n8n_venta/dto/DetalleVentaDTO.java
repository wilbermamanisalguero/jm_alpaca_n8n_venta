package com.pe.jm_alpaca_n8n_venta.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DetalleVentaDTO {

    @NotBlank(message = "El producto es obligatorio")
    private String producto;

    @NotBlank(message = "El tipo de producto es obligatorio")
    private String tipoProducto;

    @NotNull(message = "El peso es obligatorio")
    private BigDecimal peso;

    private BigDecimal descuento;

    @NotNull(message = "La cantidad es obligatoria")
    private Integer cantidad;

    @NotBlank(message = "La unidad de medida es obligatoria")
    private String unidadMedida;

    @NotNull(message = "El valor unitario es obligatorio")
    private BigDecimal valorUnitario;

    @NotNull(message = "El importe subtotal es obligatorio")
    private BigDecimal importeSubTotal;
}
