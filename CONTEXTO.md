# Contexto de SkillPath

Última actualización: 11 de noviembre de 2026, America/Lima.

**Cierre 1.0.0.** El solicitante confirmó la aprobación general de iCloudFlex el 11 de noviembre. Se entregó un instalador local Windows x64 en ZIP con lanzador CMD, manual de uso HTML y guía de instalación. El iniciador sirve la compilación de la interfaz y la API admite cierre ordenado desde el acceso de Windows. Ver `AVANCE_REQUISITOS.md` y `output/pdf/SkillPath_Informe_de_control_de_calidad_1.0.0.pdf`.

Verificación de cierre: 22 pruebas unitarias y 85 de integración aprobadas con MongoDB aislado, seis recorridos de sistema en Edge y 1 812 solicitudes de carga atendidas. Con 45 clientes HTTP concurrentes, p95 780,04 ms y máximo 860,43 ms. Con 90, p95 3 188,65 ms. La instalación se ensayó en una carpeta corta con espacios y dependencias de cachés locales por la restricción de red del entorno. Evidencias en `.logs/qa/cierre-1.0.0`. El trabajo utilizó una copia de QA con datos ficticios.

Estado vigente: RF-04 incorpora un banco de competencias y preguntas administrable. Las nuevas competencias se pueden asociar a puestos y recursos. RF-07 incorpora nota y enlace opcional como evidencia, validación o solicitud de cambios por el administrador del equipo e historial de revisiones. Avance interno estimado del 82,5 % (33/40 criterios). Ver `AVANCE_REQUISITOS.md` y `MANUAL_DE_USO.md`.

Los cambios del banco versionan los cuestionarios afectados y conservan el historial. El avance registrado y el número de evidencias validadas se muestran por separado. La revisión se verificó con cuentas y datos ficticios. El piloto y sus criterios de aceptación siguen pendientes.

Actualización del 22 de octubre: interfaz renovada, búsqueda/filtros del equipo, menú móvil y ayuda; instalación automática de herramientas portables si faltan, manual HTML/Markdown y paquete actualizado. Detalle y verificaciones: `analisis/09_INTERFAZ_INSTALADOR_MANUAL.md`. La demo sigue siendo local y el 80 % funcional no cambia por esta mejora de interfaz/operación.

Estado operativo más reciente: **apagado por petición del usuario el 22 de octubre de 2026**. Se ejecutó `DETENER_DEMO.ps1` y se comprobó que frontend, API y MongoDB cerraron los puertos 5173, 8000 y 27018. Los datos se conservan. Los registros anteriores de «demo ejecutándose» describen verificaciones históricas.

El 23 de octubre se creó el miniinforme solicitado: `output/pdf/Miniinforme_SkillPath.pdf` (4 páginas, 8 capturas reales) y su versión HTML autónoma, con panel, evaluación, brechas, ruta/avance, equipo, reportes, puestos y recursos. Generador: `scripts/generar_miniinforme.py`. Se revisaron visualmente las cuatro páginas renderizadas. Las capturas utilizan cuentas y datos ficticios; no acreditan resultados empresariales.

Para las fotos se abrió una demo aislada con base `skillpath_informe_demo` en `.logs/qa/informe-oct23/mongodb`, API 8001 y MongoDB 27019. **Quedó apagada**; puertos temporales 5173, 8001 y 27019 cerrados, ver `.logs/qa/informe-oct23/apagado-verificado.json`. Los datos habituales no se modificaron. El puerto 8000 estaba ocupado por otro servicio y no se alteró; comprobar su propietario antes de intentar el iniciador habitual.

## Encargo e indicaciones del usuario

