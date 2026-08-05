-- Encargado del SQL: Santiago Herrera

use estudio3d;

-- cliente (10)

insert into CLIENTE (Cedula_ID, Nombre, Correo, Telefono) values
('0950000000001', 'Carlos Vera', 'cvera@mail.com', '0991110001'),
('0950000000002', 'Andrea Salas', 'asalas@mail.com', '0991110002'),
('0950000000003', 'Jorge Lema', 'jlema@mail.com', '0991110003'),
('0950000000004', 'Lucia Paz', 'lpaz@mail.com', '0991110004'),
('0950000000005', 'Maria Rios', 'mrios@mail.com', '0991110005'),
('0950000000006', 'Diego Luna', 'dluna@mail.com', '0991110006'),
('0950000000007', 'Paola Nunez', 'pnunez@mail.com', '0991110007'),
('0950000000008', 'Sofia Mena', 'smena@mail.com', '0991110008'),
('0950000000009', 'Kevin Ortiz', 'kortiz@mail.com', '0991110009'),
('0950000000010', 'Valeria Cede', 'vcede@mail.com', '0991110010');

-- empleado (10)

insert into EMPLEADO (ID_Empleado, Nombre, Rol, Telefono) values
(1, 'Maria Garcia', 'Vendedor', '0981000001'),
(2, 'Juan Soto', 'Operador', '0981000002'),
(3, 'Ana Perez', 'Diseñador', '0981000003'),
(4, 'Luis Mejia', 'Bodega', '0981000004'),
(5, 'Paola Ruiz', 'Operador', '0981000005'),
(6, 'Diego Cobo', 'Mantenimiento', '0981000006'),
(7, 'Sofia Zamora', 'Vendedor', '0981000007'),
(8, 'Kevin Bravo', 'Operador', '0981000008'),
(9, 'Lucia Alarcon', 'Despacho', '0981000009'),
(10, 'Rene Torres', 'Calidad', '0981000010');

-- proveedor (10)

insert into PROVEEDOR (ID_Proveedor, Nombre, Telefono, Correo) values
(1, 'Filamentos Andinos', '022200001', 'ventas@filandinos.com'),
(2, 'Resin Pro EC', '022200002', 'contacto@resinpro.ec'),
(3, 'PrintSupply', '022200003', 'info@printsupply.com'),
(4, 'Tech3D Parts', '022200004', 'sales@tech3dparts.com'),
(5, 'Maq Center', '022200005', 'maq@center.com'),
(6, 'Global Additive', '022200006', 'hola@globaladd.com'),
(7, 'Nova Print', '022200007', 'ventas@novaprint.com'),
(8, 'RoboMakers', '022200008', 'info@robomakers.com'),
(9, 'SLA House', '022200009', 'ventas@slahouse.com'),
(10, 'FDM Planet', '022200010', 'contacto@fdmplanet.com');

-- transportadora (10)

insert into TRANSPORTADORA (ID_Transportadora, Nombre, Telefono, Sitio_Web) values
(1, 'Servientrega', '1800000001', 'https://www.servientrega.com'),
(2, 'Tramaco', '1800000002', 'https://www.tramaco.com'),
(3, 'Laarcourier', '1800000003', 'https://www.laarcourier.com'),
(4, 'RapidExpress', '1800000004', 'https://www.rapidexpress.ec'),
(5, 'CargoPlus', '1800000005', 'https://www.cargoplus.ec'),
(6, 'EnviaYa', '1800000006', 'https://www.enviaya.ec'),
(7, 'PackAndGo', '1800000007', 'https://www.packandgo.ec'),
(8, 'UrbanoShip', '1800000008', 'https://www.urbanoship.ec'),
(9, 'RastroFast', '1800000009', 'https://www.rastrofast.ec'),
(10, 'AndesCourier', '1800000010', 'https://www.andescourier.ec');

-- material (10)

