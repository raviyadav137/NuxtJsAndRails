<template>
  <div>
    <navbar class="fixed top-0 left-0 w-full z-50" />
    <div class="flex flex-col md:flex-row">
      <Sidebar />
      <div class="main-content p-4 lg:p-6 w-full">
        <h1 class="text-2xl font-bold mb-4">Artist Music Details</h1>
        <div v-if="artist" class="mb-6 flex flex-wrap justify-between">
         
        </div>
      
          <div class="flex flex-col md:flex-row  items-center mb-4">
            <button @click="showCreateForm" class="bg-blue-500 text-white px-4 py-2 rounded mb-2 md:mb-0">
              <i class="fa-regular fa-plus mr-1"></i> Create
            </button>
            <button @click="backClick" class="bg-gray-500 text-white px-4 py-2 ml-2 rounded">
              <i class="fa-solid fa-arrow-left mr-2"></i> Go Back
            </button>
          </div>

          <div v-if="showConfirmationModal" class="fixed inset-0 flex items-center justify-center bg-gray-800 bg-opacity-50 z-40">
        <div class="bg-white p-6 rounded-lg shadow-lg max-w-sm w-full">
          <h2 class="text-xl font-semibold mb-4">Confirm Deletion</h2>
          <p>Are you sure you want to delete this music?</p>
          <div class="flex justify-end space-x-2 mt-4 ">
            <button @click="cancelDelete" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
            <button @click="confirmDeleteAction" class="bg-red-500 text-white px-4 py-2  rounded">Delete</button>
          </div>
        </div>
        </div>




          <div class="overflow-x-auto">
            <table class="music_table w-full border-collapse">
              <thead>
                <tr>
                  <th>Title</th>
                  <th>Artist Name</th>
                  <th>Album Name</th>
                  <th>Genre</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="music in paginatedMusic" :key="music.id" :class="{'bg-gray-100': music.artist_id % 2 === 0}">
                  <td>{{ music.title }}</td>
                  <td>{{ music.artist_name }}</td>
                  <td>{{ music.album }}</td>
                  <td>{{ music.genre }}</td>
                  <td class="flex space-x-2 justify-center">
                    <button @click="editMusic(music)" class="bg-yellow-500 text-white px-4 ml-4 py-1 rounded">
                      <i class="fa-solid fa-pen-to-square"></i>
                    </button>
                    <button @click="deleteMusic(music.id)" class="bg-red-500 text-white px-4 py-1 rounded">
                      <i class="fa-solid fa-trash"></i>
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="pagination-container mt-4 flex justify-center items-center">
            <button @click="prevPage" :disabled="currentPage === 1" class="bg-gray-500 text-white px-4 py-2 rounded mr-2">
              Previous
            </button>
            <span>Page {{ currentPage }} of {{ totalPages }}</span>
            <button @click="nextPage" :disabled="currentPage === totalPages" class="bg-gray-500 text-white px-4 py-2 rounded ml-2">
              Next
            </button>
         </div>      
        
      
        <div v-if="showForm" class="fixed inset-0 flex items-center justify-center bg-gray-800 bg-opacity-50 z-40">
          <div class="bg-white p-6 rounded-lg shadow-lg max-w-sm w-full">
            <h2 class="text-xl font-semibold mb-4">{{ isUpdating ? 'Update Music' : 'Create Music' }}</h2>
            <form @submit.prevent="isUpdating ? submitUpdate() : createMusic()">
              <div class="mb-4">
                <label for="artist_name" class="block text-gray-700">Artist</label>
                <input v-model="form.artist_name" type="text" id="artist_name" class="border rounded p-2 w-full " readonly />
              </div>
              <div class="mb-4">
                <label for="title" class="block text-gray-700">Title</label>
                <input v-model="form.title" type="text" id="title" class="border rounded p-2 w-full" required />
              </div>
              <div class="mb-4">
                <label for="album" class="block text-gray-700">Album</label>
                <input v-model="form.album" type="text" id="album" class="border rounded p-2 w-full" required />
              </div>
              <div class="mb-4">
                <label for="genre" class="block text-gray-700">Genre</label>
                <input v-model="form.genre" type="text" id="genre" class="border rounded p-2 w-full" required />
              </div>
              <div class="flex justify-end space-x-2">
                <button type="button" @click="cancelForm" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
                <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">{{ isUpdating ? 'Update' : 'Create' }}</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useToast } from 'vue-toastification';

const toast = useToast();
definePageMeta({
  middleware: "auth",
});

const route = useRoute();
const router = useRouter();
const artistId = ref(route.params.id);
const artist = ref(null);
const musics = ref([]);
const artists = ref([]);
const showForm = ref(false);
const showConfirmationModal = ref(false);
const isUpdating = ref(false);
const musicToDelete = ref(null); // For storing the music ID to delete

const form = ref({
  id: null,
  artist_id: artistId.value,
  artist_name: '',
  title: '',
  album: '',
  genre: ''
});

