<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mi Perfil</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>
    <body>
        <main class="auth-main">
            <div class="auth-container">
                <div class="auth-line"></div>

                <div class="auth-card auth-card-wide">
                    <h1 class="auth-title">Mi Perfil</h1>

                    <div class="form-group" style="text-align:left;">
                        <p><strong>Nombre:</strong> ${sessionScope.usuario.nombre} ${sessionScope.usuario.paterno} ${sessionScope.usuario.materno}</p>
                        <p><strong>Matrícula:</strong> ${sessionScope.usuario.matricula}</p>
                        <p><strong>Correo:</strong> ${sessionScope.usuario.correo}</p>
                    </div>

                    <p class="auth-footer-link">
                        <a href="${pageContext.request.contextPath}/SCalificaciones">&larr; Volver a mis calificaciones</a>
                    </p>
                    <p class="auth-footer-link">
                        <a href="${pageContext.request.contextPath}/Logout">Cerrar sesión</a>
                    </p>
                </div>
            </div>
        </main>
    </body>
</html>
