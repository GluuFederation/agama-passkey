[#ftl output_format="HTML"]
<!DOCTYPE html>
<html lang="en">
<head><meta name="viewport" content="width=device-width, initial-scale=1"><title>Sign in with password
	</title><link rel="icon" href="${webCtx.contextPath}/servlet/favicon" type="image/x-icon"></head>
<body>

  
	
	
	
  
  
	<section class="bg-gray-100 dark:bg-gray-900">
	  <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
		<div class="flex items-center mb-6">
		  <img src="https://gluu.org/wp-content/uploads/2021/02/janssen-project-transparent-630px-182px-300x86.png" alt="logo" class="w-40">
		</div>
		<div class="w-full bg-white rounded-lg shadow-lg dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
		  <form method="post" enctype="application/x-www-form-urlencoded" class="w-full max-w-md bg-white rounded-2xl shadow-xl dark:bg-gray-800 p-8 space-y-6">
			<!-- Title -->
			<h1 class="text-2xl font-semibold text-center text-gray-900 dark:text-white">
			  Enter your password
			</h1>
			<!-- Username Info -->
			<p class="text-sm text-center text-gray-500 dark:text-gray-400">
			  Signing in as
			  <span class="font-medium text-gray-900 dark:text-white">${username}</span>
			</p>
			<!-- Password Field -->
			<div class="space-y-2">
			  <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
				Password
			  </label>
			  <input type="password" name="password" id="password" required="" autofocus="" autocomplete="current-password" placeholder="Enter your password" class="w-full px-4 py-3 text-sm border rounded-lg bg-gray-50 border-gray-300 focus:ring-2 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:placeholder-gray-400 outline-none transition">
			</div>
			<!-- Error Message -->
			<!--&lt;#if showError == true&gt;-->
			<div class="p-4 text-sm text-red-700 bg-red-50 border border-red-300 rounded-lg dark:bg-gray-900 dark:text-red-400 dark:border-red-800">
			  <p class="font-medium">${errorTitle}
			  </p>
			  <p class="mt-1">${errorMessage}
			  </p>
			</div>
			<!--#if-->
			<!-- Sign In Button -->
			<button type="submit" name="loginBtn" class="w-full py-3 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700 focus:ring-4 focus:ring-green-300 dark:focus:ring-green-800 transition">
			  Sign in
			</button>
			<!-- Divider -->
			<div class="flex items-center">
			  <div class="flex-grow h-px bg-gray-300 dark:bg-gray-600">
			  </div>
			  <span class="px-3 text-xs text-gray-500 dark:text-gray-400">or</span>
			  <div class="flex-grow h-px bg-gray-300 dark:bg-gray-600">
			  </div>
			</div>
			<!-- Back Button -->
			<div class="text-center">
			  <button type="submit" name="backBtn" formnovalidate="" class="text-sm font-medium text-green-600 hover:underline dark:text-green-400">
				Use a different username
			  </button>
			</div>
		  </form>
		</div>
	  </div>
	</section>
  
  
  
</body>

<script src="https://cdn.tailwindcss.com"></script><script>tailwind.config = {
	  darkMode: 'class' }
  </script>
</html>