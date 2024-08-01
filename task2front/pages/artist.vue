<template>
  <div>
    <navbar />
    <div class="flex ">
      <sidebar/>
      <div class="main-content p-4 lg:p-6 w-full ">
        <h1 class="text-2xl font-bold mb-4">Artists Management</h1>

        <button @click="toggleForm" class="bg-blue-500 text-white px-4 py-2 rounded mb-4 ">
          Create<i class="fa-regular fa-plus ml-1 "></i>
        </button>

        <div v-if="showForm" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div class="bg-white p-6 rounded shadow-lg w-full max-w-lg relative">
            <span @click="toggleForm" class="close">&times;</span>
            <h2 class="text-xl font-semibold mb-2">{{ isUpdating ? 'Update Artist' : 'Create Artist' }}</h2>
            <form @submit.prevent="isUpdating ? submitUpdate() : createArtist()" class="space-y-4">
              <input type="text" v-model="form.name" placeholder="Name" required class="p-2 border rounded w-full" />
              <input type="date" v-model="form.dob" placeholder="DOB" required class="p-2 border rounded w-full" />
              <select id="gender" v-model="form.gender" required  class="p-2 border rounded w-full sm:w-3/4 md:w-1/2 lg:w-1/3 xl:w-1/4">
                <option value="" disabled>Select Gender</option>
                    <option value="male">Male</option>
                   <option value="female">Female</option>
                </select>
              <input type="text" v-model="form.address" placeholder="Address" required class="p-2 border rounded w-full" />
              <input type="number" v-model="form.first_release_year" placeholder="First Release Year" required class="p-2 border rounded w-full" />
              <input type="number" v-model="form.no_of_albums_released" placeholder="No. of Albums Released" required class="p-2 border rounded w-full" />
              <div class="flex justify-between">
                
                <button type="submit" class="bg-green-500 text-white px-4 py-2 rounded"><i class="fa-solid fa-pen-to-square"></i>{{ isUpdating ? 'Update' : 'Create' }}</button>
              </div>
            </form>
          </div>
        </div>

        <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div class="bg-white p-6 rounded shadow-lg w-full max-w-md relative">
            <span @click="showDeleteModal = false" class="close">&times;</span>
            <h2 class="text-xl font-semibold mb-4">Confirm Deletion</h2>
            <p class="mb-4">Are you sure you want to delete this artist?</p>
            <div class="flex justify-end space-x-2">
              <button @click="confirmDelete" class="bg-red-500 text-white px-4 py-2 rounded">Delete</button>
              <button @click="showDeleteModal = false" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
            </div>
          </div>
        </div>



        <div v-if="paginatedArtists.length" class="overflow-x-auto">
          <table class="artist-table w-full border-separate border-spacing-0">
            <thead>
              <tr>
                <th class="border bg-gray-100 p-4 text-left">Index</th>
                <th class="border bg-gray-100 p-4 text-left">Name</th>
                <th class="border bg-gray-100 p-4 text-left">Gender</th>
                <th class="border bg-gray-100 p-4 text-left">First Release Year</th>
                <th class="border bg-gray-100 p-4 text-left">No. of Albums Released</th>
                <th class="border bg-gray-100 p-4 text-left">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(artist, index) in paginatedArtists" :key="artist.id">
                <td class="border p-2">{{ index + 1 + (currentPage - 1) * itemsPerPage }}</td>
                <td class="border p-2">{{ artist.name }}</td>
                <td class="border p-2">{{ artist.gender }}</td>
                <td class="border p-2">{{ artist.first_release_year }}</td>
                <td class="border p-2">{{ artist.no_of_albums_released }}</td>
                <td class="border p-2 flex items-center justify-center space-x-2 ">
                  <NuxtLink :to="`/artistdetail/${artist.id}`">
                    <button class="bg-blue-500 text-white px-4 py-1 ml-2 rounded"><i class="fa-solid fa-eye"></i></button>
                  </NuxtLink>
                  <button @click="editArtist(artist)" class="bg-yellow-500 text-white px-4 py-1   rounded ml-2"><i class="fa-solid fa-pen-to-square "></i></button>
                  <button @click="deleteArtist(artist.id)" class="bg-red-500 text-white px-4 py-1  rounded ml-2"><i class="fa-solid fa-trash "></i></button>
                </td>
              </tr>
            </tbody>
          </table>

          <div class="pagination mt-4 flex justify-center items-center">
            <button @click="prevPage" :disabled="currentPage === 1" class="bg-gray-500 text-white px-4 py-2 rounded mr-2">
              Previous
            </button>
            <span class="text-lg">Page {{ currentPage }} of {{ totalPages }}</span>
            <button @click="nextPage" :disabled="currentPage === totalPages" class="bg-gray-500 text-white px-4 py-2 rounded ml-2">
              Next
            </button>
          </div>
        </div>
        <div v-else>
          <p>No artists found.</p>
          <button>Click me</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useToast } from 'vue-toastification';
