<#import "../agamapasskey/commons.ftlh" as com>
<@com.main>

<script>
    function hideAlert() {
        let alert = document.getElementById("alert")
        if (alert) {
            alert.remove();
        }
    }
    window.onload = (event) => {
        setTimeout(hideAlert, 3000)
    }
</script>

<@com.nojs />

<div class="border border-1 rounded p-5 mb-3">

    <#if message??>
        <div align="center" class="py-3 alert alert-success" id="alert" role="alert">${message}</div>
    </#if>
    
    <p class="fs-4 mb-5">If you wish, choose a preferred method</p>

    <p class="fs-6 mb-4">This will be the credential you will be asked to present at login. 
        Your other credentials will act as alternatives</p>

    <form method="post" enctype="application/x-www-form-urlencoded">
        <#list methods as m>        
            <div class="mb-3 ps-3">
                <input type="radio" name="pref" id="${m?counter}" value="${m}">
                <label class="link-secondary" for="${m?counter}">                    
                    <#if m == "otp">
                        One-time verification code
                    <#elseif m == "passphrase">
                        Your passphrase
                    <#elseif m == "super_gluu">
                        A Super Gluu notification
                    <#elseif m == "fido2">
                        Your fido device
                    </#if>
                </label>
            </div>
        </#list>
        <div align="center" class="pt-3 mb-4">
            <input type="submit" class="btn btn-success px-4" value="Continue">
        </div>        
    </form>
</div>

</@com.main>
