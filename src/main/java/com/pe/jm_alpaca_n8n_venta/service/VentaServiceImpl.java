package com.pe.jm_alpaca_n8n_venta.service;

import com.pe.jm_alpaca_n8n_venta.dto.DetalleVentaDTO;
import com.pe.jm_alpaca_n8n_venta.dto.VentaDTO;
import com.pe.jm_alpaca_n8n_venta.dto.VentaRequestDTO;
import com.pe.jm_alpaca_n8n_venta.dto.VentaResponseDTO;
import com.pe.jm_alpaca_n8n_venta.exception.VentaException;
import com.pe.jm_alpaca_n8n_venta.repository.VentaRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.concurrent.CompletableFuture;

@Service
public class VentaServiceImpl implements VentaService {

    private final VentaRepository ventaRepository;

    public VentaServiceImpl(VentaRepository ventaRepository) {
        this.ventaRepository = ventaRepository;
    }

    @Override
    public CompletableFuture<VentaResponseDTO> registrarVenta(VentaRequestDTO request) {
        VentaDTO ventaDTO = request.getVenta();

        validarVenta(ventaDTO);

        return ventaRepository.ejecutarTransaccion(ventaDTO)
                .thenApply(idVenta -> new VentaResponseDTO(
                        idVenta,
                        "Venta registrada exitosamente",
                        ventaDTO.getDetalle().size(),
                        LocalDateTime.now()
                ));
    }

    private void validarVenta(VentaDTO ventaDTO) {
        if (ventaDTO.getNombreArchivo() == null || ventaDTO.getNombreArchivo().isBlank()) {
            throw new VentaException("El ID de venta (nombreArchivo) es obligatorio");
        }

        validarCoherenciaTotales(ventaDTO);
    }

    private void validarCoherenciaTotales(VentaDTO ventaDTO) {
        BigDecimal sumaSubtotales = ventaDTO.getDetalle().stream()
                .map(DetalleVentaDTO::getImporteSubTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (sumaSubtotales.compareTo(ventaDTO.getImporteTotal()) != 0) {
            throw new VentaException(
                    String.format("Inconsistencia: suma detalles=%.2f, total declarado=%.2f",
                            sumaSubtotales, ventaDTO.getImporteTotal())
            );
        }

        for (DetalleVentaDTO detalle : ventaDTO.getDetalle()) {
            BigDecimal descuento = detalle.getDescuento() != null ? detalle.getDescuento() : BigDecimal.ZERO;
            BigDecimal subtotalCalculado = detalle.getValorUnitario()
                    .multiply(new BigDecimal(detalle.getCantidad()))
                    .subtract(descuento);

            if (subtotalCalculado.compareTo(detalle.getImporteSubTotal()) != 0) {
                throw new VentaException(
                        String.format("Subtotal incorrecto para producto '%s'. Esperado: %.2f, Recibido: %.2f",
                                detalle.getProducto(), subtotalCalculado, detalle.getImporteSubTotal())
                );
            }
        }
    }
}
