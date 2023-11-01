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

    <p class="fs-4 mb-4">To proceed ensure you have Super Gluu in your smartphone</p>
    
    <div align="center" class="mb-4"><img class="w-25" src="sg.jpg"></div>
    
    <p class="fs-6 mb-4">
        When you are done, please open the application and scan the QR code that will appear in the next screen.
    </p>
    
    <div align="center" class="mb-4 px-5">
    
        <a href="https://play.google.com/store/apps/details?id=gluu.org.super.gluu&hl=en"
            target="_blank"><img src="../playstore.png" class="playstore"></a>
        
        &nbsp;&nbsp;
    
        <a href="https://apps.apple.com/us/app/super-gluu/id1093479646"
            target="_blank"><img src="../appstore.png" class="appstore"></a>
     </div>
    
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