insert into MATERIAL (ID_Material, Tipo, Color, Unidad, Stock_Actual, Costo_Unitario) values
(1, 'PLA', 'Rojo', 'g', 5000.00, 0.022),
(2, 'PLA', 'Blanco', 'g', 4200.00, 0.022),
(3, 'PETG', 'Negro', 'g', 3100.00, 0.026),
(4, 'ABS', 'Gris', 'g', 2800.00, 0.029),
(5, 'Resina', 'Gris', 'ml', 6000.00, 0.075),
(6, 'Resina', 'Transparente', 'ml', 3500.00, 0.082),
(7, 'TPU', 'Negro', 'g', 1500.00, 0.031),
(8, 'Nylon', 'Natural', 'g', 1200.00, 0.038),
(9, 'PLA', 'Azul', 'g', 2600.00, 0.022),
(10, 'PETG', 'Blanco', 'g', 2200.00, 0.027);

-- producto (10)

insert into PRODUCTO (Codigo_Producto, Nombre, Precio, Categoria, Tipo_Garantia, Stock) values
('FIL-PLA-R', 'Filamento PLA Rojo 1kg', 22.50, 'Filamento', '30 dias', 14),
('FIL-PLA-B', 'Filamento PLA Blanco 1kg', 22.50, 'Filamento', '30 dias', 8),
('FIL-PET-N', 'Filamento PETG Negro 1kg', 26.00, 'Filamento', '30 dias', 0),
('FIL-ABS-G', 'Filamento ABS Gris 1kg', 29.00, 'Filamento', '30 dias', 6),
('RES-GRY-1', 'Resina Gris 1L', 75.00, 'Resina', '15 dias', 7),
('RES-TRN-1', 'Resina Transparente 1L', 82.00, 'Resina', '15 dias', 5),
('ACC-BOQ-04', 'Boquilla 0.4mm', 6.50, 'Accesorio', '90 dias', 20),
('ACC-CAM-PT', 'Cama PEI Texturizada', 35.00, 'Accesorio', '90 dias', 9),
('ACC-NOZ-06', 'Boquilla 0.6mm', 7.20, 'Accesorio', '90 dias', 16),
('ACC-PTFE-2', 'Tubo PTFE 2m', 8.90, 'Accesorio', '90 dias', 12);

-- impresora_3d (10)

insert into IMPRESORA_3D (Codigo_Interno, Marca, Modelo, Tecnologia, Numero_Serie, Fecha_Compra, Estado, ID_Proveedor) values
('IMP-FDM-01', 'Creality', 'Ender 3 S1', 'FDM', 'SN-FDM-0001', '2024-01-15', 'Activa', 1),
('IMP-FDM-02', 'Prusa', 'MK4', 'FDM', 'SN-FDM-0002', '2024-02-01', 'Activa', 2),
('IMP-FDM-03', 'Bambu', 'P1S', 'FDM', 'SN-FDM-0003', '2024-03-10', 'Activa', 3),
('IMP-SLA-01', 'Anycubic', 'Photon M3', 'SLA', 'SN-SLA-0001', '2024-01-28', 'Activa', 4),
('IMP-SLA-02', 'Elegoo', 'Mars 4', 'SLA', 'SN-SLA-0002', '2024-04-19', 'Mantenimiento', 5),
('IMP-FDM-04', 'Creality', 'K1', 'FDM', 'SN-FDM-0004', '2024-05-02', 'Activa', 6),
('IMP-FDM-05', 'Artillery', 'X2', 'FDM', 'SN-FDM-0005', '2024-06-15', 'Activa', 7),
('IMP-SLA-03', 'Phrozen', 'Sonic Mini', 'SLA', 'SN-SLA-0003', '2024-07-22', 'Activa', 8),
('IMP-FDM-06', 'Qidi', 'X-Plus', 'FDM', 'SN-FDM-0006', '2024-08-11', 'Activa', 9),
('IMP-FDM-07', 'Raise3D', 'E2', 'FDM', 'SN-FDM-0007', '2024-09-03', 'Activa', 10);

-- pedido (10)

