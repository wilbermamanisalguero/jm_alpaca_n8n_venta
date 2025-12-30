package com.pe.jm_alpaca_n8n_venta.exception;

public class VentaException extends RuntimeException {

    public VentaException(String message) {
        super(message);
    }

    public VentaException(String message, Throwable cause) {
        super(message, cause);
    }
}
