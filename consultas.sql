USE pizzeria_don_piccolo;

-- 1. Clientes con pedidos entre dos fechas (BETWEEN).
SELECT DISTINCT clientes.nombre, clientes.telefono, clientes.correo
FROM clientes
JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente
WHERE pedidos.fecha_hora BETWEEN '2025-03-01 00:00:00' AND '2025-03-31 23:59:59';

-- 2. Pizzas más vendidas (GROUP BY y COUNT).
SELECT pizzas.nombre, pizzas.tamano, SUM(pedido_detalles.cantidad) AS total_vendidas
FROM pizzas
JOIN pedido_detalles ON pizzas.id_pizza = pedido_detalles.id_pizza
GROUP BY pizzas.id_pizza, pizzas.nombre, pizzas.tamano
ORDER BY total_vendidas DESC;

-- 3. Pedidos por repartidor (JOIN).
SELECT repartidores.nombre AS repartidor, repartidores.zona_asignada, pedidos.id_pedido, pedidos.fecha_hora, pedidos.estado
FROM repartidores
JOIN domicilios ON repartidores.id_repartidor = domicilios.id_repartidor
JOIN pedidos ON domicilios.id_pedido = pedidos.id_pedido
ORDER BY repartidores.nombre, pedidos.fecha_hora DESC;

-- 4. Promedio de entrega por zona (AVG y JOIN).
SELECT repartidores.zona_asignada, 
       AVG(TIMESTAMPDIFF(MINUTE, domicilios.hora_salida, domicilios.hora_entrega)) AS promedio_minutos
FROM repartidores
JOIN domicilios ON repartidores.id_repartidor = domicilios.id_repartidor
WHERE domicilios.hora_entrega IS NOT NULL
GROUP BY repartidores.zona_asignada;

-- 5. Clientes que gastaron más de un monto (HAVING).
-- Ejemplo: Clientes que han gastado más de $500.00 en total.
SELECT clientes.nombre, SUM(pedidos.total) AS total_gastado
FROM clientes
JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente
GROUP BY clientes.id_cliente, clientes.nombre
HAVING SUM(pedidos.total) > 500.00;

-- 6. Búsqueda por coincidencia parcial de nombre de pizza (LIKE).
-- Ejemplo: Buscar pizzas que tengan la palabra 'Queso'.
SELECT nombre, tamano, precio_base, tipo
FROM pizzas
WHERE nombre LIKE '%Queso%';

-- 7. Subconsulta para obtener los clientes frecuentes (más de 1 pedido mensual).
SELECT nombre, telefono, correo
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM pedidos
    WHERE MONTH(fecha_hora) = 3 
      AND YEAR(fecha_hora) = 2025
    GROUP BY id_cliente
    HAVING COUNT(id_pedido) > 1
);

-- ============================================================
-- CONSULTAS AVANZADAS: Window Functions, CTEs y Evento Programado
-- ============================================================

-- 8. Ranking de clientes por gasto total (RANK y Window Functions).
-- RANK() asigna un puesto a cada cliente según cuánto ha gastado en total.
-- Si dos clientes empataran, ambos tendrían el mismo puesto y el siguiente se saltaría.
SELECT 
    c.nombre AS cliente,
    SUM(p.total) AS total_gastado,
    RANK() OVER (ORDER BY SUM(p.total) DESC) AS ranking
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.estado = 'Entregado'
GROUP BY c.id_cliente, c.nombre;

-- 9. Porcentaje de participación de cada pizza en las ventas totales (SUM() OVER()).
-- Usa una Window Function sin PARTITION BY para calcular el total global y dividir cada pizza entre ese total.
SELECT 
    pz.nombre AS pizza,
    pz.tamano,
    SUM(pd.subtotal) AS ventas_pizza,
    SUM(SUM(pd.subtotal)) OVER () AS ventas_totales,
    ROUND(SUM(pd.subtotal) / SUM(SUM(pd.subtotal)) OVER () * 100, 2) AS porcentaje_participacion
FROM pizzas pz
JOIN pedido_detalles pd ON pz.id_pizza = pd.id_pizza
GROUP BY pz.id_pizza, pz.nombre, pz.tamano
ORDER BY porcentaje_participacion DESC;

-- 10. Comparación del total de cada pedido con el pedido anterior del mismo cliente (LAG).
-- LAG() mira "hacia atrás" una fila dentro de la misma partición (mismo cliente), ordenado por fecha.
SELECT 
    c.nombre AS cliente,
    p.id_pedido,
    p.fecha_hora,
    p.total AS total_actual,
    LAG(p.total) OVER (PARTITION BY p.id_cliente ORDER BY p.fecha_hora) AS total_pedido_anterior,
    p.total - IFNULL(LAG(p.total) OVER (PARTITION BY p.id_cliente ORDER BY p.fecha_hora), 0) AS diferencia
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.estado = 'Entregado'
ORDER BY c.nombre, p.fecha_hora;

-- 11. Numeración de entregas por repartidor (ROW_NUMBER).
-- ROW_NUMBER() asigna un número secuencial a cada entrega dentro del mismo repartidor.
SELECT 
    r.nombre AS repartidor,
    d.id_domicilio,
    d.hora_salida,
    d.hora_entrega,
    ROW_NUMBER() OVER (PARTITION BY r.id_repartidor ORDER BY d.hora_salida) AS numero_entrega