insert into PEDIDO (Numero_Pedido, Fecha_Hora, Tipo, Estado_Actual, Fecha_Estim_Entrega, Total, Cedula_ID) values
(1, '2026-06-01 09:15:00', 'Personalizado', 'Pendiente', '2026-06-08', 45.00, '0950000000001'),
(2, '2026-06-02 10:20:00', 'Catalogo', 'En impresion', '2026-06-09', 52.00, '0950000000002'),
(3, '2026-06-03 11:25:00', 'Personalizado', 'Post-procesado', '2026-06-10', 75.00, '0950000000003'),
(4, '2026-06-04 12:10:00', 'Catalogo', 'Enviado', '2026-06-11', 120.00, '0950000000004'),
(5, '2026-06-05 13:05:00', 'Catalogo', 'Entregado', '2026-06-12', 89.00, '0950000000005'),
(6, '2026-06-06 14:40:00', 'Personalizado', 'Pendiente', '2026-06-13', 38.00, '0950000000006'),
(7, '2026-06-07 15:00:00', 'Catalogo', 'En impresion', '2026-06-14', 64.00, '0950000000007'),
(8, '2026-06-08 16:30:00', 'Personalizado', 'Post-procesado', '2026-06-15', 98.00, '0950000000008'),
(9, '2026-06-09 17:45:00', 'Catalogo', 'Enviado', '2026-06-16', 33.00, '0950000000009'),
(10, '2026-06-10 18:55:00', 'Personalizado', 'Entregado', '2026-06-17', 150.00, '0950000000010');

-- detalle_pedido (10)

insert into DETALLE_PEDIDO (ID_Detalle, Cantidad, Precio_Unitario, Subtotal, Numero_Pedido, Codigo_Producto) values
(1, 2, 22.50, 45.00, 1, 'FIL-PLA-R'),
(2, 2, 26.00, 52.00, 2, 'FIL-PET-N'),
(3, 1, 75.00, 75.00, 3, 'RES-GRY-1'),
(4, 4, 30.00, 120.00, 4, 'ACC-CAM-PT'),
(5, 1, 89.00, 89.00, 5, 'RES-TRN-1'),
(6, 4, 9.50, 38.00, 6, 'ACC-PTFE-2'),
(7, 8, 8.00, 64.00, 7, 'ACC-NOZ-06'),
(8, 14, 7.00, 98.00, 8, 'ACC-BOQ-04'),
(9, 1, 33.00, 33.00, 9, 'FIL-ABS-G'),
(10, 2, 75.00, 150.00, 10, 'RES-GRY-1');

-- factura (10)

insert into FACTURA (Numero_Factura, Fecha_Emision, Total, Estado_Pago, Forma_Pago, Fecha_Pago, Numero_Pedido) values
(1, '2026-06-01', 45.00, 'Pagado', 'Tarjeta', '2026-06-01', 1),
(2, '2026-06-02', 52.00, 'Pendiente', null, null, 2),
(3, '2026-06-03', 75.00, 'Pagado', 'Transferencia', '2026-06-03', 3),
(4, '2026-06-04', 120.00, 'Pagado', 'Tarjeta', '2026-06-07', 4),
(5, '2026-06-05', 89.00, 'Pendiente', null, null, 5),
(6, '2026-06-06', 38.00, 'Pagado', 'Efectivo', '2026-06-06', 6),
(7, '2026-06-07', 64.00, 'Pendiente', null, null, 7),
(8, '2026-06-08', 98.00, 'Pagado', 'Transferencia', '2026-06-09', 8),
(9, '2026-06-09', 33.00, 'Pagado', 'Tarjeta', '2026-06-10', 9),
(10, '2026-06-10', 150.00, 'Pendiente', null, null, 10);

-- solicitud_impresion (10)

