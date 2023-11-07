<#import "../agamapasskey/commons.ftlh" as com>
<@com.main>
 
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/js/all.min.js" 
        integrity="sha512-2bMhOkE/ACz21dJT8zBOMgMecNxx0d37NND803ExktKiKdSzdwn+L7i9fdccw/3V06gM/DBWKbYmQvKMdAA9Nw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" async>
</script>

<script>
    function select(m) {
        document.getElementById("selection").value = m;
        document.forms[0].submit();
    }
    function hideAlert() {
        let alert = document.getElementById("alert")
        if (alert) {
            alert.remove();
        }
    }
    window.onload = (event) => {
        setTimeout(hideAlert, 2500)
    }
</script>

<style>
    a {
        text-decoration: none;
    }
    .icon {
        width:3.5rem;
    }
</style>

<@com.nojs />

<div class="border border-1 rounded p-5 mb-3">

    <#if error>
        <div align="center" class="py-3 alert alert-danger" id="alert" role="alert">
            We had trouble authenticating you. Try another option from the below list.
        </div>
    </#if>

    <p class="fs-4 mb-5">Choose the type of credential you want to use to login</p>
    
    <form method="post" enctype="application/x-www-form-urlencoded" class="ps-3">
        <#list enrolledMethods as m>
            <a href="javascript:select('${m}')" class="link-secondary d-flex align-items-center fs-6 mb-2">
                <#if m == "otp">
                    <div class="fs-1 link-success icon">
                        <i class="fa-solid fa-mobile-screen-button"></i>
                    </div>
                    <p class="m-0">
                        An access code provided by the OTP app in my phone
                    </p>
                <#elseif m == "passphrase">
                    <div class="fs-1 link-success icon">
                        <i class="fa-solid fa-asterisk"></i>
                    </div>
                    <p class="m-0 ps-2">?
                    </p>
                <#elseif m == "super_gluu">
                    <div class="fs-1 link-success icon">
                        <i class="far fa-bell" data-fa-transform="shrink-1"></i>
                    </div>
                    <p class="m-0">
                        A notification to my Super Gluu
                    </p>
                <#elseif m == "fido2">
                    <div class="fs-1 link-success icon">
                        <span class="fa-layers fa-fw" style="bottom:-.6rem;left:-.4rem">
                            <i class="fas fa-tablet" data-fa-transform="shrink-1"></i>
                            <i class="fas fa-mobile-alt" data-fa-transform="up-7 shrink-4"></i>
                            <i class="fas fa-stream" data-fa-transform="rotate--90 up-9 shrink-12"></i>
                        </span>
                    </div>
                    <p class="m-0">
                        My Fido device (eg. security key)<!--, Windows Hello, Touch ID, Face ID, etc. -->
                    </p>
                </#if>
            </a>
        </#list>
        <input type="hidden" id="selection" name="selection" value="">
    </form>
                
</div>

</@com.main>
