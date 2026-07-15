<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro login</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>
    <body>
        <main class="auth-main">
            <div class="auth-container">
                <div class="auth-line"></div>

                <div class="auth-card auth-card-wide">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="back-link">&larr; Volver al inicio</a>

                    <h1 class="auth-title">Crear Cuenta</h1>
                    <p class="auth-subtitle">Regístrate para llevar el control de tus calificaciones</p>

                    <form id="formRegistro" action="${pageContext.request.contextPath}/Registro" method="post" novalidate>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="matricula">Matrícula</label>
                                <input type="text" id="matricula" name="matricula" maxlength="13"
                                       placeholder="Ej. 21120123" value="${matricula}" required>
                            </div>
                            <div class="form-group">
                                <label for="correo">Correo electrónico</label>
                                <input type="email" id="correo" name="correo" maxlength="100"
                                       placeholder="tucorreo@ejemplo.com" value="${correo}" required autocomplete="email">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="nombre">Nombre(s)</label>
                                <input type="text" id="nombre" name="nombre" maxlength="45"
                                       placeholder="Nombre" value="${nombre}" required>
                            </div>
                            <div class="form-group">
                                <label for="paterno">Apellido paterno</label>
                                <input type="text" id="paterno" name="paterno" maxlength="45"
                                       placeholder="Apellido paterno" value="${paterno}" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="materno">Apellido materno</label>
                            <input type="text" id="materno" name="materno" maxlength="45"
                                   placeholder="Apellido materno" value="${materno}" required>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="contrasena">Contraseña</label>
                                <div class="password-wrapper">
                                    <input type="password" id="contrasena" name="contrasena"
                                           placeholder="Mínimo 8 caracteres" minlength="8" required autocomplete="new-password">
                                    <button type="button" class="toggle-password" data-target="contrasena">Ver</button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="confirmarContrasena">Confirmar contraseña</label>
                                <div class="password-wrapper">
                                    <input type="password" id="confirmarContrasena" name="confirmarContrasena"
                                           placeholder="Repite tu contraseña" minlength="8" required autocomplete="new-password">
                                    <button type="button" class="toggle-password" data-target="confirmarContrasena">Ver</button>
                                </div>
                                <span class="field-error" id="errorContrasena">Las contraseñas no coinciden.</span>
                            </div>
                        </div>

                        <button type="submit" class="btn-auth">Crear cuenta</button>
                    </form>

                    <p class="auth-footer-link">
                        ¿Ya tienes cuenta? <a href="${pageContext.request.contextPath}/loginUsuario.jsp">Inicia sesión aquí</a>
                    </p>
                </div>
            </div>
        </main>
        <script src="${pageContext.request.contextPath}/js/ojitoContrasena.js"></script>
    </body>
</html>