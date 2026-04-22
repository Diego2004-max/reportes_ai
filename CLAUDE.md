# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**reportes_ai** — App Flutter de reportes ciudadanos con IA. Permite capturar incidentes (obras, accidentes, etc.) con ubicación GPS, imágenes y audio, mostrarlos en un mapa interactivo y, en el roadmap, analizar esos datos con modelos NLP y predictivos.

Backend: Supabase · State: Riverpod · Nav: Go Router · Local: Hive

## Comandos de desarrollo

```bash
# Web (Chrome) — workflow principal
flutter run --dart-define=SUPABASE_PUBLISHABLE_KEY=<key> -d chrome

# Android
flutter run --dart-define=SUPABASE_PUBLISHABLE_KEY=<key> -d <device-id>

# Build Android release
flutter build apk --dart-define=SUPABASE_PUBLISHABLE_KEY=<key>

# Análisis estático
flutter analyze

# Tests
flutter test

# Test de un archivo específico
flutter test test/path/to/test_file.dart
```

## Configuración requerida antes de ejecutar

Ningún archivo de claves se sube a git. Cada desarrollador crea sus archivos locales siguiendo estas instrucciones.

### 1. API Key de Google Maps — Web

Copiar `web/maps_api.example.js` → `web/maps_api.js` (ya en `.gitignore`) y editar:
```js
window.GOOGLE_MAPS_API_KEY = 'TU_CLAVE_REAL_AQUI';
```
El `web/index.html` carga ese archivo e inyecta el script de Google Maps con esa variable.

### 2. API Key de Google Maps — Android

Editar `android/local.properties` (ya en `.gitignore`) y agregar:
```
MAPS_API_KEY=TU_CLAVE_REAL_AQUI
```

### 3. API Key de Google Maps — iOS

Editar `ios/Runner/AppDelegate.swift` y reemplazar el placeholder en:
```swift
GMSServices.provideAPIKey("TU_CLAVE_REAL_AQUI")
```

Las claves deben tener habilitados en Google Cloud Console: Maps JavaScript API, Maps SDK for Android, Maps SDK for iOS, Geocoding API.

### 4. Supabase Key

Pasar como `--dart-define=SUPABASE_PUBLISHABLE_KEY=<key>` al correr/compilar. La URL del proyecto está hardcodeada en `lib/main.dart`.

## Arquitectura

Clean Architecture en tres capas:

```
lib/
├── app/           # MaterialApp, Go Router (app_router.dart), tema + colores + spacing
├── core/          # Servicios transversales (location, media, speech, supabase, ai)
├── data/          # Modelos, repositorios impl, datasources remotos (Supabase) y locales (Hive)
├── domain/        # Interfaces abstractas de repositorios
├── features/      # Pantallas por feature: auth, home, map, reports, profile, analytics, notifications, settings
├── shared/        # Widgets reutilizables (design system "Vial")
└── state/         # Todos los Riverpod providers
```

**Flujo de datos:** `features/` → providers en `state/` → repositorios en `data/repositories/` → datasources remotos (`data/remote/supabase/`) o locales (`data/local/hive/`).

**Modelo central:** `data/models/report_model.dart` — campos clave: `latitude`/`longitude` (opcionales, los marcadores del mapa solo se crean si no son `null`); `status` usa los literales `'Enviado'`, `'En revisión'`, `'Atendido'`; `imagePaths` es `List<String>` pero solo se persiste el primero (`image_url`) en Supabase.

## Autenticación y sesión

- `state/auth_provider.dart` expone `AuthRepositoryImpl` para login/register.
- `state/session_provider.dart` (`SessionNotifier`) persiste la sesión activa en Hive (`isLoggedIn`, `userId`, `userEmail`, `userName`). Al reiniciar la app Hive la restaura.
- Go Router (`app/router/app_router.dart`) observa `sessionProvider`: redirige a `/login` sin sesión y a `/app` con sesión activa.
- Supabase crea el perfil en la tabla `profiles` al registrar; login recupera los datos de esa tabla.

## Mapa

