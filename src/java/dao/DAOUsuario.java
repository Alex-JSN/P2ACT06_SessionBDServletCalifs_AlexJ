package dao;

import conexion.ConexionMySQL;
import modelo.Usuario;
import util.PasswordUtil;
import util.TokenUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class DAOUsuario
{
    /**
     * Registra un nuevo usuario con Estado = 'Inactivo' (default de la tabla)
     * y genera el código de verificación de 6 dígitos que se debe enviar por correo.
     * Devuelve el código generado, para que el servlet lo mande con EmailUtil.
     */
    public String registrar(Usuario usuario)
            throws SQLException, CorreoDuplicadoException, MatriculaDuplicadaException, AlumnoNoEncontradoException
    {
        if (existeCorreo(usuario.getCorreo()))
        {
            throw new CorreoDuplicadoException("Ya existe una cuenta registrada con ese correo.");
        }
        if (existeMatricula(usuario.getMatricula()))
        {
            throw new MatriculaDuplicadaException("Ya existe una cuenta registrada con esa matrícula.");
        }

        // La tabla alumnos ya viene precargada (por el administrador/control escolar).
        // Aquí solo confirmamos que la matrícula capturada corresponda a un alumno real
        // y que el correo coincida con el que tiene registrado, para enlazar la cuenta
        // nueva (usuarios) con su registro académico (alumnos) mediante IdAlumno.
        Integer idAlumno = buscarIdAlumnoPorMatriculaYCorreo(usuario.getMatricula(), usuario.getCorreo());
        if (idAlumno == null)
        {
            throw new AlumnoNoEncontradoException(
                    "La matrícula y/o el correo no coinciden con ningún alumno registrado. "
                    + "Verifica tus datos o contacta al administrador.");
        }

        String codigo = TokenUtil.generarCodigo();
        Timestamp expiracion = Timestamp.valueOf(LocalDateTime.now().plusMinutes(TokenUtil.MINUTOS_EXPIRACION));
        String hash = PasswordUtil.hashear(usuario.getContrasena());

        String sql = "INSERT INTO usuarios "
                + "(IdAlumno, Matricula, Nombre, Paterno, Materno, Correo, Contrasena, TipoUsuario, "
                + " TokenActivacion, FechaExpiracionToken) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        // Estado y EsProtegido usan su DEFAULT de la tabla ('Inactivo' y 0).

        try (Connection con = ConexionMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setInt(1, idAlumno);
            ps.setString(2, usuario.getMatricula());
            ps.setString(3, usuario.getNombre());
            ps.setString(4, usuario.getPaterno());
            ps.setString(5, usuario.getMaterno());
            ps.setString(6, usuario.getCorreo());
            ps.setString(7, hash);
            ps.setString(8, usuario.getTipoUsuario() != null ? usuario.getTipoUsuario() : "Alumno");
            ps.setString(9, codigo);
            ps.setTimestamp(10, expiracion);

            ps.executeUpdate();
        }

        return codigo;
    }

    /**
     * Busca en la tabla alumnos un registro cuya Matricula y Correo coincidan
     * con los capturados en el formulario de registro. Devuelve su IdAlumno,
     * o null si no hay coincidencia (matrícula inexistente o correo distinto).
     */
    private Integer buscarIdAlumnoPorMatriculaYCorreo(String matricula, String correo) throws SQLException
    {
        String sql = "SELECT IdAlumno FROM alumnos WHERE Matricula = ? AND Correo = ?";
        try (Connection con = ConexionMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setString(1, matricula);
            ps.setString(2, correo);
            try (ResultSet rs = ps.executeQuery())
            {
                if (rs.next())
                {
                    return rs.getInt("IdAlumno");
                }
                return null;
            }
        }
    }

    /** Autentica por Correo + Contrasena. Lanza una excepción específica según el motivo de rechazo. */
    public Usuario autenticar(String correo, String contrasenaPlana)
            throws SQLException, CredencialesInvalidasException, CuentaInactivaException, CuentaRechazadaException
    {
        String sql = "SELECT * FROM usuarios WHERE Correo = ? LIMIT 1";

        try (Connection con = ConexionMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setString(1, correo);

            try (ResultSet rs = ps.executeQuery())
            {
                if (!rs.next())
                {
                    throw new CredencialesInvalidasException("Correo o contraseña incorrectos.");
                }

                String hashGuardado = rs.getString("Contrasena");
                if (!PasswordUtil.verificar(contrasenaPlana, hashGuardado))
                {
                    throw new CredencialesInvalidasException("Correo o contraseña incorrectos.");
                }

                String estado = rs.getString("Estado");
                if ("Rechazado".equals(estado))
                {
                    throw new CuentaRechazadaException("Tu cuenta fue rechazada por un administrador.");
                }
                if ("Inactivo".equals(estado))
                {
                    throw new CuentaInactivaException("Tu cuenta aún no está verificada. Revisa el código que enviamos a tu correo.");
                }

                return mapearUsuario(rs);
            }
        }
    }

    /**
     * Verifica el código de 6 dígitos capturado por el usuario.
     * Devuelve un resultado indicando éxito, código incorrecto o código expirado.
     */
    public ResultadoVerificacion verificarCodigo(String correo, String codigoIngresado) throws SQLException
    {
        String sqlSelect = "SELECT IdUsuario, TokenActivacion, FechaExpiracionToken, Estado "
                + "FROM usuarios WHERE Correo = ?";
        String sqlUpdate = "UPDATE usuarios SET Estado = 'Activo', FechaActivacion = NOW(), "
                + "TokenActivacion = NULL, FechaExpiracionToken = NULL WHERE IdUsuario = ?";

        try (Connection con = ConexionMySQL.getConnection())
        {
            int idUsuario;
            String tokenGuardado;
            Timestamp expiracion;
            String estado;

            try (PreparedStatement ps = con.prepareStatement(sqlSelect))
            {
                ps.setString(1, correo);
                try (ResultSet rs = ps.executeQuery())
                {
                    if (!rs.next())
                    {
                        return ResultadoVerificacion.CORREO_NO_ENCONTRADO;
                    }
                    idUsuario = rs.getInt("IdUsuario");
                    tokenGuardado = rs.getString("TokenActivacion");
                    expiracion = rs.getTimestamp("FechaExpiracionToken");
                    estado = rs.getString("Estado");
                }
            }

            if ("Activo".equals(estado))
            {
                return ResultadoVerificacion.YA_ACTIVA;
            }
            if (tokenGuardado == null || !tokenGuardado.equals(codigoIngresado))
            {
                return ResultadoVerificacion.CODIGO_INCORRECTO;
            }
            if (expiracion == null || expiracion.before(new Timestamp(System.currentTimeMillis())))
            {
                return ResultadoVerificacion.CODIGO_EXPIRADO;
            }

            try (PreparedStatement ps = con.prepareStatement(sqlUpdate))
            {
                ps.setInt(1, idUsuario);
                ps.executeUpdate();
            }

            return ResultadoVerificacion.EXITO;
        }
    }

    /**
     * Genera y guarda un nuevo código de verificación para un correo ya registrado
     * (por si el anterior expiró). Devuelve {codigo, nombre}, o null si el correo no existe
     * o la cuenta ya está activa.
     */
    public String[] reenviarCodigo(String correo) throws SQLException
    {
        String sqlSelect = "SELECT IdUsuario, Estado, Nombre FROM usuarios WHERE Correo = ?";
        String sqlUpdate = "UPDATE usuarios SET TokenActivacion = ?, FechaExpiracionToken = ? WHERE IdUsuario = ?";

        try (Connection con = ConexionMySQL.getConnection())
        {
            int idUsuario;
            String estado;
            String nombre;

            try (PreparedStatement ps = con.prepareStatement(sqlSelect))
            {
                ps.setString(1, correo);
                try (ResultSet rs = ps.executeQuery())
                {
                    if (!rs.next())
                    {
                        return null;
                    }
                    idUsuario = rs.getInt("IdUsuario");
                    estado = rs.getString("Estado");
                    nombre = rs.getString("Nombre");
                }
            }

            if ("Activo".equals(estado))
            {
                return null;
            }

            String nuevoCodigo = TokenUtil.generarCodigo();
            Timestamp expiracion = Timestamp.valueOf(LocalDateTime.now().plusMinutes(TokenUtil.MINUTOS_EXPIRACION));

            try (PreparedStatement ps = con.prepareStatement(sqlUpdate))
            {
                ps.setString(1, nuevoCodigo);
                ps.setTimestamp(2, expiracion);
                ps.setInt(3, idUsuario);
                ps.executeUpdate();
            }

            return new String[] { nuevoCodigo, nombre };
        }
    }

    /** Un administrador activa manualmente a un usuario, sin necesidad de validar el código. */
    public boolean activarPorAdministrador(int idUsuario) throws SQLException
    {
        String sql = "UPDATE usuarios SET Estado = 'Activo', FechaActivacion = NOW(), "
                + "TokenActivacion = NULL, FechaExpiracionToken = NULL WHERE IdUsuario = ?";

        try (Connection con = ConexionMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setInt(1, idUsuario);
            return ps.executeUpdate() == 1;
        }
    }

    private boolean existeCorreo(String correo) throws SQLException
    {
        String sql = "SELECT 1 FROM usuarios WHERE Correo = ?";
        try (Connection con = ConexionMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery())
            {
                return rs.next();
            }
        }
    }

    private boolean existeMatricula(String matricula) throws SQLException
    {
        String sql = "SELECT 1 FROM usuarios WHERE Matricula = ?";
        try (Connection con = ConexionMySQL.getConnection();
             PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setString(1, matricula);
            try (ResultSet rs = ps.executeQuery())
            {
                return rs.next();
            }
        }
    }

    private Usuario mapearUsuario(ResultSet rs) throws SQLException
    {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("IdUsuario"));
        int idAlumno = rs.getInt("IdAlumno");
        u.setIdAlumno(rs.wasNull() ? null : idAlumno);
        u.setMatricula(rs.getString("Matricula"));
        u.setNombre(rs.getString("Nombre"));
        u.setPaterno(rs.getString("Paterno"));
        u.setMaterno(rs.getString("Materno"));
        u.setCorreo(rs.getString("Correo"));
        u.setEstado(rs.getString("Estado"));
        u.setTipoUsuario(rs.getString("TipoUsuario"));
        u.setEsProtegido(rs.getInt("EsProtegido") == 1);
        u.setFechaRegistro(rs.getTimestamp("FechaRegistro"));
        u.setFechaActivacion(rs.getTimestamp("FechaActivacion"));
        // Nunca se regresa la contraseña/hash al resto de la aplicación.
        return u;
    }

    public enum ResultadoVerificacion
    {
        EXITO, CODIGO_INCORRECTO, CODIGO_EXPIRADO, YA_ACTIVA, CORREO_NO_ENCONTRADO
    }

    public static class CorreoDuplicadoException extends Exception
    {
        public CorreoDuplicadoException(String m) { super(m); }
    }

    public static class MatriculaDuplicadaException extends Exception
    {
        public MatriculaDuplicadaException(String m) { super(m); }
    }

    public static class AlumnoNoEncontradoException extends Exception
    {
        public AlumnoNoEncontradoException(String m) { super(m); }
    }

    public static class CredencialesInvalidasException extends Exception
    {
        public CredencialesInvalidasException(String m) { super(m); }
    }

    public static class CuentaInactivaException extends Exception
    {
        public CuentaInactivaException(String m) { super(m); }
    }

    public static class CuentaRechazadaException extends Exception
    {
        public CuentaRechazadaException(String m) { super(m); }
    }
}
