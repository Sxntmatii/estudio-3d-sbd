import mysql.connector
#Modificado por EM
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
                cursor.execute("INSERT INTO CLIENTE (Cedula_ID, Nombre, Correo, Telefono) VALUES (%s, %s, %s, %s)",
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
                cursor.execute("UPDATE CLIENTE SET Nombre = %s, Correo = %s, Telefono = %s WHERE Cedula_ID = %s",
                               (nombre, correo, telefono, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Cedula_ID del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM CLIENTE WHERE Cedula_ID = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO EMPLEADO (Nombre, Rol, Telefono) VALUES (%s, %s, %s)",
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
                cursor.execute("UPDATE EMPLEADO SET Nombre = %s, Rol = %s, Telefono = %s WHERE ID_Empleado = %s",
                               (nombre, rol, telefono, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Empleado del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM EMPLEADO WHERE ID_Empleado = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO PROVEEDOR (Nombre, Telefono, Correo) VALUES (%s, %s, %s)",
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
                cursor.execute("UPDATE PROVEEDOR SET Nombre = %s, Telefono = %s, Correo = %s WHERE ID_Proveedor = %s",
                               (nombre, telefono, correo, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Proveedor del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM PROVEEDOR WHERE ID_Proveedor = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO TRANSPORTADORA (Nombre, Telefono, Sitio_Web) VALUES (%s, %s, %s)",
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
                cursor.execute("UPDATE TRANSPORTADORA SET Nombre = %s, Telefono = %s, Sitio_Web = %s WHERE ID_Transportadora = %s",
                               (nombre, telefono, sitio_web, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Transportadora del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM TRANSPORTADORA WHERE ID_Transportadora = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO MATERIAL (Tipo, Color, Unidad, Stock_Actual, Costo_Unitario) VALUES (%s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE MATERIAL SET Tipo = %s, Color = %s, Unidad = %s, Stock_Actual = %s, Costo_Unitario = %s WHERE ID_Material = %s",
                               (tipo, color, unidad, stock_actual, costo_unitario, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Material del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM MATERIAL WHERE ID_Material = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO PRODUCTO (Codigo_Producto, Nombre, Precio, Categoria, Tipo_Garantia, Stock) VALUES (%s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE PRODUCTO SET Nombre = %s, Precio = %s, Categoria = %s, Tipo_Garantia = %s, Stock = %s WHERE Codigo_Producto = %s",
                               (nombre, precio, categoria, tipo_garantia, stock, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Codigo_Producto del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM PRODUCTO WHERE Codigo_Producto = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO IMPRESORA_3D (Codigo_Interno, Marca, Modelo, Tecnologia, Numero_Serie, Fecha_Compra, Estado, ID_Proveedor) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE IMPRESORA_3D SET Marca = %s, Modelo = %s, Tecnologia = %s, Numero_Serie = %s, Fecha_Compra = %s, Estado = %s, ID_Proveedor = %s WHERE Codigo_Interno = %s",
                               (marca, modelo, tecnologia, numero_serie, fecha_compra, estado, id_proveedor, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Codigo_Interno del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM IMPRESORA_3D WHERE Codigo_Interno = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO PEDIDO (Fecha_Hora, Tipo, Estado_Actual, Fecha_Estim_Entrega, Total, Cedula_ID) VALUES (%s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE PEDIDO SET Fecha_Hora = %s, Tipo = %s, Estado_Actual = %s, Fecha_Estim_Entrega = %s, Total = %s, Cedula_ID = %s WHERE Numero_Pedido = %s",
                               (fecha_hora, tipo, estado_actual, fecha_estim_entrega, total, cedula_id, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Numero_Pedido del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM PEDIDO WHERE Numero_Pedido = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO DETALLE_PEDIDO (Cantidad, Precio_Unitario, Subtotal, Numero_Pedido, Codigo_Producto) VALUES (%s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE DETALLE_PEDIDO SET Cantidad = %s, Precio_Unitario = %s, Subtotal = %s, Numero_Pedido = %s, Codigo_Producto = %s WHERE ID_Detalle = %s",
                               (cantidad, precio_unitario, subtotal, numero_pedido, codigo_producto, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Detalle del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM DETALLE_PEDIDO WHERE ID_Detalle = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO FACTURA (Fecha_Emision, Total, Estado_Pago, Forma_Pago, Fecha_Pago, Numero_Pedido) VALUES (%s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE FACTURA SET Fecha_Emision = %s, Total = %s, Estado_Pago = %s, Forma_Pago = %s, Fecha_Pago = %s, Numero_Pedido = %s WHERE Numero_Factura = %s",
                               (fecha_emision, total, estado_pago, forma_pago, fecha_pago, numero_pedido, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Numero_Factura del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM FACTURA WHERE Numero_Factura = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO SOLICITUD_IMPRESION (Descripcion, Referencias_Visuales, Color, Escala, Fecha_Solicitud, Numero_Pedido, ID_Material) VALUES (%s, %s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE SOLICITUD_IMPRESION SET Descripcion = %s, Referencias_Visuales = %s, Color = %s, Escala = %s, Fecha_Solicitud = %s, Numero_Pedido = %s, ID_Material = %s WHERE ID_Solicitud = %s",
                               (descripcion, referencias_visuales, color, escala, fecha_solicitud, numero_pedido, id_material, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Solicitud del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM SOLICITUD_IMPRESION WHERE ID_Solicitud = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO RENDER_PRELIMINAR (Fecha_Envio, Imagen, Respuesta, Comentarios, Fecha_Respuesta, Numero_Pedido, ID_Empleado, Cedula_ID) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE RENDER_PRELIMINAR SET Fecha_Envio = %s, Imagen = %s, Respuesta = %s, Comentarios = %s, Fecha_Respuesta = %s, Numero_Pedido = %s, ID_Empleado = %s, Cedula_ID = %s WHERE ID_Render = %s",
                               (fecha_envio, imagen, respuesta, comentarios, fecha_respuesta, numero_pedido, id_empleado, cedula_id, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Render del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM RENDER_PRELIMINAR WHERE ID_Render = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO ORDEN_IMPRESION (Gramos_Proyectados, Tiempo_Estimado, Fecha_Inicio, Fecha_Fin, Estado, Numero_Pedido, Codigo_Interno, ID_Empleado) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE ORDEN_IMPRESION SET Gramos_Proyectados = %s, Tiempo_Estimado = %s, Fecha_Inicio = %s, Fecha_Fin = %s, Estado = %s, Numero_Pedido = %s, Codigo_Interno = %s, ID_Empleado = %s WHERE ID_Orden = %s",
                               (gramos_proyectados, tiempo_estimado, fecha_inicio, fecha_fin, estado, numero_pedido, codigo_interno, id_empleado, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Orden del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM ORDEN_IMPRESION WHERE ID_Orden = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO CONSUMO_MATERIAL (Material_Bueno, Material_Desperdiciado, Fecha, ID_Orden, ID_Material) VALUES (%s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE CONSUMO_MATERIAL SET Material_Bueno = %s, Material_Desperdiciado = %s, Fecha = %s, ID_Orden = %s, ID_Material = %s WHERE ID_Consumo = %s",
                               (material_bueno, material_desperdiciado, fecha, id_orden, id_material, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Consumo del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM CONSUMO_MATERIAL WHERE ID_Consumo = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO FALLO_IMPRESION (Tipo_Fallo, Material_Desperdiciado, Tiempo_Perdido, Causa, Fue_Reimpresa, Costo_Reproceso, ID_Orden, ID_Empleado) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE FALLO_IMPRESION SET Tipo_Fallo = %s, Material_Desperdiciado = %s, Tiempo_Perdido = %s, Causa = %s, Fue_Reimpresa = %s, Costo_Reproceso = %s, ID_Orden = %s, ID_Empleado = %s WHERE ID_Fallo = %s",
                               (tipo_fallo, material_desperdiciado, tiempo_perdido, causa, fue_reimpresa, costo_reproceso, id_orden, id_empleado, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Fallo del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM FALLO_IMPRESION WHERE ID_Fallo = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO MANTENIMIENTO (Fecha, Tipo, Descripcion, Codigo_Interno, ID_Empleado) VALUES (%s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE MANTENIMIENTO SET Fecha = %s, Tipo = %s, Descripcion = %s, Codigo_Interno = %s, ID_Empleado = %s WHERE ID_Mantenimiento = %s",
                               (fecha, tipo, descripcion, codigo_interno, id_empleado, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Mantenimiento del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM MANTENIMIENTO WHERE ID_Mantenimiento = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO ENTRADA_MATERIAL (Fecha_Recepcion, Cantidad, Fecha_Vencimiento, Estado_Empaque, ID_Proveedor, ID_Material, ID_Empleado) VALUES (%s, %s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE ENTRADA_MATERIAL SET Fecha_Recepcion = %s, Cantidad = %s, Fecha_Vencimiento = %s, Estado_Empaque = %s, ID_Proveedor = %s, ID_Material = %s, ID_Empleado = %s WHERE Numero_Entrada = %s",
                               (fecha_recepcion, cantidad, fecha_vencimiento, estado_empaque, id_proveedor, id_material, id_empleado, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("Numero_Entrada del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM ENTRADA_MATERIAL WHERE Numero_Entrada = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO DESPACHO (Codigo_Rastreo, Fecha_Envio, Fecha_Entrega, Estado, Numero_Pedido, ID_Empleado, ID_Transportadora) VALUES (%s, %s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE DESPACHO SET Codigo_Rastreo = %s, Fecha_Envio = %s, Fecha_Entrega = %s, Estado = %s, Numero_Pedido = %s, ID_Empleado = %s, ID_Transportadora = %s WHERE ID_Despacho = %s",
                               (codigo_rastreo, fecha_envio, fecha_entrega, estado, numero_pedido, id_empleado, id_transportadora, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Despacho del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM DESPACHO WHERE ID_Despacho = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
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
                cursor.execute("INSERT INTO ENCUESTA_SATISFACCION (Calif_Resistencia, Calif_Acabado, Comentario, Recomienda, Fecha_Respuesta, Numero_Pedido, Cedula_ID, ID_Empleado) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
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
                cursor.execute("UPDATE ENCUESTA_SATISFACCION SET Calif_Resistencia = %s, Calif_Acabado = %s, Comentario = %s, Recomienda = %s, Fecha_Respuesta = %s, Numero_Pedido = %s, Cedula_ID = %s, ID_Empleado = %s WHERE ID_Encuesta = %s",
                               (calif_resistencia, calif_acabado, comentario, recomienda, fecha_respuesta, numero_pedido, cedula_id, id_empleado, clave))
                conexion.commit()
                print("Registros actualizados:", cursor.rowcount)
            except mysql.connector.Error as error:
                print("Error:", error.msg)
        elif opcion == "4":
            clave = pedir("ID_Encuesta del registro a eliminar: ", True)
            if confirmar():
                try:
                    cursor.execute("DELETE FROM ENCUESTA_SATISFACCION WHERE ID_Encuesta = %s", (clave,))
                    conexion.commit()
                    print("Registros eliminados:", cursor.rowcount)
                except mysql.connector.Error as error:
                    print("No se puede eliminar:", error.msg)


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


print("Conectado a la base de datos estudio3d")
menu()
cursor.close()
conexion.close()
print("Programa terminado")
