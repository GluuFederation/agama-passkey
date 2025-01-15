[#ftl output_format="HTML"]
<!DOCTYPE html>
<html lang="en">
<head><meta name="viewport" content="width=device-width, initial-scale=1"><title>Passkey add
	</title><link rel="icon" href="${webCtx.contextPath}/servlet/favicon" type="image/x-icon"></head>
<body>

  
	
	
	
  
  
	<section class="bg-gray-100 dark:bg-gray-900">
	  <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
		<div class="flex flex-col items-center mb-6 text-2xl font-semibold text-gray-900 dark:text-white">
		  <img src="https://gluu.org/wp-content/uploads/2021/02/janssen-project-transparent-630px-182px-300x86.png" alt="logo" class="w-40 mr-2">
		</div>
		<div class="w-full bg-white rounded-lg shadow-lg dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
		  <form method="post" enctype="application/x-www-form-urlencoded" class="p-6 space-y-4 md:space-y-6 sm:p-8">
			<div class="flex items-center justify-center">
			  <svg aria-hidden="true" height="24" viewBox="0 0 24 24" version="1.1" width="24" data-view-component="true" class="w-8 h-8">
				<path d="M9.496 2a5.25 5.25 0 0 0-2.519 9.857A9.006 9.006 0 0 0 .5 20.228a.751.751 0 0 0 .728.772h5.257c3.338.001 6.677.002 10.015 0a.5.5 0 0 0 .5-.5v-4.669a.95.95 0 0 0-.171-.551 9.02 9.02 0 0 0-4.814-3.423A5.25 5.25 0 0 0 9.496 2Z">
				</path>
				<path d="M23.625 10.313c0 1.31-.672 2.464-1.691 3.134a.398.398 0 0 0-.184.33v.886a.372.372 0 0 1-.11.265l-.534.534a.188.188 0 0 0 0 .265l.534.534c.071.07.11.166.11.265v.347a.374.374 0 0 1-.11.265l-.534.534a.188.188 0 0 0 0 .265l.534.534a.37.37 0 0 1 .11.265v.431a.379.379 0 0 1-.097.253l-1.2 1.319a.781.781 0 0 1-1.156 0l-1.2-1.319a.379.379 0 0 1-.097-.253v-5.39a.398.398 0 0 0-.184-.33 3.75 3.75 0 1 1 5.809-3.134ZM21 9.75a1.125 1.125 0 1 0-2.25 0 1.125 1.125 0 0 0 2.25 0Z">
				</path>
			  </svg>
			</div>
			<h1 class="text-xl text-center font-medium text-gray-900 md:text-2xl dark:text-white">
			  Add a passkey
			</h1>
			<p class="text-gray-600 leading-tight">
			  Passkeys can be used for sign-in as a simple and secure alternative to your password and
			  two-factor credentials.
			</p>
			<input type="hidden" id="tokenResponse" name="tokenResponse">
			<input type="hidden" id="skipped" name="skipped">
			<input type="hidden" id="errorMessage" name="errorMessage">
			&lt;#if showError == true&gt;
			<div id="alert-message" role="alert" class="p-4 mb-4 text-red-800 border border-red-300 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400 dark:border-red-800">
			  <div class="flex items-center">
				<svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="flex-shrink-0 w-4 h-4 me-2 fill-red-700">
				  <path d="M6.457 1.047c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575Zm1.763.707a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368Zm.53 3.996v2.5a.75.75 0 0 1-1.5 0v-2.5a.75.75 0 0 1 1.5 0ZM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0Z">
				  </path>
				</svg>
				<span class="sr-only">Info</span>
				<h3 class="text-lg font-medium">${errorTitle}
				</h3>
				<button type="button" data-dismiss-target="#alert-border-2" aria-label="Close" class="ms-auto -mx-1-5 -my-1-5 bg-red-50 text-red-500 rounded-lg focus:ring-2 focus:ring-red-400 p-1-5 hover:bg-red-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-red-400 dark:hover:bg-gray-700">Send</button>
			  </div>
			  <div class="mt-2 mb-4 text-sm">
				${errorMessage}
			  </div>
			</div>
			<!--#if-->
			<div class="space-y-2">
			  <button type="submit" name="addPasskeyBtn" class="w-full text-white bg-green-600 hover:bg-green-700 font-medium rounded-lg text-sm px-5 py-2-5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">
				Add passkey
			  </button>
			  <button type="submit" name="cancelBtn" class="w-full text-black bg-gray-50 border border-gray-300 hover:bg-gray-100 font-medium rounded-lg text-sm px-5 py-2-5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">
				Cancel
			  </button>
			</div>
		  </form>
		</div>
	  </div>
	</section>
  
  
  
  
  
  
  
</body>

<script src="https://cdn.tailwindcss.com"></script><script src="${webCtx.contextPath}/auth/fido2/js/base64js.js"></script><script src="${webCtx.contextPath}/auth/fido2/js/base64url.js"></script><script src="${webCtx.contextPath}/auth/fido2/js/webauthn.js"></script><script>
	tailwind.config = {
	  darkMode: 'class'
	}
  </script><script>
	function registerPasskey() {
	  const request = ${
		attestation?no_esc}
		delete request.authenticatorSelection.authenticatorAttachment;
		request.authenticatorSelection.requireResidentKey = true;
		request.timeout = 90000;
		request.extensions = {
		  credProps: true};
		console.log('Attestation: ', JSON.stringify(request));
		webauthn.createCredential(request)
		  .then(data => {
		  const dataObject = webauthn.responseToObject(data);
		  const createCredentialJson = JSON.stringify(dataObject);
		  console.log('Create credential response: ' + createCredentialJson);
		  alert ('Create credential response: ' + createCredentialJson)
		  document.getElementById("tokenResponse").value = createCredentialJson;
		  document.forms[0].submit();
		}
			   )
		  .catch(err => {
		  console.error('Failed to webauthn create credential: ', err);
		  if (err.name === "NotAllowedError") {
			document.getElementById('errorMessage').value = 'The operation either timed out or was not allowed.';
		  }
		  else if (err.message) {
			document.getElementById('errorMessage').value = err.message;
		  }
		  else {
			document.getElementById('errorMessage').value = 'Unknown message';
		  }
		  document.getElementById("skipped").value = "skipped";
		  document.forms[0].submit();
		}
				);
	  }
	  window.addEventListener("load", (event) => {
		const isAttestation = ${
		  isAttestation?c};
		  if (isAttestation) {
			registerPasskey();
		  }
		}
		);
  </script>
</html>