<template>
  <div>
    <navbar />
    <div class="flex">
      <sidebar />
      <div class="main-content p-4 lg:p-6 w-full">
        <h1 class="text-2xl font-bold mb-4">Song Management</h1>

        <button @click="showCreateForm" :disabled="loading" class="bg-blue-500 text-white px-4 py-2 rounded mb-4">
          <i class="fa-regular fa-plus mr-1"></i>Create Music
        </button>

        <div v-if="showForm" class="modal" @click.self="toggleForm">
          <div class="modal-content">
            <span @click="toggleForm" class="close">&times;</span>
            <h2 class="text-xl font-semibold text-green-500">{{ isUpdating ? 'Update Music' : 'Create Music' }}</h2>
            <form @submit.prevent="isUpdating ? submitUpdate() : createMusic()" class="mt-4">
              <select v-model="form.artist_id" required class="mb-2 p-2 border rounded w-full">
                <option value="" disabled>Select artist:</option>
                <option v-for="artist in artists" :key="artist.id" :value="artist.id">
                  {{ artist.name }}
                </option>
              </select>
              <input type="text" v-model="form.title" placeholder="Title" required class="mb-2 p-2 border rounded w-full" />
              <input type="text" v-model="form.album" placeholder="Album" required class="mb-2 p-2 border rounded w-full" />
              <input type="text" v-model="form.genre" placeholder="Genre" required class="mb-2 p-2 border rounded w-full" />
              <button type="submit" :disabled="loading" class="bg-green-500 text-white px-4 py-2 rounded">
                {{ isUpdating ? (loading ? 'Updating...' : 'Update') : (loading ? 'Creating...' : 'Create') }}
              </button>
            </form>
          </div>
        </div>

        <div v-if="paginatedMusics.length" class="mt-4 overflow-auto flex-grow">
          <table class="music_table w-full border-separate border-spacing-0">
            <thead>
              <tr>
                <th class="border bg-gray-100 p-4 text-left">Index</th>
                <th class="border bg-gray-100 p-4 text-left">Title</th>
                <th class="border bg-gray-100 p-4 text-left">Album Name</th>
                <th class="border bg-gray-100 p-4 text-left">Artist Name</th>
                <th class="border bg-gray-100 p-4 text-left">Genre</th>
                <th class="border bg-gray-100 p-4 text-left">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(music, index) in paginatedMusics" :key="music.id">
                <td class="border p-2">{{ index + 1 + (currentPage - 1) * itemsPerPage }}</td>
                <td class="border p-2">{{ music.title }}</td>
                <td class="border p-2">{{ music.album }}</td>
                <td class="border p-2">{{ music.artist_name }}</td>
                <td class="border p-2">{{ music.genre }}</td>
                <td class="border p-2 flex items-center justify-center space-x-2">
                  <button @click="showMusic(music)" class="bg-blue-500 text-white px-4  py-1 ml-2 rounded"><i class="fa-solid fa-eye"></i></button>
                  <button @click="editMusic(music)" class="bg-yellow-500 text-white px-4 py-1  rounded ml-2"><i class="fa-solid fa-pen-to-square"></i></button>
                  <button @click="prepareDelete(music.id)" class="bg-red-500 text-white px-4  py-1 rounded ml-2"><i class="fa-solid fa-trash"></i></button>
                </td>
              </tr>
            </tbody>
          </table>

          <div class="pagination-container mt-4 flex justify-center items-center">
            <button @click="prevPage" :disabled="currentPage === 1" class="bg-gray-500 text-white px-4 py-2 rounded mr-2">
              Previous
            </button>
            <span>Page {{ currentPage }} of {{ totalPages }}</span>
            <button @click="nextPage" :disabled="currentPage === totalPages" class="bg-gray-500 text-white px-4 py-2 rounded ml-2">
              Next
            </button>
          </div>
        </div>

        <div v-else class="mt-4">
          <p>No music found.</p>
        </div>

        <div v-if="showDetails" class="modal" @click.self="closeModal">
          <div class="modal-content bg-white p-6 rounded shadow-lg">
            <span class="close" @click="closeModal">&times;</span>
            <h2 class="text-xl font-semibold">Music Details</h2>
            <p><strong>Artist ID:</strong> {{ selectedMusic.artist_id }}</p>
            <p><strong>Title:</strong> {{ selectedMusic.title }}</p>
            <p><strong>Album Name:</strong> {{ selectedMusic.album }}</p>
            <p><strong>Artist Name:</strong> {{ selectedMusic.artist_name }}</p>
            <p><strong>Genre:</strong> {{ selectedMusic.genre }}</p>
          </div>
        </div>

        <div v-if="showDeleteModal" class="modal" @click.self="hideDeleteModal">
          <div class="modal-content bg-white p-6 rounded shadow-lg">
            <span @click="hideDeleteModal" class="close">&times;</span>
            <h2 class="text-xl font-semibold mb-1">Confirm Deletion</h2>
            <p class="mb-4">Are you sure you want to delete this music?</p>
            <div class="flex justify-end space-x-2">
              <button @click="confirmDelete" class="bg-red-500 text-white px-4 py-2 rounded">Delete</button>
              <button @click="hideDeleteModal" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue';
import { useToast } from 'vue-toastification';
const toast = useToast();

definePageMeta({
  middleware: "auth",
});

