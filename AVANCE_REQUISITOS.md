# Avance verificable de SkillPath

Fecha de corte: 11 de noviembre de 2026.

**Los ocho requisitos funcionales tienen implementación y verificación técnica en SkillPath 1.0.0.** La aprobación general de iCloudFlex fue informada por el solicitante el 11 de noviembre de 2026. El cuadro conserva los criterios específicos del piloto y su estado de evidencia.

El ensayo local de RNF-02 completó 540 de 540 solicitudes con 45 clientes HTTP concurrentes. El percentil 95 fue 780,04 ms y el máximo 860,43 ms. En el nivel exploratorio de 90 clientes se completaron 1 080 de 1 080 solicitudes y el percentil 95 alcanzó 3 188,65 ms. El entorno y el banco de datos fueron locales y de prueba.

## Cómo se obtiene

La lista interna pondera por igual cinco criterios de cada RF. El editor de competencias y preguntas completa el criterio pendiente del RF-04. El RF-07 ya permite revisar y corregir evidencias en la aplicación. Su último criterio requiere validar ese flujo durante el piloto con iCloudFlex.

La numeración se contrastó con el informe fuente `2026-1 ISC-Capstone Project Sistemas.docx`, tabla RF-01 a RF-08 (extracción local, líneas 661–716). Corrección respecto de los primeros Markdown: **RF-05 es asociación de recursos con competencias; RF-06 es el panel privado del colaborador**. El login y los permisos son controles transversales de seguridad/RNF que habilitan RF-06. Las fuentes originales permanecen intactas.

| RF | Alcance | Cumplidos / total | Avance interno | Pendiente concreto |
| --- | --- | --- | --- | --- |
| RF-01 | Evaluación y brechas | 4 / 5 | 80 % | Validación empresarial del banco de preguntas y los niveles |
| RF-02 | Ruta automática | 4 / 5 | 80 % | Medición de pertinencia con participantes reales |
| RF-03 | Tablero analítico | 4 / 5 | 80 % | Medición en infraestructura del piloto. Ensayo local aprobado a 45 clientes HTTP concurrentes |
| RF-04 | Puestos y matriz | 5 / 5 | 100 % | Criterios internos completos |
| RF-05 | Recursos y competencias | 4 / 5 | 80 % | Validación empresarial del contenido y disponibilidad de enlaces |
| RF-06 | Panel privado del colaborador | 4 / 5 | 80 % | Prueba de usabilidad y aceptación con usuarios del cliente |
| RF-07 | Evaluaciones y progreso | 4 / 5 | 80 % | Validar con iCloudFlex los criterios y el flujo de revisión de evidencias |
| RF-08 | Reportes consolidados | 4 / 5 | 80 % | Aceptación del formato del reporte por el cliente |

## Lista de comprobación y evidencia

### RF-01 — Evaluación y brechas

- [x] Selección de las cuatro categorías
- [x] Cálculo ponderado y validación de respuestas
- [x] Aplicación de la matriz del puesto seleccionado
- [x] Persistencia de diagnóstico, claves y snapshot
- [ ] Validación empresarial del banco de preguntas y los niveles

Evidencia: `test_scoring.py; test_categories.py; test_create_consult_and_evaluate_job_with_own_matrix`. Pruebas en `backend/tests/`; JSON/capturas en `.logs/qa/`.

### RF-02 — Ruta automática

- [x] Recursos solo para competencias con brecha
- [x] Prioridad por brecha/criticidad y prerrequisitos
- [x] Idempotencia y almacenamiento de la ruta
- [x] Rutas incompletas explícitas y snapshots conservados
- [ ] Medición de pertinencia con participantes reales

Evidencia: `test_recommendation.py; test_api_mongodb.py; test_new_catalog_only_affects_new_routes`. Pruebas en `backend/tests/`; JSON/capturas en `.logs/qa/`.

### RF-03 — Tablero analítico

- [x] Indicadores calculados sobre MongoDB
- [x] Filtro por categoría
- [x] Alcance propio o equipo asignado
- [x] Brechas, rutas y actividades con denominadores
- [ ] Medición de rendimiento bajo la carga del piloto (RNF)

Evidencia: `test_progress_dashboard.py; test_auth_team.py`. Pruebas en `backend/tests/`; JSON/capturas en `.logs/qa/`.

### RF-04 — Puestos y matriz

- [x] Alta y consulta de puestos dentro de cuatro categorías
- [x] Asociación de competencias y niveles/criticidades
- [x] Edición, retiro y control de concurrencia
- [x] Matriz versionada aplicada a nuevas evaluaciones
- [x] Alta y edición de competencias y preguntas desde el banco, con aplicación a puestos y nuevas evaluaciones

