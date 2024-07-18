export default defineNuxtRouteMiddleware((to, from) => {
    if(process.client){
       const isLoggedIn = localStorage.getItem('isLoggedIn') 
       if (!isLoggedIn) {
         return navigateTo('/login');
       }
     }
   });

