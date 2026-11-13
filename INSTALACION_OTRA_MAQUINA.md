# Instalar SkillPath en otra PC Windows

SkillPath 1.0.0 · 11 de noviembre de 2026. Instalación local para Windows x64. Para aprender a usar la aplicación consulta `MANUAL_DE_USO.html` o `MANUAL_DE_USO.md`.

## Instalación rápida

1. Copia `entrega/SkillPath-1.0.0-Instalador-Windows-x64.zip` al equipo de destino.
2. Haz clic derecho en el ZIP, selecciona **Extraer todo** y elige una ruta local corta con permisos de escritura, como `C:\Proyectos`. Las dependencias de Node contienen rutas internas extensas. Abre los archivos desde la carpeta extraída.
3. Abre la carpeta `SkillPath` extraída. Debe contener `frontend`, `backend`, `README.md` e `INSTALAR_Y_ABRIR.cmd`.
4. Haz doble clic en **INSTALAR_Y_ABRIR.cmd** y espera a que termine la preparación.
5. El navegador abre [SkillPath local](http://127.0.0.1:5173). Inicia sesión como `ana.admin@skillpath.test` con `AdminDemo!2026`, o como `carla@skillpath.test` con `UsuarioDemo!2026`.

No se necesita instalar Python y Node manualmente si faltan: el preparador obtiene las distribuciones oficiales portables. No necesitas Codex, un editor, Docker, MongoDB Compass ni una API de IA.

## Equipo y conexión

- **Windows 11 x64**, recomendado para esta demo. MongoDB 8.0 documenta Windows 11 y Windows Server 2022 de 64 bits como plataformas Windows compatibles; no se promete compatibilidad con Windows 10 o ARM64. [Compatibilidad oficial](https://www.mongodb.com/docs/v8.0/tutorial/install-mongodb-on-windows/).
- Reserva aproximadamente **4 GB libres** para código, herramientas, entornos, archivos temporales y base de demostración. Es una previsión operativa y no un resultado de pruebas de rendimiento.
- La instalación inicial necesita Internet para `api.nuget.org`, `nodejs.org`, PyPI y sus archivos, `registry.npmjs.org` y `fastdl.mongodb.org`. Una red corporativa puede requerir autorización de TI.
- La descarga inicial de MongoDB es de aproximadamente **800 MB**, además de Python, Node y los paquetes. La duración depende de la conexión; el instalador muestra sus seis etapas y el progreso de MongoDB.
- La demo usa **27018** para MongoDB y **5173** para la interfaz. La API usa **8000** o **8001** si 8000 está ocupado. Los servicios escuchan en `127.0.0.1`.

## Verificar la descarga

Compara el SHA-256 de tu ZIP con el archivo de huella incluido en la entrega.

```powershell
Get-FileHash '.\SkillPath-1.0.0-Instalador-Windows-x64.zip' -Algorithm SHA256
```

## Qué hace el instalador

1. Comprueba la arquitectura y localiza Python 3.12 y Node compatibles. Prefiere las herramientas locales del proyecto y después las instaladas que cumplen el requisito. Si faltan, descarga Python **3.12.10 x64** y Node **22.23.4 x64** dentro de `.tools`.
2. Verifica SHA256 antes de extraer y comprueba firmas de Python Software Foundation y OpenJS Foundation. Las versiones portables están fijadas en `scripts/herramientas_windows.ps1`; la huella de Node se contrastó con el manifiesto oficial del proveedor.
3. Crea `backend/.venv`, instala `requirements.txt` y ejecuta `pip check`.
4. Ejecuta `npm ci` con `package-lock.json`.
5. Compila TypeScript y la interfaz con Vite.
6. Prepara MongoDB **8.0.32** con SHA256 fijado y metadata relativa al proyecto.

Después `INSTALAR_Y_ABRIR.cmd` inicia los servicios, carga cinco cuentas y seis diagnósticos ficticios de forma idempotente y abre el navegador. La carga no restablece contraseñas ni reasigna cuentas existentes.

Los archivos completos de descarga se verifican antes de reutilizarlos; un archivo parcial no se ejecuta. La preparación guarda un registro `instalacion-AAAAmmdd-HHMMSS.log` en `.logs`. El PATH y las variables auxiliares solo cambian en el proceso de preparación. No se instala un servicio de Windows ni se cambia permanentemente la política de PowerShell.

## Uso diario

| Archivo | Uso |
| --- | --- |
| `INSTALAR_Y_ABRIR.cmd` | Primera instalación, inicio y creación de ejemplos |
| `INICIAR_DEMO.cmd` | Abrir una instalación ya preparada |
| `DETENER_DEMO.cmd` | Cerrar los servicios y conservar los datos |
| `PREPARAR_EQUIPO.cmd` | Preparar dependencias sin iniciar servicios |
| `ABRIR_MANUAL.cmd` | Leer el manual HTML sin iniciar la aplicación |

Cierra la aplicación con `DETENER_DEMO.cmd` antes de reinstalar dependencias. El preparador bloquea cambios mientras esa misma copia está funcionando; `-Comprobar` sí se puede ejecutar con la demo abierta.

## Opciones de preparación

Abre una terminal en la carpeta extraída. Los espacios en la ruta están admitidos.

```powershell
Set-Location 'C:\Proyectos\SkillPath'
powershell.exe -NoProfile -ExecutionPolicy Bypass -File '.\PREPARAR_EQUIPO.ps1' -Comprobar
```

Para forzar herramientas portables aunque existan otras instaladas:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File '.\PREPARAR_EQUIPO.ps1' -HerramientasLocales
```

Para instalar también pytest y HTTPX:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File '.\PREPARAR_EQUIPO.ps1' -ConPruebas
```

Para recuperar un entorno copiado o incompleto, detén primero la aplicación y ejecuta:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File '.\PREPARAR_EQUIPO.ps1' -RecrearEntorno
```

Se renombra únicamente `backend/.venv` como `.venv-respaldo-<identificador>` y se crea un entorno nuevo. Los datos MongoDB se conservan. Si quieres elegir un Python 3.12 existente, indica `-PythonExe 'C:\ruta\python.exe'`.

`-CacheDir 'D:\cache'` permite reutilizar archivos oficiales ya descargados, siempre verificando SHA256. Busca el archivo esperado directamente en esa carpeta o en sus subcarpetas `downloads` y `mongodb`. La caché reduce descargas de herramientas; no vuelve la instalación completamente offline porque pip y npm todavía pueden requerir Internet.

## Servicios, comprobación y registros

| Componente | Dirección |
| --- | --- |
| Aplicación | http://127.0.0.1:5173 |
| API / documentación | http://127.0.0.1:8000/docs o http://127.0.0.1:8001/docs según el puerto que indique el iniciador |
| MongoDB | mongodb://127.0.0.1:27018, base `skillpath_demo` |

```powershell
Invoke-RestMethod 'http://127.0.0.1:5173/api/health'
```

Resultado esperado: `status: ok`, `database: mongodb`. En `.logs` están los registros de instalación, MongoDB, backend y frontend. Un fallo parcial de inicio registra los procesos creados para que `DETENER_DEMO.cmd` pueda cerrarlos. El iniciador comprueba la API y sirve la interfaz compilada. El cierre solicita a la API y MongoDB que terminen antes de confirmar la detención.

## Problemas frecuentes

- **El `.ps1` no tiene firma:** usa los accesos `.cmd`; su excepción de PowerShell dura solo ese proceso. No cambies la política permanente del equipo. Una directiva corporativa puede requerir TI.
- **Puerto ocupado:** cierra la otra copia o el servicio correspondiente. El iniciador rechaza un puerto ocupado sin un proceso registrado de esta copia; no cierra servicios ajenos.
- **Python/Node no se descargan:** revisa Internet, fecha/hora de Windows y acceso a los dominios anteriores. Conserva el registro de instalación. No omitas las verificaciones de firma o SHA256.
- **Entorno virtual inválido:** detén la demo y prepara con `-RecrearEntorno`.
- **No hay administradores al registrarse:** ejecuta la instalación inicial para cargar los ejemplos. Si una cuenta ficticia fue modificada, la carga avisa y no la sobrescribe.
- **Cambios de interfaz no visibles:** usa Ctrl+F5.
- **Una instalación muestra otros datos:** revisa desde qué carpeta la iniciaste. Cada copia usa su propio `data/mongodb`.

## Trasladar también datos existentes

El ZIP excluye datos, sesiones, `.env`, herramientas, entornos y paquetes. No copies `.venv` ni `node_modules`: se recrean en destino.

Para trasladar la base físicamente entre estas dos instalaciones Windows: detén ambas copias; usa la misma versión MongoDB 8.0.32; conserva aparte cualquier base del destino; copia completa `data/mongodb` y verifica después cuentas, diagnósticos y avance. No mezcles carpetas ni copies archivos de una base abierta. Si migraste cuentas existentes, utiliza `INICIAR_DEMO.cmd` y no necesitas cargar de nuevo los ejemplos.

No se incorpora un respaldo lógico ni una migración entre versiones. Para un piloto con datos reales faltan ese procedimiento de restauración, HTTPS, MongoDB autenticado y alojamiento autorizado.

## Preparar el paquete para entregar

Desde la carpeta de desarrollo:

```powershell
backend\.venv\Scripts\python.exe scripts\generar_manual.py
backend\.venv\Scripts\python.exe scripts\empaquetar_proyecto.py --output entrega\SkillPath-1.0.0-Instalador-Windows-x64.zip
```

Entrega el ZIP generado en `entrega`, junto a su archivo `.sha256` si quieres comprobar la integridad del traslado. Incluye el manual HTML y Markdown, los accesos, el bootstrap portable y el código. Los originales del cliente que están fuera de SkillPath no se incluyen ni se modifican.

Las pruebas de instalación en carpeta limpia de esta misma computadora no sustituyen una prueba física en el equipo destinatario. Las evidencias actuales se documentan en `CONTEXTO.md` y `analisis/09_INTERFAZ_INSTALADOR_MANUAL.md`.
