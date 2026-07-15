-- -----------------------------------------------------
-- Table `alumnos`
-- -----------------------------------------------------
CREATE TABLE `alumnos`
(
  `IdAlumno`      INT          NOT NULL AUTO_INCREMENT,
  `Matricula`     VARCHAR(13)  NOT NULL,
  `Nombre`        VARCHAR(45)  NOT NULL,
  `Paterno`       VARCHAR(45)  NOT NULL,
  `Materno`       VARCHAR(45)      NULL,
  `Correo`        VARCHAR(100) NOT NULL,
  `FechaRegistro` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdAlumno`),
  UNIQUE INDEX `uk_Correo`    (`Correo`    ASC),
  UNIQUE INDEX `uk_Matricula` (`Matricula` ASC)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `materias`
-- -----------------------------------------------------
CREATE TABLE `materias`
(
  `IdMateria` INT          NOT NULL AUTO_INCREMENT,
  `Materia`   VARCHAR(100) NOT NULL,
  PRIMARY KEY (`IdMateria`),
  UNIQUE INDEX `uk_Materia` (`Materia` ASC)
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `calificaciones`
-- -----------------------------------------------------
CREATE TABLE `calificaciones`
(
  `IdCalificacion`    INT          NOT NULL AUTO_INCREMENT,
  `Periodo`           VARCHAR(20)  NOT NULL,
  `Parcial1`          DECIMAL(4,1)     NULL,
  `Parcial2`          DECIMAL(4,1)     NULL,
  `Parcial3`          DECIMAL(4,1)     NULL,
  `FechaRegistro`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `FechaModificacion` DATETIME         NULL ON UPDATE CURRENT_TIMESTAMP,
  `IdMateria`         INT          NOT NULL,
  `IdAlumno`          INT          NOT NULL,
  PRIMARY KEY (`IdCalificacion`),
  INDEX `fk_calificaciones_materias_idx` (`IdMateria` ASC),
  INDEX `fk_calificaciones_alumnos_idx`  (`IdAlumno`  ASC),
  UNIQUE INDEX `uk_calificaciones_unico` (`IdAlumno`  ASC, `IdMateria` ASC, `Periodo` ASC),
  CONSTRAINT `fk_calificaciones_materias`
    FOREIGN KEY (`IdMateria`) REFERENCES `materias` (`IdMateria`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_calificaciones_alumnos`
    FOREIGN KEY (`IdAlumno`)  REFERENCES `alumnos`  (`IdAlumno`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `usuarios`
-- -----------------------------------------------------
CREATE TABLE `usuarios`
(
  `IdUsuario`            INT          NOT NULL AUTO_INCREMENT,
  `IdAlumno`             INT              NULL,
  `Matricula`            VARCHAR(13)      NULL,
  `Nombre`               VARCHAR(45)  NOT NULL,
  `Paterno`              VARCHAR(45)  NOT NULL,
  `Materno`              VARCHAR(45)      NULL,
  `Correo`               VARCHAR(100) NOT NULL,
  `Contrasena`           VARCHAR(255) NOT NULL,
  `TipoUsuario`          ENUM('Administrador', 'Alumno') NOT NULL,
  `Estado`               ENUM('Activo', 'Inactivo', 'Pendiente', 'Rechazado') NOT NULL DEFAULT 'Inactivo',
  `EsProtegido`          TINYINT(1)   NOT NULL DEFAULT 0,
  `TokenActivacion`      VARCHAR(100)     NULL,
  `FechaExpiracionToken` DATETIME         NULL,
  `FechaRegistro`        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `FechaActivacion`      DATETIME         NULL,
  PRIMARY KEY (`IdUsuario`),
  UNIQUE INDEX `uk_Correo`        (`Correo`   ASC),
  INDEX `fk_usuarios_alumnos_idx` (`IdAlumno` ASC),
  CONSTRAINT `fk_usuarios_alumnos`
    FOREIGN KEY (`IdAlumno`) REFERENCES `alumnos` (`IdAlumno`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;


-- =========================================================
-- Administrador inicial (protegido, no se puede eliminar)
-- Sustituye el hash de Contrasena por uno real (bcrypt, etc.)
-- INSERT INTO usuarios (Nombre, Paterno, Materno, Correo, Contrasena, TipoUsuario, Estado, EsProtegido, FechaActivacion)
-- VALUES ('Admin', 'Sistema', NULL, 'admin@escuela.edu.mx', '$2y$10$REEMPLAZAR_HASH', 'Administrador', 'Activo', 1, NOW());
-- =========================================================