const toast = useToast();

const artists = ref([]);
const showForm = ref(false);
const isUpdating = ref(false);
const showDeleteModal = ref(false);
const artistToDelete = ref(null);

const form = ref({
  id: null,
  name: '',
  dob: '',
  gender: '',
  address: '',
  first_release_year: '',
  no_of_albums_released: ''
});

const currentPage = ref(1);
const itemsPerPage = ref(5);

const paginatedArtists = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return artists.value.slice(start, end);
});

const totalPages = computed(() => {
  return Math.ceil(artists.value.length / itemsPerPage.value);
});

const fetchArtists = async () => {
  try {
    const response = await fetch('http://127.0.0.1:3000/api/v1/artists');
    const data = await response.json();
    artists.value = data;
  } catch (error) {
    console.error('Error fetching artists:', error);
  }
};

onMounted(fetchArtists);

const resetForm = () => {
  form.value = {
    id: null,
    name: '',
    dob: '',
    gender: '',
    address: '',
    first_release_year: '',
    no_of_albums_released: ''
  };
};

const toggleForm = () => {
  if (showForm.value) {
    resetForm();
    isUpdating.value = false;
  }
  showForm.value = !showForm.value;
};

const editArtist = (artist) => {
  form.value = { ...artist };
  isUpdating.value = true;
  showForm.value = true;
};

const submitUpdate = async () => {
  try {
    const response = await fetch(`http://127.0.0.1:3000/api/v1/artists/${form.value.id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ artist: form.value })
    });
    if (!response.ok) {
      throw new Error('Failed to update artist');
    }
    toast.success("updated sucessfully");
    resetForm();
    isUpdating.value = false;
    showForm.value = false;
    fetchArtists();
  } catch (error) {
    console.error('Update artist error:', error);
  }
};

const createArtist = async () => {
  try {
    const response = await fetch('http://127.0.0.1:3000/api/v1/artists', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ artist: form.value })
    });
    if (!response.ok) {
      throw new Error('Failed to create artist');
    }
    resetForm();
    showForm.value = false;
    fetchArtists();
  } catch (error) {
    console.error('Create artist error:', error);
  }
};

const deleteArtist = (artistId) => {
  artistToDelete.value = artistId;
  showDeleteModal.value = true;
};

const confirmDelete = async () => {
  if (artistToDelete.value !== null) {
    try {
      const response = await fetch(`http://127.0.0.1:3000/api/v1/artists/${artistToDelete.value}`, {
        method: 'DELETE'
      });
      if (!response.ok) {
        throw new Error('Failed to delete artist');
      }
      toast.success("deleted sucessfully")
      fetchArtists();
      showDeleteModal.value = false;
      artistToDelete.value = null;
    } catch (error) {
      console.error('Delete artist error:', error);
    }
  }
};

const prevPage = () => {
  if (currentPage.value > 1) currentPage.value--;
};

const nextPage = () => {
  if (currentPage.value < totalPages.value) currentPage.value++;
};
</script>


<style scoped>

.close {
  position: absolute;
  top: 10px;
  right: 10px;
  font-size: 24px;
  font-weight: bold;
  cursor: pointer;
}
.close:hover {
  color: #ff0000;
}

.artist-table th, .artist-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
  text-align: center;
}
.artist-table th{
  background-color: #418062;
  color: white;
}


.bg-red-500 {
  background-color: #ef4444;
}

.bg-gray-500 {
  background-color: #6b7280;
}

.text-white {
  color: #ffffff;
}


.rounded {
  border-radius: 0.375rem;
}

.bg-opacity-50 {
  background-color: rgba(0, 0, 0, 0.5);
}

.w-full {
  width: 100%;
}

.max-w-md {
  max-width: 28rem;
}
</style>