- El usuario recibió un encargo pagado relacionado con un trabajo final de Capstone Project.
- La primera tarea es analizar la información entregada y proponer arquitectura y tecnologías.
- Carpeta vigente desde el 22 de octubre de 2026: `D:\Capstone Diana\SkillPath`, extraída del ZIP de código. La indicación anterior de usar `D:\Capstone Diana\Software` corresponde a la instalación histórica.
- Solicitó guardar contexto en archivos Markdown para continuar en nuevos chats.
- Idioma de trabajo: español.
- El 10 de octubre de 2026 el usuario confirmó cuatro categorías para sustituir los perfiles iniciales: Soporte TI 24/7/365, Desarrollo Web Moderno, Infraestructura y Virtualización, y Redes y Ciberseguridad. Continuar conforme a los RF documentados.
- Entrega final: diciembre de 2026 según los documentos. El día exacto está pendiente: las fuentes mencionan 4 y 15 de diciembre.
- Prioridad inmediata confirmada: al menos una funcionalidad implementada para el viernes 9 de octubre de 2026.
- **MongoDB es obligatorio**, según confirmación expresa del usuario. Tiene prioridad sobre PostgreSQL en los archivos originales.
- El usuario supuso que MongoDB se pide por machine learning. No confirmó que entrenar un modelo sea obligatorio. Se explicó que son decisiones distintas.

## Producto y alcance

- SkillPath: aplicación web interna para identificar brechas de competencias y generar rutas de aprendizaje para el área de TI de iCloudFlex, Lima.
- Flujo: puesto objetivo → evaluación → brechas → recursos/ruta → progreso → reevaluación y seguimiento.
- Roles actuales confirmados: usuario y administrador responsable de su equipo. Separación previa de supervisor/administradores funcional y técnico: propuesta pendiente de confirmar; ver documento 07.
- Fuentes: 11 archivos en `D:\Capstone Diana`: 4 DOCX, 3 XLSX, 2 PDF, 1 PPTX y una imagen EDT. Los originales no se modificaron.
- Los PDF son imágenes. Se extrajeron textos por OCR y se inspeccionaron visualmente páginas técnicas, requisitos y diagramas.

## Arquitectura vigente

- Propuesta en uso para el primer incremento: React + TypeScript + Vite, FastAPI + Pydantic, MongoDB + PyMongo.
- Backend como monolito modular. No se añadió NestJS: figura en parte de la documentación, pero no se ha confirmado como obligatorio.
- RF-02 implementado con reglas explícitas y ponderaciones. No se añadió machine learning ni una API de IA.
- CSS propio en todos los módulos actuales, incluidos los gráficos de seguimiento con HTML/CSS. Tailwind y ECharts no están instalados.
- PostgreSQL, SQLAlchemy y Alembic no forman parte del stack vigente. Dos dependencias SQL se instalaron en el entorno virtual antes de recibir la obligación de MongoDB, pero no se usan ni figuran en requirements.
- MongoDB Community portable 8.0.32, descargado del proveedor y verificado con SHA256, dentro de `.tools/mongodb/`. No se instaló como servicio de Windows ni se cambió PATH.

## Primera funcionalidad implementada y verificada

- RF-01: elección entre dos puestos de ejemplo, nueve preguntas técnicas en tres competencias (Python, SQL, HTTP), evaluación ponderada en servidor y comparación con requisitos del puesto.
- Resultado: puntuación, brecha en puntos, brecha relativa y estado por competencia.
- Guarda evaluación, respuestas, snapshots y versiones en MongoDB. Historial de las últimas 20 evaluaciones y exportación CSV.
- Frontend con diseño de escritorio y móvil. Navegación entre pasos conserva respuestas.
- API valida respuestas faltantes, repetidas, ajenas al puesto, opciones inválidas y versiones antiguas. No expone claves de respuesta en el cuestionario público.
- 13 pruebas pytest pasaron, incluyendo persistencia en MongoDB real y recuperación con nueva conexión. Bases de prueba aisladas con prefijo `test_skillpath_`.
- Build del frontend pasó. Prueba en navegador verificó flujo completo, regreso entre pasos, resultado conocido, persistencia tras recarga, exportación y ausencia de desbordamiento móvil o errores JavaScript.
- Se comprobó apagado ordenado y reinicio real de MongoDB: las dos evaluaciones de demostración se conservaron. El iniciador y el cierre verifican PID, ejecutable y fecha de inicio de los procesos registrados.
- Hay una advertencia de deprecación de TestClient/HTTPX en las versiones actuales y una advertencia de caché de pytest, sin fallos de pruebas.
- Los datos y el banco de preguntas son ejemplos. No son información real ni instrumentos validados de iCloudFlex.
- RF-01/RF-02 se mantienen. RF-03/RF-07 se incorporaron el 8 de octubre; ver el incremento de seguimiento más abajo. Autenticación/RBAC y catálogos administrables siguen pendientes. No se publicó el sistema.

