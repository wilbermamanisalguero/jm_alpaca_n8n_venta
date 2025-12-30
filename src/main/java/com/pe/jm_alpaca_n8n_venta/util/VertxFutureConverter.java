package com.pe.jm_alpaca_n8n_venta.util;

import io.vertx.core.Future;
import io.vertx.core.Promise;

import java.util.concurrent.CompletableFuture;

public class VertxFutureConverter {

    public static <T> CompletableFuture<T> toCompletableFuture(Future<T> vertxFuture) {
        CompletableFuture<T> completableFuture = new CompletableFuture<>();
        vertxFuture.onComplete(ar -> {
            if (ar.succeeded()) {
                completableFuture.complete(ar.result());
            } else {
                completableFuture.completeExceptionally(ar.cause());
            }
        });
        return completableFuture;
    }

    public static <T> Future<T> toVertxFuture(CompletableFuture<T> completableFuture) {
        Promise<T> promise = Promise.promise();
        completableFuture.whenComplete((result, error) -> {
            if (error != null) {
                promise.fail(error);
            } else {
                promise.complete(result);
            }
        });
        return promise.future();
    }
}
