<#import "../../agamapasskey/commons.ftlh" as com>
<#import "../commons.ftlh" as authncom>

<@com.main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/js/all.min.js" 
        integrity="sha512-2bMhOkE/ACz21dJT8zBOMgMecNxx0d37NND803ExktKiKdSzdwn+L7i9fdccw/3V06gM/DBWKbYmQvKMdAA9Nw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" async>
</script>

<@com.nojs />

<div class="border border-1 rounded p-5 mb-3">

    <p class="fs-4 mb-4">${name!}, check your phone's OTP app</p>
        
    <div align="center" class="link-secondary lh-sm ps-2" style="font-size:8rem">
        <i class="fa-solid fa-mobile-screen-button"></i>
    </div>
    <div align="center" class="fs-4 link-secondary mb-4 pb-2" style="margin-top:-1rem">_ _ _ _ _ _</div>
    
    <#if !(matches!true)>
        <p align="center" class="fs-6 text-danger mb-4">Wrong code entered!</p>
    </#if>

    <form method="post" enctype="application/x-www-form-urlencoded">
        <div class="mb-5 row">
            <label for="passcode" class="col-sm-5 col-form-label">Enter the code displayed</label>
            <div class="col-sm-3">
                <input type="text" class="form-control" id="passcode" name="passcode"
                        pattern="[0-9]+" placeHolder="000000" autocomplete="off" required autofocus>
                <#-- Pressing the enter key on this field triggers submission via the FIRST submit button found in the page -->
            </div>
            <div class="col-sm-4">
                <input type="submit" class="btn btn-success px-3" value=" Login ">
            </div>
        </div>
    </form>
    <#if escape!false>
        <@authncom.main />
    </#if>
</div>

</@com.main>