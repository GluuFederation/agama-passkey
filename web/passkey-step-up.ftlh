[#ftl output_format="HTML"]
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Verify your identity
	</title></head>
<body>

  
	
	
	
  
  
	<h1>Verify your identity
	</h1>
	<p>This action requires passkey confirmation.
	</p>
	&lt;#if showError&gt;
	<p class="error">${errorMessage}
	</p>
	<!--#if-->
	<form method="post" id="stepUpForm">
	  <input type="hidden" name="tokenResponse" id="tokenResponse" value="">
	  <input type="hidden" name="skipped" id="skipped" value="">
	  <input type="hidden" name="errorMessage" id="errorMessageField" value="">
	  <button type="button" id="verifyBtn">Verify with passkey</button>
	</form>
  
  
</body>

<script>
	const assertionJson = ${
	  assertion};
	document.getElementById('verifyBtn').addEventListener('click', async () => {
	  try {
		const options = assertionJson;
		options.challenge = base64urlToBuffer(options.challenge);
		if (options.allowCredentials) {
		  options.allowCredentials = options.allowCredentials.map(c => ({
			...c,
			id: base64urlToBuffer(c.id)
		  }
																	   ));
		}
		const credential = await navigator.credentials.get({
		  publicKey: options }
														  );
		document.getElementById('tokenResponse').value = JSON.stringify(credentialToJson(credential));
		document.getElementById('stepUpForm').submit();
	  }
	  catch (e) {
		if (e.name === 'NotAllowedError') {
		  document.getElementById('skipped').value = 'skipped';
		  document.getElementById('errorMessageField').value = 'Passkey verification was cancelled.';
		  document.getElementById('stepUpForm').submit();
		}
	  }
	}
														 );
	function base64urlToBuffer(base64url) {
	  const base64 = base64url.replace(/-/g, '+').replace(/_/g, '/');
	  const binary = atob(base64);
	  const buffer = new Uint8Array(binary.length);
	  for (let i = 0; i < binary.length; i++) buffer[i] = binary.charCodeAt(i);
	  return buffer.buffer;
	}
	function bufferToBase64url(buffer) {
	  const bytes = new Uint8Array(buffer);
	  let str = '';
	  for (const b of bytes) str += String.fromCharCode(b);
	  return btoa(str).replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '');
	}
	function credentialToJson(cred) {
	  return {
		id: cred.id,
		rawId: bufferToBase64url(cred.rawId),
		type: cred.type,
		response: {
		  authenticatorData: bufferToBase64url(cred.response.authenticatorData),
		  clientDataJSON: bufferToBase64url(cred.response.clientDataJSON),
		  signature: bufferToBase64url(cred.response.signature),
		  userHandle: cred.response.userHandle ? bufferToBase64url(cred.response.userHandle) : null
		}
	  };
	}
  </script>
</html>