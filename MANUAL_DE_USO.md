# SkillPath · Manual de uso

SkillPath 1.0.0 · 11 de noviembre de 2026

Guía de la demostración local · iCloudFlex · Actualizado el 11 de noviembre de 2026.

SkillPath permite evaluar competencias TI, identificar brechas y seguir actividades de aprendizaje. Este manual cubre la instalación, el uso como colaborador y el seguimiento como administrador. Los cuestionarios, recursos y cuentas iniciales son ejemplos pendientes de validación empresarial.

## 1. Instalar en otra PC

1. Usa una computadora Windows 11 de 64 bits, arquitectura x64, con conexión a Internet y una carpeta donde puedas guardar archivos. Reserva aproximadamente 4 GB libres para herramientas, dependencias y la base de demostración; es una previsión operativa, no una medición de rendimiento.
2. Copia el archivo `SkillPath-1.0.0-Instalador-Windows-x64.zip` que está en `entrega`. Haz clic derecho y elige **Extraer todo**. No ejecutes archivos dentro del ZIP.
3. Abre la carpeta extraída que contiene `README.md`, `frontend`, `backend` e `INSTALAR_Y_ABRIR.cmd`. Puedes usar una ruta como `C:\Proyectos\SkillPath`.
4. Haz doble clic en **INSTALAR_Y_ABRIR.cmd**. Mantén abierta la ventana hasta terminar los seis pasos. La primera descarga de MongoDB pesa aproximadamente 800 MB y puede tardar varios minutos.
5. El preparador usa Python 3.12 y Node compatibles si están disponibles. Si faltan, descarga las versiones oficiales portables dentro de `.tools`; comprueba sus huellas y firmas. También instala las dependencias, compila la interfaz y prepara MongoDB.
6. Al terminar se inician los servicios, se crean las cuentas ficticias y se abre **http://127.0.0.1:5173**. Ingresa con una cuenta de la sección siguiente.

No necesitas instalar un editor, Docker, Compass ni una API de IA. La preparación estándar no solicita privilegios de administrador, no instala un servicio de Windows ni modifica el PATH permanente. Una política corporativa de tu equipo puede requerir apoyo de TI.

El paquete de código excluye bases de datos, sesiones y contraseñas reales. En otra PC comienza una demostración nueva con cuentas ficticias; la migración de datos existentes es un procedimiento separado.

## 2. Cuentas de demostración

| Nombre | Correo | Rol | Equipo o responsable |
| --- | --- | --- | --- |
| Ana Torres | ana.admin@skillpath.test | Administrador | Carla y Diego |
| Luis Medina | luis.admin@skillpath.test | Administrador | Lucía |
| Carla Ruiz | carla@skillpath.test | Usuario | Ana |
| Diego Pérez | diego@skillpath.test | Usuario | Ana |
| Lucía Gómez | lucia@skillpath.test | Usuario | Luis |

Contraseña de administradores: `AdminDemo!2026`. Contraseña de usuarios: `UsuarioDemo!2026`.

Son credenciales exclusivas de esta demostración. La carga inicial incluye dos diagnósticos por usuario. Repetir la carga conserva las cuentas existentes; no restablece sus contraseñas ni cambia responsables.

## 3. Abrir, cerrar y navegar

- **Abrir otro día:** haz doble clic en `INICIAR_DEMO.cmd`. No necesitas reinstalar las dependencias cada vez.
- **Cerrar:** primero guarda tus cambios y usa `DETENER_DEMO.cmd`. Cerrar el navegador no detiene los servicios.
- **Consultar el manual:** abre `ABRIR_MANUAL.cmd`, o entra en **Ayuda y manual** dentro de la aplicación. La versión HTML puede consultarse sin iniciar SkillPath y tiene un botón para imprimir o guardar como PDF desde el navegador.
- **En una ventana estrecha (vista móvil):** pulsa **Abrir menú** en la parte superior. El menú muestra los nombres completos de las secciones; al elegir una se cierra. Puedes cerrarlo con Escape.
- **Salir de tu cuenta:** pulsa **Salir**. La sesión dura hasta ocho horas y también puede caducar; vuelve a ingresar si la aplicación lo indica.

La dirección `127.0.0.1` abre la aplicación de esta computadora. Para usar la demo en otra PC se instala allí otra copia. Esta entrega no publica una web ni habilita acceso por la red.

## 4. Tu recorrido como usuario

### Crear una cuenta

1. En la pantalla inicial selecciona **Crear cuenta**.
2. Escribe tu nombre, correo y una contraseña de al menos 12 caracteres. Confirma la contraseña.
3. Selecciona un administrador activo y pulsa **Crear mi cuenta**.
4. Si no aparece ningún administrador en una instalación nueva, ejecuta el instalador inicial para cargar las cuentas ficticias.

El registro crea usuarios colaboradores. No permite crear administradores ni escoger otro rol.

### Realizar una evaluación

