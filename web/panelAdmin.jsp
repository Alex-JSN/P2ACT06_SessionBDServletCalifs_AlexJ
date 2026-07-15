<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel de Administración</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>
    <body>
        <main class="auth-main">
            <div class="auth-container">
                <div class="auth-line"></div>

                <div class="auth-card auth-card-wide">
                    <h1 class="auth-title">Panel de Administración</h1>
                    <p class="auth-subtitle">
                        Bienvenido${not empty sessionScope.usuario ? ', ' : ''}${sessionScope.usuario.nombre}.
                    </p>

                    <div class="form-group" style="text-align:left; margin-top:24px;">
                        <a href="${pageContext.request.contextPath}/SMaterias" class="btn-auth" style="display:block; text-decoration:none; margin-bottom:12px;">
                            Gestionar materias
                        </a>
                        <a href="${pageContext.request.contextPath}/SCalificaciones" class="btn-auth" style="display:block; text-decoration:none;">
                            Ver calificaciones
                        </a>
                    </div>

                    <p class="auth-footer-link">
                        <a href="${pageContext.request.contextPath}/Logout">Cerrar sesión</a>
                    </p>
                </div>
            </div>
        </main>
    </body>
</html>