- Pantalla: `features/map/presentation/screens/map_screen.dart`
- Usa `allReportsProvider` (FutureProvider) que llama `ReportRepositoryImpl.getAllReports()` en Supabase.
- Centro inicial: `LatLng(1.2136, -77.2811)` (Pasto, Colombia).
- Tap en marcador → bottom sheet con detalle del reporte.
- El mapa queda gris/blanco si `MAPS_API_KEY` está vacía o no configurada.

## Reportes

- **Creación:** dos flujos — reporte escrito (`CreateWrittenReportScreen`) y reporte de audio (`CreateAudioReportScreen`). Ambos capturan ubicación GPS automáticamente al abrirse usando `LocationService`.
- **Audio:** `VoiceService` envuelve el paquete `record`; `SpeechService` envuelve `speech_to_text` (disponible pero no integrado todavía en el flujo de creación).
- **Caché local:** `reportCacheBox` (reportes vistos offline) y `reportDraftsBox` (borradores sin subir) definidos en `core/constants/hive_boxes.dart`.
- **Categorías disponibles** (hardcoded en UI): Accidente, Derrumbe, Semáforo dañado, Vía bloqueada.

## Providers clave de Riverpod

| Provider | Tipo | Descripción |
|---|---|---|
| `sessionProvider` | `NotifierProvider` | Sesión activa del usuario |
| `authProvider` | `Provider` | Instancia de `AuthRepositoryImpl` |
| `reportRepositoryProvider` | `Provider` | Instancia de `ReportRepositoryImpl` |
| `allReportsProvider` | `FutureProvider` | Todos los reportes (para el mapa) |
| `userReportsProvider` | `FutureProvider` | Reportes del usuario autenticado |
| `recentUserReportsProvider` | `FutureProvider.family(int)` | N reportes más recientes del usuario |
| `userReportStatsProvider` | `FutureProvider` | Conteos por status para dashboard |
| `reportRefreshProvider` | `NotifierProvider` | Incrementar para forzar re-fetch |
| `themeProvider` | `NotifierProvider` | Modo de tema (light/dark/system), persiste en Hive |

## Roadmap de IA (stubs listos, lógica pendiente)

Los siguientes archivos existen vacíos y son el punto de entrada para implementar las capacidades de IA:

- `core/services/ai_service.dart` — servicio central de IA
- `data/models/analytics_model.dart` — modelos de datos analíticos
- `data/repositories/analytics_repository_impl.dart` — repositorio de analytics
- `features/analytics/presentation/screens/statistics_screen.dart` — pantalla de estadísticas
- `features/analytics/presentation/screens/hotspots_screen.dart` — pantalla de zonas de riesgo

**Capacidades planificadas:**

1. **Clasificación NLP de incidentes** — al crear un reporte, usar embeddings (modelo tipo DistilBERT vía API externa o tflite) para asignar categoría automáticamente con probabilidad. Categorías objetivo: Accidente de tránsito, Infraestructura, Seguridad, Emergencia climática, Servicios públicos.

2. **Detección de reportes falsos** — `analytics_repository_impl.dart` debe implementar un índice de credibilidad basado en: frecuencia de envíos por usuario/minuto, similitud semántica con otros reportes recientes, historial de reportes confirmados. Modelos candidatos: Isolation Forest o LOF (vía API Python/FastAPI).

3. **Priorización inteligente** — calcular `priorityScore` como función ponderada de: severidad NLP + confirmaciones + tipo de zona + historial de zona + hora del día − riesgo de falsedad. Almacenar en `reports` como columna adicional en Supabase.

4. **Análisis predictivo espacio-temporal** — `hotspots_screen.dart` debe mostrar mapas de calor (heatmap overlay sobre Google Maps) usando datos históricos de reportes agrupados por zona, hora y condición climática. Modelo candidato: Random Forest vía API externa.

## Tablas Supabase

- `reports`: todos los campos de `ReportModel` incluyendo `latitude`, `longitude`, `image_url`, `audio_url`, `expires_at`.
- `profiles`: `id` (FK de auth.users), `full_name`, `email`.

## Design system

Widgets propios con prefijo `Vial` en `shared/widgets/`: `VialButton`, `VialCard`, `VialTextField`. Color primario: `#005EA4`. Tipografía: Plus Jakarta Sans. Espaciado en `app/theme/app_spacing.dart`.
