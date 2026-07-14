USE pizzeria_don_piccolo;

-- Vista de resumen de pedidos por cliente (nombre del cliente, cantidad de pedidos, total gastado).
CREATE OR REPLACE VIEW vista_resumen_clientes AS
SELECT 
    c.nombre AS cliente,
    COUNT(p.id_pedido) AS cantidad_pedidos,
    SUM(p.total) AS total_gastado
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre;

-- Vista de desempeño de repartidores (número de entregas, tiempo promedio, zona).
CREATE OR REPLACE VIEW vista_desempeno_repartidores AS
SELECT 
    r.nombre AS repartidor,
    r.zona_asignada AS zona,
    COUNT(d.id_domicilio) AS numero_entregas,
    AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS tiempo_promedio_minutos
FROM repartidores r
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.id_repartidor, r.nombre, r.zona_asignada;

-- Vista de stock de ingredientes por debajo del mínimo permitido.
CREATE OR REPLACE VIEW vista_alertas_stock AS
SELECT 
    nombre AS ingrediente,
    stock_disponible,
    stock_minimo,
    unidad_medida,
    (stock_minimo - stock_disponible) AS cantidad_a_reponer
FROM ingredientes
WHERE stock_disponible < stock_minimo;
