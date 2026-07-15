package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Landing page a la que llega un usuario con TipoUsuario = 'Administrador'
 * después de iniciar sesión (ver SAutenticarUsuario).
 */
@WebServlet(name = "SPanelAdmin", urlPatterns = {"/PanelAdmin"})
public class SPanelAdmin extends HttpServlet
{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null)
        {
            response.sendRedirect(request.getContextPath() + "/SLogin?vista=login");
            return;
        }

        if (!"Administrador".equals(session.getAttribute("tipoUsuario")))
        {
            // Un alumno no debe poder entrar aquí solo por conocer la URL.
            response.sendRedirect(request.getContextPath() + "/SCalificaciones");
            return;
        }

        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/panelAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        doGet(request, response);
    }
}
