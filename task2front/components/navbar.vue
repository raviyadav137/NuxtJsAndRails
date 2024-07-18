<!-- components/Navbar.vue -->
<template>
    <nav class="navbar">
       <div class="navbar-brand">
           <nuxt-link to="/"> Dashboard</nuxt-link>
      </div>
      <div v-if="isLoggedIn" class="navbar-links">
        <div class="dropdown">
          <button class="dropbtn">Menu</button>
          <div class="dropdown-content">
            <nuxt-link to="/song">Song</nuxt-link>
            <nuxt-link to="/artist">Artist</nuxt-link>
            <nuxt-link to="/user">User</nuxt-link>
          </div>
        </div>
        <button @click="logout" class="logout-button">Logout</button>
      </div>
      <div v-else class="navbar-links">
        <nuxt-link to="/login">Login</nuxt-link>
        <nuxt-link to="/register">Register</nuxt-link>
      </div>
    </nav>
  </template>
  
  <script>
  export default {
    data() {
      return {
        isLoggedIn: false
      };
    },
    mounted() {
      if (process.client) {
        this.isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
      }
    },
    methods: {
      logout() {
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('token')
        this.isLoggedIn = false;
        this.$router.push('/register');
      }
    }
  };
  </script>
  
  <style scoped>
  .navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #333;
    color: white;
    padding: 1rem;
  }
  
  .navbar-brand {
    font-size: 1.5rem;
    
  }
  .navbar-brand a{
    text-decoration:none;
    color:white;
  }
  .navbar-links {
    display: flex;
    align-items: center;
  }
  
  .navbar-links a,
  .logout-button {
    color: white;
    text-decoration: none;
    margin-left: 1rem;
    cursor: pointer;
  }
  
  .logout-button {
    background: none;
    border: none;
    font-size: 1rem;
  }
  
  .dropdown {
    position: relative;
    display: inline-block;
  }
  
  .dropbtn {
    background-color: #333;
    color: white;
    padding: 1rem;
    font-size: 1rem;
    border: none;
    cursor: pointer;
  }
  
  .dropdown-content {
    display: none;
    position: absolute;
    background-color: #f9f9f9;
    min-width: 160px;
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
    z-index: 1;
  }
  
  .dropdown-content a {
    color: black;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
  }
  
  .dropdown-content a:hover {background-color: #f1f1f1;}
  
  .dropdown:hover .dropdown-content {
    display: block;
  }
  
  .dropdown:hover .dropbtn {
    background-color: #555;
  }
  </style>