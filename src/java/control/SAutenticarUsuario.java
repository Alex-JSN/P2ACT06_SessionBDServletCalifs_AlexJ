package control;

import dao.DAOUsuario;
import modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Procesa el POST de loginUsuario.jsp (action="/Login"): correo, contrasena
 *
 * OJO: esto NO es lo mismo que SLogin. SLogin solo decide qué JSP mostrar
 * (router de vistas, mapeado a /SLogin). Este servlet es el que de verdad
 * valida contra la base de datos y abre la sesión.
 */
@WebServlet(name = "SAutenticarUsuario", urlPatterns = {"/Login"})
public class SAutenticarUsuario extends HttpServlet
{
    private final DAOUsuario daoUsuario = new DAOUsuario();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        if (esVacio(correo) || esVacio(contrasena))
        {
            request.setAttribute("error", "Ingresa tu correo y tu contraseña.");
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/loginUsuario.jsp").forward(request, response);
            return;
        }

        try
        {
            Usuario usuario = daoUsuario.autenticar(correo.trim().toLowerCase(), contrasena);

            HttpSession session = request.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setAttribute("idUsuario", usuario.getIdUsuario());
            session.setAttribute("idAlumno", usuario.getIdAlumno());
            session.setAttribute("tipoUsuario", usuario.getTipoUsuario());
            session.setMaxInactiveInterval(30 * 60); // 30 min

            // TipoUsuario solo puede ser 'Administrador' o 'Alumno' (enum de la tabla usuarios)
            switch (usuario.getTipoUsuario())
            {
                case "Administrador":
                    response.sendRedirect(request.getContextPath() + "/PanelAdmin");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/SCalificaciones");
            }

        }
        catch (DAOUsuario.CredencialesInvalidasException e)
        {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/loginUsuario.jsp").forward(request, response);

        }
        catch (DAOUsuario.CuentaInactivaException e)
        {
            // Cuenta sin verificar: mandamos directo a capturar el código en vez de solo mostrar error
            HttpSession session = request.getSession(true);
            session.setAttribute("correoPendienteVerificacion", correo.trim().toLowerCase());
            response.sendRedirect(request.getContextPath() + "/VerificarCuenta");

        }
        catch (DAOUsuario.CuentaRechazadaException e)
        {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/loginUsuario.jsp").forward(request, response);

        }
        catch (SQLException e)
        {
            e.printStackTrace();
            request.setAttribute("error", "Ocurrió un error al iniciar sesión. Intenta más tarde.");
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/loginUsuario.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        response.sendRedirect(request.getContextPath() + "/loginUsuario.jsp");
    }

    private boolean esVacio(String s)
    {
        return s == null || s.trim().isEmpty();
    }
}
