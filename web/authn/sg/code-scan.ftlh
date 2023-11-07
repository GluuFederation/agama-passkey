<#import "../../agamapasskey/commons.ftlh" as com>
<#import "../commons.ftlh" as authncom>

<@com.main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"
        integrity="sha512-pumBsjNRGGqkPzKHndZMaAG+bir374sORyzM3uulLV14lN5LyykqNk8eEeUlUkB3U0M4FApyaHraT65ihJhDpQ=="
        crossorigin="anonymous" referrerpolicy="no-referrer">
</script>
<script src="${webCtx.contextPath}/js/jquery-qrcode-0.17.0.min.js">
</script>
<script src="${webCtx.contextPath}/js/gluu-auth.js">
</script>
<script>

function setError(msg) {
    document.getElementById("error").textContent = msg
}

function showQR(qrRequest) {

    //visit https://larsjung.de/jquery-qrcode/ for more info...
    var options = {
        render: 'canvas',
        minVersion: 1,
        maxVersion: 40,
        ecLevel: 'L',
        left: 0,
        top: 0,
        size: 260,
        fill: '#000',
        background: null,
        text: qrRequest,
        radius: 0,
        quiet: 0,
        mode: 0,
        mSize: 0.1,
        mPosX: 0.5,
        mPosY: 0.5,
        label: null,
        fontname: 'sans',
        fontcolor: '#000',
        image: null
    }
    $("#qr_container").html("")
    $("#qr_container").qrcode(options)

}

var timeLeft = ${timeout} <= 0 ? 1 : ${timeout} 
var intervalId 

function updateTimer() {
    
    timeLeft--
    $("#time").text(timeLeft)
    if (timeLeft == 0) {
        clearInterval(intervalId)
        intervalId = null

        $("#qr_container").html("")
    }

}

function onSignInCallback(result) {

    console.log("Result: " + result)
    if (result == "success") {
        document.forms[0].submit()
    } else {
        if (result == "error") {
            setError("An error has occurred")
        }
        timeLeft = 1
        $("#timer").html("")
    }

}

window.onload = (event) => {    
    intervalId = setInterval(updateTimer, 1000)
    showQR('${request?no_esc}')
    gluu_auth.startSessionChecker(onSignInCallback, ${timeout});
}

</script>

<@com.nojs />

<div class="border border-1 rounded p-5">

    <p class="fs-4 mb-5">Scan the QR code with Super Gluu</p>

    <div align="center" class="mb-2" id="qr_container"></div>
        
    <div align="center" class="fs-6 text-danger mt-3" id="error"></div>
    
    <div align="center" class="mb-3 link-secondary" id="timer">Time remaining: <span id="time">-</span> secs</div>
    
    <p align="center" class="fs-6 mb-5">We'll log you in as soon as we detect your approval.</p>
    
    <form method="post" enctype="application/x-www-form-urlencoded">
    </form>
        
    <#if escape!false>
        <@authncom.main />
    </#if>
</div>

</@com.main>