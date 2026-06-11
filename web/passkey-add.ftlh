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
			<div id="alert-message" role="alert" class="p-4 mb-4 text-red-800 border border-red-300 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400 dark:border-red-800">
			  <div class="flex items-center">
			  </div>
			  <div class="mt-2 mb-4 text-sm">
				${errorMessage}
			  </div>
			</div>
			<!--#if-->
			<div class="space-y-2">
			  <button type="submit" name="addPasskeyBtn" class="w-full h-10 text-white bg-green-600 hover:bg-green-700 font-medium rounded-lg text-sm px-5 text-center">
				Add passkey
			  </button>
			  <br>
			  <button type="submit" name="cancelBtn" class="w-full h-10 text-black bg-gray-50 border border-gray-300 hover:bg-gray-100 font-medium rounded-lg text-sm px-5 text-center">
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