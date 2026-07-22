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

-- Vista de desempeño de repartidores (entregas_totales, promedio_minutos_entrega, nombre_repartidor).
CREATE OR REPLACE VIEW vista_desempeno_repartidor AS
SELECT 
    r.nombre AS nombre_repartidor,
    COUNT(d.id_domicilio) AS entregas_totales,
    AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS promedio_minutos_entrega
FROM 
    repartidores r
LEFT JOIN 
    domicilios d ON r.id_repartidor = d.id_repartidor AND d.estado = 'entregado'
GROUP BY 
    r.id_repartidor, r.nombre;

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

-- Vista de menú disponible: Solo muestra las pizzas que se pueden preparar con el stock actual.
-- Usa GROUP BY + HAVING para verificar que TODOS los ingredientes de cada pizza tengan stock suficiente.
CREATE OR REPLACE VIEW vista_menu_disponible AS
SELECT 
    p.id_pizza,
    p.nombre AS pizza,
    p.tamano,
    p.precio_base,
    p.tipo
FROM pizzas p
WHERE p.id_pizza NOT IN (
    -- Subconsulta: IDs de pizzas que tienen AL MENOS UN ingrediente sin stock suficiente
    SELECT pi.id_pizza
    FROM pizza_ingredientes pi
    JOIN ingredientes i ON pi.id_ingrediente = i.id_ingrediente
    WHERE i.stock_disponible < pi.cantidad_requerida
);
