# Proyecto: Gestión de Clinica Medica

## Descripcion
Este proyecto implementa un sistema de gestion de base de datos para una clinica medica. Permite registrar pacientes, medicos, turnos, historias clinicas y pagos, y realizar consultas relacionadas con estas entidades.

## Estructura de la Base de Datos
- **Paciente**: Contiene los datos de los pacientes.
- **Medico**: Contiene los datos de los medicos.
- **Historia Clínica**: Registra las consultas medicas.
- **Turno**: Registra las citas medicas entre pacientes y médicos.
- **Pago**: Registra los pagos realizados por los pacientes.
- **Diagrama**: Agregue un diagrama para que se vean mas a detalle las relaciones entre las tablas.

## Procedimientos Almacenados
Se crearon procedimientos almacenados para:
- Insertar nuevos pacientes, medicos y turnos.
- Consultar el historial de un paciente.
- Realizar pagos y asociarlos a turnos.
- Actualizar la información de pacientes y medicos.
- Nota: en los procesos para actualizar informacion (paciente/medico) solo es necesario especificar (luego del dni) los valores a modificar, no es necesario agregar los demas campos si no van a ser actualizados.

## Consultas
- Consultas para obtener turnos en un rango de fechas, calcular pagos totales, obtener la especialidad de un medico, y listar pacientes con turnos no pagados.

## Instrucciones
- Dentro de la carpeta "ProyectoClinica" se encuentran los archivos "CRT_Tables.sql" y "CRT_StoredProcedures.sql" los cuales contienen todo lo mencionado anteriormente.
- Dentro del archivo "CRT_StoredProcedures.sql" debajo de cada bloque de codigo hay un ejemplo para ejecutar su respectivo proceso.
- Dentro del archivo "CRT_Tables.sql" se crea la base de datos "ProyectoClinica" y alli se crean las tablas.
- Ademas agregue una imagen del diagrama de relacion entre las tablas llamado "DiagramaProyectoClinica"
