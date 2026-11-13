# SkillPath

Aplicación local para evaluar competencias TI, detectar brechas y seguir rutas de aprendizaje en cuatro categorías de iCloudFlex.

**SkillPath 1.0.0 para Windows x64.** La empresa aprobó la entrega según confirmación del solicitante del 11 de noviembre de 2026. Consulta los criterios de implementación y los pendientes del piloto en [Avance de requisitos](AVANCE_REQUISITOS.md).

## Abrir en este equipo

Carpeta vigente: `D:\Capstone Diana\SkillPath`. Haz doble clic en `INICIAR_DEMO.cmd` para iniciar y abrir el navegador; usa `DETENER_DEMO.cmd` para cerrar los servicios. `PREPARAR_EQUIPO.cmd` reinstala las dependencias cuando sea necesario y mantiene visible cualquier error. Los accesos usan una excepción de PowerShell limitada al proceso.

**Primera instalación en otra PC:** extrae `entrega/SkillPath-1.0.0-Instalador-Windows-x64.zip` y abre **`INSTALAR_Y_ABRIR.cmd`**. Prepara automáticamente las herramientas faltantes, instala, inicia y crea los ejemplos. Requiere Internet; la guía explica compatibilidad y espacio. No reutilices los entornos de esta PC.

**Manual de uso:** abre `ABRIR_MANUAL.cmd` o [MANUAL_DE_USO.html](MANUAL_DE_USO.html). Incluye instalación, cuentas, evaluaciones, rutas, progreso, equipos, catálogos, reportes y solución de errores. También está disponible desde «Ayuda y manual» de la aplicación, con descarga para consultar sin conexión.

Alternativa desde una terminal:

```powershell
Set-Location 'D:\Capstone Diana\SkillPath'
powershell.exe -NoProfile -ExecutionPolicy Bypass -File '.\INICIAR_DEMO.ps1'
```

