<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión de Materias</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>
    <body>
        <main class="auth-main">
            <div class="auth-container">
                <div class="auth-line"></div>

                <div class="auth-card auth-card-wide">
                    <h1 class="auth-title">Gestión de Materias</h1>
                    <div class="alert alert-success" style="text-align:left;">
                        Aquí se listará y administrará la tabla <strong>materias</strong>
                        (alta, edición y baja) una vez conectado su DAO.
                    </div>

                    <p class="auth-footer-link">
                        <a href="${pageContext.request.contextPath}/PanelAdmin">&larr; Volver al panel de administración</a>
                    </p>
                </div>
            </div>
        </main>
    </body>
</html>
