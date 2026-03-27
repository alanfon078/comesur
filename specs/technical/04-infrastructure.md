# ComeSur - Infraestructura y Despliegue

## 1. Arquitectura de Infraestructura

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          ARQUITECTURA AWS                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                         INTERNET                                 │   │
│  │                           │                                     │   │
│  │                           ▼                                     │   │
│  │  ┌─────────────────────────────────────────────────────────┐   │   │
│  │  │                    ROUTE 53                                │   │   │
│  │  │              (DNS Management)                               │   │   │
│  │  └─────────────────────────────────────────────────────────┘   │   │
│  │                           │                                     │   │
│  │         ┌────────────────┴────────────────┐                 │   │
│  │         ▼                                 ▼                 │   │
│  │  ┌─────────────┐                   ┌─────────────┐            │   │
│  │  │ CloudFront │                   │ CloudFront  │            │   │
│  │  │  (API)     │                   │  (Static)   │            │   │
│  │  └─────┬──────┘                   └─────────────┘            │   │
│  │        │                                                       │   │
│  └────────┼───────────────────────────────────────────────────────┘   │
│           │                                                           │
│           ▼                                                           │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │                    VPC (10.0.0.0/16)                            │ │
│  │                                                                  │ │
│  │  ┌──────────────────────────────────────────────────────────┐  │ │
│  │  │              PUBLIC SUBNET (10.0.1.0/24)                  │  │ │
│  │  │                                                            │  │ │
│  │  │  ┌────────────────────────────────────────────────────┐  │  │ │
│  │  │  │           EC2 Instance (t3.medium)                   │  │  │ │
│  │  │  │         Node.js + Express + PM2                      │  │  │ │
│  │  │  │                                                       │  │  │ │
│  │  │  │  ┌──────────────────────────────────────────────┐   │  │  │ │
│  │  │  │  │           Docker Container                     │   │  │  │ │
│  │  │  │  │  ┌────────┐ ┌────────┐ ┌────────┐          │   │  │  │ │
│  │  │  │  │  │ Node.js│ │ Nginx  │ │ Redis  │          │   │  │  │ │
│  │  │  │  │  │  API   │ │  Proxy │ │ Cache  │          │   │  │  │ │
│  │  │  │  │  └────────┘ └────────┘ └────────┘          │   │  │  │ │
│  │  │  │  └──────────────────────────────────────────────┘   │  │  │ │
│  │  │  └────────────────────────────────────────────────────┘  │  │  │
│  │  └──────────────────────────────────────────────────────────┘  │  │
│  │                           │                                    │  │
│  │                           │                                    │  │
│  │                           ▼                                    │  │
│  │  ┌──────────────────────────────────────────────────────────┐  │ │
│  │  │              PRIVATE SUBNET (10.0.2.0/24)                  │  │ │
│  │  │                                                            │  │ │
│  │  │  ┌────────────────────────────────────────────────────┐  │  │ │
│  │  │  │           RDS MySQL 8.0 (db.t3.medium)               │  │  │ │
│  │  │  │         Multi-AZ: us-east-1a / us-east-1b            │  │  │ │
│  │  │  │                                                       │  │  │ │
│  │  │  │  ┌──────────┐ ┌──────────┐ ┌──────────┐            │  │  │ │
│  │  │  │  │ Primary  │ │  Replica │ │  Replica │            │  │  │ │
│  │  │  │  │          │ │   Read   │ │   Read   │            │  │  │ │
│  │  │  │  │          │ │          │ │          │            │  │  │ │
│  │  │  │  └──────────┘ └──────────┘ └──────────┘            │  │  │ │
│  │  │  └────────────────────────────────────────────────────┘  │  │  │
│  │  └──────────────────────────────────────────────────────────┘  │  │
│  └─────────────────────────────────────────────────────────────────┘  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Configuración de Servidores

### VPS Configuration (Development/Staging)

| Componente | Especificación |
|------------|----------------|
| OS | Ubuntu 22.04 LTS |
| CPU | 2 vCPU |
| RAM | 4 GB |
| Storage | 80 GB SSD |
| Bandwidth | 2 TB |

### Production (AWS EC2)

| Componente | Especificación |
|------------|----------------|
| Instance | t3.medium |
| OS | Amazon Linux 2023 |
| CPU | 2 vCPU |
| RAM | 4 GB |
| Storage | EBS gp3 50 GB |

---

## 3. Stack de Software

### Servidor de Producción

