package com.pe.jm_alpaca_n8n_venta.config;

import io.vertx.core.Vertx;
import io.vertx.mysqlclient.MySQLConnectOptions;
import io.vertx.mysqlclient.MySQLPool;
import io.vertx.sqlclient.PoolOptions;
import jakarta.annotation.PreDestroy;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

@Configuration
public class VertxConfig {

    @Value("${mysql.host}")
    private String host;

    @Value("${mysql.port}")
    private int port;

    @Value("${mysql.database}")
    private String database;

    @Value("${mysql.username}")
    private String username;

    @Value("${mysql.password}")
    private String password;

    @Value("${mysql.pool.max-size}")
    private int maxSize;

    @Value("${mysql.connection.timeout}")
    private int connectionTimeout;

    private MySQLPool mySQLPool;

    @Bean
    public Vertx vertx() {
        return Vertx.vertx();
    }

    @Bean
    public MySQLPool mySQLPool(Vertx vertx) {
        MySQLConnectOptions connectOptions = new MySQLConnectOptions()
                .setHost(host)
                .setPort(port)
                .setDatabase(database)
                .setUser(username)
                .setPassword(password)
                .setCharset("utf8mb4")
                .setCollation("utf8mb4_unicode_ci");

        PoolOptions poolOptions = new PoolOptions()
                .setMaxSize(maxSize)
                .setConnectionTimeout(connectionTimeout)
                .setConnectionTimeoutUnit(TimeUnit.MILLISECONDS);

        this.mySQLPool = MySQLPool.pool(vertx, connectOptions, poolOptions);
        return this.mySQLPool;
    }

    @PreDestroy
    public void cleanup() {
        if (mySQLPool != null) {
            mySQLPool.close();
        }
    }
}