insert into SOLICITUD_IMPRESION (ID_Solicitud, Descripcion, Referencias_Visuales, Color, Escala, Fecha_Solicitud, Numero_Pedido, ID_Material) values
(1, 'Llaveros corporativos', 'ref_llavero_01.png', 'Rojo', 1.00, '2026-06-01', 1, 1),
(2, 'Prototipo carcasa', 'ref_carcasa_02.png', 'Negro', 1.20, '2026-06-02', 2, 3),
(3, 'Figura coleccionable', 'ref_figura_03.png', 'Gris', 0.80, '2026-06-03', 3, 5),
(4, 'Soporte de camara', 'ref_soporte_04.png', 'Blanco', 1.00, '2026-06-04', 4, 2),
(5, 'Logo de escritorio', 'ref_logo_05.png', 'Transparente', 0.90, '2026-06-05', 5, 6),
(6, 'Pieza mecanica', 'ref_pieza_06.png', 'Gris', 1.50, '2026-06-06', 6, 4),
(7, 'Base para sensor', 'ref_base_07.png', 'Azul', 1.00, '2026-06-07', 7, 9),
(8, 'Miniatura arquitectonica', 'ref_mini_08.png', 'Natural', 0.70, '2026-06-08', 8, 8),
(9, 'Clip industrial', 'ref_clip_09.png', 'Negro', 1.10, '2026-06-09', 9, 7),
(10, 'Carcasa drone', 'ref_drone_10.png', 'Blanco', 1.30, '2026-06-10', 10, 10);

-- render_preliminar (10)

insert into RENDER_PRELIMINAR (ID_Render, Fecha_Envio, Imagen, Respuesta, Comentarios, Fecha_Respuesta, Numero_Pedido, ID_Empleado, Cedula_ID) values
(1, '2026-06-01', 'render_01.png', 'Aprobado', 'Todo correcto', '2026-06-01', 1, 3, '0950000000001'),
(2, '2026-06-02', 'render_02.png', 'Aprobado', 'Ajustar borde', '2026-06-02', 2, 3, '0950000000002'),
(3, '2026-06-03', 'render_03.png', 'Aprobado', 'Sin cambios', '2026-06-03', 3, 10, '0950000000003'),
(4, '2026-06-04', 'render_04.png', 'Rechazado', 'Cambiar color', '2026-06-04', 4, 10, '0950000000004'),
(5, '2026-06-05', 'render_05.png', 'Aprobado', 'Perfecto', '2026-06-05', 5, 3, '0950000000005'),
(6, '2026-06-06', 'render_06.png', 'Aprobado', 'Reducir escala', '2026-06-06', 6, 10, '0950000000006'),
(7, '2026-06-07', 'render_07.png', 'Aprobado', 'Ok', '2026-06-07', 7, 3, '0950000000007'),
(8, '2026-06-08', 'render_08.png', 'Aprobado', 'Sin observacion', '2026-06-08', 8, 10, '0950000000008'),
(9, '2026-06-09', 'render_09.png', 'Aprobado', 'Listo para producir', '2026-06-09', 9, 3, '0950000000009'),
(10, '2026-06-10', 'render_10.png', 'Aprobado', 'Continuar', '2026-06-10', 10, 10, '0950000000010');

-- orden_impresion (10)

insert into ORDEN_IMPRESION (ID_Orden, Gramos_Proyectados, Tiempo_Estimado, Fecha_Inicio, Fecha_Fin, Estado, Numero_Pedido, Codigo_Interno, ID_Empleado) values
(1, 120.00, 3.50, '2026-06-01 10:00:00', '2026-06-01 13:30:00', 'Finalizada', 1, 'IMP-FDM-01', 2),
(2, 210.00, 5.00, '2026-06-02 11:00:00', '2026-06-02 16:00:00', 'Finalizada', 2, 'IMP-FDM-02', 5),
(3, 95.00, 4.20, '2026-06-03 09:00:00', '2026-06-03 13:12:00', 'Finalizada', 3, 'IMP-SLA-01', 8),
(4, 300.00, 7.00, '2026-06-04 08:30:00', '2026-06-04 15:30:00', 'Finalizada', 4, 'IMP-FDM-03', 2),
(5, 145.00, 4.80, '2026-06-05 10:20:00', '2026-06-05 15:08:00', 'Finalizada', 5, 'IMP-SLA-03', 8),
(6, 80.00, 2.90, '2026-06-06 12:00:00', '2026-06-06 14:54:00', 'Finalizada', 6, 'IMP-FDM-04', 5),
(7, 160.00, 5.60, '2026-06-07 09:40:00', '2026-06-07 15:16:00', 'En proceso', 7, 'IMP-FDM-05', 2),
(8, 260.00, 6.40, '2026-06-08 11:20:00', '2026-06-08 17:44:00', 'En proceso', 8, 'IMP-FDM-06', 5),
(9, 70.00, 2.30, '2026-06-09 13:15:00', '2026-06-09 15:33:00', 'Finalizada', 9, 'IMP-FDM-07', 8),
(10, 330.00, 8.10, '2026-06-10 07:50:00', '2026-06-10 15:56:00', 'En proceso', 10, 'IMP-FDM-02', 2);