## Segunda funcionalidad implementada y verificada

- Petición del 7 de octubre: continuar y desarrollar otro RF usando el contexto. Se implementó RF-02, generación de rutas como continuación del diagnóstico.
- Ruta automática al completar o consultar una evaluación, solo para competencias con brecha. Se prioriza brecha relativa × criticidad, con bases antes del recurso principal cuando el nivel actual no alcanza su entrada.
- Catálogo de demostración: seis actividades, enlaces oficiales Python/SQL/HTTP, prácticas y tiempos estimados. Criticidades y niveles son ejemplos pendientes de validación. SQL conserva material de aprendizaje aunque MongoDB sea la base de la aplicación.
- Criticidad queda en el snapshot; evaluaciones previas sin ese dato usan valor neutro 1. No se añaden prerrequisitos de competencias alcanzadas ni se inventa contenido faltante.
- Guarda una ruta inmutable por evaluación en `learning_paths`, con índice único, diagnóstico, reglas, prioridades, explicaciones y recursos seleccionados. Repetir la solicitud recupera la misma ruta, también bajo concurrencia.
- API POST/GET `/api/evaluations/{id}/learning-path`. POST devuelve 201 al crear o 200 al recuperar; GET devuelve 404 si todavía no existe. Estados sin brechas, completo, parcial o sin recursos.
- Interfaz con actividades, enlaces, duración, explicación, estado sin brechas y reintento independiente del diagnóstico.
- 26 pruebas pytest pasaron (13 nuevas de RF-02), incluyendo cuatro solicitudes simultáneas, persistencia real y recuperación con nueva conexión. Build aprobado.
- Navegador Edge/Playwright verificó las cinco actividades y 390 minutos del caso intermedio, recuperación tras recarga, reintento 503, caso sin brechas, CSV y móvil sin desbordamiento ni errores JavaScript. Capturas inspeccionadas.
- Se corrigieron scripts de inicio/cierre: lectura de JSON vacío, comparación robusta de fechas y cierre del proceso hijo de Uvicorn. Apagado de los tres puertos comprobado.
- Reinicio real final comprobado: se conservaron las 7 evaluaciones y 3 rutas de demostración, incluida la misma ruta y sus actividades. Evidencia en `.logs/qa/reinicio-rf02.json`.
- Detalle de reglas, límites y guion en `analisis/04_RF02_RUTAS_DE_APRENDIZAJE.md`; evidencias locales en `.logs/qa/`.

## Incremento de seguimiento: RF-03 y RF-07

