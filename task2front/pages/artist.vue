<template>
    <div>
      <TheHeader/>
      <navbar />
      <h1>Artists Management</h1>
  
      <button @click="toggleForm">{{ showForm ? 'Hide Form' : 'Create Artist' }}</button>
  
      <div v-if="showForm">
        <h2>{{ isUpdating ? 'Update Artist' : 'Create Artist' }}</h2>
        <form @submit.prevent="isUpdating ? submitUpdate() : createArtist()">
          <input type="text" v-model="form.name" placeholder="Name" required />
          <input type="date" v-model="form.dob" placeholder="DOB" required />
          <input type="text" v-model="form.gender" placeholder="Gender" required />
          <input type="text" v-model="form.address" placeholder="Address" required />
          <input type="number" v-model="form.first_release_year" placeholder="First Release Year" required />
          <input type="number" v-model="form.no_of_albums_released" placeholder="No. of Albums Released" required />
          <button type="submit">{{ isUpdating ? 'Update' : 'Create' }}</button>
        </form>
      </div>
  
      <div v-if="paginatedArtists.length">
        <table class="artist-table">
          <thead>
            <tr>
              <th>Index</th>
              <th>Name</th>
              <th>Gender</th>
              <th>First Release Year</th>
              <th>No. of Albums Released</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(artist, index) in paginatedArtists" :key="artist.id">
              <td>{{ index + 1 + (currentPage - 1) * itemsPerPage }}</td>
              <td>{{ artist.name }}</td>
              <td>{{ artist.gender }}</td>
              <td>{{ artist.first_release_year }}</td>
              <td>{{ artist.no_of_albums_released }}</td>
              <td>
                <NuxtLink :to="`/artistdetail/${artist.id}`"><button>Show</button></NuxtLink>
                <button @click="editArtist(artist)">Update</button>
                <button @click="deleteArtist(artist.id)">Delete</button>
              </td>
            </tr>
          </tbody>
        </table>
  
        <div class="pagination">
          <button @click="prevPage" :disabled="currentPage === 1">Previous</button>
          <span>Page {{ currentPage }} of {{ totalPages }}</span>
          <button @click="nextPage" :disabled="currentPage === totalPages">Next</button>
        </div>
      </div>
      <div v-else>
        <p>No artists found.</p>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, computed } from 'vue';
  import { useRouter } from 'vue-router';
  
  const router = useRouter();
  const artists = ref([]);
  
  const showForm = ref(false);
  const isUpdating = ref(false);
  const showDetails = ref(false);
  const selectedArtist = ref(null);
  const form = ref({
    id: null,
    name: '',
    dob: '',
    gender: '',
    address: '',
    first_release_year: '',
    no_of_albums_released: ''
  });
  
  // Pagination states
  const currentPage = ref(1);
  const itemsPerPage = ref(5);
  
  // Computed property for paginated artists
  const paginatedArtists = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage.value;
    const end = start + itemsPerPage.value;
    return artists.value.slice(start, end);
  });
  
  // Computed property for total pages
  const totalPages = computed(() => {
    return Math.ceil(artists.value.length / itemsPerPage.value);
  });
  
  // Fetch artists
  const fetchArtists = async () => {
    try {
      const response = await fetch('http://127.0.0.1:3000/api/v1/artists');
      const data = await response.json();
      artists.value = data;
    } catch (error) {
      console.error('Error fetching artists:', error);
    }
  };
  
  // Fetch artists on component mount
  onMounted(fetchArtists);
  
  // Function to reset form
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
  
  // Function to toggle the form visibility
  const toggleForm = () => {
    if (showForm.value) {
      resetForm();
      isUpdating.value = false;
    }
    showForm.value = !showForm.value;
  };
  
  // Function to show artist details


  // Function to show the form for updating an artist
  const editArtist = (artist) => {
    form.value = { ...artist };
    isUpdating.value = true;
    showForm.value = true;
  };
  
  // Function to submit the updated artist
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
      resetForm();
      isUpdating.value = false;
      showForm.value = false;
      fetchArtists();
    } catch (error) {
      console.error('Update artist error:', error);
    }
  };
  
  // Function to create a new artist
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
  
  // Function to delete an artist
  const deleteArtist = async (artistId) => {
    try {
      const response = await fetch(`http://127.0.0.1:3000/api/v1/artists/${artistId}`, {
        method: 'DELETE'
      });
      if (!response.ok) {
        throw new Error('Failed to delete artist');
      }
      fetchArtists();
    } catch (error) {
      console.error('Delete artist error:', error);
    }
  };
  
  // Pagination methods
  const prevPage = () => {
    if (currentPage.value > 1) currentPage.value--;
  };
  
  const nextPage = () => {
    if (currentPage.value < totalPages.value) currentPage.value++;
  };
  </script>
  
  <style scoped>
  /* General styles */
  body {
    font-family: Arial, sans-serif;
    background-color: #f1efec;
    color: #27609a;
    margin: 0;
    padding: 0;
  }
  
  h1, h2 {
    color: #418062;
  }
  
  button {
    cursor: pointer;
    margin-right: 5px;
    padding: 10px 15px;
    border: none;
    border-radius: 5px;
    color: #00ff88;
    color: rgb(70, 104, 75);
    font-size: 14px;
  }
  
  button:hover {
    color: #00ff88;
  }
  
  button:disabled {
    background-color: burlywood;
  }
  
  form {
    margin-top: 20px;
  }
  
  input, select {
    display: block;
    margin-bottom: 10px;
    padding: 10px;
    width: 100%;
    box-sizing: border-box;
    border: 1px solid #c3b1b1;
    border-radius: 5px;
  }
  
  /* Table styles */
  .artist-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background-color: rgb(253, 253, 253);
    border-radius: 5px;
    overflow: hidden;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  .artist-table th, .artist-table td {
    background-color: rgb(253, 253, 253);
    padding: 12px;
    text-align: left;
  }
  
  .artist-table th {
    color: #00ff88;
    color: rgb(174, 59, 59);
  }
  
  .artist-table tr:nth-child(even) {
    background-color: #993939;
  }
  
  /* Modal styles */
  .modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .modal-content {
    background-color: #c0b4b4;
    padding: 20px;
    border-radius: 5px;
    width: 600px;
    max-width: 90%;
    box-shadow: 0 4px 8px rgba(225, 76, 76, 0.2);
    position: relative;
    justify-content: space-around;
  }
  
  .modal-content .close {
    position: absolute;
    top: 10px;
    right: 10px;
    cursor: pointer;
    font-size: 20px;
    color: #00ff88;
  }
  
  .modal-content .close:hover {
    color: #00ff88;
  }
  
  .modal-content h2 {
    margin-top: 0;
  }
  .music-table{
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
    text-align: center;
    border-radius: 5px;
    overflow: hidden;
  }
  .mmusic-details{
    margin-top: 5px;
  }
  /* Pagination styles */
  .pagination {
    margin-top: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .pagination button {
    margin: 0 5px;
  }
  
  .pagination span {
    margin: 0 10px;
  }
  </style>
  