Abre [SkillPath](http://127.0.0.1:5173). Para cerrar:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File '.\DETENER_DEMO.ps1'
```

La excepción de PowerShell solo aplica al proceso; no cambia la política permanente. Los datos permanecen en `data/mongodb`.

## Instalar en otra máquina

Consulta el [tutorial paso a paso](INSTALACION_OTRA_MAQUINA.md). El paquete para transferir es `entrega/SkillPath-1.0.0-Instalador-Windows-x64.zip`; excluye datos, logs, entornos y herramientas de esta PC.

En el destino, con Python 3.12 y Node LTS compatibles instalados:

```powershell
Set-Location 'C:\Proyectos\SkillPath'
powershell.exe -NoProfile -ExecutionPolicy Bypass -File '.\PREPARAR_EQUIPO.ps1'
powershell.exe -NoProfile -ExecutionPolicy Bypass -File '.\INICIAR_DEMO.ps1'
backend\.venv\Scripts\python.exe scripts\crear_usuarios_demo.py
```

No copies `.venv` ni `node_modules`: se recrean. La guía incluye preparación manual, solución de errores, requisitos de Internet, puertos y traslado separado de datos.

La alternativa recomendada es `INSTALAR_Y_ABRIR.cmd`: descarga Python 3.12.10 y Node 22.23.4 portables oficiales si faltan. La preparación se debe ejecutar con la copia detenida; para revisar sin reinstalar usa `PREPARAR_EQUIPO.cmd -Comprobar`.

## Cuentas ficticias

| Persona | Correo | Rol | Equipo / administrador |
| --- | --- | --- | --- |
| Ana Torres | ana.admin@skillpath.test | Administrador | Carla y Diego |
| Luis Medina | luis.admin@skillpath.test | Administrador | Lucía |
| Carla Ruiz | carla@skillpath.test | Usuario | Ana |
| Diego Pérez | diego@skillpath.test | Usuario | Ana |
| Lucía Gómez | lucia@skillpath.test | Usuario | Luis |

Clave de administradores: `AdminDemo!2026`. Clave de usuarios: `UsuarioDemo!2026`. Dos diagnósticos por usuario permiten demostrar cambios. La carga de ejemplos es idempotente y no restablece claves ni responsables.

El registro exige elegir un administrador activo. Cada usuario consulta sus registros; el administrador ve únicamente los usuarios asignados. Los diagnósticos antiguos sin propietario se conservan en MongoDB y no se adjudican a estas cuentas.

## Funcionalidades

- Cuatro categorías: Soporte TI 24/7/365, Desarrollo Web Moderno, Infraestructura y Virtualización, Redes y Ciberseguridad.
- Evaluación general por categoría o por competencias del puesto elegido, con brechas calculadas en servidor.
- Diagnóstico, respuestas, snapshots y versiones persistentes; historial paginado y CSV individual.
- Rutas explicables solo para brechas; prioridades, prerrequisitos, enlaces, tiempos y contenido pendiente.
- Actividades con nota, enlace opcional de evidencia, estado, autor, porcentaje e historial. El administrador del equipo valida la evidencia o solicita cambios.
- Reevaluación vinculada, comparación de instrumentos compatibles y conservación del progreso previo.
- Panel privado y sección «Mi equipo» con historial y evolución.
- «Puestos»: crear, consultar, editar y retirar puestos, asociar competencias y definir niveles/criticidades.
- «Puestos → Banco de preguntas»: crear y editar competencias, enunciados, opciones, respuestas correctas y pesos.
- «Recursos»: alta, edición y retiro de material; asociación, enlaces, niveles, prerrequisitos e historial.
- «Reportes»: consolidado de equipo, filtros de persona/categoría/fechas, brechas/alcanzadas/rutas/avance y exportación CSV.
- Interfaz renovada el 22 de octubre: panel con acceso a rutas pendientes, búsqueda y filtros del equipo, resumen de personas/actividades, menú móvil con etiquetas, atajo de teclado al contenido y centro de ayuda. Referencias, decisiones y verificaciones en `analisis/09_INTERFAZ_INSTALADOR_MANUAL.md`.

Los puestos y recursos forman un catálogo común administrado por los administradores. Los resultados personales siguen aislados por equipo. Los cambios afectan nuevos diagnósticos/rutas; no reescriben los anteriores.

El catálogo inicial tiene 12 competencias y 36 preguntas de demostración. Las competencias nuevas se incorporan a la evaluación al asociarlas a un puesto. Queda pendiente validar el contenido con iCloudFlex.

## Tecnologías y operación

| Componente | Tecnología / ubicación |
| --- | --- |
| Interfaz | React + TypeScript + Vite, CSS propio; `frontend/` |
| API | FastAPI + Pydantic + PyMongo + Argon2; `backend/app/` |
| Base obligatoria | MongoDB portable 8.0.32; `data/mongodb/` |
| Sesión | Cookie HttpOnly, CSRF, ocho horas y revocación |
| Documentación | `analisis/`, `CONTEXTO.md` y manuales raíz |

Interfaz compilada en http://127.0.0.1:5173. El iniciador usa el puerto 8000 para la API y prueba 8001 si 8000 está ocupado. MongoDB local en mongodb://127.0.0.1:27018, base `skillpath_demo`.

La API lee `MONGODB_URI`, `MONGODB_DATABASE` y `SESSION_COOKIE_SECURE` del proceso; no carga `.env` automáticamente. Ver `backend/.env.example`. HTTPS, autenticación de MongoDB, respaldos y alojamiento del piloto siguen pendientes.

## Verificación

Con MongoDB iniciado y dependencias de prueba instaladas:

```powershell
Set-Location 'D:\Capstone Diana\SkillPath\backend'
.venv\Scripts\python.exe -m pytest -q -p no:cacheprovider
Set-Location ..\frontend
npm.cmd run build
```

Verificación de la versión 1.0.0: **22 pruebas unitarias y 85 de integración aprobadas** con MongoDB aislado, compilación TypeScript/Vite aprobada y seis casos de sistema en Edge. La carga de 45 clientes concurrentes completó 540 solicitudes con p95 de 780,04 ms. Consulta el informe de calidad y las evidencias de la entrega.

El recorrido nuevo utiliza una base temporal y backend en puerto 8001:

```powershell
Set-Location 'D:\Capstone Diana\SkillPath'
$env:SKILLPATH_QA_SCRIPT = 'probar_catalogos_reportes.cjs'
backend\.venv\Scripts\python.exe scripts\probar_login_equipos.py
```

Requiere Playwright y Edge/Chromium disponibles. Variables opcionales: `SKILLPATH_PLAYWRIGHT_MODULE`, `SKILLPATH_BROWSER_PATH`, `SKILLPATH_NODE_PATH`. Para el recorrido anterior de login, elimina `SKILLPATH_QA_SCRIPT` de esa terminal. Evidencias en `.logs/qa/`. Los guiones históricos que usan Carla directamente pueden crear registros en la demo; se recomienda el runner aislado.

Para reconstruir el instalador de esta versión:

```powershell
backend\.venv\Scripts\python.exe scripts\empaquetar_proyecto.py --output entrega\SkillPath-1.0.0-Instalador-Windows-x64.zip
```

## API principal

- Público: `GET /api/health`, `GET /api/auth/administrators`, `POST /api/auth/register`, `POST /api/auth/login`.
- Sesión: `GET /api/auth/me`, `POST /api/auth/logout`.
- Evaluación: `GET /api/profiles`, `GET /api/profiles/{id}/assessment`, `POST /api/evaluations`, `GET /api/evaluations`, `GET /api/evaluations/{id}`.
- Ruta y progreso: `GET/POST /api/evaluations/{id}/learning-path`, `GET /api/evaluations/{id}/progress`, `PUT /api/evaluations/{id}/progress/{resource_id}`.
- Equipo: `GET /api/team`, `GET /api/team/{user_id}`, `GET /api/dashboard`.
- Puestos: `GET/POST /api/job-profiles`, `GET/PUT /api/job-profiles/{id}`.
- Banco de preguntas (administrador): `GET/POST /api/admin/competencies`, `PUT /api/admin/competencies/{id}`.
- Revisión de evidencia (administrador del equipo): `PUT /api/evaluations/{id}/progress/{resource_id}/review`.
- Recursos (administrador): `GET/POST /api/admin/resources`, `PUT /api/admin/resources/{id}`.
- Reportes (administrador): `GET /api/reports/team`, `GET /api/reports/team.csv`.

Escrituras autenticadas: cookie de sesión y `X-CSRF-Token` obtenido en login o `/auth/me`. Puestos y recursos requieren revisión esperada para editar. Progreso recibe `status`, `note`, `expected_version`; completar exige nota. Las consultas comprueban propietario/equipo en backend.

## Documentos para continuar

- [Avance, evidencia y pendientes](AVANCE_REQUISITOS.md).
- [Instalación en otro equipo](INSTALACION_OTRA_MAQUINA.md).
- [Puestos, recursos y reportes](analisis/08_CATALOGOS_REPORTES_INSTALACION.md).
- [Login y equipos](analisis/07_RF06_LOGIN_Y_EQUIPOS.md).
- [Contexto de trabajo](CONTEXTO.md).
