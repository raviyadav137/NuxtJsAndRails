<template>
    <div>
      <TheHeader/>
      <navbar />
      <h1>Music Management</h1>
  
      <button @click="showCreateForm">Create Music</button>
  
      <div v-if="showForm">
        <h2>{{ isUpdating ? 'Update Music' : 'Create Music' }}</h2>
        <form @submit.prevent="isUpdating ? submitUpdate() : createMusic()">
          <input type="number" v-model="form.artist_id" placeholder="Artist_id" required />
          <input type="text" v-model="form.title" placeholder="Title" required />
          <input type="text" v-model="form.album" placeholder="Album" required />
          <input type="text" v-model="form.artist_name" placeholder="Artist Name" required />
          <input type="text" v-model="form.genre" placeholder="Genre" required />
          <button type="submit">{{ isUpdating ? 'Update' : 'Create' }}</button>
          <button type="button" @click="cancelForm">Cancel</button>
        </form>
      </div>
  
      <div v-if="paginatedMusics.length">
        <table class="music-table">
          <thead>
            <tr>
              <th>Index</th>
              <th>Artist_id</th>
              <th>Title</th>
              <th>Album Name</th>
              <th>Artist Name</th>
              <th>Genre</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(music, index) in paginatedMusics" :key="music.id">
              <td>{{ index + 1 + (currentPage - 1) * itemsPerPage }}</td>
              <td>{{ music.artist_id }}</td>
              <td>{{ music.title }}</td>
              <td>{{ music.album }}</td>
              <td>{{ music.artist_name }}</td>
              <td>{{ music.genre }}</td>
              <td>
                <button @click="showMusic(music)">Show</button>
                <button @click="editMusic(music)">Update</button>
                <button @click="deleteMusic(music.id)">Delete</button>
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
        <p>No music found.</p>
      </div>
  
      <div v-if="showDetails" class="modal">
        <div class="modal-content">
          <span class="close" @click="closeModal">&times;</span>
          <h2>Music Details</h2>
          <p><strong>Artist_id:</strong> {{ selectedMusic.artist_id }}</p>
          <p><strong>Title:</strong> {{ selectedMusic.title }}</p>
          <p><strong>Album Name:</strong> {{ selectedMusic.album }}</p>
          <p><strong>Artist Name:</strong> {{ selectedMusic.artist_name }}</p>
          <p><strong>Genre:</strong> {{ selectedMusic.genre }}</p>
          <button @click="closeModal">Close</button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, computed } from 'vue';
  
  const musics = ref([]);
  const showForm = ref(false);
  const isUpdating = ref(false);
  const showDetails = ref(false);
  const selectedMusic = ref(null);
  const form = ref({
    id: null,
    artist_id: '',
    title: '',
    album: '',
    artist_name: '',
    genre: ''
  });
  
  // Pagination states
  const currentPage = ref(1);
  const itemsPerPage = ref(5);
  
  // Computed property for paginated musics
  const paginatedMusics = computed(() => {
    if (!musics.value) return []; // Handle case where musics is undefined
    const start = (currentPage.value - 1) * itemsPerPage.value;
    const end = start + itemsPerPage.value;
    return musics.value.slice(start, end);
  });
  
  // Computed property for total pages
  const totalPages = computed(() => {
    if (!musics.value) return 0; // Handle case where musics is undefined
    return Math.ceil(musics.value.length / itemsPerPage.value);
  });
  
  // Fetch musics
  const fetchMusics = async () => {
    try {
      const response = await fetch('http://127.0.0.1:3000/api/v1/songs');
      const data = await response.json();
      musics.value = data;
      console.log(musics.value);
    } catch (error) {
      console.error('Error fetching musics:', error);
    }
  };
  
  // Fetch musics on component mount
  onMounted(fetchMusics);
  
  // Function to reset form
  const resetForm = () => {
    form.value = {
      id: null,
      artist_id: '',
      title: '',
      album: '',
      artist_name: '',
      genre: ''
    };
  };
  
  // Function to show the form for creating a new music
  const showCreateForm = () => {
    resetForm();
    isUpdating.value = false;
    showForm.value = true;
  };
  
  // Function to show music details
  const showMusic = (music) => {
    selectedMusic.value = music;
    showDetails.value = true;
  };
  
  // Function to close the modal
  const closeModal = () => {
    showDetails.value = false;
  };
  
  // Function to show the form for updating a music
  const editMusic = (music) => {
    form.value = { ...music };
    isUpdating.value = true;
    showForm.value = true;
  };
  
  // Function to cancel the form
  const cancelForm = () => {
    resetForm();
    isUpdating.value = false;
    showForm.value = false;
  };
  
  // Function to submit the updated music
  const submitUpdate = async () => {
    try {
      const response = await fetch(`http://127.0.0.1:3000/api/v1/songs/${form.value.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ song: form.value })
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`Failed to update music: ${errorData.message}`);
      }
      resetForm();
      isUpdating.value = false;
      showForm.value = false;
      fetchMusics();
    } catch (error) {
      console.error('Update music error:', error);
    }
  };
  
  // Function to create a new music
  const createMusic = async () => {
    try {
      const response = await fetch('http://127.0.0.1:3000/api/v1/songs', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ song: form.value })
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`Failed to create music: ${errorData.message}`);
      }
      resetForm();
      showForm.value = false;
      fetchMusics();
    } catch (error) {
      console.error('Create music error:', error);
    }
  };
  
  // Function to delete a music
  const deleteMusic = async (musicId) => {
    try {
      const response = await fetch(`http://127.0.0.1:3000/api/v1/songs/${musicId}`, {
        method: 'DELETE'
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`Failed to delete music: ${errorData.message}`);
      }
      fetchMusics();
    } catch (error) {
      console.error('Delete music error:', error);
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
  .music-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
  }
  
  .music-table th, .artist-table td {
    border: 1px solid #ccc;
    padding: 8px;
    text-align: left;
  }
  
  .music-table th {
    background-color: #f2f2f2;
  }
  
  button {
    cursor: pointer;
    margin-right: 5px;
  }
  
  form {
    margin-top: 20px;
  }
  
  input {
    display: block;
    margin-bottom: 10px;
    padding: 8px;
    width: 100%;
    box-sizing: border-box;
  }
  
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
    background-color: #fff;
    padding: 20px;
    border-radius: 5px;
    width: 500px;
    max-width: 90%;
  }
  
  .close {
    position: absolute;
    top: 10px;
    right: 10px;
    cursor: pointer;
  }
  
  .pagination {
    margin-top: 10px;
  }
  
  .pagination button {
    margin-right: 5px;
  }
  
  .pagination span {
    margin: 0 10px;
  }
  </style>
  

  