FROM repartidores r
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
WHERE d.hora_entrega IS NOT NULL;

-- 12. Reporte completo de rentabilidad por pizza usando CTE (Common Table Expression).
-- Un CTE (WITH ... AS) es como una tabla temporal que solo existe durante la ejecución de la consulta.
-- Es más legible que anidar subconsultas y permite reutilizar resultados intermedios.
WITH ventas_por_pizza AS (
    SELECT 
        pd.id_pizza,
        SUM(pd.cantidad) AS unidades_vendidas,
        SUM(pd.subtotal) AS ingreso_total
    FROM pedido_detalles pd
    JOIN pedidos p ON pd.id_pedido = p.id_pedido
    WHERE p.estado = 'Entregado'
    GROUP BY pd.id_pizza
),
costo_por_pizza AS (
    SELECT 
        pi.id_pizza,
        SUM(pi.cantidad_requerida * i.costo_por_unidad) AS costo_unitario
    FROM pizza_ingredientes pi
    JOIN ingredientes i ON pi.id_ingrediente = i.id_ingrediente
    GROUP BY pi.id_pizza
)
SELECT 
    pz.nombre AS pizza,
    pz.tamano,
    pz.precio_base,
    vp.unidades_vendidas,
    vp.ingreso_total,
    cp.costo_unitario,
    (cp.costo_unitario * vp.unidades_vendidas) AS costo_total,
    (vp.ingreso_total - (cp.costo_unitario * vp.unidades_vendidas)) AS ganancia_neta,
    ROUND((vp.ingreso_total - (cp.costo_unitario * vp.unidades_vendidas)) / vp.ingreso_total * 100, 2) AS margen_porcentaje
FROM pizzas pz
JOIN ventas_por_pizza vp ON pz.id_pizza = vp.id_pizza
JOIN costo_por_pizza cp ON pz.id_pizza = cp.id_pizza
ORDER BY ganancia_neta DESC;

-- 13. Top 3 días con más ventas usando CTE + LIMIT.
WITH ventas_diarias AS (
    SELECT 
        DATE(fecha_hora) AS fecha,
        COUNT(*) AS cantidad_pedidos,
        SUM(total) AS total_ventas
    FROM pedidos
    WHERE estado = 'Entregado'
    GROUP BY DATE(fecha_hora)
)
SELECT 
    fecha,
    cantidad_pedidos,
    total_ventas,
    RANK() OVER (ORDER BY total_ventas DESC) AS ranking
FROM ventas_diarias
ORDER BY total_ventas DESC
LIMIT 3;

-- ============================================================
-- EVENTO PROGRAMADO: Alerta automática de stock bajo (CREATE EVENT)
-- ============================================================
-- Este evento se ejecuta automáticamente todos los días a medianoche.
-- Revisa qué ingredientes están por debajo de su stock mínimo y registra una alerta.
-- Requisito: SET GLOBAL event_scheduler = ON;

DELIMITER //

CREATE EVENT IF NOT EXISTS ev_alerta_stock_diaria
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
COMMENT 'Revisa el inventario diariamente y genera alertas para ingredientes bajo mínimo'
DO
BEGIN
    INSERT INTO alertas_stock (id_ingrediente, nombre_ingrediente, stock_actual, stock_minimo, cantidad_a_reponer)
    SELECT 
        i.id_ingrediente,
        i.nombre,
        i.stock_disponible,
        i.stock_minimo,
        (i.stock_minimo - i.stock_disponible)
    FROM ingredientes i
    WHERE i.stock_disponible < i.stock_minimo
    -- Evitar duplicados: solo insertar si no existe ya una alerta no atendida para ese ingrediente
    AND i.id_ingrediente NOT IN (
        SELECT a.id_ingrediente FROM alertas_stock a WHERE a.atendida = FALSE
    );
END //

DELIMITER ;
-- Las consultas del examen son las siguientes:
-- 1. Consulta de entregas realizadas por cada repartidor

SELECT 
    r.nombre,
    COUNT(d.id_domicilio) AS cantidad_entregas,
    SUM(p.total) AS total_acumulado
FROM 
    repartidores r
JOIN 
    domicilios d ON r.id_repartidor = d.id_repartidor
JOIN 
    pedidos p ON d.id_pedido = p.id_pedido
WHERE 
    d.estado = 'entregado'
GROUP BY 
    r.id_repartidor, r.nombre;
DELIMITER ; 
-- 2. Consulta de pedidos demorados
SELECT 
    d.id_pedido, 
    d.hora_salida, 
    d.hora_entrega,
    TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega) AS minutos_demora
FROM 
    domicilios d
WHERE 
    TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega) > 40;
DELIMITER ;
-- 3. Consulta de repartidores activos sin entregas
-- Muestra los repartidores con estado 'activo' que no tienen domicilios asignados
SELECT 
    r.id_repartidor,
    r.nombre
FROM 
    repartidores r
LEFT JOIN 
    domicilios d ON r.id_repartidor = d.id_repartidor
WHERE 
    r.estado = 'activo' AND d.id_domicilio IS NULL;
DELIMITER ;



