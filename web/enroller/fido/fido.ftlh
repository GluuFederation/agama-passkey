<#import "../../agamapasskey/commons.ftlh" as com>
<#import "../commons.ftlh" as enrcom>

<@com.main>

<script src="${webCtx.contextPath}/auth/fido2/js/base64js.js">
</script>
<script src="${webCtx.contextPath}/auth/fido2/js/base64url.js">
</script>
<script src="${webCtx.contextPath}/auth/fido2/js/webauthn.js">
</script>

<script>

function setStatus(statusText) {
    document.getElementById("status").textContent = statusText
}

function setError(msg) {
    document.getElementById("error").textContent = msg
}

function startAttestation() {
    
    let request = ${attestation?no_esc}
    
    webauthn.createCredential(request)
        .then(data => {
                setStatus("Please wait...");
                document.getElementById("tokenResponse").value = JSON.stringify(webauthn.responseToObject(data))
                document.forms[0].submit()
            })
        .catch(err => {
                setStatus("")
                let excludeCredentials = request.excludeCredentials && request.excludeCredentials.length > 0
                let name = err.name
                let message = ""
    
                if (err.message) {
                    message = err.message
                } else {
                    let messages = err.messages
                    if (messages && messages.length > 0) {
                        message = messages[0].message
                    }
                }

                if (name == "NotAllowedError") {
                    message = excludeCredentials ? 
                        "Credential creation failed, probably because an already registered credential is available" : 
                        "An error occurred";
                } else if (name == "AbortError") {
                    message = "Operation was cancelled"
                } else {
                    message = "An error occurred: " + message
                }
                setError(message)
                console.log(name)
                document.getElementById("retry").style.display = "block"
            })

}

window.onload = (event) => {    
    setTimeout(startAttestation, 500)
}
</script>

<@com.nojs />

<div class="border border-1 rounded p-5">

    <p class="fs-4 mb-4">Insert and activate your security key</p>

    <div align="center" class="link-secondary mt-3" id="status"></div>
    
    <div align="center" class="fs-6 text-danger mt-3" id="error"></div>
    
    <div align="center" class="fs-6 mb-3" id="retry" style="display:none">
        <a href="javascript:startAttestation()" class="btn-link link-secondary">Try again</a>
    </div>
    
    <div align="center" class="mb-5">
        <img class="pe-5" src="${webCtx.contextPath}/img/step_ver.png">
    </div>
    
    <form method="post" enctype="application/x-www-form-urlencoded">
        <input type="hidden" id="tokenResponse" name="tokenResponse">
    </form>
        
    <#if escape!false>
        <@enrcom.main />
    </#if>
</div>

</@com.main>
