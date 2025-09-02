# Convert YTM 🎵

Un convertidor de medios moderno con interfaz estilo iOS que permite descargar y convertir videos/audios de YouTube Music y otras plataformas.

## ✨ Características

- **Interfaz iOS moderna**: Diseño con blur effects, animaciones suaves y componentes redondeados
- **Conversión en tiempo real**: Progreso en vivo via WebSocket
- **Múltiples formatos**: MP3, AAC, MP4, WebM con diferentes calidades
- **Recorte de tiempo**: Especifica inicio y fin para extraer segmentos
- **Cola de trabajos**: Gestión inteligente de múltiples conversiones
- **Arquitectura escalable**: Backend C++ con Drogon, Frontend React
- **Containerizado**: Docker y Docker Compose para fácil despliegue

## 🏗️ Arquitectura

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │    Backend      │    │   External      │
│   (React)       │◄──►│   (C++/Drogon)  │◄──►│   (yt-dlp,      │
│                 │    │                 │    │    FFmpeg)      │
│ • iOS UI        │    │ • REST API      │    │                 │
│ • WebSocket     │    │ • WebSocket     │    │ • Download      │
│ • Real-time     │    │ • Job Queue     │    │ • Convert       │
│   progress      │    │ • SQLite DB     │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Inicio Rápido

### Usando Docker (Recomendado)

```bash
# Clonar el repositorio
git clone <repository-url>
cd "convert YTM"

# Construir y ejecutar
chmod +x scripts/build.sh
./scripts/build.sh

# Acceder a la aplicación
open http://localhost
```

### Desarrollo Local

```bash
# Instalar dependencias del sistema
# Ubuntu/Debian:
sudo apt-get update
sudo apt-get install build-essential cmake libdrogon-dev libcurl4-openssl-dev libsqlite3-dev nlohmann-json3-dev ffmpeg python3-pip
pip3 install yt-dlp

# macOS:
brew install cmake drogon curl sqlite3 nlohmann-json ffmpeg
pip3 install yt-dlp

# Ejecutar en modo desarrollo
chmod +x scripts/dev.sh
./scripts/dev.sh
```

## 📁 Estructura del Proyecto

```
convert YTM/
├── backend/                 # Backend C++
│   ├── src/
│   │   ├── main.cpp
│   │   ├── routes/         # Controladores REST
│   │   ├── workers/        # Procesamiento de jobs
│   │   ├── ws/            # WebSocket manager
│   │   ├── models/        # Modelos de datos
│   │   └── utils/         # Utilidades
│   └── CMakeLists.txt
├── frontend/               # Frontend React
│   ├── src/
│   │   ├── components/    # Componentes React
│   │   ├── styles/        # Estilos iOS
│   │   └── App.jsx
│   ├── package.json
│   └── tailwind.config.js
├── docker/                # Configuración Docker
│   ├── Dockerfile.backend
│   ├── Dockerfile.frontend
│   └── nginx.conf
├── infra/                 # Infraestructura
│   └── docker-compose.yml
├── docs/                  # Documentación
│   └── api_spec.md
└── scripts/               # Scripts de automatización
    ├── build.sh
    └── dev.sh
```

## 🔧 Configuración

### Variables de Entorno

```bash
# Backend
DB_PATH=/data/convert_ytm.db
MAX_CONCURRENT_JOBS=3
TEMP_DIR=/tmp/convert_ytm
OUTPUT_DIR=/var/www/files

# Opcional: Redis para cola distribuida
REDIS_URL=redis://localhost:6379

# Opcional: MinIO para almacenamiento
MINIO_ENDPOINT=localhost:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin123
```

### Configuración del Frontend

El frontend permite configurar:
- Formato y calidad por defecto
- Descarga automática
- Notificaciones
- Limpieza automática de archivos
- Número de trabajos concurrentes

## 📖 Uso

### 1. Convertir un Video/Audio

1. Pega el enlace en el campo de entrada
2. Selecciona formato (MP3, AAC, MP4, WebM)
3. Elige la calidad deseada
4. Opcionalmente, especifica tiempo de inicio/fin
5. Haz clic en "Convertir"

### 2. Monitorear Progreso

- El progreso se actualiza en tiempo real
- Estados: En cola → Descargando → Convirtiendo → Completado
- Mensajes detallados durante cada fase