- Petición del 8 de octubre: continuar directamente desde los Markdown, avanzar al menos dos requisitos y mejorar la presentación del software.
- RF-03: panel inicial con filtro por puesto, indicadores sobre todas las evaluaciones/rutas/actividades persistidas, brechas por competencia, estado de formación y acceso a diagnósticos recientes. El total no se limita a las 20 evaluaciones del historial. Cuenta registros de demo, no personas únicas.
- RF-07: estados y nota por actividad, porcentaje, tiempo pendiente e historial. MongoDB guarda estado/versión/evento atómicamente; conflictos entre ventanas devuelven 409. Sin actividades, porcentaje nulo. El progreso declarado no cambia puntuaciones ni demuestra dominio.
- Reevaluación vinculada al mismo puesto con comparación de puntuación y brechas, conservando diagnóstico y progreso previos. Versiones o requisitos diferentes se señalan como no comparables.
- Interfaz mejorada: panel visual, barra lateral verde, texto más legible, controles etiquetados, actividades completadas y diseño adaptable. La presentación mejorada es la del software; no se editaron los originales ni se creó PPTX.
- 36 pruebas pytest aprobadas (26 anteriores + 10 nuevas), build aprobado. Navegador Edge verificó regresión RF-01/RF-02 y nuevos filtros, métricas, guardado, notas, 503/reintento, 409 entre ventanas, recarga y reevaluación. Escritorio/móvil inspeccionados sin desbordamiento ni errores JavaScript.
- Caso nuevo: seis actividades, tres completas y una en curso = 50 %; reevaluación 0 → 100 con el avance anterior conservado. Son datos de ejemplo creados por QA.
- Cierre de MongoDB ahora espera la terminación real del proceso, corrigiendo una carrera de reinicio. Salida temporal de evaluaciones normalizada a milisegundos. Reinicio real aprobado: se conservaron las 12 evaluaciones, 8 rutas y 1 registro de progreso, junto con diagnósticos, comparación y métricas. Evidencia: `.logs/qa/reinicio-rf03-rf07.json`. La demo quedó ejecutándose.
- Detalle, límites y guion en `analisis/05_RF03_RF07_PANEL_Y_PROGRESO.md`; evidencias en `.logs/qa/rf03-rf07-ui.json` y capturas. Nuevos módulos `progress.py`, `dashboard.py`, `Dashboard.tsx` y prueba `scripts/probar_seguimiento.cjs`.
- Acceso sigue compartido y local: **RF-06/autenticación/RBAC no está implementado**. No presentar este incremento como seguimiento privado de un equipo real.

## Adaptación vigente: cuatro categorías de servicio

- Implementada el 10 de octubre de 2026 por petición del usuario. Las cuatro categorías confirmadas sustituyen los perfiles junior/intermedio en selección y filtro del panel.
- Tres competencias y nueve preguntas propias por categoría: 12 competencias y 36 preguntas en total. Desarrollo Web Moderno incluye HTML/CSS/accesibilidad, JavaScript y HTTP.
- 24 actividades para las categorías actuales, con enlaces y prácticas. Matriz y recursos en JSON versionado. Niveles, pesos, preguntas, criticidades y tiempos son ejemplos pendientes de validación.
- Se mantienen evaluación, rutas, avance y reevaluación de RF-01/RF-02/RF-03/RF-07. Administración autenticada de catálogos, validación empresarial, privacidad y reportes de equipo todavía no están completos.
- Diagnósticos anteriores legibles, marcados como perfiles anteriores y contados aparte, con sus rutas y progreso originales. No se reasignan ni se ofrecen para nuevas evaluaciones o comparaciones ficticias.
- 36 pruebas anteriores y 11 nuevas aprobadas con MongoDB real; build aprobado. Tres recorridos de Edge verificaron categorías, regresión, filtros, notas, 503, 409, reevaluación, historial y móvil. Capturas inspeccionadas sin desbordamiento ni errores JavaScript.
- Conservación exacta verificada de los datos anteriores: 15 evaluaciones, 11 rutas y un registro de progreso. Reinicio final real aprobado: 25 evaluaciones, 21 rutas y siete registros de progreso intactos; API recuperó los flujos y avance de las cuatro categorías. Demo ejecutándose. Evidencia: `.logs/qa/categorias-reinicio-verificado.json`.
- Alcance, matriz, trazabilidad de los ocho RF y evidencias en `analisis/06_CATEGORIAS_Y_TRAZABILIDAD_RF.md`; capturas y resultados en `.logs/qa/`.

## Login y equipos: incremento vigente RF-06

