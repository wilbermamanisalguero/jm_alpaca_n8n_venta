package com.pe.jm_alpaca_n8n_venta.service;

import com.pe.jm_alpaca_n8n_venta.dto.VentaRequestDTO;
import com.pe.jm_alpaca_n8n_venta.dto.VentaResponseDTO;

import java.util.concurrent.CompletableFuture;

public interface VentaService {
    CompletableFuture<VentaResponseDTO> registrarVenta(VentaRequestDTO request);
}