Evidencia en `test_catalog_reports.py` y `test_competencies_evidence.py`. Recorrido de alta, edición, asociación y evaluación en `.logs/qa/nov10-interfaz.json`.

### RF-05 — Recursos y competencias

- [x] Alta y consulta de recursos asociados
- [x] Edición y retiro con actor/motivo
- [x] Validación de enlaces, niveles y prerrequisitos
- [x] Catálogo persistente aplicado a nuevas rutas
- [ ] Validación empresarial del contenido y disponibilidad de enlaces

Evidencia: `test_resources_created_updated_and_recorded_with_actor; test_resource_graph_levels_and_url_validation; test_new_catalog_only_affects_new_routes`. Pruebas en `backend/tests/`; JSON/capturas en `.logs/qa/`.

### RF-06 — Panel privado del colaborador

- [x] Consulta de ruta y competencias pendientes
- [x] Consulta de recursos asignados
- [x] Porcentaje y estados de avance propios
- [x] Bloqueo de información de otras personas
- [ ] Prueba de usabilidad y aceptación con usuarios del cliente

Evidencia: `test_auth_team.py; test_progress_dashboard.py; login-equipos-ui.json`. Pruebas en `backend/tests/`; JSON/capturas en `.logs/qa/`.

### RF-07 — Evaluaciones y progreso

- [x] Estados y notas guardados por actividad
- [x] Porcentajes y estados recalculados
- [x] Historial con autor y conflictos 409
- [x] Reevaluación comparable sin alterar antecedentes
- [ ] Validar en el piloto la revisión de evidencias. El flujo permite enviar nota y enlace, solicitar cambios, reenviar y validar con el responsable del equipo.

Evidencia en `test_progress_dashboard.py`, `test_categories.py` y `test_competencies_evidence.py`. Recorrido de revisión y reenvío en `.logs/qa/nov10-interfaz.json`.

### RF-08 — Reportes consolidados

- [x] Brechas, rutas, avance y competencias por persona
- [x] Filtros de categoría/persona/fechas
- [x] Exportación CSV consistente y protegida frente a fórmulas
- [x] Separación por equipo e instrumentos comparables
- [ ] Aceptación del formato del reporte por el cliente

Evidencia: `test_report_matches_database_and_csv_uses_same_rows; test_report_calendar_boundaries_and_csv_formula_protection; oct19-catalogos-reportes-ui.json`. Pruebas en `backend/tests/`; JSON/capturas en `.logs/qa/`.

## Entrega del 19 de octubre

- Administración de puestos, competencias asociadas y requisitos dentro de las cuatro categorías confirmadas. No se añadieron categorías junior/senior.
- Catálogo de recursos persistente con altas, edición, retiro, enlaces, niveles, prerrequisitos y auditoría.
- Reporte privado de equipo con CSV, filtros y estado por persona/instrumento. No se mezclan puntuaciones de distintos puestos o versiones.
- Guía `INSTALACION_OTRA_MAQUINA.md`, preparador Windows, rutas portables de MongoDB y ZIP de código transferible.

Verificación: 75 pruebas previas y 28 nuevas aprobadas con MongoDB real; compilación aprobada; Edge verificó puestos, matriz aplicada, conservación histórica, recursos, reportes/CSV, equipos y móvil. Sin errores JavaScript ni desbordamiento horizontal de página; capturas inspeccionadas.

Instalación y reinicio finales: Instalación limpia y arranque real desde carpeta reubicada aprobados en esta misma PC; no una segunda PC física. Demo original reiniciada, sesión conservada y huellas intactas de 5 cuentas, 33 diagnósticos, 29 rutas y 10 documentos de avance. Evidencia: .logs/qa/oct19-instalacion-verificada.json y oct19-arranque-reubicado-verificado.json.

## Validaciones del piloto y despliegue

La entrega 1.0.0 instala el producto en Windows y usa datos de demostración. La evaluación en el entorno del piloto abarca la matriz y el banco de preguntas, la pertinencia de las rutas, los recursos, la usabilidad, el flujo de evidencias, el formato de reportes y la carga en infraestructura del cliente. Para el despliegue con datos reales quedan HTTPS, MongoDB autenticado, respaldo y restauración y la gestión de cuentas.

Los datos, preguntas y ejemplos actuales son ficticios; la aplicación permite demostrar el flujo completo, pero todavía no acredita resultados de mejora laboral de iCloudFlex.

## Verificación del 11 de noviembre

La suite completa pasó 107 pruebas con MongoDB aislado. Edge comprobó el banco, el diagnóstico por puesto y el flujo de corrección y aprobación de evidencias en escritorio y móvil. La compilación TypeScript/Vite pasó. Evidencias locales en `.logs/qa/nov10-pytest.xml` y `.logs/qa/nov10-interfaz.json`.
