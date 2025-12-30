package com.pe.jm_alpaca_n8n_venta.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VentaDTO {

    @NotBlank(message = "El nombre de archivo (ID_VENTA) es obligatorio")
    private String nombreArchivo;

    @NotBlank(message = "El tipo de venta es obligatorio")
    private String tipoVenta;

    @NotNull(message = "La fecha de despacho es obligatoria")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate fechaDespacho;

    @NotNull(message = "El RUC del vendedor es obligatorio")
    private Long rucVendedor;

    @NotBlank(message = "El nombre del vendedor es obligatorio")
    private String vendedor;

    private String codigoFactura;

    @NotNull(message = "El RUC del cliente es obligatorio")
    private Long rucCliente;

    @NotBlank(message = "El nombre del cliente es obligatorio")
    private String cliente;

    private String facturaAnticipo;

    @NotBlank(message = "El tipo de moneda es obligatorio")
    private String tipoMoneda;

    @NotNull(message = "El importe total es obligatorio")
    private BigDecimal importeTotal;

    private String observacion;

    @Valid
    @NotEmpty(message = "Debe incluir al menos un detalle de venta")
    private List<DetalleVentaDTO> detalle;
}
