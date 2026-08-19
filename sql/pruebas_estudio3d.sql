-- ===================================================================
--  PROYECTO: Estudio de Impresion 3D - Grupo 1
--  Mora Eduardo, Santana James, Santiago Herrera
--
--  SENTENCIAS DE PRUEBA
--  Sirven para comprobar que todo lo del proyecto funciona.
--  Se pueden ejecutar una por una en MySQL Workbench.
--  Al final hay una seccion para dejar la base como estaba.
-- ===================================================================

USE estudio3d;


-- ===================================================================
--  1) TRIGGERS
-- ===================================================================

-- 1.1 El subtotal se calcula solo al insertar.
--     Se manda 0 a proposito y el trigger igual pone 3 x 22.50 = 67.50
CALL sp_detalle_pedido_insertar(3, 22.50, 0, 1, 'FIL-PLA-B');

SELECT ID_Detalle, Cantidad, Precio_Unitario, Subtotal
FROM DETALLE_PEDIDO
ORDER BY ID_Detalle DESC
LIMIT 1;


-- 1.2 El subtotal se vuelve a calcular al editar.
--     Se cambia la cantidad a 10 y el subtotal debe pasar a 225.00
UPDATE DETALLE_PEDIDO
SET Cantidad = 10
WHERE ID_Detalle = (SELECT MAX(ID_Detalle) FROM (SELECT ID_Detalle FROM DETALLE_PEDIDO) AS t);

SELECT ID_Detalle, Cantidad, Precio_Unitario, Subtotal
FROM DETALLE_PEDIDO
ORDER BY ID_Detalle DESC
LIMIT 1;


-- 1.3 El consumo descuenta el material del inventario.
--     Antes de registrar el consumo:
SELECT ID_Material, Tipo, Color, Stock_Actual FROM MATERIAL WHERE ID_Material = 1;

CALL sp_consumo_material_insertar(50, 5, '2026-08-10', 1, 1);

--     Despues: el stock bajo 55 (50 de material bueno + 5 desperdiciado)
SELECT ID_Material, Tipo, Color, Stock_Actual FROM MATERIAL WHERE ID_Material = 1;


-- ===================================================================
--  2) REPORTES (cada uno junta 3 o mas tablas)
-- ===================================================================

-- 2.1 Pedidos con su cliente y sus productos
SELECT * FROM v_reporte_pedidos;

-- 2.2 Produccion: orden, maquina y operador
SELECT * FROM v_reporte_produccion;

-- 2.3 Consumo de material por orden, con el costo
SELECT * FROM v_reporte_consumo;

-- 2.4 Entregas: transportadora y encargado
SELECT * FROM v_reporte_entregas;


-- ===================================================================
--  3) PROCEDIMIENTOS Y SUS VALIDACIONES
-- ===================================================================

-- 3.1 Insertar un cliente nuevo (funciona)
CALL sp_cliente_insertar('0900000000999', 'Cliente De Prueba', 'prueba@mail.com', '0999999999');
SELECT * FROM CLIENTE WHERE Cedula_ID = '0900000000999';

-- 3.2 Actualizarlo
CALL sp_cliente_actualizar('0900000000999', 'Cliente Editado', 'editado@mail.com', '0988888888');
SELECT * FROM CLIENTE WHERE Cedula_ID = '0900000000999';

-- 3.3 Eliminarlo
CALL sp_cliente_eliminar('0900000000999');
SELECT * FROM CLIENTE WHERE Cedula_ID = '0900000000999';   -- ya no aparece


-- 3.4 VALIDACION: cedula repetida
--     Debe salir: 'Ya existe un registro con esa clave en CLIENTE'
CALL sp_cliente_insertar('0950000000001', 'Repetido', 'x@x.com', '0900000000');

-- 3.5 VALIDACION: calificacion fuera de 1 a 5
--     Debe salir: 'La calificacion de resistencia va de 1 a 5'
CALL sp_encuesta_satisfaccion_insertar(9, 9, 'prueba', 1, '2026-08-10', 1, '0950000000001', 2);

