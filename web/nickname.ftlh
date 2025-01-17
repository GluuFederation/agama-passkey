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
		  <form method="post" enctype="application/x-www-form-urlencoded" class="p-6 space-y-4 md:space-y-6 sm:p-8">
			<div class="flex items-center justify-center">
			  <svg height="32" aria-hidden="true" viewBox="0 0 24 24" version="1.1" width="32" data-view-component="true" class="-fill-green-700 w-8 h-8">
				<path d="M17.28 9.28a.75.75 0 0 0-1.06-1.06l-5.97 5.97-2.47-2.47a.75.75 0 0 0-1.06 1.06l3 3a.75.75 0 0 0 1.06 0l6.5-6.5Z">
				</path>
				<path d="M12 1c6.075 0 11 4.925 11 11s-4.925 11-11 11S1 18.075 1 12 5.925 1 12 1ZM2.5 12a9.5 9.5 0 0 0 9.5 9.5 9.5 9.5 0 0 0 9.5-9.5A9.5 9.5 0 0 0 12 2.5 9.5 9.5 0 0 0 2.5 12Z">
				</path>
			  </svg>
			</div>
			<h1 class="text-xl text-center font-medium text-gray-900 md:text-2xl dark:text-white">
			  Successfully added a passkey
			</h1>
			<p class="text-gray-600 leading-tight">
			  From now on, you can use this passkey to sign-in.
			</p>
			<div class="w-full border-t border-gray-300">
			</div>
			<div class="space-y-2">
			  <label for="nickname" class="text-gray-800">
				Passkey nickname
			  </label>
			  <p class="text-gray-600 leading-tight">
				You may want to nickname it by its manufacturer or device model.
			  </p>
			</div>
			<input type="text" name="nickname" id="nickname" placeholder="" required="" autocomplete="off" class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2-5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
			<button type="submit" class="w-full text-white bg-green-600 hover:bg-green-700 font-medium rounded-lg text-sm px-5 py-2-5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">
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