1. Entra en **Evaluación** o pulsa **Nueva evaluación** en tu panel.
2. Selecciona una categoría: Soporte TI 24/7/365, Desarrollo Web Moderno, Infraestructura y Virtualización, o Redes y Ciberseguridad.
3. Si existe un puesto específico, selecciónalo. La evaluación general utiliza las competencias de la categoría; el puesto aplica su propia selección y niveles requeridos.
4. Pulsa **Comenzar evaluación**. Responde todas las preguntas de cada paso. Usa **Anterior** para revisar; las respuestas se conservan entre pasos dentro de esa evaluación abierta.
5. Pulsa **Ver mi diagnóstico**. No recargues la página mientras estás respondiendo: las respuestas todavía no enviadas no se guardan como borrador.

### Entender tu diagnóstico

La puntuación representa los aciertos ponderados de ese cuestionario. Cada competencia muestra puntuación obtenida, objetivo requerido y brecha. Ejemplo: 50 puntos obtenidos frente a 80 requeridos dan una brecha de 30 puntos, equivalente al 37,5 % del objetivo.

**Objetivo alcanzado** significa que la puntuación de ese cuestionario llega al requisito. El diagnóstico no certifica desempeño laboral. Puedes exportarlo con **Exportar resultados** y recuperarlo después desde **Historial**.

### Seguir la ruta y registrar avance

1. Debajo del diagnóstico consulta la ruta y el orden de las actividades. Las recomendaciones se generan para las competencias con brecha.
2. Revisa enlaces, práctica sugerida, tiempo estimado y explicación de la recomendación.
3. Elige **Pendiente**, **En curso** o **Completada** en cada actividad. Para completarla, escribe una nota de práctica. Puedes añadir un enlace a la evidencia antes de pulsar **Guardar avance**.
4. Consulta el porcentaje, las evidencias validadas y el historial. Si el administrador solicita cambios, revisa su comentario, actualiza la nota o el enlace y guarda para volver a enviar la evidencia.
5. Si otra ventana cambió el mismo avance, actualiza los datos antes de intentar guardar de nuevo. La aplicación evita sobrescribir cambios ajenos con una versión antigua.

El porcentaje refleja las actividades marcadas como completadas. La ruta también indica cuántas de esas evidencias validó el administrador. Para medir cambios en la puntuación, realiza una reevaluación.

### Volver a evaluarte

Abre un diagnóstico anterior y pulsa **Reevaluar esta categoría**. Se conserva el vínculo con el resultado previo. La comparación numérica solo se muestra cuando categoría, puesto e instrumento son compatibles. Los diagnósticos, rutas y notas anteriores se conservan.

## 5. El espacio del administrador

### Mi equipo

La pantalla inicial resume personas asignadas, personas evaluadas, actividades completadas y avance agregado. La puntuación de un diagnóstico y el porcentaje de actividades son indicadores diferentes.

Escribe un nombre, correo o categoría en **Buscar una persona**. Puedes filtrar el avance de actividades y ordenar por nombre o por menor avance. El filtro se basa en actividades completadas; empezar una actividad sin terminarla todavía no aumenta ese porcentaje. El buscador admite nombres con o sin tilde. Si no hay coincidencias, usa **Limpiar filtros**.

Abre **Ver seguimiento** en una persona para consultar su evolución y su historial. Desde el diagnóstico, baja a la ruta y revisa la nota y el enlace de una actividad completada. Elige **Validar evidencia** o **Solicitar cambios** y pulsa **Guardar revisión**. Si solicitas cambios, indica qué debe corregir la persona. La decisión, el comentario y el responsable quedan en el historial.

### Puestos y competencias

1. Abre **Puestos** y pulsa **Nuevo puesto**.
2. Escribe nombre y descripción; elige una de las cuatro categorías.
3. Selecciona competencias, nivel requerido y criticidad. Guarda el puesto.
4. Usa **Editar puesto** para cambiarlo o retirarlo de futuras evaluaciones.

Para gestionar el contenido, abre **Puestos → Banco de preguntas**. Elige la categoría y pulsa **Nueva competencia** o **Editar competencia**. En cada pregunta, escribe el enunciado, las opciones, la respuesta correcta y el peso. Guarda y vuelve a **Puestos** para asociar una competencia nueva y definir el nivel requerido y la criticidad. Puedes asociarle material desde **Recursos**.

Los cambios se aplican en nuevas evaluaciones. Los diagnósticos anteriores conservan el cuestionario y la matriz con que se obtuvieron.

### Recursos de aprendizaje

1. Abre **Recursos** y pulsa **Nuevo recurso**.
2. Registra título, competencia, proveedor, práctica, duración, niveles y un enlace HTTP/HTTPS válido. Configura los prerrequisitos cuando corresponda.
3. Escribe el motivo del cambio y guarda.
4. Para retirar un recurso de futuras recomendaciones, edítalo y desmarca **Disponible para generar nuevas rutas**.

Las rutas ya guardadas conservan sus recursos y progreso. La disponibilidad para nuevas rutas no acredita validación del material por el cliente.

### Reportes del equipo

