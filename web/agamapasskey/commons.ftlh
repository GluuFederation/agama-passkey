<#macro main>
    <!doctype html>
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">

    <head>
        <title>Agama PassKey</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="${webCtx.contextPath}/servlet/favicon" type="image/x-icon">
        <script src="https://cdn.tailwindcss.com/3.3.3"></script>
    </head>

    <body>
    <section class="mx-auto max-w-3xl px-4 sm:px-6 xl:max-w-5xl xl:px-0">
        <div class="flex h-screen flex-col justify-between font-sans">
            <header class="flex items-center justify-between py-10">
                <div class="mr-3">
                    <img alt="logo" class="h-12" src="https://gluu.org/wp-content/uploads/2021/02/janssen-project-transparent-630px-182px-300x86.png">
                </div>
            </header>

            <main class="mb-auto">
                <#nested>
            </main>
        </div>
    </section>
    </body>
    </html>
</#macro>

<#macro nojs>
    <noscript>
        <p class="text-center">Please enable javascript to use this page!</p>
    </noscript>
</#macro>