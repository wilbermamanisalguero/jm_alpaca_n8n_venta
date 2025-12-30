package com.pe.jm_alpaca_n8n_venta.repository;

import com.pe.jm_alpaca_n8n_venta.dto.VentaDTO;

import java.util.concurrent.CompletableFuture;

public interface VentaRepository {
    CompletableFuture<String> ejecutarTransaccion(VentaDTO ventaDTO);
}