- El 10 de octubre el usuario confirmó relación 1:N: un administrador puede tener muchos usuarios; cada usuario escoge un administrador existente y activo al registrarse. Sin responsable válido no se crea la cuenta.
- Implementados login, registro, sesiones revocables de ocho horas, cierre y permisos por propietario/equipo en backend. Argon2id, correo único, cookie HttpOnly/SameSite, CSRF e intentos limitados. No hay registro público de administradores.
- «Mi equipo»: personas asignadas, historial paginado, actividades/notas y evolución por categoría e instrumento comparable. Administrador consulta; usuario registra su propio avance.
- Dos administradores y tres usuarios ficticios: Ana Torres → Carla Ruiz y Diego Pérez; Luis Medina → Lucía Gómez. Dos diagnósticos propios por persona y notas ficticias. Correos y claves en README.
- Registros anónimos anteriores intactos en MongoDB, sin reasignación ni acceso desde cuentas nuevas. Conservación SHA256 comprobada: 27 diagnósticos, 23 rutas y 7 documentos de progreso.
- Build y recorrido Edge de acceso/registro/equipos, cuatro categorías, avance, reevaluación y CSV aprobados. Capturas de escritorio/móvil inspeccionadas, sin desbordamiento ni errores JavaScript. UI probada en base temporal para mantener cinco cuentas en la demo.
- Suite de backend: 75 pruebas aprobadas: suite completa de 74 y una prueba adicional de categoría inválida; además, se repitió satisfactoriamente la prueba de CSRF/caducidad/revocación con cabecera no ASCII. Las 47 pruebas previas se conservan usando login real. Advertencia de deprecación de TestClient/httpx sin fallos. Reinicio final: aprobado con MongoDB y los tres procesos reiniciados: 5 cuentas, 33 diagnósticos, 29 rutas y 10 documentos de progreso conservados exactamente. Tres sesiones sobrevivieron al reinicio; equipos 2/1 e historiales 4/2/2 comprobados. Demo ejecutándose. Evidencia en .logs/qa/login-reinicio-verificado.json.
- Detalle en `analisis/07_RF06_LOGIN_Y_EQUIPOS.md`. Este apartado actualiza las limitaciones de autenticación de los incrementos históricos anteriores.


## Incremento vigente del 19 de octubre: puestos, recursos y reportes

- Petición: continuar los RF, alcanzar al menos el 70 % y dejar un tutorial para otra máquina.
- Se contrastó la tabla RF original: RF-05 = asociar recursos; RF-06 = panel privado. Login/RBAC son controles transversales de RNF-01. Las etiquetas previas de los Markdown eran abreviaturas imprecisas.
- RF-04: alta/consulta/edición/retiro de puestos dentro de las cuatro categorías; competencias existentes asociadas, niveles y criticidades, revisión esperada y auditoría. El usuario puede elegir puesto; backend aplica sus preguntas/requisitos y conserva snapshots. Falta crear competencias y preguntas nuevas desde la app.
- RF-05: catálogo MongoDB con alta/edición/retiro de recursos, asociaciones, enlaces seguros, prerrequisitos/ausencia de ciclos y auditoría. Nuevas rutas usan la revisión persistida; anteriores no se alteran.
- RF-08: reporte privado por equipo con filtros de categoría/persona/fechas y CSV; brechas, alcanzadas, rutas, avance y puntuaciones comparables. Personas sin diagnóstico no se consideran nivel cero.
- Catálogos comunes administrados por ambos administradores; historiales y reportes personales restringidos al equipo. Esta implementación no cambia la relación 1:N confirmada.
- Guía INSTALACION_OTRA_MAQUINA.md, PREPARAR_EQUIPO.ps1, empaquetado de código sin datos/entornos y corrección de rutas portables MongoDB. Se reparó el venv local porque apuntaba a un Python Microsoft Store no disponible; usa Python 3.12.7 instalado.
- 75 pruebas anteriores y 28 nuevas aprobadas, build aprobado. Edge aprobó puestos/matriz, recursos, reportes/CSV, privacidad y móvil; capturas inspeccionadas sin errores JavaScript ni desbordamiento de página.
- Matriz interna: 32 de 40 criterios cumplidos = 80 % funcional estimado del MVP. No equivale a aceptación del cliente ni avance de toda la tesis. Ocho pendientes explícitos en AVANCE_REQUISITOS.md.
- Instalación y reinicio finales: Instalación limpia y arranque real desde carpeta reubicada aprobados en esta misma PC; no una segunda PC física. Demo original reiniciada, sesión conservada y huellas intactas de 5 cuentas, 33 diagnósticos, 29 rutas y 10 documentos de avance. Evidencia: .logs/qa/oct19-instalacion-verificada.json y oct19-arranque-reubicado-verificado.json.
- Detalle y evidencias en analisis/08_CATALOGOS_REPORTES_INSTALACION.md.

