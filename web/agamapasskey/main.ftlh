<#import "commons.ftlh" as com>
<@com.main>
    <div class="bg-white relative flex flex-col items-center pt-20">
        <div class="md:border md:border-gray-300 bg-white md:shadow-lg shadow-none rounded p-10 align-middle w-80">
            <div class="flex flex-col items-center space-y-3">
                <div class="flex">
                    <img src="https://gluu.org/wp-content/uploads/2020/12/logo.png"/>
                </div>
                <span class="text-2xl font-semi-bold leading-normal">Fido PassKey</span>
            </div>
            <form method="post" class="my-8" enctype="application/x-www-form-urlencoded">
                <div class="relative mb-2">
                    <label class="block text-gray-700 text-sm font-bold mb-2" for="username">
                        Username
                    </label>
                    <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                           id="username" name="username" type="text">
                </div>
                <div class="relative mb-2">
                    <label class="block text-gray-700 text-sm font-bold mb-2" for="password">
                        Password
                    </label>
                    <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
                           id="password" name="password" type="password">
                </div>
                <div class="space-y-9">
                    <div class="text-sm flex justify-center items-center">
                        <input type="submit" name="loginBtn" class="py-2 px-6 rounded text-white btn bg-green-500 hover:bg-green-600" value="Login">
                    </div>
                </div>
            </form>
        </div>
    </div>
</@com.main>