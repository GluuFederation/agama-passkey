<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <title>Agama passkey</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="${webCtx.contextPath}/servlet/favicon" type="image/x-icon">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="${webCtx.contextPath}/auth/fido2/js/base64js.js"></script>
    <script src="${webCtx.contextPath}/auth/fido2/js/base64url.js"></script>
    <script src="${webCtx.contextPath}/auth/fido2/js/webauthn.js"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        }
    </script>
</head>
<body>
<script>
    function authenticationWithPasskey() {
        const request = ${assertion?no_esc}
        console.log('Assertion request: ' + JSON.stringify(request));
        webauthn.getAssertion(request)
            .then(data => {
                const dataObject = webauthn.responseToObject(data);
                const assertionJson = JSON.stringify(dataObject);
                console.log('Assertion response: ' + assertionJson);
                document.getElementById("tokenResponse").value = assertionJson;
                document.forms[0].submit();
            })
            .catch(err => {
                console.error('Failed to webauthn get credential: ', err);
                if (err.name === "NotAllowedError") {
                    document.getElementById('errorMessage').value = 'The operation either timed out or was not allowed.';
                } else if (err.message) {
                    document.getElementById('errorMessage').value = err.message;
                } else {
                    document.getElementById('errorMessage').value = 'Unknown message';
                }
                document.getElementById("skipped").value = "skipped";
                document.forms[0].submit();
            });
    }

    window.addEventListener("load", (event) => {
        const isAssertion = ${isAssertion?c};
        if (isAssertion) {
            authenticationWithPasskey();
        }
    });
</script>
<section class="bg-gray-100 dark:bg-gray-900">
    <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
        <div class="flex items-center mb-6 text-2xl font-semibold text-gray-900 dark:text-white">
            <img class="w-40 mr-2"
                 src="https://gluu.org/wp-content/uploads/2021/02/janssen-project-transparent-630px-182px-300x86.png"
                 alt="logo">
        </div>
        <div class="w-full bg-white rounded-lg shadow-lg dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
            <form id="loginForm" method="post" enctype="application/x-www-form-urlencoded"
                  class="p-6 space-y-4 md:space-y-6 sm:p-8">
                <h1 class="text-xl text-center font-medium text-gray-900 md:text-2xl dark:text-white">
                    Agama Passkey
                </h1>

                <div class="space-y-3">
                    <div>
                        <label for="username" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">
                            Username
                        </label>
                        <input type="text" name="username" id="username"
                               class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                               placeholder="" required="" autocomplete="off">
                    </div>
                    <div>
                        <label for="password" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">
                            Password
                        </label>
                        <input type="password" name="password" id="password" placeholder=""
                               class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                               required="">
                    </div>
                </div>

                <button type="submit"
                        name="loginBtn"
                        class="w-full text-white bg-green-600 hover:bg-green-700 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">
                    Sign in
                </button>

                <div class="relative">
                    <div class="absolute inset-0 flex items-center">
                        <div class="w-full border-t border-gray-300"></div>
                    </div>
                    <div class="relative flex justify-center text-sm">
                        <span class="px-2 bg-white text-gray-900">
                            Or
                        </span>
                    </div>
                </div>

                <input type="hidden" id="tokenResponse" name="tokenResponse">
                <input type="hidden" id="skipped" name="skipped">
                <input type="hidden" id="errorMessage" name="errorMessage">

                <#if showError == true>
                    <div id="alert-message"
                         class="p-4 mb-4 text-red-800 border border-red-300 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400 dark:border-red-800"
                         role="alert">
                        <div class="flex items-center">
                            <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16"
                                 data-view-component="true" class="flex-shrink-0 w-4 h-4 me-2 fill-red-700">
                                <path d="M6.457 1.047c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575Zm1.763.707a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368Zm.53 3.996v2.5a.75.75 0 0 1-1.5 0v-2.5a.75.75 0 0 1 1.5 0ZM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0Z"></path>
                            </svg>
                            <span class="sr-only">Info</span>
                            <h3 class="text-lg font-medium">${errorTitle}</h3>
                            <button type="button"
                                    onclick="document.getElementById('alert-message').style.display = 'none'"
                                    class="ms-auto -mx-1.5 -my-1.5 bg-red-50 text-red-500 rounded-lg focus:ring-2 focus:ring-red-400 p-1.5 hover:bg-red-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-red-400 dark:hover:bg-gray-700"
                                    data-dismiss-target="#alert-border-2" aria-label="Close">
                                <span class="sr-only">Dismiss</span>
                                <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                                     fill="none"
                                     viewBox="0 0 14 14">
                                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                          stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                                </svg>
                            </button>
                        </div>
                        <div class="mt-2 mb-4 text-sm">
                            ${errorMessage}
                        </div>
                    </div>
                </#if>

                <button type="submit" name="loginWithPasskeyBtn" formnovalidate
                        class="w-full text-black bg-gray-50 border border-gray-300 hover:bg-gray-100 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">
                    Sign in with a passkey
                </button>
            </form>
        </div>
    </div>
</section>
</body>
</html>
