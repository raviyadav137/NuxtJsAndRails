<!-- pages/artistdetail/_id.vue -->
<template>
    <div>
      <h1>Artist Details</h1>
      <div v-if="artist">
        <p><strong>Name:</strong> {{ artist.name }}</p>
        <p><strong>DOB:</strong> {{ artist.dob }}</p>
        <p><strong>Gender:</strong> {{ artist.gender }}</p>
        <p><strong>Address:</strong> {{ artist.address }}</p>
        <p><strong>First Release Year:</strong> {{ artist.first_release_year }}</p>
        <p><strong>No. of Albums Released:</strong> {{ artist.no_of_albums_released }}</p>
      </div>
      <div v-else>
        <p>Loading artist details...</p>
      </div>
      <div v-if="filteredMusic.length">
        <h2>Music List</h2>
       <table class="song_table">
        <thead>
           <tr>
            <th>Title</th>
            <th>Artist_Name</th>
            <th>Album Name</th>
            <th>Genre</th>
            <th>Action</th>
           </tr>
        </thead>
        <tbody>
            <tr v-for="music in filteredMusic" :key="music.id">
            <td>{{music.title}}</td>
            <td>{{music.artist_name}}</td>
            <td>{{music.album}}</td>
            <td>{{music.genre}}</td>
            <td><button @click="deleteMusic(music.id)">delete</button></td>
            </tr>
        </tbody>
       </table>
      </div>
      <div v-else>
        <p>No music found for this artist.</p>
      </div>
      <br/>
      <button @click="showCreateForm">Create Music</button>
  
  <div v-if="showForm">
    <h2>Create Music</h2>
    <br/>
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
       <br/>
      <Nuxt-link to="/artist"><button class="btn">Go Back</button></Nuxt-link>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, computed } from 'vue';
  import { useRoute } from 'vue-router';
  
  const route = useRoute();
  const artistId = route.params.id;
  const artist = ref(null);
  const musics = ref([]);
  const showForm = ref(false);
  const isUpdating = ref(false);
  
  const form = ref({
    id: null,
    artist_id: '',
    title: '',
    album: '',
    artist_name: '',
    genre: ''
  });


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
  
  const showCreateForm = () => {
    resetForm();
    isUpdating.value = false;
    showForm.value = true;
  };
  const fetchArtist = async () => {
    try {
      const response = await fetch(`http://127.0.0.1:3000/api/v1/artists/${artistId}`);
      const result = await response.json();
      artist.value = result.data; // Access the `data` field to get the artist details
    } catch (error) {
      console.error('Error fetching artist details:', error);
    }
  };
  
  const fetchMusics = async () => {
    try {
      const response = await fetch('http://127.0.0.1:3000/api/v1/songs');
      const data = await response.json();
      musics.value = data;
      console.log('Fetched musics:', musics.value);
    } catch (error) {
      console.error('Error fetching musics:', error);
    }
  };
  
  const filteredMusic = computed(() => {
    return musics.value.filter(music => music.artist_id === parseInt(artistId, 10));
  });

  const cancelForm = () => {
    resetForm();
    isUpdating.value = false;
    showForm.value = false;
  };
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


  onMounted(fetchArtist);
  onMounted(fetchMusics);
  </script>
  
  <style scoped>
  .list_item{
    display:flex;
    justify-content:space-between;
  }
  .song_table{
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background-color: rgb(253, 253, 253);
    border-radius: 5px;
    overflow: hidden;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);

  }
  .song_table th, .song_table td {
    background-color: rgb(253, 253, 253);
    padding: 12px;
    text-align: left;
  }
  
  .song_table th {
    color: #00ff88;
    color: rgb(174, 59, 59);
  }
  
  .song_table tr:nth-child(even) {
    background-color: #993939;
  }
  .btn{
    margin: auto;
    position: relative;
    float: inline-end;
  }
  </style>
  