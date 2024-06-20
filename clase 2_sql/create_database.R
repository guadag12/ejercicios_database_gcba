library(dplyr)
library(tidyverse)

rm(list = ls())
# Creando dataframes
Cliente <- data.frame(
  Cliente_ID = 1:15,
  Nombre = c("Juan Pérez", "Ana Gómez", "Lucía Fernández", "Carlos Díaz", "Elena Soto",
             "Miguel Álvarez", "Sofía Torres", "Brian López", "Laura García", "Roberto Ramírez",
             "Jessica Vidal", "Mohammed Alí", "Sara Ortega", "Ricardo Ruiz", "Xiu Ying"),
  Correo = c("juan.perez@ejemplo.com", "ana.gomez@ejemplo.com", "lucia.fernandez@ejemplo.com", 
             "carlos.diaz@ejemplo.com", "elena.soto@ejemplo.com", "miguel.alvarez@ejemplo.com", 
             "sofia.torres@ejemplo.com", "brian.lopez@ejemplo.com", "laura.garcia@ejemplo.com", 
             "roberto.ramirez@ejemplo.com", "jessica.vidal@ejemplo.com", "mohammed.ali@ejemplo.com", 
             "sara.ortega@ejemplo.com", "ricardo.ruiz@ejemplo.com", "xiu.ying@ejemplo.com"),
  Direccion = c("Calle Falsa 123", "Av. San Martín 234", "Calle Siempre Viva 345", "Av. Corrientes 456", "Calle Libertad 567",
                "Av. Santa Fe 678", "Calle Bolívar 789", "Av. 9 de Julio 890", "Calle Mitre 135", "Av. Pueyrredón 246",
                "Calle Lavalle 357", "Av. Cabildo 468", "Calle Juramento 579", "Av. Belgrano 680", "Calle Florida 791")
)

Cliente <- Cliente %>%
  separate(Nombre, into = c("Nombre", "Apellido"), sep = " ")
Pedido <- data.frame(
  Pedido_ID = 1:20,
  Fecha_Pedido = seq(as.Date('2024-06-01'), by = "day", length.out = 20),
  Envio_ID = sample(1:5, 20, replace = TRUE),
  Cliente_ID = sample(1:15, 20, replace = TRUE)
)

Producto <- data.frame(
  Producto_ID = 1:15,
  Nombre_Producto = c("iPhone 13", "Samsung Galaxy S22", "MacBook Air", 
                      "Auriculares Sony", "Surface Laptop", "Dell XPS 13", 
                      "Google Pixel 6", "iPad Air", "Galaxy Tab S7", 
                      "PlayStation 5", "AirPods Pro", "Televisor Samsung QLED", 
                      "Apple Watch Serie 7", "Xbox Series X", "Mouse Logitech"),
  Categoria_ID = sample(1:5, 15, replace = TRUE)
)
Producto <- Producto %>%
  mutate(Precio = c(799, 999, 999, 199, 1299, 999, 599, 599, 699, 499, 249, 1199, 399, 499, 59))


Categoria <- data.frame(
  Categoria_ID = 1:5,
  Nombre_Categoria = c("Smartphones", "Portátiles", "Tabletas", "Consolas de Juegos", "Accesorios"),
  Tipo_Categoria = c("Electrónica", "Computadoras", "Electrónica", "Electrónica", "Computadoras")
)

Envio <- data.frame(
  Envio_ID = 1:5,
  Tipo = c("Estándar", "Expreso", "Nocturno", "Internacional", "Económico"),
  Estado = sample(c("Entregado", "Pendiente", "Enviado"), 5, replace = TRUE)
)

write.csv(Categoria, "Categoria.csv", row.names = FALSE)
write.csv(Cliente, "Cliente.csv", row.names = FALSE)
write.csv(Envio, "Envio.csv", row.names = FALSE)
write.csv(Pedido, "Pedido.csv", row.names = FALSE)
write.csv(Producto, "Producto.csv", row.names = FALSE)

# Instalar y cargar RSQLite
if (!require(RSQLite)) install.packages("RSQLite")
library(RSQLite)

# Crear una conexión a la base de datos SQLite
db <- dbConnect(SQLite(), dbname = "tienda_tecnologia.sqlite")

# Guardar cada dataframe como una tabla en la base de datos SQLite
dbWriteTable(db, "Cliente", Cliente, overwrite = TRUE)
dbWriteTable(db, "Pedido", Pedido, overwrite = TRUE)
dbWriteTable(db, "Producto", Producto, overwrite = TRUE)
dbWriteTable(db, "Categoria", Categoria, overwrite = TRUE)
dbWriteTable(db, "Envio", Envio, overwrite = TRUE)

# Cerrar


# Cargar la librería RSQLite
library(RSQLite)

# Conectarse a la base de datos SQLite
db <- dbConnect(SQLite(), dbname = "tienda_tecnologia.sqlite")

# Ejecutar una consulta SQL
consulta_sql <- dbGetQuery(db, "
  SELECT 
    p.Pedido_ID,
    c.Nombre AS Nombre_Cliente,
    c.Correo,
    pr.Nombre_Producto,
    pr.Categoria_ID,
    cat.Nombre_Categoria,
    e.Tipo AS Tipo_Envio,
    e.Estado AS Estado_Envio
  FROM 
    Pedido p
  JOIN 
    Cliente c ON p.Cliente_ID = c.Cliente_ID
  JOIN 
    Producto pr ON pr.Categoria_ID = p.Pedido_ID
  JOIN 
    Categoria cat ON pr.Categoria_ID = cat.Categoria_ID
  JOIN 
    Envio e ON p.Envio_ID = e.Envio_ID
  WHERE
    e.Estado = 'Entregado'
")

# Mostrar los resultados de la consulta
print(consulta_sql)

# Cerrar la conexión a la base de datos
dbDisconnect(db)