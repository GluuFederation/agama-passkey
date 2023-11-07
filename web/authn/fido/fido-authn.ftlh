<#import "../../agamapasskey/commons.ftlh" as com>
<#import "../commons.ftlh" as authncom>
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

function startAssertion() {
    
    let request = ${assertion?no_esc}
    
    webauthn.getAssertion(request)
        .then(data => {
                setStatus("Please wait...");
                document.getElementById("tokenResponse").value = JSON.stringify(webauthn.responseToObject(data))
                document.forms[0].submit()
            })
        .catch(err => {
                let name = err.name
                
                setStatus("")
                let message = ""
    
                if (name === "NotAllowedError") {
                    //Credential not recognized. 
                    message = "Please use a fido credential already associated to your account"
                } else if (name === "AbortError") {
                    message = "Operation was cancelled"
                } else {
                    message = "An error occurred"
                    
                    if (err.message) {
                        console.log(err.message)
                    } else if (err.messages) {
                        console.log(err.messages)
                    }
                }
                console.log(name)
                setError(message)
                document.getElementById("retry").style.display = "block"
            })
}

window.onload = (event) => {    
    setTimeout(startAssertion, 500)
}
</script>

<@com.nojs />

<div class="border border-1 rounded p-5 mb-3">

    <p class="fs-4 mb-5">Insert and activate your security key</p>

    <div align="center" class="link-secondary mt-3" id="status"></div>
    
    <div align="center" class="fs-6 text-danger mt-3" id="error"></div>
    
    <div align="center" class="fs-6 mb-3" id="retry" style="display:none">
        <a href="javascript:startAssertion()" class="btn-link link-secondary">Try again</a>
    </div>
    
    <div align="center" class="mb-5">
        <img class="pe-5" src="${webCtx.contextPath}/img/step_ver.png">
    </div>
    
    <form method="post" enctype="application/x-www-form-urlencoded">
        <input type="hidden" id="tokenResponse" name="tokenResponse">
    </form>
        
    <#if escape!false>
        <@authncom.main />
    </#if>
                
</div>

</@com.main>