const musics = ref([]);
const showForm = ref(false);
const isUpdating = ref(false);
const showDetails = ref(false);
const showDeleteModal = ref(false);
const selectedMusic = ref(null);
const musicToDelete = ref(null);

const form = ref({
  id: null,
  artist_id: '',
  title: '',
  album: '',
  artist_name: '',
  genre: ''
});

const currentPage = ref(1);
const itemsPerPage = ref(5);
const loading = ref(false);

const paginatedMusics = computed(() => {
  if (!musics.value.length) return []; 
  const start = (currentPage.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return musics.value.slice(start, end);
});

const totalPages = computed(() => {
  if (!musics.value.length) return 0; 
  return Math.ceil(musics.value.length / itemsPerPage.value);
});

const fetchMusics = async () => {
  loading.value = true;
  try {
    const response = await fetch('http://127.0.0.1:3000/api/v1/songs');
    if (!response.ok) throw new Error('Failed to fetch musics');
    musics.value = await response.json();
  } catch (error) {
    console.error('Error fetching musics:', error);
  } finally {
    loading.value = false;
  }
};

const artists = ref([]);
const fetchArtists = async () => {
  try {
    const response = await fetch('http://127.0.0.1:3000/api/v1/artists');
    if (!response.ok) throw new Error('Failed to fetch artists');
    artists.value = await response.json();
  } catch (error) {
    console.error('Error fetching artists:', error);
  }
};

const showCreateForm = () => {
  form.value = { id: null, artist_id: '', title: '', album: '', artist_name: '', genre: '' };
  isUpdating.value = false;
  showForm.value = true;
};

const toggleForm = () => {
  showForm.value = !showForm.value;
};

const createMusic = async () => {
  loading.value = true;
  try {
    const response = await fetch('http://127.0.0.1:3000/api/v1/songs', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('jwt')}`
      },
      body: JSON.stringify(form.value)
    });
    if (!response.ok) throw new Error('Failed to create music');
    await fetchMusics();
    showForm.value = false;
    toast.success('Music created successfully');
  } catch (error) {
    console.error('Error creating music:', error);
    toast.error('Error creating music');
  } finally {
    loading.value = false;
  }
};

const editMusic = (music) => {
  form.value = { ...music, artist_name: artists.value.find(artist => artist.id === music.artist_id)?.name || '' };
  isUpdating.value = true;
  showForm.value = true;
};

const submitUpdate = async () => {
  loading.value = true;
  try {
    const response = await fetch(`http://127.0.0.1:3000/api/v1/songs/${form.value.id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('jwt')}`
      },
      body: JSON.stringify(form.value)
    });
    if (!response.ok) throw new Error('Failed to update music');
    await fetchMusics();
    showForm.value = false;
    toast.success('Music updated successfully');
  } catch (error) {
    console.error('Error updating music:', error);
    toast.error('Error updating music');
  } finally {
    loading.value = false;
  }
};

const showMusic = (music) => {
  selectedMusic.value = music;
  showDetails.value = true;
};

const closeModal = () => {
  selectedMusic.value = null;
  showDetails.value = false;
};

const prepareDelete = (id) => {
  musicToDelete.value = id;
  showDeleteModal.value = true;
};

const hideDeleteModal = () => {
  musicToDelete.value = null;
  showDeleteModal.value = false;
};

const confirmDelete = async () => {
  if (!musicToDelete.value) return;
  loading.value = true;
  try {
    const response = await fetch(`http://127.0.0.1:3000/api/v1/songs/${musicToDelete.value}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('jwt')}`
      }
    });
    if (!response.ok) throw new Error('Failed to delete music');
    await fetchMusics();
    toast.success('Music deleted successfully');
  } catch (error) {
    console.error('Error deleting music:', error);
    toast.error('Error deleting music');
  } finally {
    loading.value = false;
    hideDeleteModal();
  }
};

const prevPage = () => {
  if (currentPage.value > 1) currentPage.value--;
};

const nextPage = () => {
  if (currentPage.value < totalPages.value) currentPage.value++;
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
  fetchMusics();
  fetchArtists();
});
</script>

<style scoped>

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}


.modal-content {
  background: white;
  padding: 20px;
  border-radius: 8px;
  max-width: 600px;
  width: 100%;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  position: relative;
}

.close {
  position: absolute;
  top: 10px;
  right: 10px;
  font-size: 20px;
  font-weight: bold;
  color: #333;
  cursor: pointer;
  transition: color 0.3s ease;
}

.close:hover {
  color: #ff0000;
}


.music_table {
  border-collapse: collapse;
  width: 100%;
  margin-bottom: 1rem;
}

.music_table th, .music_table td {
  border: 1px solid #ddd;
  padding: 8px;
 
  text-align: center;
}

.music_table th {
  background-color: #418062;
  color: white;
}

.music-table tr:nth-child(even) {
  background-color: #f9f9f9;
}


.pagination-container {
  margin-top: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.pagination-container button {
  background-color: #4a5568;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
  margin: 0 5px;
  transition: background-color 0.3s ease;
}
.px-4, .py-2 {
  padding: 0.5rem 1rem;
}

.pagination-container button:disabled {
  background-color: #b2b2b2;
  cursor: not-allowed;
}

.pagination-container button:hover:not(:disabled) {
  background-color: #2d3748;
}

@media (max-width: 768px) {
  .main-content {
    padding: 2px;
  }
}
</style>