### 3. Descargar Resultado

- Botón "Descargar" aparece cuando está listo
- Descarga directa del archivo convertido
- Archivos se mantienen por 7 días por defecto

## 🔌 API

### REST Endpoints

```http
POST /api/v1/jobs          # Crear trabajo de conversión
GET  /api/v1/jobs/{id}     # Obtener estado del trabajo
GET  /api/v1/jobs          # Listar trabajos
POST /api/v1/jobs/{id}/cancel  # Cancelar trabajo
GET  /api/v1/download/{id} # Descargar archivo
GET  /api/v1/health        # Health check
```

### WebSocket

```javascript
// Conectar
const ws = new WebSocket('ws://localhost:8080/ws');

// Suscribirse a actualizaciones
ws.send(JSON.stringify({
  type: 'subscribe',
  job_id: 'your-job-id'
}));

// Recibir progreso
ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  if (data.type === 'job:update') {
    console.log(`Progreso: ${data.progress}%`);
  }
};
```

Ver [documentación completa de la API](docs/api_spec.md).

## 🎨 Diseño iOS

El frontend implementa el sistema de diseño de iOS:

- **Tipografía**: San Francisco (system-ui fallback)
- **Colores**: Paleta iOS con grises y azul sistema
- **Componentes**: Cards con blur, botones redondeados, switches
- **Animaciones**: Transiciones suaves, efectos de entrada
- **Responsive**: Adaptable a móvil y desktop

### Componentes Principales

- `PasteLinkPanel`: Entrada de URL con opciones avanzadas
- `QueuePanel`: Lista de trabajos con filtros
- `DownloadCard`: Tarjeta individual con progreso
- `SettingsModal`: Configuración de la aplicación

## 🔧 Desarrollo

### Requisitos

- **Backend**: CMake 3.16+, C++17, Drogon, libcurl, SQLite3
- **Frontend**: Node.js 18+, npm
- **Herramientas**: FFmpeg, yt-dlp, Docker (opcional)

### Comandos Útiles

```bash
# Desarrollo local
./scripts/dev.sh

# Build completo
./scripts/build.sh production

# Solo backend
cd backend && mkdir build && cd build
cmake .. && make -j$(nproc)
./convert_ytm

# Solo frontend
cd frontend
npm install && npm run dev

# Docker
docker-compose -f infra/docker-compose.yml up -d

# Logs
docker-compose -f infra/docker-compose.yml logs -f

# Limpiar
docker-compose -f infra/docker-compose.yml down --volumes
```

### Testing

```bash
# Backend (cuando se implementen tests)
cd backend/build && make test

# Frontend
cd frontend && npm test

# E2E
cd frontend && npm run test:e2e

# API testing
curl -X POST http://localhost:8080/api/v1/jobs \
  -H "Content-Type: application/json" \
  -d '{"url":"https://example.com/video.mp4","format":"mp3"}'
```

## 🚀 Despliegue

### Docker Compose (Recomendado)

```bash
# Producción completa
docker-compose -f infra/docker-compose.yml --profile production up -d

# Con monitoreo
docker-compose -f infra/docker-compose.yml --profile monitoring up -d
```

### Kubernetes

```bash
# Aplicar manifiestos (cuando se implementen)
kubectl apply -f k8s/
```

### Manual

1. Compilar backend y copiar binario
2. Build frontend y servir con nginx
3. Configurar reverse proxy
4. Configurar SSL con Let's Encrypt

## 📊 Monitoreo

- **Prometheus**: Métricas del sistema
- **Grafana**: Dashboards visuales
- **Health checks**: Endpoints de salud
- **Logs**: Structured logging

## 🔒 Seguridad

- Validación de URLs para prevenir SSRF
- Sanitización de argumentos de comandos
- Rate limiting por IP
- Ejecución en contenedores sin privilegios
- Headers de seguridad en nginx

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

## 🙏 Agradecimientos

- [Drogon](https://github.com/drogonframework/drogon) - Framework web C++
- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - Descargador de videos
- [FFmpeg](https://ffmpeg.org/) - Procesamiento multimedia
- [React](https://reactjs.org/) - Biblioteca UI
- [Tailwind CSS](https://tailwindcss.com/) - Framework CSS

---

**Convert YTM** - Convierte tus medios favoritos con estilo 🎵