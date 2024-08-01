<template>
  <aside class="w-64 h-screen bg-blue-950 text-white flex flex-col hidden lg:flex aside_bar">
    <!-- Navigation Links -->
    <nav class="flex-1 mt-4">
      <ul class="space-y-4">
        <nuxt-link to="/">
          <li class="flex items-center space-x-3 p-4 hover:bg-blue-700 cursor-pointer">
            <i class="fas fa-tachometer-alt"></i>
            <span>Dashboard</span>
          </li>
        </nuxt-link>
        <nuxt-link to="/artist">
          <li class="flex items-center space-x-3 p-4 hover:bg-blue-700 cursor-pointer">
            <i class="fas fa-user"></i>
            <span>Artists</span>
          </li>
        </nuxt-link>
        <nuxt-link to="/song">
          <li class="flex items-center space-x-3 p-4 hover:bg-blue-700 cursor-pointer">
            <i class="fas fa-music"></i>
            <span>Songs</span>
          </li>
        </nuxt-link>
        <nuxt-link to="/user">
          <li class="flex items-center space-x-3 p-4 hover:bg-blue-700 cursor-pointer">
            <i class="fas fa-users"></i>
            <span>Users</span>
          </li>
        </nuxt-link>
        <li @click="logout" class="flex items-center space-x-3 p-4 hover:bg-blue-700 cursor-pointer">
          <i class="fas fa-sign-out-alt"></i>
          <span>Signout</span>
        </li>
      </ul>
    </nav>
  </aside>
</template>


<script setup>
import { useRouter } from 'vue-router';
import { useToast } from 'vue-toastification';

const toast = useToast();
const router = useRouter();

const logout = () => {
  toast.success("Logout Scucssfully")

  localStorage.removeItem('token');

 
  router.push('/login');
};
</script>

  <style scoped>
  .aside_bar{
    height: calc(100vh - 64px);
  }
</style>
  

  