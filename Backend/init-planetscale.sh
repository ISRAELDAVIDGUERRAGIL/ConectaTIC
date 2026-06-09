#!/bin/bash

# ============================================================
# SCRIPT: init-planetscale.sh
# PROPÓSITO: Inicializar base de datos MySQL en PlanetScale
# DESCRIPCIÓN: Ejecuta migraciones y crea tablas necesarias
# ============================================================

echo "🚀 ConectaTIC - Inicializador de PlanetScale"
echo "=================================================="
echo ""

# Verificar que mysql está instalado
if ! command -v mysql &> /dev/null; then
    echo "❌ MySQL CLI no está instalado"
    echo "Instala MySQL Client: https://dev.mysql.com/downloads/mysql/"
    exit 1
fi

# Leer variables de .env
if [ -f ".env" ]; then
    export $(cat .env | grep -v '#' | xargs)
else
    echo "❌ Archivo .env no encontrado"
    echo "Copia .env.example a .env y actualiza con tus credenciales"
    exit 1
fi

echo "✅ Variables de entorno cargadas"
echo ""

# Crear tabla usuarios
echo "📝 Creando tabla usuarios..."
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" << EOF
CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  progreso INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear índice en correo para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_correo ON usuarios(correo);
EOF

if [ $? -eq 0 ]; then
    echo "✅ Tabla usuarios creada exitosamente"
else
    echo "❌ Error creando tabla usuarios"
    exit 1
fi

echo ""
echo "✅ Base de datos inicializada correctamente"
echo ""
echo "Próximos pasos:"
echo "1. Verifica en PlanetScale dashboard que la tabla existe"
echo "2. Ejecuta: npm run dev"
echo "3. Prueba el servidor en http://localhost:3000"
