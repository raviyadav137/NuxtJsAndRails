// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-04-03',
  devtools: { enabled:false },
  modules: [
    '@nuxtjs/tailwindcss'
],
css: [
  '@fortawesome/fontawesome-free/css/all.css',
  '@/assets/css/input.css',
],
plugins: [
  '~/plugins/toast.js',
],

})