-- consumo_material (10)

insert into CONSUMO_MATERIAL (ID_Consumo, Material_Bueno, Material_Desperdiciado, Fecha, ID_Orden, ID_Material) values
(1, 115.00, 5.00, '2026-06-01', 1, 1),
(2, 200.00, 10.00, '2026-06-02', 2, 3),
(3, 90.00, 5.00, '2026-06-03', 3, 5),
(4, 286.00, 14.00, '2026-06-04', 4, 2),
(5, 138.00, 7.00, '2026-06-05', 5, 6),
(6, 76.00, 4.00, '2026-06-06', 6, 4),
(7, 151.00, 9.00, '2026-06-07', 7, 9),
(8, 247.00, 13.00, '2026-06-08', 8, 8),
(9, 66.00, 4.00, '2026-06-09', 9, 7),
(10, 315.00, 15.00, '2026-06-10', 10, 10);

-- fallo_impresion (10)

insert into FALLO_IMPRESION (ID_Fallo, Tipo_Fallo, Material_Desperdiciado, Tiempo_Perdido, Causa, Fue_Reimpresa, Costo_Reproceso, ID_Orden, ID_Empleado) values
(1, 'Warping', 3.00, 0.80, 'Cama fria', 1, 2.10, 1, 2),
(2, 'Adherencia', 4.00, 1.10, 'Nivelacion irregular', 1, 3.00, 2, 5),
(3, 'Laminado', 2.50, 0.70, 'Exceso de exposicion', 0, 1.90, 3, 8),
(4, 'Stringing', 1.80, 0.50, 'Temperatura alta', 1, 1.20, 4, 2),
(5, 'Soportes', 2.20, 0.60, 'Soporte insuficiente', 1, 1.70, 5, 8),
(6, 'Desplazamiento', 3.40, 0.90, 'Correa floja', 1, 2.40, 6, 5),
(7, 'Subextrusion', 2.00, 0.70, 'Boquilla obstruida', 1, 1.50, 7, 2),
(8, 'Huecos', 2.70, 0.80, 'Flujo bajo', 0, 1.80, 8, 5),
(9, 'Despegue', 1.60, 0.40, 'Superficie sucia', 1, 1.10, 9, 8),
(10, 'Sobrecalentamiento', 3.10, 1.00, 'Ventilacion deficiente', 0, 2.20, 10, 2);

-- mantenimiento (10)

insert into MANTENIMIENTO (ID_Mantenimiento, Fecha, Tipo, Descripcion, Codigo_Interno, ID_Empleado) values
(1, '2026-05-20', 'Preventivo', 'Limpieza general y ajuste ejes', 'IMP-FDM-01', 6),
(2, '2026-05-21', 'Correctivo', 'Cambio de boquilla', 'IMP-FDM-02', 6),
(3, '2026-05-22', 'Preventivo', 'Calibracion de cama', 'IMP-FDM-03', 6),
(4, '2026-05-23', 'Preventivo', 'Cambio de FEP', 'IMP-SLA-01', 6),
(5, '2026-05-24', 'Correctivo', 'Cambio de pantalla LCD', 'IMP-SLA-02', 6),
(6, '2026-05-25', 'Preventivo', 'Lubricacion de guias', 'IMP-FDM-04', 6),
(7, '2026-05-26', 'Preventivo', 'Ajuste de extrusor', 'IMP-FDM-05', 6),
(8, '2026-05-27', 'Correctivo', 'Cambio de ventilador', 'IMP-SLA-03', 6),
(9, '2026-05-28', 'Preventivo', 'Tension de correas', 'IMP-FDM-06', 6),
(10, '2026-05-29', 'Preventivo', 'Revision electrica', 'IMP-FDM-07', 6);

