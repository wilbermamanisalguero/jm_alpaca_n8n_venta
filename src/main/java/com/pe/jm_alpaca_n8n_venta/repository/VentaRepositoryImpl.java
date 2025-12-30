package com.pe.jm_alpaca_n8n_venta.repository;

import com.pe.jm_alpaca_n8n_venta.dto.DetalleVentaDTO;
import com.pe.jm_alpaca_n8n_venta.dto.VentaDTO;
import com.pe.jm_alpaca_n8n_venta.exception.DatabaseException;
import com.pe.jm_alpaca_n8n_venta.util.VertxFutureConverter;
import io.vertx.core.Future;
import io.vertx.mysqlclient.MySQLPool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.SqlConnection;
import io.vertx.sqlclient.Tuple;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@Repository
public class VentaRepositoryImpl implements VentaRepository {

    private final MySQLPool pool;

    public VentaRepositoryImpl(MySQLPool pool) {
        this.pool = pool;
    }

    @Override
    public CompletableFuture<String> ejecutarTransaccion(VentaDTO ventaDTO) {
        Future<String> future = pool.getConnection()
                .compose(conn -> conn.begin()
                        .compose(tx -> verificarInsertarCliente(conn, ventaDTO.getRucCliente(), ventaDTO.getCliente())
                                .compose(v -> verificarInsertarVendedor(conn, ventaDTO.getRucVendedor(), ventaDTO.getVendedor()))
                                .compose(v -> insertarVenta(conn, ventaDTO))
                                .compose(idVenta -> insertarDetalles(conn, idVenta, ventaDTO.getDetalle())
                                        .map(idVenta))
                                .compose(idVenta -> tx.commit().map(idVenta))
                                .onFailure(err -> tx.rollback()))
                        .eventually(v -> conn.close()));

        return VertxFutureConverter.toCompletableFuture(future)
                .exceptionally(ex -> {
                    throw new DatabaseException("Error en la transacción de venta", ex);
                });
    }

    private Future<Void> verificarInsertarCliente(SqlConnection conn, Long rucCliente, String nombreCliente) {
        String selectSql = "SELECT COUNT(*) as count FROM CLIENTE WHERE RUC_CLIENTE = ?";

        return conn.preparedQuery(selectSql)
                .execute(Tuple.of(rucCliente))
                .compose(rows -> {
                    Row row = rows.iterator().next();
                    int count = row.getInteger("count");

                    if (count == 0) {
                        String insertSql = "INSERT INTO CLIENTE (RUC_CLIENTE, NOMBRE_CLIENTE) VALUES (?, ?)";
                        return conn.preparedQuery(insertSql)
                                .execute(Tuple.of(rucCliente, nombreCliente))
                                .mapEmpty();
                    }
                    return Future.succeededFuture();
                });
    }

    private Future<Void> verificarInsertarVendedor(SqlConnection conn, Long rucVendedor, String nombreVendedor) {
        String selectSql = "SELECT COUNT(*) as count FROM VENDEDOR WHERE RUC_VENDEDOR = ?";

        return conn.preparedQuery(selectSql)
                .execute(Tuple.of(rucVendedor))
                .compose(rows -> {
                    Row row = rows.iterator().next();
                    int count = row.getInteger("count");

                    if (count == 0) {
                        String insertSql = "INSERT INTO VENDEDOR (RUC_VENDEDOR, NOMBRE_VENDEDOR) VALUES (?, ?)";
                        return conn.preparedQuery(insertSql)
                                .execute(Tuple.of(rucVendedor, nombreVendedor))
                                .mapEmpty();
                    }
                    return Future.succeededFuture();
                });
    }

    private Future<String> insertarVenta(SqlConnection conn, VentaDTO ventaDTO) {
        String sql = """
                INSERT INTO VENTA (
                    ID_VENTA, TIPO_VENTA, FECHA_DESPACHO, RUC_VENDEDOR, VENDEDOR,
                    CODIGO_FACTURA, RUC_CLIENTE, CLIENTE, FACTURA_ANTICIPO,
                    TIPO_MONEDA, IMPORTE_TOTAL, OBSERVACION
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        Tuple params = Tuple.of(
                ventaDTO.getNombreArchivo(),
                ventaDTO.getTipoVenta(),
                ventaDTO.getFechaDespacho(),
                ventaDTO.getRucVendedor(),
                ventaDTO.getVendedor(),
                ventaDTO.getCodigoFactura(),
                ventaDTO.getRucCliente(),
                ventaDTO.getCliente(),
                ventaDTO.getFacturaAnticipo(),
                ventaDTO.getTipoMoneda(),
                ventaDTO.getImporteTotal(),
                ventaDTO.getObservacion()
        );

        return conn.preparedQuery(sql)
                .execute(params)
                .map(ventaDTO.getNombreArchivo());
    }

    private Future<Void> insertarDetalles(SqlConnection conn, String idVenta, List<DetalleVentaDTO> detalles) {
        String sql = """
                INSERT INTO VENTA_DETALLE (
                    ID_VENTA, PRODUCTO, TIPO_PRODUCTO, PESO, DESCUENTO,
                    CANTIDAD, UNIDAD_MEDIDA, VALOR_UNITARIO, IMPORTE_SUBTOTAL
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        List<Tuple> batch = detalles.stream()
                .map(detalle -> Tuple.of(
                        idVenta,
                        detalle.getProducto(),
                        detalle.getTipoProducto(),
                        detalle.getPeso(),
                        detalle.getDescuento() != null ? detalle.getDescuento() : 0,
                        detalle.getCantidad(),
                        detalle.getUnidadMedida(),
                        detalle.getValorUnitario(),
                        detalle.getImporteSubTotal()
                ))
                .collect(Collectors.toList());

        return conn.preparedQuery(sql)
                .executeBatch(batch)
                .mapEmpty();
    }
}
