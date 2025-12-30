package com.pe.jm_alpaca_n8n_venta.exception;

import com.pe.jm_alpaca_n8n_venta.dto.ErrorResponseDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(VentaException.class)
    public ResponseEntity<ErrorResponseDTO> handleVentaException(VentaException ex) {
        ErrorResponseDTO error = new ErrorResponseDTO(
                "VENTA_ERROR",
                ex.getMessage(),
                LocalDateTime.now(),
                null
        );
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    @ExceptionHandler(DatabaseException.class)
    public ResponseEntity<ErrorResponseDTO> handleDatabaseException(DatabaseException ex) {
        ErrorResponseDTO error = new ErrorResponseDTO(
                "DATABASE_ERROR",
                "Error al procesar la transacción",
                LocalDateTime.now(),
                List.of(ex.getMessage())
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponseDTO> handleValidationException(MethodArgumentNotValidException ex) {
        List<String> detalles = ex.getBindingResult().getFieldErrors().stream()
                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                .collect(Collectors.toList());

        ErrorResponseDTO error = new ErrorResponseDTO(
                "VALIDATION_ERROR",
                "Errores de validación en los datos enviados",
                LocalDateTime.now(),
                detalles
        );
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponseDTO> handleGenericException(Exception ex) {
        ErrorResponseDTO error = new ErrorResponseDTO(
                "INTERNAL_ERROR",
                "Error inesperado en el servidor",
                LocalDateTime.now(),
                List.of(ex.getMessage())
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
