#  Conexión a MySQL con Docker

Este repositorio te permite levantar rápidamente un servidor MySQL 5.7 usando Docker.

---

## Pasos para usarlo

### 1. Clonar el repositorio

```bash
git clone https://github.com/Micagomez/db

```
---

### 2. Levantar la base de datos

```bash
docker-compose up -d
```

Esto iniciará el servidor MySQL y guardará los datos en la carpeta `./data/mysql`.

---

### 3. Conectarse a MySQL

Desde tu PC (con DBeaver, Workbench o consola):

- **Host:** `localhost`
- **Puerto:** `3307`
- **Usuario:** `cooperative_db`
- **Contraseña:** `coop`
- **Base de datos:** `cooperative_db`

---
