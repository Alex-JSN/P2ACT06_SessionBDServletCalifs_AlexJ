<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mis Calificaciones</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>
    <body>
        <main class="auth-main">
            <div class="auth-container">
                <div class="auth-line"></div>

                <div class="auth-card auth-card-wide">
                    <h1 class="auth-title">Mis Calificaciones</h1>
                    <p class="auth-subtitle">
                        Hola, ${sessionScope.usuario.nombre} ${sessionScope.usuario.paterno}
                        (Matrícula ${sessionScope.usuario.matricula}).
                    </p>

                    <div class="alert alert-success" style="text-align:left;">
                        Aquí se listarán tus materias y parciales (Parcial1, Parcial2, Parcial3)
                        una vez conectado el DAO de calificaciones.
                    </div>

                    <c:if test="${sessionScope.tipoUsuario == 'Administrador'}">
                        <p class="auth-footer-link">
                            <a href="${pageContext.request.contextPath}/PanelAdmin">&larr; Volver al panel de administración</a>
                        </p>
                    </c:if>

                    <p class="auth-footer-link">
                        <a href="${pageContext.request.contextPath}/Logout">Cerrar sesión</a>
                    </p>
                </div>
            </div>
        </main>
    </body>
</html>
