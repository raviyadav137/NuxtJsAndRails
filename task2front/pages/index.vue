<template>
  <navbar />
  <div class="flex flex-col md:flex-row">
    
      <sidebar />
   
    
    <div class="main-content p-4 lg:p-6 w-full">
      <div class="flex flex-col md:flex-row flex-wrap justify-center gap-4">
        <div class="flex flex-col items-center bg-white border border-gray-200 rounded-lg shadow hover:bg-gray-100 dark:border-gray-700 dark:bg-gray-800 dark:hover:bg-gray-700 w-full md:w-1/4 max-w-sm p-4">
          <NuxtLink to="/artist" class="flex flex-col items-center">
            <i class="fas fa-user text-4xl mb-2"></i>
            <h5 class="mb-2 text-2xl font-semibold tracking-tight text-gray-900 dark:text-white">Artist List</h5>
            <p class="text-gray-700 dark:text-gray-400">{{ statistics.artist_count || 0 }}</p>
          </NuxtLink>
        </div>

        <div class="flex flex-col items-center bg-white border border-gray-200 rounded-lg shadow hover:bg-gray-100 dark:border-gray-700 dark:bg-gray-800 dark:hover:bg-gray-700 w-full md:w-1/4 max-w-sm p-4">
          <NuxtLink to="/song" class="flex flex-col items-center">
            <i class="fas fa-music text-4xl mb-2"></i>
            <h5 class="mb-2 text-2xl font-semibold tracking-tight text-gray-900 dark:text-white">Songs List</h5>
            <p class="text-gray-700 dark:text-gray-400">{{ statistics.song_count || 0 }}</p>
          </NuxtLink>
        </div>

        <div class="flex flex-col items-center bg-white border border-gray-200 rounded-lg shadow hover:bg-gray-100 dark:border-gray-700 dark:bg-gray-800 dark:hover:bg-gray-700 w-full md:w-1/4 max-w-sm p-4">
          <NuxtLink to="/user" class="flex flex-col items-center">
            <i class="fas fa-users text-4xl mb-2"></i>
            <h5 class="mb-2 text-2xl font-semibold tracking-tight text-gray-900 dark:text-white">Users List</h5>
            <p class="text-gray-700 dark:text-gray-400">{{ statistics.user_count || 0 }}</p>
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { fetchStatistics } from '@/services/apiService';

definePageMeta({
  middleware: "auth",
});

const statistics = ref({
  user_count: 0,
  artist_count: 0,
  song_count: 0
});
const loading = ref(true);
const error = ref(false);

onMounted(async () => {
  try {
    const result = await fetchStatistics();
    if (result) {
      statistics.value = result;
    } else {
      error.value = true;
    }
  } catch (err) {
    console.error('Error loading statistics:', err);
    error.value = true;
  } finally {
    loading.value = false;
  }

  const user = JSON.parse(localStorage.getItem('user'));
  if (user) {
    firstName.value = user.first_name || '';
    lastName.value = user.last_name || '';
  }
});
</script>

<style scoped>

</style>
