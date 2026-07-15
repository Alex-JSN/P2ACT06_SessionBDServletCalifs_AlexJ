package modelo;

import java.sql.Timestamp;

public class Usuario 
{
    private int       idUsuario;
    private String    matricula;
    private String    nombre;
    private String    paterno;
    private String    materno;
    private String    correo;
    private String    contrasena;
    private String    estado;
    private String    tipoUsuario;
    private boolean   esProtegido;
    private String    tokenActivacion;
    private Timestamp fechaExpiracionToken;
    private Timestamp fechaRegistro;
    private Timestamp fechaActivacion;

    public int getIdUsuario() 
    {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) 
    {
        this.idUsuario = idUsuario;
    }

    public String getMatricula()
    {
        return matricula;
    }

    public void setMatricula(String matricula) 
    {
        this.matricula = matricula;
    }

    public String getNombre() 
    {
        return nombre;
    }

    public void setNombre(String nombre) 
    {
        this.nombre = nombre;
    }

    public String getPaterno() 
    {
        return paterno;
    }

    public void setPaterno(String paterno) 
    {
        this.paterno = paterno;
    }

    public String getMaterno() 
    {
        return materno;
    }

    public void setMaterno(String materno) 
    {
        this.materno = materno;
    }

    public String getCorreo() 
    {
        return correo;
    }

    public void setCorreo(String correo) 
    {
        this.correo = correo;
    }

    public String getContrasena() 
    {
        return contrasena;
    }

    public void setContrasena(String contrasena) 
    {
        this.contrasena = contrasena;
    }

    public String getEstado() 
    {
        return estado;
    }

    public void setEstado(String estado) 
    {
        this.estado = estado;
    }

    public String getTipoUsuario() 
    {
        return tipoUsuario;
    }

    public void setTipoUsuario(String tipoUsuario) 
    {
        this.tipoUsuario = tipoUsuario;
    }

    public boolean isEsProtegido() 
    {
        return esProtegido;
    }

    public void setEsProtegido(boolean esProtegido) 
    {
        this.esProtegido = esProtegido;
    }

    public String getTokenActivacion() 
    {
        return tokenActivacion;
    }

    public void setTokenActivacion(String tokenActivacion) 
    {
        this.tokenActivacion = tokenActivacion;
    }

    public Timestamp getFechaExpiracionToken() 
    {
        return fechaExpiracionToken;
    }

    public void setFechaExpiracionToken(Timestamp fechaExpiracionToken) 
    {
        this.fechaExpiracionToken = fechaExpiracionToken;
    }

    public Timestamp getFechaRegistro() 
    {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) 
    {
        this.fechaRegistro = fechaRegistro;
    }

    public Timestamp getFechaActivacion() 
    {
        return fechaActivacion;
    }

    public void setFechaActivacion(Timestamp fechaActivacion)
    {
        this.fechaActivacion = fechaActivacion;
    }

    public String getNombreCompleto()
    {
        return nombre + " " + paterno + " " + materno;
    }
}
