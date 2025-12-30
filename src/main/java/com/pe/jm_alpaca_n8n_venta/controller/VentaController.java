package com.pe.jm_alpaca_n8n_venta.controller;

import com.pe.jm_alpaca_n8n_venta.dto.VentaRequestDTO;
import com.pe.jm_alpaca_n8n_venta.dto.VentaResponseDTO;
import com.pe.jm_alpaca_n8n_venta.service.VentaService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/venta")
@Validated
public class VentaController {

    private final VentaService ventaService;

    public VentaController(VentaService ventaService) {
        this.ventaService = ventaService;
    }

    @PostMapping("/registrar")
    public CompletableFuture<ResponseEntity<VentaResponseDTO>> registrarVenta(
            @Valid @RequestBody VentaRequestDTO request) {

        return ventaService.registrarVenta(request)
                .thenApply(response -> ResponseEntity.status(HttpStatus.CREATED).body(response));
    }
}
