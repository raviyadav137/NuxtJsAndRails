<template>
  <nav class="bg-green-600 h-16 py-4 px-6 flex items-center justify-around relative">
    <i class="fas fa-bars text-white text-xl cursor-pointer lg:hidden" @click="toggleMenu"></i>
    <h1 class="text-white text-lg font-semibold">Artist Management System</h1>
    <ul class="hidden md:flex space-x-6 ml-auto">
      <li class="text-white hover:text-green-300 cursor-pointer">
        <i class="fas fa-user mr-2"></i>{{ firstName }} {{ lastName }}
      </li>
    </ul>
    <div v-if="menuOpen" class="absolute h-screen top-16 left-0 px-6 bg-gray-600 text-white shadow-lg lg:hidden flex flex-col py-2">
      <ul class="space-y-4">
        <NuxtLink 
          to="/" 
          @click.native="handleLinkClick"
          :class="{ 'text-green-300': currentRoute === '/' }"
        >
          <li class="hover:text-green-300 pt-10 text-2xl cursor-pointer flex items-center">
            <i class="fas fa-tachometer-alt"></i> Dashboard
          </li>
        </NuxtLink>
        <NuxtLink 
          to="/artist"
          @click.native="handleLinkClick"
          :class="{ 'text-green-300': currentRoute === '/artist' }"
        >
          <li class="hover:text-green-300 pt-10 text-2xl cursor-pointer flex items-center">
            <i class="fas fa-microphone-alt mr-2"></i> Artists
          </li>
        </NuxtLink>
        <NuxtLink 
          to="/song"
          @click.native="handleLinkClick"
          :class="{ 'text-green-300': currentRoute === '/song' }"
        >
          <li class="hover:text-green-300 pt-10 text-2xl cursor-pointer flex items-center">
            <i class="fas fa-music mr-2"></i> Songs
          </li>
        </NuxtLink>
        <NuxtLink 
          to="/user"
          @click.native="handleLinkClick"
          :class="{ 'text-green-300': currentRoute === '/user' }"
        >
          <li class="hover:text-green-300 pt-10 text-2xl cursor-pointer flex items-center">
            <i class="fas fa-users mr-2"></i> Users
          </li>
        </NuxtLink>
        <li @click="logout" class="hover:text-green-300 pt-10 text-2xl cursor-pointer flex items-center">
          <i class="fas fa-sign-out-alt mr-2"></i> Logout
        </li>
      </ul>
    </div>
  </nav>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useToast } from 'vue-toastification';
import { useRoute, useRouter } from 'vue-router';

const toast = useToast();
const firstName = ref('');
const lastName = ref('');
const menuOpen = ref(false);
const route = useRoute();
const router = useRouter();

const toggleMenu = () => {
  menuOpen.value = !menuOpen.value;
};

const handleLinkClick = (event) => {
  if (menuOpen.value) {
    menuOpen.value = false;
  }
};

const logout = () => {
  toast.success("Logout successfully");
  localStorage.removeItem('token');
  router.push('/login');
};

onMounted(() => {
  const user = JSON.parse(localStorage.getItem('user'));
  if (user) {
    firstName.value = user.first_name || '';
    lastName.value = user.last_name || '';
  }
});

const currentRoute = ref(route.path);

watch(route, (newRoute) => {
  currentRoute.value = newRoute.path;
});
</script>