```yaml
# docker-compose.yml
version: '3.8'

services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: comesur-api
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
      - DB_HOST=${DB_HOST}
      - DB_PORT=3306
      - DB_NAME=comesur
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - JWT_SECRET=${JWT_SECRET}
    networks:
      - comesur-network
    depends_on:
      - redis

  nginx:
    image: nginx:alpine
    container_name: comesur-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - api
    networks:
      - comesur-network

  redis:
    image: redis:alpine
    container_name: comesur-redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - comesur-network

networks:
  comesur-network:
    driver: bridge

volumes:
  redis-data:
```

---

## 4. Configuración de Nginx

```nginx
# /etc/nginx/nginx.conf

worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml application/json application/javascript;

    # Rate Limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=search:10m rate=30r/m;

    upstream api_backend {
        server localhost:3000;
        keepalive 32;
    }

    server {
        listen 80;
        server_name api.comesur.app;

        # Redirect to HTTPS
        return 301 https://$server_name$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name api.comesur.app;

        # SSL Configuration
        ssl_certificate /etc/nginx/ssl/certificate.crt;
        ssl_certificate_key /etc/nginx/ssl/private.key;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
        ssl_prefer_server_ciphers off;
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 1d;

        # Security Headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;

        # API Location
        location /api {
            limit_req zone=api burst=20 nodelay;
            
            proxy_pass http://api_backend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_cache_bypass $http_upgrade;

            # Timeouts
            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;
        }

        # Search endpoint with stricter rate limit
        location /api/negocios/filtrar {
            limit_req zone=search burst=10 nodelay;
            
            proxy_pass http://api_backend;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        # Health check
        location /health {
            proxy_pass http://api_backend;
            access_log off;
        }
    }
}
```

---

## 5. Configuración de PM2 (Process Manager)

```javascript
// ecosystem.config.js
module.exports = {
  apps: [{
    name: 'comesur-api',
    script: './src/server.js',
    instances: 2,
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'development',
      PORT: 3000
    },
    env_production: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: '/var/log/comesur/error.log',
    out_file: '/var/log/comesur/out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,
    max_memory_restart: '500M',
    autorestart: true,
    watch: false,
    max_restarts: 10,
    min_uptime: '10s'
  }]
};
```

---

## 6. Base de Datos (RDS MySQL)

### Configuración Production

| Parámetro | Valor |
|-----------|-------|
| Instance Class | db.t3.medium |
| Multi-AZ | Yes |
| Storage | 100 GB gp3 |
| IOPS | 3000 |
| Backup Retention | 7 days |
| Encryption | AES-256 |

### Parámetros Importantes

```sql
-- my.cnf / RDS Parameter Group
max_connections = 151
innodb_buffer_pool_size = 2GB
innodb_log_file_size = 512MB
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
query_cache_type = 0
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2
```

---

## 7. CI/CD con GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '20.x'
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json
      
      - name: Install dependencies
        run: npm ci
        working-directory: backend
      
      - name: Run lint
        run: npm run lint
        working-directory: backend
      
      - name: Run tests
        run: npm test
        working-directory: backend

  build-backend:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      
      - name: Login to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Build and push Backend image
        uses: docker/build-push-action@v5
        with:
          context: ./backend
          push: true
          tags: |
            ghcr.io/${{ github.repository }}/api:latest
            ghcr.io/${{ github.repository }}/api:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy:
    needs: build-backend
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Deploy to VPS
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.VPS_HOST }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          script: |
            cd /opt/comesur
            docker-compose pull
            docker-compose up -d
            docker system prune -f
```

---

## 8. Monitoreo y Logging

### Stack de Monitoreo

| Herramienta | Propósito |
|-------------|-----------|
| CloudWatch | Métricas de AWS |
| Sentry | Error tracking |
| Datadog | APM |
| UptimeRobot | Uptime monitoring |

### Health Check Endpoint

```javascript
// GET /health
{
    "status": "healthy",
    "timestamp": "2026-03-25T12:00:00Z",
    "services": {
        "database": "connected",
        "redis": "connected",
        "api": "running"
    },
    "uptime": 3600,
    "version": "1.0.0"
}
```

---

## 9. Disaster Recovery

### RTO y RPO

| Métrica | Objetivo |
|---------|----------|
| RTO (Recovery Time Objective) | 4 horas |
| RPO (Recovery Point Objective) | 1 hora |

### Backup Strategy

| Tipo | Frecuencia | Retención |
|------|------------|-----------|
| Automático RDS | Diario | 7 días |
| Manual snapshot | Semanal | 4 semanas |
| Export S3 | Mensual | 12 meses |

### Plan de Recuperación

1. Detectar outage
2. Evaluar impacto
3. Activar failover si es necesario
4. Restaurar desde backup si aplica
5. Verificar funcionalidad
6. Comunicación a usuarios

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
