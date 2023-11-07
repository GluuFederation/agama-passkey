<#import "../../agamapasskey/commons.ftlh" as com>
<#import "../commons.ftlh" as enrcom>

<@com.main>

<style>
    .playstore {
        height: 2rem;
    }
    .appstore {
        height: 1.9rem;
        background-color:#000
    }
</style>
<div class="border border-1 rounded p-5">

    <p class="fs-4 mb-5">To proceed ensure you have an OTP app installed in your smartphone</p>
    
    <p class="fs-6 mb-3">Here are some examples:</p>
    <ul class="mb-4">
        <li class="mb-3 d-flex">
            <div class="mt-1" style="width:12rem">Google Authenticator</div>
            
            <a href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en"
                target="_blank"><img src="../playstore.png" class="playstore"></a>
            
            &nbsp;

            <a href="https://apps.apple.com/us/app/google-authenticator/id388497605"
                target="_blank"><img src="../appstore.png" class="appstore"></a>
                
        <li class="d-flex">
            <div class="mt-1" style="width:12rem">FreeOTP</div>
            
            <a href="https://play.google.com/store/apps/details?id=org.fedorahosted.freeotp&hl=en"
                    target="_blank"><img src="../playstore.png" class="playstore"></a>
            
            &nbsp;
                
            <a href="https://apps.apple.com/us/app/freeotp-authenticator/id872559395"
                target="_blank"><img src="../appstore.png" class="appstore"></a>
    </ul>
    
    <p class="fs-6 mb-4">
        When you are done, please open the application and scan the QR code that will appear in the next screen.
    </p>
    
    <form method="post" enctype="application/x-www-form-urlencoded">
        <div class="mb-4 row">
            <div class="col-md-12 d-flex justify-content-end">
                <input type="submit" class="btn btn-success px-4" value="Continue">
            </div>
        </div>
    </form>
        
    <#if escape!false>
        <@enrcom.main />
    </#if>
</div>

</@com.main>
