<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Registro de Usuario</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>
    <body>
        <main class="auth-main">
            <div class="auth-container">
                <div class="auth-card">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="back-link">&larr; Volver al inicio</a>

                    <h1>Registro de Usuario</h1>

                    <%
                        String error = (String) request.getAttribute("error");
                        if (error != null) {
                    %>
                    <div class="error-message"><%= error%></div>
                    <%
                            request.removeAttribute("error");
                        }

                        // Verificar si es el primer usuario (sin consultar BD directamente)
                        // Podemos usar un atributo o simplemente mostrar siempre el campo matrícula
                        // La lógica en el servlet decidirá si es obligatorio
%>

                    <form action="${pageContext.request.contextPath}/Registro" method="post">
                        <div class="form-group">
                            <label for="nombre">Nombre</label>
                            <input type="text" id="nombre" name="nombre" value="${nombre}" required>
                        </div>

                        <div class="form-group">
                            <label for="paterno">Apellido Paterno</label>
                            <input type="text" id="paterno" name="paterno" value="${paterno}" required>
                        </div>

                        <div class="form-group">
                            <label for="materno">Apellido Materno</label>
                            <input type="text" id="materno" name="materno" value="${materno}">
                        </div>

                        <div class="form-group">
                            <label for="matricula">Matrícula</label>
                            <input type="text" id="matricula" name="matricula" value="${matricula}" placeholder="Solo para alumnos">
                            <small>Si eres el primer usuario (Administrador), no necesitas matrícula.</small>
                        </div>

                        <div class="form-group">
                            <label for="correo">Correo Electrónico</label>
                            <input type="email" id="correo" name="correo" value="${correo}" required>
                        </div>

                        <div class="form-group">
                            <label for="contrasena">Contraseña</label>
                            <input type="password" id="contrasena" name="contrasena" required minlength="8">
                            <small>Mínimo 8 caracteres.</small>
                        </div>

                        <div class="form-group">
                            <label for="confirmarContrasena">Confirmar Contraseña</label>
                            <input type="password" id="confirmarContrasena" name="confirmarContrasena" required>
                        </div>

                        <button type="submit" class="btn-register">Registrarse</button>
                    </form>

                    <p>¿Ya tienes cuenta? <a href="${pageContext.request.contextPath}/SLogin?vista=login">Inicia sesión aquí</a></p>
                </div>
            </div>
        </main>
    </body>
</html>