## Reinstalación del 22 de octubre de 2026

- El usuario pidió reinstalar el proyecto extraído y leer los Markdown porque no podía ejecutar los scripts. Se leyeron los documentos de raíz y los ocho documentos de `analisis/`.
- Se encontraron los tres `.ps1` con `Zone.Identifier` y política `RemoteSigned`; solo se detectó Python 3.11 y no había `.venv`, `node_modules` ni MongoDB en esta carpeta. Node 22.14.0 y npm 10.9.2 sí estaban disponibles.
- Se preparó Python 3.12.10 de 64 bits dentro de `.tools/python312/tools/python.exe`, desde el paquete oficial de CPython para NuGet. Firma del ejecutable válida, editor Python Software Foundation; origen y SHA256 en `.tools/python312/origen.json`. No se cambió el PATH ni la política permanente de PowerShell.
- `PREPARAR_EQUIPO.ps1` detecta primero ese runtime local. Entorno nuevo con `requirements-dev.txt`, `npm ci`, build y MongoDB 8.0.32 descargado y verificado contra la huella fijada. `pip check` y `-Comprobar` aprobados.
- Se desbloquearon exclusivamente `PREPARAR_EQUIPO.ps1`, `INICIAR_DEMO.ps1` y `DETENER_DEMO.ps1`. Nuevos accesos `.cmd` con ruta relativa a su propia ubicación: preparar, iniciar/abrir navegador y detener. Errores visibles; excepción de ejecución limitada al proceso. Los tres se incluyen en el empaquetador.
- Inicio real aprobado desde `INICIAR_DEMO.cmd`. Creadas cinco cuentas ficticias, seis diagnósticos y sus rutas/progreso. El ZIP de código no contiene la base histórica; esta reinstalación usa sus propios datos en `SkillPath/data/mongodb` y no modifica los archivos originales de la carpeta superior.
- Comprobación HTTP real a través del frontend: página 200, salud MongoDB `ok`, login de Ana/Luis/Carla, cuatro categorías, equipos 2/1, historiales 4/2/2, reportes y CSV de administradores, acceso de usuario al equipo rechazado. Evidencia: `.logs/qa/oct22-reinstalacion-http.json`.
- Suite completa: **103 pruebas aprobadas** en 183,78 segundos. Un aviso de deprecación de TestClient/httpx, sin fallos. Evidencia: `.logs/qa/oct22-reinstalacion-pytest.xml`.
- Cierre y reinicio real aprobados con `scripts/verificar_login_reinicio.py`: huellas intactas de 5 cuentas, 6 diagnósticos, 6 rutas y 3 documentos de progreso; tres sesiones sobrevivieron, equipos 2/1 e historiales 4/2/2 correctos. Salud final `ok`; la demo quedó ejecutándose. Evidencia: `.logs/qa/oct22-reinstalacion-reinicio.json`.
- Las evidencias y cantidades de los incrementos de octubre 7–19 son históricas y no describen los datos de esta carpeta nueva.

## Arranque y operación local