-- 3.6 VALIDACION: editar algo que no existe
--     Debe salir: 'No existe ese registro en CLIENTE'
CALL sp_cliente_actualizar('1111111111111', 'No existe', 'x@x.com', '0900000000');

-- 3.7 VALIDACION: borrar un cliente que tiene pedidos
--     Debe salir: 'No se pudo eliminar de CLIENTE, puede tener registros relacionados'
CALL sp_cliente_eliminar('0950000000001');


-- 3.8 ROLLBACK: se intenta un pedido con un cliente que no existe.
--     Debe dar error y NO debe quedar ninguna fila nueva.
SELECT COUNT(*) AS pedidos_antes FROM PEDIDO;

CALL sp_pedido_insertar('2026-08-10 10:00:00', 'Catalogo', 'Pendiente', '2026-08-20', 50.00, '9999999999999');

SELECT COUNT(*) AS pedidos_despues FROM PEDIDO;   -- tiene que ser el mismo numero


-- ===================================================================
--  4) INDICES
-- ===================================================================

-- 4.1 Ver los indices que se crearon
SHOW INDEX FROM PEDIDO;
SHOW INDEX FROM ENCUESTA_SATISFACCION;

-- 4.2 Comprobar que el indice se usa.
--     En la columna 'key' debe aparecer idx_pedido_estado
EXPLAIN SELECT * FROM PEDIDO WHERE Estado_Actual = 'Entregado';

--     Aqui debe aparecer idx_producto_categoria
EXPLAIN SELECT * FROM PRODUCTO WHERE Categoria = 'Filamento';

--     Aqui el indice de dos columnas: idx_encuesta_emp_fecha
EXPLAIN SELECT * FROM ENCUESTA_SATISFACCION
        WHERE ID_Empleado = 2 AND Fecha_Respuesta BETWEEN '2026-06-01' AND '2026-06-30';


-- ===================================================================
--  5) USUARIOS Y PERMISOS
-- ===================================================================

-- 5.1 Ver los permisos de cada uno
SHOW GRANTS FOR 'santiago_herrera'@'localhost';   -- Santiago (administrador)
SHOW GRANTS FOR 'james_santana'@'localhost';      -- James (aplicacion)
SHOW GRANTS FOR 'eduardo_mora'@'localhost';       -- Eduardo (produccion y reportes)
SHOW GRANTS FOR 'bodeguero01'@'localhost';
SHOW GRANTS FOR 'despachador01'@'localhost';
SHOW GRANTS FOR 'cliente_consulta'@'localhost';

-- 5.2 Para probar que los permisos de verdad limitan, hay que abrir una
--     conexion nueva con ese usuario (en Workbench: Database > Connect to Database)
--     y ejecutar estas sentencias:
--
--     Con eduardo_mora (clave Eduardo_2026):
--         SELECT * FROM v_reporte_produccion;  -- SI puede
--         SELECT * FROM CLIENTE;               -- NO puede, no tiene permiso
--
--     Con cliente_consulta (clave Clie_2026):
--         SELECT Codigo_Producto, Nombre, Precio FROM PRODUCTO;   -- SI puede
--         SELECT Stock FROM PRODUCTO;                             -- NO puede


-- ===================================================================
--  6) DEJAR LA BASE COMO ESTABA
--     (borra lo que insertaron las pruebas de arriba)
-- ===================================================================

DELETE FROM CONSUMO_MATERIAL WHERE ID_Consumo > 10;
DELETE FROM DETALLE_PEDIDO   WHERE ID_Detalle > 10;
DELETE FROM CLIENTE          WHERE Cedula_ID = '0900000000999';
UPDATE MATERIAL SET Stock_Actual = 5000.00 WHERE ID_Material = 1;

-- Comprobacion final: deben salir 10 filas en cada tabla
SELECT 'CLIENTE' AS tabla, COUNT(*) AS filas FROM CLIENTE
UNION ALL SELECT 'DETALLE_PEDIDO', COUNT(*) FROM DETALLE_PEDIDO
UNION ALL SELECT 'CONSUMO_MATERIAL', COUNT(*) FROM CONSUMO_MATERIAL;
