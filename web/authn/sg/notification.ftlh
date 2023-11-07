<#import "../../agamapasskey/commons.ftlh" as com>
<#import "../commons.ftlh" as authncom>

<@com.main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"
        integrity="sha512-pumBsjNRGGqkPzKHndZMaAG+bir374sORyzM3uulLV14lN5LyykqNk8eEeUlUkB3U0M4FApyaHraT65ihJhDpQ=="
        crossorigin="anonymous" referrerpolicy="no-referrer">
</script>
<script src="${webCtx.contextPath}/js/gluu-auth.js">
</script>
<script>

function setError(msg) {
    document.getElementById("error").textContent = msg
}

function onSignInCallback(result) {

    console.log("Result: " + result)
    if (result == "success") {
        document.forms[0].submit()
    } else {
        let msg = "An error occurred"
        if (result == "timeout") {
            msg = "We couldn't detect approval of the notification sent"
        }
        setError(msg/* + ". Try the links below for alternatives"*/)
    }

}

window.onload = (event) => {
    gluu_auth.startSessionChecker(onSignInCallback, ${timeout});
}

</script>

<@com.nojs />

<div class="border border-1 rounded p-5">

    <p class="fs-4 mb-4">You will get a notification to your Super Gluu shortly</p>
        
    <p align="center" class="fs-6 text-danger mt-3" id="error"></p>
   
    <div align="center" class="mb-5"><img class="w-25" src="../../enroller/sg/sg.jpg"></div>    
    
    <p class="fs-6 mb-4">You will be authenticated once you tap &quot;approve&quot; in the notification screen.</p>    

    <form method="post" enctype="application/x-www-form-urlencoded">
        <div class="row mb-5">
            <div class="d-flex justify-content-center">
                Didn't receive a notification?
                <button type="submit" class="btn btn-link p-0 ps-1" id="scan-QR" name="scan-QR" value="">Scan a QR code instead</button>
            </div>
        </div>
    </form>
        
    <#if escape!false>
        <@authncom.main />
    </#if>
</div>

</@com.main>
