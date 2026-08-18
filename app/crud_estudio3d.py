import mysql.connector

conexion = mysql.connector.connect(
    host="localhost",
    user="root",
    password="1234",
    database="estudio3d"
)
cursor = conexion.cursor()


def mostrar(sql, datos=()):
    cursor.execute(sql, datos)
    filas = cursor.fetchall()
    titulos = ""
    for columna in cursor.description:
        titulos = titulos + columna[0] + " | "
    print()
    print(titulos)
    for fila in filas:
        linea = ""
        for valor in fila:
            if valor is None:
                linea = linea + "- | "
            else:
                linea = linea + str(valor) + " | "
        print(linea)
    print("Total de filas:", len(filas))


def pedir(texto, obligatorio):
    while True:
        valor = input(texto)
        if valor != "":
            return valor
        if not obligatorio:
            return None
        print("Ese dato es obligatorio")


def confirmar():
    return input("Seguro que desea eliminar? (s/n): ").lower() == "s"


def crud_cliente():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Clientes (CLIENTE) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            cedula_id = pedir("Cedula_ID: ", True)
            nombre = pedir("Nombre: ", True)
            correo = pedir("Correo: ", False)
            telefono = pedir("Telefono: ", False)
            try:
                cursor.execute("CALL sp_cliente_insertar(%s, %s, %s, %s)",
                               (cedula_id, nombre, correo, telefono))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM CLIENTE")
        elif opcion == "3":
            clave = pedir("Cedula_ID del registro a editar: ", True)
            nombre = pedir("Nombre: ", True)
            correo = pedir("Correo: ", False)
            telefono = pedir("Telefono: ", False)
            try:
                cursor.execute("CALL sp_cliente_actualizar(%s, %s, %s, %s)",
                               (clave, nombre, correo, telefono))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Cedula_ID del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_cliente_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_empleado():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Empleados (EMPLEADO) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            nombre = pedir("Nombre: ", True)
            rol = pedir("Rol: ", True)
            telefono = pedir("Telefono: ", False)
            try:
                cursor.execute("CALL sp_empleado_insertar(%s, %s, %s)",
                               (nombre, rol, telefono))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM EMPLEADO")
        elif opcion == "3":
            clave = pedir("ID_Empleado del registro a editar: ", True)
            nombre = pedir("Nombre: ", True)
            rol = pedir("Rol: ", True)
            telefono = pedir("Telefono: ", False)
            try:
                cursor.execute("CALL sp_empleado_actualizar(%s, %s, %s, %s)",
                               (clave, nombre, rol, telefono))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Empleado del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_empleado_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_proveedor():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Proveedores (PROVEEDOR) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            nombre = pedir("Nombre: ", True)
            telefono = pedir("Telefono: ", False)
            correo = pedir("Correo: ", False)
            try:
                cursor.execute("CALL sp_proveedor_insertar(%s, %s, %s)",
                               (nombre, telefono, correo))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM PROVEEDOR")
        elif opcion == "3":
            clave = pedir("ID_Proveedor del registro a editar: ", True)
            nombre = pedir("Nombre: ", True)
            telefono = pedir("Telefono: ", False)
            correo = pedir("Correo: ", False)
            try:
                cursor.execute("CALL sp_proveedor_actualizar(%s, %s, %s, %s)",
                               (clave, nombre, telefono, correo))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Proveedor del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_proveedor_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_transportadora():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Transportadoras (TRANSPORTADORA) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            nombre = pedir("Nombre: ", True)
            telefono = pedir("Telefono: ", False)
            sitio_web = pedir("Sitio_Web: ", False)
            try:
                cursor.execute("CALL sp_transportadora_insertar(%s, %s, %s)",
                               (nombre, telefono, sitio_web))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM TRANSPORTADORA")
        elif opcion == "3":
            clave = pedir("ID_Transportadora del registro a editar: ", True)
            nombre = pedir("Nombre: ", True)
            telefono = pedir("Telefono: ", False)
            sitio_web = pedir("Sitio_Web: ", False)
            try:
                cursor.execute("CALL sp_transportadora_actualizar(%s, %s, %s, %s)",
                               (clave, nombre, telefono, sitio_web))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Transportadora del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_transportadora_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_material():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Materiales (MATERIAL) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            tipo = pedir("Tipo: ", True)
            color = pedir("Color: ", True)
            unidad = pedir("Unidad: ", True)
            stock_actual = pedir("Stock_Actual: ", True)
            costo_unitario = pedir("Costo_Unitario: ", True)
            try:
                cursor.execute("CALL sp_material_insertar(%s, %s, %s, %s, %s)",
                               (tipo, color, unidad, stock_actual, costo_unitario))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM MATERIAL")
        elif opcion == "3":
            clave = pedir("ID_Material del registro a editar: ", True)
            tipo = pedir("Tipo: ", True)
            color = pedir("Color: ", True)
            unidad = pedir("Unidad: ", True)
            stock_actual = pedir("Stock_Actual: ", True)
            costo_unitario = pedir("Costo_Unitario: ", True)
            try:
                cursor.execute("CALL sp_material_actualizar(%s, %s, %s, %s, %s, %s)",
                               (clave, tipo, color, unidad, stock_actual, costo_unitario))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Material del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_material_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_producto():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Productos (PRODUCTO) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            codigo_producto = pedir("Codigo_Producto: ", True)
            nombre = pedir("Nombre: ", True)
            precio = pedir("Precio: ", True)
            categoria = pedir("Categoria: ", True)
            tipo_garantia = pedir("Tipo_Garantia: ", False)
            stock = pedir("Stock: ", True)
            try:
                cursor.execute("CALL sp_producto_insertar(%s, %s, %s, %s, %s, %s)",
                               (codigo_producto, nombre, precio, categoria, tipo_garantia, stock))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM PRODUCTO")
        elif opcion == "3":
            clave = pedir("Codigo_Producto del registro a editar: ", True)
            nombre = pedir("Nombre: ", True)
            precio = pedir("Precio: ", True)
            categoria = pedir("Categoria: ", True)
            tipo_garantia = pedir("Tipo_Garantia: ", False)
            stock = pedir("Stock: ", True)
            try:
                cursor.execute("CALL sp_producto_actualizar(%s, %s, %s, %s, %s, %s)",
                               (clave, nombre, precio, categoria, tipo_garantia, stock))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Codigo_Producto del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_producto_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_impresora_3d():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Impresoras 3D (IMPRESORA_3D) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            codigo_interno = pedir("Codigo_Interno: ", True)
            marca = pedir("Marca: ", True)
            modelo = pedir("Modelo: ", True)
            tecnologia = pedir("Tecnologia: ", True)
            numero_serie = pedir("Numero_Serie: ", True)
            fecha_compra = pedir("Fecha_Compra: ", False)
            estado = pedir("Estado: ", True)
            id_proveedor = pedir("ID_Proveedor: ", True)
            try:
                cursor.execute("CALL sp_impresora_3d_insertar(%s, %s, %s, %s, %s, %s, %s, %s)",
                               (codigo_interno, marca, modelo, tecnologia, numero_serie, fecha_compra, estado, id_proveedor))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM IMPRESORA_3D")
        elif opcion == "3":
            clave = pedir("Codigo_Interno del registro a editar: ", True)
            marca = pedir("Marca: ", True)
            modelo = pedir("Modelo: ", True)
            tecnologia = pedir("Tecnologia: ", True)
            numero_serie = pedir("Numero_Serie: ", True)
            fecha_compra = pedir("Fecha_Compra: ", False)
            estado = pedir("Estado: ", True)
            id_proveedor = pedir("ID_Proveedor: ", True)
            try:
                cursor.execute("CALL sp_impresora_3d_actualizar(%s, %s, %s, %s, %s, %s, %s, %s)",
                               (clave, marca, modelo, tecnologia, numero_serie, fecha_compra, estado, id_proveedor))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Codigo_Interno del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_impresora_3d_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_pedido():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Pedidos (PEDIDO) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            fecha_hora = pedir("Fecha_Hora: ", True)
            tipo = pedir("Tipo: ", False)
            estado_actual = pedir("Estado_Actual: ", False)
            fecha_estim_entrega = pedir("Fecha_Estim_Entrega: ", False)
            total = pedir("Total: ", False)
            cedula_id = pedir("Cedula_ID: ", True)
            try:
                cursor.execute("CALL sp_pedido_insertar(%s, %s, %s, %s, %s, %s)",
                               (fecha_hora, tipo, estado_actual, fecha_estim_entrega, total, cedula_id))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM PEDIDO")
        elif opcion == "3":
            clave = pedir("Numero_Pedido del registro a editar: ", True)
            fecha_hora = pedir("Fecha_Hora: ", True)
            tipo = pedir("Tipo: ", False)
            estado_actual = pedir("Estado_Actual: ", False)
            fecha_estim_entrega = pedir("Fecha_Estim_Entrega: ", False)
            total = pedir("Total: ", False)
            cedula_id = pedir("Cedula_ID: ", True)
            try:
                cursor.execute("CALL sp_pedido_actualizar(%s, %s, %s, %s, %s, %s, %s)",
                               (clave, fecha_hora, tipo, estado_actual, fecha_estim_entrega, total, cedula_id))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Numero_Pedido del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_pedido_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_detalle_pedido():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Detalle de pedido (DETALLE_PEDIDO) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            cantidad = pedir("Cantidad: ", True)
            precio_unitario = pedir("Precio_Unitario: ", True)
            subtotal = pedir("Subtotal: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            codigo_producto = pedir("Codigo_Producto: ", True)
            try:
                cursor.execute("CALL sp_detalle_pedido_insertar(%s, %s, %s, %s, %s)",
                               (cantidad, precio_unitario, subtotal, numero_pedido, codigo_producto))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM DETALLE_PEDIDO")
        elif opcion == "3":
            clave = pedir("ID_Detalle del registro a editar: ", True)
            cantidad = pedir("Cantidad: ", True)
            precio_unitario = pedir("Precio_Unitario: ", True)
            subtotal = pedir("Subtotal: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            codigo_producto = pedir("Codigo_Producto: ", True)
            try:
                cursor.execute("CALL sp_detalle_pedido_actualizar(%s, %s, %s, %s, %s, %s)",
                               (clave, cantidad, precio_unitario, subtotal, numero_pedido, codigo_producto))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Detalle del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_detalle_pedido_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_factura():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Facturas (FACTURA) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            fecha_emision = pedir("Fecha_Emision: ", True)
            total = pedir("Total: ", True)
            estado_pago = pedir("Estado_Pago: ", True)
            forma_pago = pedir("Forma_Pago: ", False)
            fecha_pago = pedir("Fecha_Pago: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            try:
                cursor.execute("CALL sp_factura_insertar(%s, %s, %s, %s, %s, %s)",
                               (fecha_emision, total, estado_pago, forma_pago, fecha_pago, numero_pedido))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM FACTURA")
        elif opcion == "3":
            clave = pedir("Numero_Factura del registro a editar: ", True)
            fecha_emision = pedir("Fecha_Emision: ", True)
            total = pedir("Total: ", True)
            estado_pago = pedir("Estado_Pago: ", True)
            forma_pago = pedir("Forma_Pago: ", False)
            fecha_pago = pedir("Fecha_Pago: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            try:
                cursor.execute("CALL sp_factura_actualizar(%s, %s, %s, %s, %s, %s, %s)",
                               (clave, fecha_emision, total, estado_pago, forma_pago, fecha_pago, numero_pedido))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Numero_Factura del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_factura_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_solicitud_impresion():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Solicitudes de impresion (SOLICITUD_IMPRESION) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            descripcion = pedir("Descripcion: ", False)
            referencias_visuales = pedir("Referencias_Visuales: ", False)
            color = pedir("Color: ", False)
            escala = pedir("Escala: ", False)
            fecha_solicitud = pedir("Fecha_Solicitud: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            id_material = pedir("ID_Material: ", True)
            try:
                cursor.execute("CALL sp_solicitud_impresion_insertar(%s, %s, %s, %s, %s, %s, %s)",
                               (descripcion, referencias_visuales, color, escala, fecha_solicitud, numero_pedido, id_material))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM SOLICITUD_IMPRESION")
        elif opcion == "3":
            clave = pedir("ID_Solicitud del registro a editar: ", True)
            descripcion = pedir("Descripcion: ", False)
            referencias_visuales = pedir("Referencias_Visuales: ", False)
            color = pedir("Color: ", False)
            escala = pedir("Escala: ", False)
            fecha_solicitud = pedir("Fecha_Solicitud: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            id_material = pedir("ID_Material: ", True)
            try:
                cursor.execute("CALL sp_solicitud_impresion_actualizar(%s, %s, %s, %s, %s, %s, %s, %s)",
                               (clave, descripcion, referencias_visuales, color, escala, fecha_solicitud, numero_pedido, id_material))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Solicitud del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_solicitud_impresion_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_render_preliminar():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Renders preliminares (RENDER_PRELIMINAR) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            fecha_envio = pedir("Fecha_Envio: ", False)
            imagen = pedir("Imagen: ", False)
            respuesta = pedir("Respuesta: ", False)
            comentarios = pedir("Comentarios: ", False)
            fecha_respuesta = pedir("Fecha_Respuesta: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            cedula_id = pedir("Cedula_ID: ", True)
            try:
                cursor.execute("CALL sp_render_preliminar_insertar(%s, %s, %s, %s, %s, %s, %s, %s)",
                               (fecha_envio, imagen, respuesta, comentarios, fecha_respuesta, numero_pedido, id_empleado, cedula_id))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM RENDER_PRELIMINAR")
        elif opcion == "3":
            clave = pedir("ID_Render del registro a editar: ", True)
            fecha_envio = pedir("Fecha_Envio: ", False)
            imagen = pedir("Imagen: ", False)
            respuesta = pedir("Respuesta: ", False)
            comentarios = pedir("Comentarios: ", False)
            fecha_respuesta = pedir("Fecha_Respuesta: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            cedula_id = pedir("Cedula_ID: ", True)
            try:
                cursor.execute("CALL sp_render_preliminar_actualizar(%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                               (clave, fecha_envio, imagen, respuesta, comentarios, fecha_respuesta, numero_pedido, id_empleado, cedula_id))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Render del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_render_preliminar_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_orden_impresion():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Ordenes de impresion (ORDEN_IMPRESION) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            gramos_proyectados = pedir("Gramos_Proyectados: ", False)
            tiempo_estimado = pedir("Tiempo_Estimado: ", False)
            fecha_inicio = pedir("Fecha_Inicio: ", False)
            fecha_fin = pedir("Fecha_Fin: ", False)
            estado = pedir("Estado: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            codigo_interno = pedir("Codigo_Interno: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            try:
                cursor.execute("CALL sp_orden_impresion_insertar(%s, %s, %s, %s, %s, %s, %s, %s)",
                               (gramos_proyectados, tiempo_estimado, fecha_inicio, fecha_fin, estado, numero_pedido, codigo_interno, id_empleado))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM ORDEN_IMPRESION")
        elif opcion == "3":
            clave = pedir("ID_Orden del registro a editar: ", True)
            gramos_proyectados = pedir("Gramos_Proyectados: ", False)
            tiempo_estimado = pedir("Tiempo_Estimado: ", False)
            fecha_inicio = pedir("Fecha_Inicio: ", False)
            fecha_fin = pedir("Fecha_Fin: ", False)
            estado = pedir("Estado: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            codigo_interno = pedir("Codigo_Interno: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            try:
                cursor.execute("CALL sp_orden_impresion_actualizar(%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                               (clave, gramos_proyectados, tiempo_estimado, fecha_inicio, fecha_fin, estado, numero_pedido, codigo_interno, id_empleado))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Orden del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_orden_impresion_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_consumo_material():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Consumo de material (CONSUMO_MATERIAL) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            material_bueno = pedir("Material_Bueno: ", False)
            material_desperdiciado = pedir("Material_Desperdiciado: ", False)
            fecha = pedir("Fecha: ", False)
            id_orden = pedir("ID_Orden: ", True)
            id_material = pedir("ID_Material: ", True)
            try:
                cursor.execute("CALL sp_consumo_material_insertar(%s, %s, %s, %s, %s)",
                               (material_bueno, material_desperdiciado, fecha, id_orden, id_material))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM CONSUMO_MATERIAL")
        elif opcion == "3":
            clave = pedir("ID_Consumo del registro a editar: ", True)
            material_bueno = pedir("Material_Bueno: ", False)
            material_desperdiciado = pedir("Material_Desperdiciado: ", False)
            fecha = pedir("Fecha: ", False)
            id_orden = pedir("ID_Orden: ", True)
            id_material = pedir("ID_Material: ", True)
            try:
                cursor.execute("CALL sp_consumo_material_actualizar(%s, %s, %s, %s, %s, %s)",
                               (clave, material_bueno, material_desperdiciado, fecha, id_orden, id_material))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Consumo del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_consumo_material_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_fallo_impresion():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Fallos de impresion (FALLO_IMPRESION) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            tipo_fallo = pedir("Tipo_Fallo: ", False)
            material_desperdiciado = pedir("Material_Desperdiciado: ", False)
            tiempo_perdido = pedir("Tiempo_Perdido: ", False)
            causa = pedir("Causa: ", False)
            fue_reimpresa = pedir("Fue_Reimpresa: ", False)
            costo_reproceso = pedir("Costo_Reproceso: ", False)
            id_orden = pedir("ID_Orden: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            try:
                cursor.execute("CALL sp_fallo_impresion_insertar(%s, %s, %s, %s, %s, %s, %s, %s)",
                               (tipo_fallo, material_desperdiciado, tiempo_perdido, causa, fue_reimpresa, costo_reproceso, id_orden, id_empleado))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM FALLO_IMPRESION")
        elif opcion == "3":
            clave = pedir("ID_Fallo del registro a editar: ", True)
            tipo_fallo = pedir("Tipo_Fallo: ", False)
            material_desperdiciado = pedir("Material_Desperdiciado: ", False)
            tiempo_perdido = pedir("Tiempo_Perdido: ", False)
            causa = pedir("Causa: ", False)
            fue_reimpresa = pedir("Fue_Reimpresa: ", False)
            costo_reproceso = pedir("Costo_Reproceso: ", False)
            id_orden = pedir("ID_Orden: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            try:
                cursor.execute("CALL sp_fallo_impresion_actualizar(%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                               (clave, tipo_fallo, material_desperdiciado, tiempo_perdido, causa, fue_reimpresa, costo_reproceso, id_orden, id_empleado))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Fallo del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_fallo_impresion_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_mantenimiento():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Mantenimientos (MANTENIMIENTO) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            fecha = pedir("Fecha: ", False)
            tipo = pedir("Tipo: ", False)
            descripcion = pedir("Descripcion: ", False)
            codigo_interno = pedir("Codigo_Interno: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            try:
                cursor.execute("CALL sp_mantenimiento_insertar(%s, %s, %s, %s, %s)",
                               (fecha, tipo, descripcion, codigo_interno, id_empleado))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM MANTENIMIENTO")
        elif opcion == "3":
            clave = pedir("ID_Mantenimiento del registro a editar: ", True)
            fecha = pedir("Fecha: ", False)
            tipo = pedir("Tipo: ", False)
            descripcion = pedir("Descripcion: ", False)
            codigo_interno = pedir("Codigo_Interno: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            try:
                cursor.execute("CALL sp_mantenimiento_actualizar(%s, %s, %s, %s, %s, %s)",
                               (clave, fecha, tipo, descripcion, codigo_interno, id_empleado))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Mantenimiento del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_mantenimiento_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_entrada_material():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Entradas de material (ENTRADA_MATERIAL) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            fecha_recepcion = pedir("Fecha_Recepcion: ", False)
            cantidad = pedir("Cantidad: ", False)
            fecha_vencimiento = pedir("Fecha_Vencimiento: ", False)
            estado_empaque = pedir("Estado_Empaque: ", False)
            id_proveedor = pedir("ID_Proveedor: ", True)
            id_material = pedir("ID_Material: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            try:
                cursor.execute("CALL sp_entrada_material_insertar(%s, %s, %s, %s, %s, %s, %s)",
                               (fecha_recepcion, cantidad, fecha_vencimiento, estado_empaque, id_proveedor, id_material, id_empleado))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM ENTRADA_MATERIAL")
        elif opcion == "3":
            clave = pedir("Numero_Entrada del registro a editar: ", True)
            fecha_recepcion = pedir("Fecha_Recepcion: ", False)
            cantidad = pedir("Cantidad: ", False)
            fecha_vencimiento = pedir("Fecha_Vencimiento: ", False)
            estado_empaque = pedir("Estado_Empaque: ", False)
            id_proveedor = pedir("ID_Proveedor: ", True)
            id_material = pedir("ID_Material: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            try:
                cursor.execute("CALL sp_entrada_material_actualizar(%s, %s, %s, %s, %s, %s, %s, %s)",
                               (clave, fecha_recepcion, cantidad, fecha_vencimiento, estado_empaque, id_proveedor, id_material, id_empleado))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Numero_Entrada del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_entrada_material_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_despacho():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Despachos (DESPACHO) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            codigo_rastreo = pedir("Codigo_Rastreo: ", False)
            fecha_envio = pedir("Fecha_Envio: ", False)
            fecha_entrega = pedir("Fecha_Entrega: ", False)
            estado = pedir("Estado: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            id_transportadora = pedir("ID_Transportadora: ", True)
            try:
                cursor.execute("CALL sp_despacho_insertar(%s, %s, %s, %s, %s, %s, %s)",
                               (codigo_rastreo, fecha_envio, fecha_entrega, estado, numero_pedido, id_empleado, id_transportadora))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM DESPACHO")
        elif opcion == "3":
            clave = pedir("ID_Despacho del registro a editar: ", True)
            codigo_rastreo = pedir("Codigo_Rastreo: ", False)
            fecha_envio = pedir("Fecha_Envio: ", False)
            fecha_entrega = pedir("Fecha_Entrega: ", False)
            estado = pedir("Estado: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            id_transportadora = pedir("ID_Transportadora: ", True)
            try:
                cursor.execute("CALL sp_despacho_actualizar(%s, %s, %s, %s, %s, %s, %s, %s)",
                               (clave, codigo_rastreo, fecha_envio, fecha_entrega, estado, numero_pedido, id_empleado, id_transportadora))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Despacho del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_despacho_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def crud_encuesta_satisfaccion():
    opcion = ""
    while opcion != "0":
        print()
        print("===== Encuestas de satisfaccion (ENCUESTA_SATISFACCION) =====")
        print("1) Anadir")
        print("2) Consultar")
        print("3) Editar")
        print("4) Eliminar")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            calif_resistencia = pedir("Calif_Resistencia: ", False)
            calif_acabado = pedir("Calif_Acabado: ", False)
            comentario = pedir("Comentario: ", False)
            recomienda = pedir("Recomienda: ", False)
            fecha_respuesta = pedir("Fecha_Respuesta: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            cedula_id = pedir("Cedula_ID: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            try:
                cursor.execute("CALL sp_encuesta_satisfaccion_insertar(%s, %s, %s, %s, %s, %s, %s, %s)",
                               (calif_resistencia, calif_acabado, comentario, recomienda, fecha_respuesta, numero_pedido, cedula_id, id_empleado))
                conexion.commit()
                print("Registro agregado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "2":
            mostrar("SELECT * FROM ENCUESTA_SATISFACCION")
        elif opcion == "3":
            clave = pedir("ID_Encuesta del registro a editar: ", True)
            calif_resistencia = pedir("Calif_Resistencia: ", False)
            calif_acabado = pedir("Calif_Acabado: ", False)
            comentario = pedir("Comentario: ", False)
            recomienda = pedir("Recomienda: ", False)
            fecha_respuesta = pedir("Fecha_Respuesta: ", False)
            numero_pedido = pedir("Numero_Pedido: ", True)
            cedula_id = pedir("Cedula_ID: ", True)
            id_empleado = pedir("ID_Empleado: ", True)
            try:
                cursor.execute("CALL sp_encuesta_satisfaccion_actualizar(%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                               (clave, calif_resistencia, calif_acabado, comentario, recomienda, fecha_respuesta, numero_pedido, cedula_id, id_empleado))
                conexion.commit()
                print("Registro actualizado")
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Encuesta del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("CALL sp_encuesta_satisfaccion_eliminar(%s)", (clave,))
                    conexion.commit()
                    print("Registro eliminado")
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


def reportes():
    opcion = ""
    while opcion != "0":
        print()
        print("===== REPORTES =====")
        print("1) Pedidos con su cliente y sus productos")
        print("2) Produccion: orden, maquina y operador")
        print("3) Consumo de material por orden")
        print("4) Entregas: transportadora y encargado")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            mostrar("SELECT * FROM v_reporte_pedidos")
        elif opcion == "2":
            mostrar("SELECT * FROM v_reporte_produccion")
        elif opcion == "3":
            mostrar("SELECT * FROM v_reporte_consumo")
        elif opcion == "4":
            mostrar("SELECT * FROM v_reporte_entregas")


def consultas():
    opcion = ""
    while opcion != "0":
        print()
        print("===== CONSULTAS =====")
        print("1) Productos por categoria")
        print("2) Pedidos personalizados")
        print("3) Quien envio un pedido")
        print("4) Pago de un pedido")
        print("5) Calificaciones de un empleado")
        print("0) Volver")
        opcion = input("Opcion: ")
        if opcion == "1":
            mostrar("SELECT Categoria, Codigo_Producto, Nombre, Precio, Stock FROM PRODUCTO ORDER BY Categoria")
        elif opcion == "2":
            mostrar("SELECT p.Numero_Pedido, c.Nombre, s.Descripcion, s.Escala, s.Color, s.Referencias_Visuales "
                    "FROM SOLICITUD_IMPRESION s "
                    "JOIN PEDIDO p ON s.Numero_Pedido = p.Numero_Pedido "
                    "JOIN CLIENTE c ON p.Cedula_ID = c.Cedula_ID ORDER BY p.Numero_Pedido")
        elif opcion == "3":
            numero = input("Numero de pedido: ")
            mostrar("SELECT d.Numero_Pedido, e.Nombre, t.Nombre, d.Codigo_Rastreo, d.Estado, d.Fecha_Envio "
                    "FROM DESPACHO d "
                    "JOIN EMPLEADO e ON d.ID_Empleado = e.ID_Empleado "
                    "JOIN TRANSPORTADORA t ON d.ID_Transportadora = t.ID_Transportadora "
                    "WHERE d.Numero_Pedido = %s", (numero,))
        elif opcion == "4":
            numero = input("Numero de pedido: ")
            mostrar("SELECT p.Numero_Pedido, c.Nombre, f.Total, f.Estado_Pago, f.Forma_Pago, f.Fecha_Pago "
                    "FROM FACTURA f "
                    "JOIN PEDIDO p ON f.Numero_Pedido = p.Numero_Pedido "
                    "JOIN CLIENTE c ON p.Cedula_ID = c.Cedula_ID "
                    "WHERE p.Numero_Pedido = %s", (numero,))
        elif opcion == "5":
            empleado = input("ID del empleado: ")
            desde = input("Fecha desde (AAAA-MM-DD): ")
            hasta = input("Fecha hasta (AAAA-MM-DD): ")
            mostrar("SELECT e.Nombre, en.Numero_Pedido, en.Calif_Resistencia, en.Calif_Acabado, en.Fecha_Respuesta "
                    "FROM ENCUESTA_SATISFACCION en "
                    "JOIN EMPLEADO e ON en.ID_Empleado = e.ID_Empleado "
                    "WHERE en.ID_Empleado = %s AND en.Fecha_Respuesta BETWEEN %s AND %s",
                    (empleado, desde, hasta))


def menu():
    opcion = ""
    while opcion != "0":
        print()
        print("========== ESTUDIO 3D - SISTEMA DE GESTION ==========")
        print("-- Comercial --")
        print(" 1) Clientes")
        print(" 2) Productos")
        print(" 3) Pedidos")
        print(" 4) Detalle de pedido")
        print(" 5) Facturas")
        print("-- Personalizacion --")
        print(" 6) Solicitudes de impresion")
        print(" 7) Renders preliminares")
        print("-- Produccion --")
        print(" 8) Empleados")
        print(" 9) Impresoras 3D")
        print("10) Materiales")
        print("11) Ordenes de impresion")
        print("12) Consumo de material")
        print("-- Calidad y mantenimiento --")
        print("13) Fallos de impresion")
        print("14) Mantenimientos")
        print("-- Inventario --")
        print("15) Proveedores")
        print("16) Entradas de material")
        print("-- Entrega y postventa --")
        print("17) Transportadoras")
        print("18) Despachos")
        print("19) Encuestas de satisfaccion")
        print("-- Otros --")
        print("20) Consultas")
        print("21) Reportes")
        print(" 0) Salir")
        opcion = input("Opcion: ")
        if opcion == "1":
            crud_cliente()
        elif opcion == "2":
            crud_producto()
        elif opcion == "3":
            crud_pedido()
        elif opcion == "4":
            crud_detalle_pedido()
        elif opcion == "5":
            crud_factura()
        elif opcion == "6":
            crud_solicitud_impresion()
        elif opcion == "7":
            crud_render_preliminar()
        elif opcion == "8":
            crud_empleado()
        elif opcion == "9":
            crud_impresora_3d()
        elif opcion == "10":
            crud_material()
        elif opcion == "11":
            crud_orden_impresion()
        elif opcion == "12":
            crud_consumo_material()
        elif opcion == "13":
            crud_fallo_impresion()
        elif opcion == "14":
            crud_mantenimiento()
        elif opcion == "15":
            crud_proveedor()
        elif opcion == "16":
            crud_entrada_material()
        elif opcion == "17":
            crud_transportadora()
        elif opcion == "18":
            crud_despacho()
        elif opcion == "19":
            crud_encuesta_satisfaccion()
        elif opcion == "20":
            consultas()
        elif opcion == "21":
            reportes()


print("Conectado a la base de datos estudio3d")
menu()
cursor.close()
conexion.close()
print("Programa terminado")
