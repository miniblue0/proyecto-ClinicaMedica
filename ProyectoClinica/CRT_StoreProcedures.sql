-- SP INS_PACIENTE
CREATE PROC INS_Paciente
    @DNI INT,
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Direccion NVARCHAR(100),
    @FechaNacimiento DATE,
    @Telefono NVARCHAR(15)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Paciente WHERE DNI = @DNI)
    BEGIN
        INSERT INTO Paciente (DNI, Nombre, Apellido, Direccion, FechaNacimiento, Telefono)
        VALUES (@DNI, @Nombre, @Apellido, @Direccion, @FechaNacimiento, @Telefono)
    END
    ELSE
        PRINT 'El paciente ya existe';
END

-- EJEMPLO:  EXEC INS_Paciente @DNI = 12345678, @Nombre = 'Juan', @Apellido = 'Juarez', @Direccion = 'Calle 000', @FechaNacimiento = '2000-04-20', @Telefono = '555123456'




-- SP INS_MEDICO
CREATE PROC INS_Medico
    @DNI INT,
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Especialidad NVARCHAR(50),
    @Telefono NVARCHAR(15)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Medico WHERE DNI = @DNI)
    BEGIN
        INSERT INTO Medico (DNI, Nombre, Apellido, Especialidad, Telefono)
        VALUES (@DNI, @Nombre, @Apellido, @Especialidad, @Telefono);
        PRINT 'Medico insertado correctamente'
    END
    ELSE
        PRINT 'El medico ya existe'
END



--  EJEMPLO: EXEC IMS_Medico @DNI = 98765432, @Nombre = 'Maria', @Apellido = 'Marta', @Especialidad = 'Cardiologia', @Telefono = '555987654'




-- SP INS_TURNO
CREATE PROC INS_Turno
    @PacienteDNI INT,
    @MedicoDNI INT,
    @FechaHora DATETIME
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Paciente WHERE DNI = @PacienteDNI) 
       AND EXISTS (SELECT 1 FROM Medico WHERE DNI = @MedicoDNI)
    BEGIN
        INSERT INTO Turno (PacienteDNI, MedicoDNI, FechaHora, Estado)
        VALUES (@PacienteDNI, @MedicoDNI, @FechaHora, 'Pendiente')
        PRINT 'Turno insertado correctamente'
    END
    ELSE
        PRINT 'El paciente o medico no existe'
END



-- EJEMPLO: EXEC INS_Turno @PacienteDNI = 12345678, @MedicoDNI = 98765432, @FechaHora = '2024-12-01 10:00:00'




-- SP SEL_HISTORIACLINICA
CREATE PROC SEL_HistoriaPaciente
    @PacienteDNI INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Paciente WHERE DNI = @PacienteDNI)
    BEGIN
        SELECT H.IdHistoria, H.Fecha, H.Diagnostico, H.Tratamiento
        FROM HistoriaClinica H
        WHERE H.PacienteDNI = @PacienteDNI
        ORDER BY H.Fecha DESC
    END
    ELSE
        PRINT 'El paciente no existe'
END


-- EJEMPLO: EXEC SEL_HistoriaPaciente @PacienteDNI = 12345678





-- SP INS_PAGO
CREATE PROC INS_Pago
    @TurnoId INT,
    @Monto DECIMAL(10, 2),
    @FechaPago DATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Turno WHERE IdTurno = @TurnoId AND Estado = 'Pendiente')
    BEGIN
        INSERT INTO Pago (TurnoId, Monto, FechaPago)
        VALUES (@TurnoId, @Monto, @FechaPago);
        
        UPDATE Turno
        SET Estado = 'Pagado'
        WHERE IdTurno = @TurnoId;
        
        PRINT 'Pago registrado y turno marcado como "Pagado"'
    END
    ELSE
        PRINT 'El turno no existe o ya esta pagado'
END


--  EJEMPLO: EXEC INS_Pago @TurnoId = 1, @Monto = 500.00, @FechaPago = '2024-12-01'




