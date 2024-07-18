<template>
  <div>
    <TheHeader />
    <navbar /><br/><br/>
   
  
    <div v-if="showForm">
      <h2>{{ isUpdating ? 'Update User' : 'Create User' }}</h2>
      <form @submit.prevent="isUpdating ? submitUpdate() : createArtist()">
        <input type="text" v-model="form.first_name" placeholder="First Name" required /><br/><br/>
        <input type="text" v-model="form.last_name" placeholder="Last Name" required /><br/><br/>
        <input type="email" v-model="form.email" placeholder="Email" required /><br/><br/>
        <input type="text" v-model="form.phone" placeholder="Phone" required /><br/><br/>
        <input type="date" v-model="form.dob" placeholder="Date of Birth" required /><br/><br/>
        <input type="text" v-model="form.address" placeholder="Address" required /><br/><br/>
              <button type="submit">update</button>
        <button @click="submitCancel">cancel</button>
      </form>
    </div>

    <div v-if="users.length">
      <h2>User List</h2>
      <table class="user_table">
        <thead>
          <tr>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>Phone No</th>
            <th>Date Of Birth</th>
            <th>Address</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id">
            <td>{{ user.first_name }}</td>
            <td>{{ user.last_name }}</td>
            <td>{{ user.email }}</td>
            <td>{{ user.phone }}</td>
            <td>{{ user.dob }}</td>
            <td>{{ user.address }}</td>
            <td>
              <button @click="editUser(user)">Update</button>
              <button @click="deleteUser(user.id, user.email)">Delete</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div v-else>
      <p>Loading users...</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const users = ref([]);
const showForm = ref(false);
const isUpdating = ref(false);
const form = ref({
  id: null,
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  dob: '',
  address: '',
  
});

const resetForm = () => {
    form.value = {
      id: null,
      first_name: '',
  last_name: '',
  email: '',
  phone: '',
  dob: '',
  address: '',
  password_digest: '',
    };
  };

const submitCancel=()=>{
  showForm.value=false;
}
const editUser = (user) => {
  form.value = { ...user };
  isUpdating.value = true;
  showForm.value = true;
};

const fetchUsers = async () => {
  try {
    const response = await fetch('http://127.0.0.1:3000/users');
    const data = await response.json();
    users.value = data;
  } catch (error) {
    console.error('Error fetching users:', error);
  }
};

const deleteUser = async (userId, userEmail) => {
  try {
    const token = localStorage.getItem('token'); 
    const response = await fetch(`http://127.0.0.1:3000/logout`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${token}`, 
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email: userEmail }) 
    });
    if (!response.ok) {
      throw new Error('Failed to delete user');
    }
    fetchUsers(); 
  } catch (error) {
    console.error('Error deleting user:', error);
  }
};

const submitUpdate = async () => {
    try {
      const response = await fetch(`http://127.0.0.1:3000/update/${form.value.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ user: form.value })
      });
      if (!response.ok) {
        throw new Error('Failed to update artist');
      }
      resetForm();
      isUpdating.value = false;
      showForm.value = false;
      fetchUsers();
    } catch (error) {
      console.error('Update users error:', error);
    }
  };


onMounted(fetchUsers);
</script>

<style>

.user_table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
  background-color: rgb(253, 253, 253);
  border-radius: 5px;
  overflow: hidden;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.user_table th,
.user_table td {
  background-color: rgb(253, 253, 253);
  padding: 12px;
  text-align: left;
}

.user_table th {
  color: #00ff88;
  color: rgb(174, 59, 59);
}

.user_table tr:nth-child(even) {
  background-color: #993939;
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
  button{
    margin-left: 5px;
       cursor:pointer;
  }
</style>
