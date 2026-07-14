USE pizzeria_don_piccolo;

DELIMITER //

-- Función para calcular el total de un pedido (sumando precios de pizzas + costo de envío + IVA).
-- Asumimos un IVA del 19%
CREATE FUNCTION calcular_total_pedido(p_id_pedido INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_subtotal_pizzas DECIMAL(10,2) DEFAULT 0;
    DECLARE v_costo_envio DECIMAL(10,2) DEFAULT 0;
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_iva DECIMAL(10,2);

    -- Obtener subtotal de pizzas
    SELECT IFNULL(SUM(subtotal), 0) INTO v_subtotal_pizzas
    FROM pedido_detalles
    WHERE id_pedido = p_id_pedido;

    -- Obtener costo de envío si aplica
    SELECT IFNULL(SUM(costo_envio), 0) INTO v_costo_envio
    FROM domicilios
    WHERE id_pedido = p_id_pedido;

    -- Calcular IVA (19%)
    SET v_iva = (v_subtotal_pizzas + v_costo_envio) * 0.19;

    -- Total final
    SET v_total = v_subtotal_pizzas + v_costo_envio + v_iva;

    RETURN v_total;
END //

-- Función para calcular la ganancia neta diaria (ventas - costos de ingredientes).
CREATE FUNCTION calcular_ganancia_diaria(p_fecha DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total_ventas DECIMAL(10,2) DEFAULT 0;
    DECLARE v_costo_ingredientes DECIMAL(10,2) DEFAULT 0;
    DECLARE v_ganancia DECIMAL(10,2);

    -- Ventas totales del día para pedidos entregados
    SELECT IFNULL(SUM(total), 0) INTO v_total_ventas
    FROM pedidos
    WHERE DATE(fecha_hora) = p_fecha AND estado = 'Entregado';

    -- Costo de ingredientes de los pedidos entregados
    SELECT IFNULL(SUM(pi.cantidad_requerida * i.costo_por_unidad * pd.cantidad), 0) INTO v_costo_ingredientes
    FROM pedidos p
    JOIN pedido_detalles pd ON p.id_pedido = pd.id_pedido
    JOIN pizza_ingredientes pi ON pd.id_pizza = pi.id_pizza
    JOIN ingredientes i ON pi.id_ingrediente = i.id_ingrediente
    WHERE DATE(p.fecha_hora) = p_fecha AND p.estado = 'Entregado';

    SET v_ganancia = v_total_ventas - v_costo_ingredientes;

    RETURN v_ganancia;
END //

-- Procedimiento para cambiar automáticamente el estado del pedido a “Entregado” cuando se registre la hora de entrega.
CREATE PROCEDURE registrar_hora_entrega(IN p_id_domicilio INT, IN p_hora_entrega DATETIME)
BEGIN
    DECLARE v_id_pedido INT;

    -- Actualizar hora de entrega en domicilio
    UPDATE domicilios 
    SET hora_entrega = p_hora_entrega
    WHERE id_domicilio = p_id_domicilio;

    -- Obtener id del pedido asociado al domicilio
    SELECT id_pedido INTO v_id_pedido
    FROM domicilios
    WHERE id_domicilio = p_id_domicilio;

    -- Actualizar estado del pedido a 'Entregado'
    UPDATE pedidos
    SET estado = 'Entregado'
    WHERE id_pedido = v_id_pedido;
    
END //

DELIMITER ;