-- SP UPD_PACIENTE
CREATE PROC UPD_Paciente
    @DNI INT,
    @Nombre NVARCHAR(50) = NULL,
    @Apellido NVARCHAR(50) = NULL,
    @Direccion NVARCHAR(100) = NULL,
    @FechaNacimiento DATE = NULL,
    @Telefono NVARCHAR(15) = NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Paciente WHERE DNI = @DNI)
    BEGIN
        UPDATE Paciente
        SET Nombre = ISNULL(@Nombre, Nombre),
            Apellido = ISNULL(@Apellido, Apellido),
            Direccion = ISNULL(@Direccion, Direccion),
            FechaNacimiento = ISNULL(@FechaNacimiento, FechaNacimiento),
            Telefono = ISNULL(@Telefono, Telefono)
        WHERE DNI = @DNI;
        
        PRINT 'Paciente actualizado'
    END
    ELSE
		PRINT 'El paciente no existe'
END



--  EJEMPLO: EXEC UPD_Paciente @DNI = 12345678, @Nombre = 'Juan Carlos', @Telefono = '555987654'






-- SP UPD_MEDICOO
CREATE PROC UPD_Medico
    @DNI INT,
    @Nombre NVARCHAR(50) = NULL,
    @Apellido NVARCHAR(50) = NULL,
    @Especialidad NVARCHAR(50) = NULL,
    @Telefono NVARCHAR(15) = NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Medico WHERE DNI = @DNI)
    BEGIN
        UPDATE Medico
        SET Nombre = ISNULL(@Nombre, Nombre),
            Apellido = ISNULL(@Apellido, Apellido),
            Especialidad = ISNULL(@Especialidad, Especialidad),
            Telefono = ISNULL(@Telefono, Telefono)
        WHERE DNI = @DNI
        
        PRINT 'Medico actualizado'
    END
    ELSE
        PRINT 'El medico no existe'
END


--  EJEMPLO: EXEC UPD_Medico @DNI = 98765432, @Nombre = 'Maria Jose', @Especialidad = 'Neurología'




-- SP SEL_TURNOSDELPACIENTEPORFECHAS
CREATE PROC SEL_TurnosDelPacientePorFechas
    @PacienteDNI INT,
    @FechaInicio DATETIME,
    @FechaFin DATETIME
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Paciente WHERE DNI = @PacienteDNI)
    BEGIN
        SELECT T.IdTurno, T.FechaHora, T.Estado, M.Nombre AS NombreMedico, M.Apellido AS ApellidoMedico, M.Especialidad
        FROM Turno T
        JOIN Medico M ON T.MedicoDNI = M.DNI
        WHERE T.PacienteDNI = @PacienteDNI
          AND T.FechaHora BETWEEN @FechaInicio AND @FechaFin
        ORDER BY T.FechaHora ASC
    END
    ELSE
        PRINT 'El paciente no existe'
END


--  EJEMPLO: EXEC SEL_TurnosDelPacientePorFechas @PacienteDNI = 12345678, @FechaInicio = '2024-01-01', @FechaFin = '2024-12-31'




-- SP SUM_PAGOSPACIENTE
CREATE PROC SUM_PagosPaciente
    @PacienteDNI INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Paciente WHERE DNI = @PacienteDNI)
    BEGIN
        SELECT SUM(P.Monto) AS TotalPagado
        FROM Pago P
        JOIN Turno T ON P.TurnoId = T.IdTurno
        WHERE T.PacienteDNI = @PacienteDNI
    END
    ELSE
        PRINT 'El paciente no existe'
END



-- EJEMPLO:  EXEC SUM_PagosPaciente @PacienteDNI = 12345678




-- SP SEL_MEDICOESPECIALIDAD
CREATE PROC SEL_MedicoEspecialidad
    @MedicoDNI INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Medico WHERE DNI = @MedicoDNI)
    BEGIN
        SELECT Especialidad
        FROM Medico
        WHERE DNI = @MedicoDNI
    END
    ELSE
        PRINT 'El médico no existe.'
END

-- EJEMPLO:  EXEC SEL_MedicoEspecialidad @MedicoDNI = 98765432



-- SP SEL_PACIENTESENDEUDA
CREATE PROC SEL_PacientesEnDeuda
AS
BEGIN
    SELECT DISTINCT P.DNI, P.Nombre, P.Apellido, P.Telefono
    FROM Paciente P
    JOIN Turno T ON P.DNI = T.PacienteDNI
    WHERE T.Estado = 'Pendiente'
    ORDER BY P.Apellido, P.Nombre;
END

-- EJEMPLO:  EXEC SEL_PacientesEnDeuda




-- 