const resetForm = () => {
  form.value = {
    id: null,
    artist_id: artistId.value,
    artist_name: artist.value ? artist.value.name : '',
    title: '',
    album: '',
    genre: ''
  };
};

const showCreateForm = () => {
  resetForm();
  isUpdating.value = false;
  showForm.value = true;
};

const fetchArtist = async () => {
  try {
    const response = await fetch(`http://127.0.0.1:3000/api/v1/artists/${artistId.value}`);
    const result = await response.json();
    artist.value = result.data;
    form.value.artist_name = artist.value.name;
  } catch (error) {
    console.error('Error fetching artist details:', error);
  }
};

const fetchAllArtists = async () => {
  try {
    const response = await fetch('http://127.0.0.1:3000/api/v1/artists');
    const data = await response.json();
    artists.value = data;
  } catch (error) {
    console.error('Error fetching artists:', error);
  }
};

const fetchMusics = async () => {
  try {
    const response = await fetch('http://127.0.0.1:3000/api/v1/songs');
    const data = await response.json();
    musics.value = data.map(music => {
      const artist = artists.value.find(artist => artist.id === music.artist_id);
      return {
        ...music,
        artist_name: artist ? artist.name : 'unknown'
      };
    });
  } catch (error) {
    console.error('Error fetching musics:', error);
  }
};

const filteredMusic = computed(() => {
  return musics.value.filter(music => music.artist_id === parseInt(artistId.value, 10));
});

const itemsPerPage = 4;
const currentPage = ref(1);

const totalPages = computed(() => Math.ceil(filteredMusic.value.length / itemsPerPage));

const paginatedMusic = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  return filteredMusic.value.slice(start, start + itemsPerPage);
});

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

const cancelForm = () => {
  resetForm();
  isUpdating.value = false;
  showForm.value = false;
};

const deleteMusic = (musicId) => {
  musicToDelete.value = musicId;
  showConfirmationModal.value = true;
};

const cancelDelete = () => {
  musicToDelete.value = null;
  showConfirmationModal.value = false;
};

const confirmDeleteAction = async () => {
  if (musicToDelete.value === null) return;

  try {
    const response = await fetch(`http://127.0.0.1:3000/api/v1/songs/${musicToDelete.value}`, {
      method: 'DELETE'
    });
    if (response.ok) {
      musics.value = musics.value.filter(music => music.id !== musicToDelete.value);
      toast.success("Music deleted successfully");
    } else {
      console.error('Failed to delete music:', response.status);
    }
  } catch (error) {
    console.error('Error deleting music:', error);
  } finally {
    musicToDelete.value = null;
    showConfirmationModal.value = false;
  }
};

const editMusic = (music) => {
  form.value = { ...music };
  isUpdating.value = true;
  showForm.value = true;
};

const submitUpdate = async () => {
  try {
    const response = await fetch(`http://127.0.0.1:3000/api/v1/songs/${form.value.id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ song: form.value })
    });

    if (response.ok) {
      const updatedMusic = await response.json();
      const index = musics.value.findIndex(music => music.id === updatedMusic.id);
      if (index !== -1) {
        musics.value[index] = updatedMusic;
        const artist = artists.value.find(artist => artist.id === updatedMusic.artist_id);
        musics.value[index].artist_name = artist ? artist.name : 'Unknown';
      }
      toast.success("Updated successfully");
      showForm.value = false;
      resetForm();
    } else {
      console.error('Failed to update music:', response.status);
    }
  } catch (error) {
    console.error('Error updating music:', error);
  }
};

const createMusic = async () => {
  try {
    const response = await fetch('http://127.0.0.1:3000/api/v1/songs', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ song: form.value })
    });

    if (response.ok) {
      const newMusic = await response.json();
      const artist = artists.value.find(artist => artist.id === newMusic.artist_id);
      newMusic.artist_name = artist ? artist.name : 'Unknown';
      musics.value.push(newMusic);
      toast.success("Music created successfully");
      showForm.value = false;
      resetForm();
    } else {
      console.error('Failed to create music:', response.status);
    }
  } catch (error) {
    console.error('Error creating music:', error);
  }
};

const backClick = () => {
  router.push('/artist');
};

watch(() => form.value.artist_id, (newArtistId) => {
  const selectedArtist = artists.value.find(artist => artist.id === newArtistId);
  if (selectedArtist) {
    form.value.artist_name = selectedArtist.name;
  } else {
    form.value.artist_name = '';
  }
});

onMounted(() => {
  fetchAllArtists().then(() => {
    fetchArtist();
    fetchMusics();
  });
});
</script>

<style scoped>
.music_table {
  border-collapse: collapse;
  width: 100%;
  margin-bottom: 1rem;
}

.music_table th, .music_table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
  text-align: center;
}
.close:hover {
  color: #ff0000;
}

.music_table th {
  background-color: #418062;
  color: white;
}
</style>