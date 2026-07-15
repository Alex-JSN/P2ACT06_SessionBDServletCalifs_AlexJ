package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Landing page a la que llega un usuario con TipoUsuario = 'Alumno' después
 * de iniciar sesión (ver SAutenticarUsuario). Por ahora solo muestra sus
 * datos de sesión; aquí es donde después se conectará el DAO de
 * calificaciones para listar Parcial1/Parcial2/Parcial3 por materia.
 */
@WebServlet(name = "SCalificaciones", urlPatterns = {"/SCalificaciones"})
public class SCalificacion extends HttpServlet
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

        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/calificacion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        doGet(request, response);
    }
}
