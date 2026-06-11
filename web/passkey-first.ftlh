[#ftl output_format="HTML"]
<!DOCTYPE html>
<html lang="en">
<head><meta name="viewport" content="width=device-width, initial-scale=1"><title>Sign in
	</title><link rel="icon" href="${webCtx.contextPath}/servlet/favicon" type="image/x-icon"></head>
<body>

  
	
	
	
  
  
	<section class="bg-gray-100 dark:bg-gray-900">
	  <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
		<div class="flex items-center mb-6">
		  <img src="https://gluu.org/wp-content/uploads/2021/02/janssen-project-transparent-630px-182px-300x86.png" alt="logo" class="w-40">
		</div>
		<form method="post" id="firstForm" enctype="application/x-www-form-urlencoded" class="w-full max-w-md bg-white rounded-2xl shadow-xl dark:bg-gray-800 p-8 space-y-6">
		  <h1 class="text-2xl font-semibold text-center text-gray-900 dark:text-white">
			Sign in
		  </h1>
		  <!-- Username -->
		  <div>
			<label for="username" class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
			  Username
			</label>
			<input type="text" name="username" id="username" placeholder="Enter your username" required="" autocomplete="username webauthn" class="w-full px-4 py-3 text-sm border rounded-lg bg-gray-50 border-gray-300 focus:ring-2 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:placeholder-gray-400 outline-none transition">
		  </div>
		  <!-- Hidden Fields -->
		  <input type="hidden" id="tokenResponse" name="tokenResponse">
		  <input type="hidden" id="skipped" name="skipped">
		  <input type="hidden" id="errorMessage" name="errorMessage">
		  <!-- Error -->
		  <div class="p-4 text-sm text-red-700 bg-red-50 border border-red-300 rounded-lg">
			<p class="font-medium">${errorTitle}
			</p>
			<p class="mt-1">${errorMessage}
			</p>
		  </div>
		  <!--#if-->
		  <!-- Continue Button -->
		  <button type="submit" name="continueBtn" class="w-full py-3 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700">
			Continue
		  </button>
		  <!-- Divider -->
		  <div class="flex items-center">
			<div class="flex-grow h-px bg-gray-300">
			</div>
			<span class="px-3 text-xs text-gray-500">or</span>
			<div class="flex-grow h-px bg-gray-300">
			</div>
		  </div>
		  <!-- Lost Passkey Button -->
		  <button type="submit" name="lostpasskey" value="lost" class="w-full py-3 text-sm font-medium text-green-700 bg-green-50 border border-green-600 rounded-lg hover:bg-green-100">
			I have lost my Passkey
		  </button>
		</form>
	  </div>
	</section>
  
  
  
  
  
  
  
</body>

<script src="https://cdn.tailwindcss.com"></script><script src="${webCtx.contextPath}/auth/fido2/js/base64js.js"></script><script src="${webCtx.contextPath}/auth/fido2/js/base64url.js"></script><script src="${webCtx.contextPath}/auth/fido2/js/webauthn.js"></script><script>tailwind.config = {
	  darkMode: 'class' }
  </script><script>
	let conditionalAbortController = null;
	function submitWithAssertion(assertionJson) {
	  document.getElementById("tokenResponse").value = assertionJson;
	  document.forms[0].submit();
	}
	async function startConditionalUI() {
	  if (!window.PublicKeyCredential ||
		  typeof PublicKeyCredential.isConditionalMediationAvailable !== 'function') {
		return;
	  }
	  const supported = await PublicKeyCredential.isConditionalMediationAvailable();
	  if (!supported) return;
	  try {
		const request = ${
		  assertion?no_esc};
		  conditionalAbortController = new AbortController();
		  request.signal = conditionalAbortController.signal;
		  request.mediation = 'conditional';
		  console.log('Starting conditional UI assertion');
		  webauthn.getAssertion(request)
			.then(data => {
			const assertionJson = JSON.stringify(webauthn.responseToObject(data));
			console.log('Conditional UI resolved');
			submitWithAssertion(assertionJson);
		  }
				 )
			.catch(err => {
			if (err.name === "AbortError") return;
			// user typed username instead
			console.error('Conditional UI error:', err);
		  }
				  );
		}
		catch (e) {
		  console.log('Conditional UI setup failed (non-fatal):', e);
		}
	  }
	  window.addEventListener("load", () => {
		startConditionalUI();
	  }
							 );
  </script>
</html>