- Carpeta: `D:\Capstone Diana\SkillPath`. Doble clic en `INICIAR_DEMO.cmd` para iniciar y abrir el navegador; `DETENER_DEMO.cmd` para cerrar. Alternativa: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File '.\INICIAR_DEMO.ps1'`. Abre procesos ocultos y escucha solo en localhost.
- Primera instalación en otra PC: extraer el ZIP actualizado de `entrega` y ejecutar `INSTALAR_Y_ABRIR.cmd`. Descarga Python/Node oficiales portables si faltan, prepara dependencias y MongoDB, inicia y crea los ejemplos. Preparar de nuevo requiere detener esa copia; `-Comprobar` funciona en lectura con la demo abierta.
- Manual de uso: `ABRIR_MANUAL.cmd`, `MANUAL_DE_USO.html` o «Ayuda y manual» dentro de la app. HTML autónomo, capturas incrustadas e impresión. Generador: `scripts/generar_manual.py`.
- Verificación del incremento de interfaz/instalación: 103 pruebas aprobadas, build, recorrido del navegador y móvil; instalación limpia con Python 3.12.10/Node 22.23.4 portables y arranque real de la copia nueva en esta PC, cierre y retorno a la original con huellas y sesión conservadas. No se ensayó una segunda PC física. Evidencias y límites en documento 09.
- 10 de octubre de 2026: el usuario reportó bloqueo de PowerShell por falta de firma digital. README actualizado con inicio y cierre mediante `powershell.exe -NoProfile -ExecutionPolicy Bypass -File`, limitado al proceso y sin cambio de política permanente. Se ejecutó el comando de inicio y su comprobación de salud respondió `SkillPath listo en http://127.0.0.1:5173`; la demo quedó ejecutándose. No se repitió la suite funcional.
- Frontend: `http://127.0.0.1:5173`.
- API: `http://127.0.0.1:8000`, documentación `/docs`.
- MongoDB: `mongodb://127.0.0.1:27018`, base `skillpath_demo`, archivos en `data/mongodb/`.
- Logs y procesos registrados en `.logs/`. `DETENER_DEMO.ps1` permite detener la demo.
- A la conclusión de este trabajo se dejó la demo ejecutándose. En nuevos chats comprobar disponibilidad antes de asumir que sigue encendida.
- Las carpetas `.tools`, `.venv`, `node_modules`, `_fuentes`, `data` y `.logs` son locales y están excluidas por `.gitignore`.

## Documentos de referencia para continuar

1. `analisis/01_ANALISIS_DE_FUENTES.md`: alcance, fuentes, indicadores, inconsistencias y datos pendientes.
2. `analisis/02_ARQUITECTURA_PROPUESTA.md`: propuesta vigente con MongoDB y modelo documental.
3. `README.md`: instrucciones y alcance real de la demostración.
4. `analisis/03_ENTREGA_VIERNES.md`: evidencia del primer incremento y guion de demostración.
5. `analisis/04_RF02_RUTAS_DE_APRENDIZAJE.md`: reglas, API, evidencias y límites de RF-02.
6. `analisis/05_RF03_RF07_PANEL_Y_PROGRESO.md`: panel, registro de avance, reevaluación y verificaciones.
7. `analisis/06_CATEGORIAS_Y_TRAZABILIDAD_RF.md`: categorías confirmadas, matriz de demo, compatibilidad histórica y estado de los RF.
8. `analisis/07_RF06_LOGIN_Y_EQUIPOS.md`: login, relación 1:N, permisos, evolución y verificaciones.

9. analisis/08_CATALOGOS_REPORTES_INSTALACION.md: nuevos módulos, API, portabilidad y verificaciones.
10. AVANCE_REQUISITOS.md e INSTALACION_OTRA_MAQUINA.md: alcance medido y tutorial del destinatario.

## Hallazgos importantes y siguientes tareas

- Unificar los documentos: MongoDB se describe erróneamente como RDBMS con JSONB; hay stack NestJS/FastAPI frente a FastAPI solo y dos bibliotecas de gráficos.
- Presupuesto Excel duplica partidas/subtotales y tiene fechas interpretadas de forma incompatible. Informe propone S/ 30 000 y Excel detalle 11 520 sin moneda unificada.
- Una EDT agrega chatbot sin RF y el PDF largo incluye un diagrama de IoT ajeno a SkillPath. Los archivos contienen textos de plantilla y resultados redactados sin evidencia primaria adjunta.
- Siguientes prioridades: validar preguntas, recursos, revisión de evidencias y reportes con iCloudFlex. Ejecutar las pruebas del piloto y de rendimiento. Preparar HTTPS, base autenticada y respaldo/restauración para el despliegue.
- Pedir al cliente matriz de puesto-competencia, escala, pesos, preguntas validadas, recursos y participantes. Datos reales requieren autorización y controles.
- Confirmar si el docente exige también NestJS o machine learning específico. No interpretar «MongoDB obligatorio» como esas obligaciones adicionales.
- Confirmar fecha final y entorno de piloto. Mantener la demo local mientras se determina alojamiento.


