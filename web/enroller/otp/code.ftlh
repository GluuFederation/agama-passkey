<#import "../../agamapasskey/commons.ftlh" as com>
<#import "../commons.ftlh" as enrcom>

<@com.main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"
        integrity="sha512-pumBsjNRGGqkPzKHndZMaAG+bir374sORyzM3uulLV14lN5LyykqNk8eEeUlUkB3U0M4FApyaHraT65ihJhDpQ=="
        crossorigin="anonymous" referrerpolicy="no-referrer">
</script>
<script src="${webCtx.contextPath}/js/jquery-qrcode-0.17.0.min.js">
</script>
<script>

function showQR(qrRequest) {

    //visit https://larsjung.de/jquery-qrcode/ for more info...
    var options = {
        render: 'canvas',
        minVersion: 1,
        maxVersion: 40,
        ecLevel: 'L',
        left: 0,
        top: 0,
        size: 240,
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

        $("#passcode").prop("disabled", true)
        $("#submit").prop("disabled", true)
    }

}

window.onload = (event) => {

    intervalId = setInterval(updateTimer, 1000)
    let qr = "${request?no_esc}"
    
    //drop the issuer if present - it looks weird in the smartphone
    let iss = "issuer="
    let i = qr.indexOf(iss)
    if (i != -1) {
        let j = qr.indexOf("&", i + iss.length)
        j = j == -1 ? qr.length : j
        qr = qr.substring(0, i) + qr.substring(j)
    }
    showQR(qr)

}

</script>

<@com.nojs />

<div class="border border-1 rounded p-5">

    <p class="fs-4 mb-4">Scan the QR code with your OTP app and enter the code that appears in your phone</p>

    <div align="center" class="mb-2" id="qr_container"></div>
    
    <div align="center" class="mb-3 link-secondary">Time remaining: <span id="time">-</span> secs</div>

    <#if !(matches!true)>
        <p align="center" class="fs-6 text-danger mb-4">Wrong code entered!</p>
    </#if>
    
    <form method="post" enctype="application/x-www-form-urlencoded">
        <div class="mb-3 row">
            <label for="passcode" class="col-md-5 col-form-label">Enter the code</label>
            <div class="col-md-7">
                <input type="text" class="form-control" id="passcode" name="passcode"
                        pattern="[0-9]+" placeHolder="000000" autocomplete="off" required autofocus>
                <#-- Pressing the enter key on this field triggers submission via the FIRST submit button found in the page -->
            </div>
        </div>
        <div class="mb-4 row">
            <div class="col-md-12 d-flex justify-content-end">
                <input type="submit" class="btn btn-success px-4" value="Validate" id="submit" name="submit">
            </div>
        </div>
    </form>
        
    <#if escape!false>
        <@enrcom.main />
    </#if>
</div>

</@com.main>