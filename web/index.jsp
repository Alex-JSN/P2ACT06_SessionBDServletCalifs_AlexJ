<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bienvenid@</title>

    <style>
        *
        {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --verde: #2E6B4F;
            --verde-hover: #24563F;
            --verde-claro: #EDF6F0;
            --texto: #234033;
            --gris: #64736B;
            --blanco: #FFFFFF;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: linear-gradient(180deg, #f8faf8, #eef4f0);
            display: flex;
            flex-direction: column;
        }

        .main {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .container {
            width: 100%;
            max-width: 950px;
            text-align: center;
        }

        .line {
            width: 90px;
            height: 5px;
            background: var(--verde);
            margin: 0 auto 40px;
            border-radius: 50px;
        }

        /* ===================== TÍTULO ===================== */
        #welcome-title {
            font-size: 4.2rem;
            font-weight: 600;            /* Letra más gruesa */
            color: var(--texto);
            min-height: 120px;
            letter-spacing: -1px;
            line-height: 1.2;
            text-align: center;          /* Centrado sin flex */
            display: block;              /* Bloque para centrar */
        }

        /* Texto dinámico en línea para que el cursor se pegue */
        #typing-text {
            display: inline;             /* En línea, ocupa solo su contenido */
            white-space: pre-wrap;       /* Respeta espacios y permite saltos de línea */
            word-break: break-word;      /* Rompe palabras largas si es necesario */
        }

        /* ===== CURSOR CON EL ESTILO ORIGINAL ===== */
        .cursor {
            display: inline-block;       /* Como estaba antes */
            width: 3px;
            height: 1em;
            margin-left: 4px;            /* Separación con el texto */
            background: var(--verde);
            animation: blink .8s infinite;
            vertical-align: bottom;      /* Alineado con la base del texto */
        }

        @keyframes blink {
            0%, 50% { opacity: 1; }
            51%, 100% { opacity: 0; }
        }

        .subtitle {
            margin-top: 35px;
            font-size: 1.15rem;
            color: var(--gris);
            line-height: 1.8;
            max-width: 720px;
            margin-left: auto;
            margin-right: auto;
        }

        .buttons-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 40px;
            flex-wrap: wrap;
        }

        .btn {
            text-decoration: none;
            padding: 14px 40px;
            border-radius: 30px;
            font-size: 1rem;
            font-weight: 600;
            transition: .25s;
            display: inline-block;
            min-width: 180px;
            text-align: center;
        }

        .btn-login {
            background: var(--verde);
            color: white;
        }

        .btn-login:hover {
            background: var(--verde-hover);
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(46, 107, 79, .20);
        }

        .btn-register {
            color: var(--verde);
            border: 2px solid var(--verde);
        }

        .btn-register:hover {
            background: var(--verde);
            color: white;
        }

        /* ===================== RESPONSIVE ===================== */
        @media (max-width: 768px) {
            #welcome-title {
                font-size: 3rem;
                min-height: 100px;
            }

            .buttons-container {
                gap: 15px;
            }

            .btn {
                min-width: 160px;
                padding: 12px 30px;
            }
        }

        @media (max-width: 480px) {
            #welcome-title {
                font-size: 2.2rem;
                min-height: 80px;
            }

            .subtitle {
                font-size: 1rem;
            }

            .btn {
                width: 100%;
                max-width: 250px;
                min-width: unset;
            }

            .buttons-container {
                flex-direction: column;
                align-items: center;
                gap: 12px;
            }
        }
    </style>
</head>

<body>
    <main class="main">
        <div class="container">
            <div class="line"></div>

            <h1 id="welcome-title">
                <span id="typing-text"></span><span class="cursor"></span>
            </h1>

            <p class="subtitle">
                Sistema institucional para la gestión de usuarios.
                Acceda con su cuenta o regístrese para comenzar a utilizar el sistema.
            </p>

            <div class="buttons-container">
                <a href="login.jsp" class="btn btn-login">Iniciar Sesión</a>
                <a href="registro.jsp" class="btn btn-register">Registrarse</a>
            </div>
        </div>
    </main>

    <script>
        (function() {
            const frases =
            [
                "Bienvenido al Sistema",
                "Inicia sesión para continuar",
                "Regístrate si aún no tienes cuenta",
                "¡Comienza ahora!"
            ];

            const velocidadEscritura = 80;
            const pausaAntesBorrar = 2000;
            const velocidadBorrado = 40;
            const pausaAntesSiguiente = 500;

            let indiceFrase = 0;
            let indiceCaracter = 0;
            let estaBorrando = false;
            let timeout = null;

            const typingElement = document.getElementById('typing-text');

            function escribir() {
                const fraseActual = frases[indiceFrase];

                if (!estaBorrando) {
                    typingElement.textContent = fraseActual.substring(0, indiceCaracter + 1);
                    indiceCaracter++;

                    if (indiceCaracter === fraseActual.length) {
                        timeout = setTimeout(borrar, pausaAntesBorrar);
                        return;
                    }

                    timeout = setTimeout(escribir, velocidadEscritura);
                }
            }

            function borrar() {
                const fraseActual = frases[indiceFrase];
                estaBorrando = true;

                typingElement.textContent = fraseActual.substring(0, indiceCaracter - 1);
                indiceCaracter--;

                if (indiceCaracter === 0) {
                    estaBorrando = false;
                    indiceFrase = (indiceFrase + 1) % frases.length;
                    timeout = setTimeout(escribir, pausaAntesSiguiente);
                    return;
                }

                timeout = setTimeout(borrar, velocidadBorrado);
            }

            typingElement.textContent = '';
            indiceFrase = 0;
            indiceCaracter = 0;
            estaBorrando = false;
            escribir();
        })();
    </script>
</body>
</html>