1. Abre **Reportes**. Solo aparecen resultados de las personas asignadas a tu equipo.
2. Selecciona persona, categoría y fechas según lo que necesitas consultar.
3. Revisa brechas, competencias alcanzadas, rutas y avance. Una persona sin diagnóstico se muestra sin puntuación.
4. Pulsa **Exportar reporte CSV**. El archivo respeta los filtros y puede abrirse en Excel; utiliza UTF-8 y separador punto y coma.

Las fechas del filtro corresponden al diagnóstico, con días completos en UTC-05:00. El avance corresponde al estado actual de las actividades de esas rutas. No compares como una misma serie instrumentos distintos.

## 6. Conservar o trasladar los datos

Los datos de esta copia se guardan en `data\mongodb`. No borres ni mezcles esa carpeta si quieres conservar cuentas e historiales.

Para una copia física entre estas instalaciones Windows: detén SkillPath en ambos equipos, conserva aparte cualquier base existente en el destino y copia la carpeta completa `data\mongodb` usando la misma versión MongoDB 8.0.32. No copies archivos mientras MongoDB esté funcionando. Inicia la copia de destino y verifica cuentas, diagnósticos y avance. El paquete de código por sí solo no traslada datos.

Para datos reales, cambios de versión o un piloto, falta definir y probar un respaldo lógico con restauración. No se incorporó una migración automática en esta entrega.

## 7. Solucionar problemas

| Síntoma | Acción |
| --- | --- |
| La ventana muestra un error | Conserva el mensaje. Revisa el registro más reciente `instalacion-*.log` en `.logs`. Los accesos mantienen visibles los errores. |
| PowerShell bloquea el `.ps1` | Usa los accesos `.cmd`. Ejecutan PowerShell con una excepción limitada a ese proceso. Una política corporativa puede requerir intervención de TI. |
| Falta Python o Node | Ejecuta `INSTALAR_Y_ABRIR.cmd` con Internet. Las herramientas faltantes se preparan automáticamente. |
| La preparación dice que la copia está abierta | Guarda el trabajo, ejecuta `DETENER_DEMO.cmd` y vuelve a preparar. |
| El entorno virtual fue copiado o está incompleto | Detén la aplicación. Desde una terminal en el proyecto ejecuta `PREPARAR_EQUIPO.cmd -RecrearEntorno`. Se conserva la carpeta anterior como respaldo. |
| La descarga se interrumpió | Vuelve a ejecutar la preparación. Los archivos parciales no se ejecutan y las descargas completas deben pasar la verificación. |
| Falla una firma o el checksum | No fuerces la instalación. Revisa la conexión, fecha/hora de Windows y acceso a los proveedores oficiales; conserva el registro del error. |
| Un puerto está ocupado | La API usa 8001 si 8000 está ocupado. Si 5173, 27018 o ambos puertos de API están ocupados, revisa qué servicio los usa antes de reintentar. |
| No hay administradores para registrarme | Ejecuta la instalación inicial para crear las cuentas ficticias. Si las cuentas fueron modificadas, revisa el mensaje antes de intentar cargarlas otra vez. |
| No veo los cambios de interfaz | Recarga con Ctrl+F5. Vuelve a iniciar sesión si la sesión caducó. |
| No veo mis datos anteriores | Comprueba qué carpeta de SkillPath iniciaste. Cada copia tiene su propia base; el ZIP de código no lleva el historial anterior. |

## 8. Demostración en cinco minutos

1. Ingresa como **Ana**: revisa el resumen y busca a **Carla**. Abre su evolución y luego el reporte del equipo.
2. Sal e ingresa como **Luis**: su equipo contiene únicamente a **Lucía**.
3. Ingresa como **Carla**: abre su panel, retoma una ruta y consulta las actividades. Si registras una práctica, recuerda que cambiará los datos de esta demo.
4. Consulta **Historial**, abre un diagnóstico y explica la diferencia entre puntuación, brecha y avance formativo.
5. Abre **Ayuda y manual** y, al finalizar, detén los servicios con `DETENER_DEMO.cmd`.

## 9. Referencias y alcance

- Inspiración de navegación y progreso: [Dashboard de Moodle](https://docs.moodle.org/501/en/Dashboard).
- Referencia de visualización de datos: [Carbon Design System de IBM](https://www.carbondesignsystem.com/building-blocks/data-visualization/overview).
- Compatibilidad del servidor: [MongoDB 8.0 para Windows](https://www.mongodb.com/docs/v8.0/tutorial/install-mongodb-on-windows/). El proveedor enumera Windows 11 y Windows Server 2022 x64; esta guía de escritorio usa Windows 11.
- Runtime de Python: [distribución oficial mediante NuGet](https://docs.python.org/3.12/using/windows.html#the-nuget-org-packages).

Para el piloto quedan pendientes la validación del contenido y de los criterios de revisión con iCloudFlex, las pruebas de aceptación y rendimiento, la gestión de identidades, HTTPS, la autenticación de MongoDB y la prueba de respaldo y restauración.
