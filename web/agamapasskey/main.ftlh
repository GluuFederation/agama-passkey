<#import "commons.ftlh" as com>
<@com.main>

    <div class="border border-1 rounded p-5">

        <p class="fs-4 mb-5">Welcome to Agama PassKey</p>

        <form method="post" enctype="application/x-www-form-urlencoded">
            <div class="mb-3 row">
                <label for="username" class="col-md-4 col-form-label">Enter your username</label>
                <div class="col-md-8">
                    <input type="text" class="form-control" name="username" id="username"
                           placeHolder="username" value="${username!}" required autofocus>
                </div>
            </div>
            <div class="mb-3 row">
                <label for="password" class="col-md-4 col-form-label">Enter your password</label>
                <div class="col-md-8">
                    <input type="password" class="form-control" name="password" id="password"
                           placeHolder="password" required autofocus>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 d-flex justify-content-end">
                    <input type="submit" class="btn btn-success px-4" value="Login" name="loginBtn">
                </div>
            </div>
        </form>
    </div>

</@com.main>