-- entrada_material (10)

insert into ENTRADA_MATERIAL (Numero_Entrada, Fecha_Recepcion, Cantidad, Fecha_Vencimiento, Estado_Empaque, ID_Proveedor, ID_Material, ID_Empleado) values
(1, '2026-05-01', 1000.00, '2028-05-01', 'Sellado', 1, 1, 4),
(2, '2026-05-02', 1000.00, '2028-05-02', 'Sellado', 2, 2, 4),
(3, '2026-05-03', 800.00, '2028-05-03', 'Sellado', 3, 3, 4),
(4, '2026-05-04', 700.00, '2028-05-04', 'Sellado', 4, 4, 4),
(5, '2026-05-05', 1200.00, '2027-05-05', 'Integro', 5, 5, 4),
(6, '2026-05-06', 900.00, '2027-05-06', 'Integro', 6, 6, 4),
(7, '2026-05-07', 600.00, '2028-05-07', 'Sellado', 7, 7, 4),
(8, '2026-05-08', 500.00, '2028-05-08', 'Sellado', 8, 8, 4),
(9, '2026-05-09', 700.00, '2028-05-09', 'Integro', 9, 9, 4),
(10, '2026-05-10', 650.00, '2028-05-10', 'Integro', 10, 10, 4);

-- despacho (10)

insert into DESPACHO (ID_Despacho, Codigo_Rastreo, Fecha_Envio, Fecha_Entrega, Estado, Numero_Pedido, ID_Empleado, ID_Transportadora) values
(1, 'TRK-0001', '2026-06-02', '2026-06-03', 'Entregado', 1, 9, 1),
(2, 'TRK-0002', '2026-06-03', null, 'En ruta', 2, 9, 2),
(3, 'TRK-0003', '2026-06-04', '2026-06-05', 'Entregado', 3, 9, 3),
(4, 'TRK-0004', '2026-06-05', '2026-06-06', 'Entregado', 4, 9, 4),
(5, 'TRK-0005', '2026-06-06', null, 'En ruta', 5, 9, 5),
(6, 'TRK-0006', '2026-06-07', '2026-06-08', 'Entregado', 6, 9, 6),
(7, 'TRK-0007', '2026-06-08', null, 'En ruta', 7, 9, 7),
(8, 'TRK-0008', '2026-06-09', null, 'En ruta', 8, 9, 8),
(9, 'TRK-0009', '2026-06-10', '2026-06-11', 'Entregado', 9, 9, 9),
(10, 'TRK-0010', '2026-06-11', null, 'Preparado', 10, 9, 10);

-- encuesta_satisfaccion (10)

insert into ENCUESTA_SATISFACCION (ID_Encuesta, Calif_Resistencia, Calif_Acabado, Comentario, Recomienda, Fecha_Respuesta, Numero_Pedido, Cedula_ID, ID_Empleado) values
(1, 5, 4, 'Muy buen trabajo', 1, '2026-06-05', 1, '0950000000001', 2),
(2, 4, 4, 'Cumple lo esperado', 1, '2026-06-06', 2, '0950000000002', 5),
(3, 5, 5, 'Excelente acabado', 1, '2026-06-07', 3, '0950000000003', 8),
(4, 3, 4, 'Buena atencion', 1, '2026-06-08', 4, '0950000000004', 2),
(5, 4, 3, 'Tiempo de entrega aceptable', 1, '2026-06-09', 5, '0950000000005', 5),
(6, 5, 4, 'Recomendado', 1, '2026-06-10', 6, '0950000000006', 8),
(7, 4, 5, 'Muy conforme', 1, '2026-06-11', 7, '0950000000007', 2),
(8, 3, 3, 'Puede mejorar', 0, '2026-06-12', 8, '0950000000008', 5),
(9, 5, 4, 'Buen soporte', 1, '2026-06-13', 9, '0950000000009', 8),
(10, 4, 5, 'Trabajo prolijo', 1, '2026-06-14', 10, '0950000000010', 2);
