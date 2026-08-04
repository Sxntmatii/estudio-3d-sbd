import mysql.connector

conexion = mysql.connector.connect(
    host="localhost",
    user="root",
    password="1234",
    database="estudio3d"
)
cursor = conexion.cursor()
print(">> Conectado a la base de datos estudio3d")


def ver_clientes():
    print("\n----- PANTALLA 1: CLIENTES -----")
    cursor.execute("SELECT Cedula_ID, Nombre, Correo, Telefono FROM CLIENTE")
    for fila in cursor.fetchall():
        print(fila[0], "|", fila[1], "|", fila[2], "|", fila[3])


def ver_productos():
    print("\n----- PANTALLA 2: PRODUCTOS POR CATEGORIA -----")
    cursor.execute("SELECT Categoria, Codigo_Producto, Nombre, Precio, Stock "
                   "FROM PRODUCTO ORDER BY Categoria")
    for fila in cursor.fetchall():
        print(fila[0], "|", fila[1], "|", fila[2], "| $", fila[3], "| stock:", fila[4])


def pedidos_personalizados():
    print("\n----- PEDIDOS ESPECIALES: descripcion, tamano e imagen -----")
    cursor.execute("SELECT p.Numero_Pedido, c.Nombre, s.Descripcion, s.Escala, s.Color, s.Referencias_Visuales "
                   "FROM SOLICITUD_IMPRESION s "
                   "JOIN PEDIDO p ON s.Numero_Pedido = p.Numero_Pedido "
                   "JOIN CLIENTE c ON p.Cedula_ID = c.Cedula_ID "
                   "ORDER BY p.Numero_Pedido")
    for fila in cursor.fetchall():
        print("Pedido:", fila[0], "| Cliente:", fila[1], "|", fila[2],
              "| tamano:", fila[3], "| color:", fila[4], "| imagen:", fila[5])


def quien_envia():
    num = input("Numero de pedido (ej. 4): ")
    cursor.execute("SELECT d.Numero_Pedido, e.Nombre, t.Nombre, d.Estado, d.Fecha_Envio "
                   "FROM DESPACHO d "
                   "JOIN EMPLEADO e ON d.ID_Empleado = e.ID_Empleado "
                   "JOIN TRANSPORTADORA t ON d.ID_Transportadora = t.ID_Transportadora "
                   "WHERE d.Numero_Pedido = %s", (num,))
    for fila in cursor.fetchall():
        print("Pedido:", fila[0], "| Empleado:", fila[1], "| Transportadora:", fila[2],
              "| Estado:", fila[3], "| Enviado:", fila[4])


def pago_pedido():
    num = input("Numero de pedido (ej. 4): ")
    cursor.execute("SELECT p.Numero_Pedido, c.Nombre, f.Total, f.Estado_Pago, f.Forma_Pago, f.Fecha_Pago "
                   "FROM FACTURA f "
                   "JOIN PEDIDO p ON f.Numero_Pedido = p.Numero_Pedido "
                   "JOIN CLIENTE c ON p.Cedula_ID = c.Cedula_ID "
                   "WHERE p.Numero_Pedido = %s", (num,))
    for fila in cursor.fetchall():
        print("Pedido:", fila[0], "| Cliente:", fila[1], "| Total:", fila[2],
              "| Pago:", fila[3], "| Forma:", fila[4], "| Fecha:", fila[5])


def calificaciones():
    emp = input("ID del empleado (ej. 2): ")
    desde = input("Fecha desde (ej. 2026-06-01): ")
    hasta = input("Fecha hasta (ej. 2026-06-30): ")
    cursor.execute("SELECT e.Nombre, en.Numero_Pedido, en.Calif_Resistencia, en.Calif_Acabado, en.Fecha_Respuesta "
                   "FROM ENCUESTA_SATISFACCION en "
                   "JOIN EMPLEADO e ON en.ID_Empleado = e.ID_Empleado "
                   "WHERE en.ID_Empleado = %s "
                   "AND en.Fecha_Respuesta BETWEEN %s AND %s", (emp, desde, hasta))
    for fila in cursor.fetchall():
        print(fila[0], "| pedido:", fila[1], "| resistencia:", fila[2],
              "| acabado:", fila[3], "| fecha:", fila[4])


opcion = ""
while opcion != "0":
    print("\n============= MENU =============")
    print("1) Ver clientes            (tabla CLIENTE)")
    print("2) Ver productos           (tabla PRODUCTO)")
    print("3) Pedidos personalizados  (descripcion, tamano, imagen)")
    print("4) Quien envio un pedido")
    print("5) Pago de un pedido")
    print("6) Calificaciones de un empleado")
    print("0) Salir")
    opcion = input("Elige una opcion: ")
    if opcion == "1":
        ver_clientes()
    elif opcion == "2":
        ver_productos()
    elif opcion == "3":
        pedidos_personalizados()
    elif opcion == "4":
        quien_envia()
    elif opcion == "5":
        pago_pedido()
    elif opcion == "6":
        calificaciones()

cursor.close()
conexion.close()
print("Programa terminado.")
