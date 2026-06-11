[#ftl output_format="HTML"]
<!DOCTYPE html>
<html lang="en">
<head><meta name="viewport" content="width=device-width, initial-scale=1"><title>Passkey nickname
	</title><link rel="icon" href="${webCtx.contextPath}/servlet/favicon" type="image/x-icon"></head>
<body>

  
	
	
	
  
  
	<section class="bg-gray-100 dark:bg-gray-900">
	  <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
		<div class="flex flex-col items-center mb-6 text-2xl font-semibold text-gray-900 dark:text-white">
		  <img src="https://gluu.org/wp-content/uploads/2021/02/janssen-project-transparent-630px-182px-300x86.png" alt="logo" class="w-40 mr-2">
		</div>
		<div class="w-full bg-white rounded-lg shadow-lg dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
		  <form method="post" enctype="application/x-www-form-urlencoded" class="w-full max-w-md bg-white rounded-2xl shadow-xl dark:bg-gray-800 p-8 space-y-6">
			<!-- Success Icon -->
			<div class="flex items-center justify-center">
			  <div class="flex items-center justify-center w-12 h-12 rounded-full bg-green-100">
				<svg height="28" viewBox="0 0 24 24" width="28" class="text-green-600">
				  <path fill="currentColor" d="M17.28 9.28a.75.75 0 0 0-1.06-1.06l-5.97 5.97-2.47-2.47a.75.75 0 0 0-1.06 1.06l3 3a.75.75 0 0 0 1.06 0l6.5-6.5Z">
				  </path>
				  <path fill="currentColor" d="M12 1c6.075 0 11 4.925 11 11s-4.925 11-11 11S1 18.075 1 12 5.925 1 12 1ZM2.5 12a9.5 9.5 0 0 0 9.5 9.5 9.5 9.5 0 0 0 9.5-9.5A9.5 9.5 0 0 0 12 2.5 9.5 9.5 0 0 0 2.5 12Z">
				  </path>
				</svg>
			  </div>
			</div>
			<!-- Title -->
			<h1 class="text-2xl text-center font-semibold text-gray-900 dark:text-white">
			  Passkey added successfully
			</h1>
			<!-- Description -->
			<p class="text-sm text-center text-gray-600 dark:text-gray-400">
			  You can now use this passkey to sign in securely.
			</p>
			<!-- Divider -->
			<div class="border-t border-gray-200 dark:border-gray-700">
			</div>
			<!-- Nickname Section -->
			<div class="space-y-2">
			  <label for="nickname" class="block text-sm font-medium text-gray-700 dark:text-gray-300">
				Passkey nickname
			  </label>
			  <p class="text-xs text-gray-500 dark:text-gray-400">
				Give it a recognizable name like your device or browser.
			  </p>
			  <input type="text" name="nickname" id="nickname" placeholder="My Passkey" autocomplete="off" class="w-full px-4 py-3 text-sm border rounded-lg bg-gray-50 border-gray-300 focus:ring-2 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:placeholder-gray-400 outline-none transition">
			</div>
			<!-- Submit Button -->
			<button type="submit" class="w-full py-3 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700 focus:ring-4 focus:ring-green-300 dark:focus:ring-green-800 transition">
			  Done
			</button>
		  </form>
		</div>
	  </div>
	</section>
  
  
  
</body>

<script src="https://cdn.tailwindcss.com"></script><script>
	tailwind.config = {
	  darkMode: 'class'
	}
  </script>
</html>