<template>
  <div>
    <navbar />
    <div class="flex flex-col lg:flex-row">
      <sidebar />
      <div class="main-content p-4 lg:p-6 w-full">
        <div v-if="showForm" class="modal">
          <div class="modal-content relative">
            <span @click="handleCloseForm" class="close">&times;</span>
            <h2 class="text-xl text-green-500 font-semibold">{{ isUpdating ? 'Update User' : 'Create User' }}</h2>
            <form @submit.prevent="isUpdating ? submitUpdate() : createUser()" class="mt-4">
              <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <input type="text" v-model="form.first_name" placeholder="First Name" required class="p-2 border rounded" />
                <input type="text" v-model="form.last_name" placeholder="Last Name" required class="p-2 border rounded" />
                <input type="email" v-model="form.email" placeholder="Email" required class="p-2 border rounded" />
                <input type="text" v-model="form.phone" placeholder="Phone" required class="p-2 border rounded" />
                <input type="date" v-model="form.dob" placeholder="Date of Birth" required class="p-2 border rounded" />
                <input type="text" v-model="form.address" placeholder="Address" required class="p-2 border rounded" />
              </div>
              <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded mt-4">
                <i class="fa-solid fa-pen-to-square"></i>{{ isUpdating ? 'Update' : 'Create' }}
              </button>
            </form>
          </div>
        </div>
        <div v-if="users.length">
          <h2 class="text-xl font-semibold mt-6">User List</h2>
          <div class="overflow-x-auto">
            <table class="user_table w-full border-collapse mt-4">
              <thead>
                <tr>
                  <th class="border p-2">First Name</th>
                  <th class="border p-2">Last Name</th>
                  <th class="border p-2">Email</th>
                  <th class="border p-2">Phone No</th>
                  <th class="border p-2">Date Of Birth</th>
                  <th class="border p-2">Address</th>
                  <th class="border p-2">Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in paginatedUsers" :key="user.id">
                  <td class="border p-2">{{ user.first_name }}</td>
                  <td class="border p-2">{{ user.last_name }}</td>
                  <td class="border p-2">{{ user.email }}</td>
                  <td class="border p-2">{{ user.phone }}</td>
                  <td class="border p-2">{{ user.dob }}</td>
                  <td class="border p-2">{{ user.address }}</td>
                  <td class="border p-2 flex justify-center space-x-2">
                    <button @click="editUser(user)" class="bg-yellow-500 text-white px-4 py-1 rounded"><i class="fa-solid fa-pen-to-square"></i></button>
                    <button @click="prepareDelete(user.id, user.email)" class="bg-red-500 text-white px-4 py-1 rounded"><i class="fa-solid fa-trash"></i></button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
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
          <p>Loading users...</p>
        </div>

        <div v-if="showDeleteModal" class="modal">
          <div class="modal-content">
            <span @click="hideDeleteModal" class="close">&times;</span>
            <h2 class="text-xl font-semibold">Delete User</h2>
            <p class="mt-4">Are you sure you want to delete this user?</p>
            <div class="flex justify-end space-x-2">
              <button @click="confirmDelete" class="bg-red-500 text-white px-4 py-2 rounded mr-2 ">Delete</button>
              <button @click="hideDeleteModal" class="bg-gray-500 text-white px-4 py-2 rounded ">Cancel</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useToast } from 'vue-toastification';

const toast = useToast();

definePageMeta({
  middleware: "auth",
});

const users = ref([]);
const showForm = ref(false);
const showDeleteModal = ref(false);
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

const currentPage = ref(1);
const usersPerPage = ref(5);

let userToDelete = ref(null);

const resetForm = () => {
  form.value = {
    id: null,
    first_name: '',
    last_name: '',
    email: '',
    phone: '',
    dob: '',
    address: '',
  };
};

const handleCloseForm = () => {
  if (isUpdating.value) 
    showForm.value = false;
  
};

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

onMounted(fetchUsers);

const prepareDelete = (userId, userEmail) => {
  userToDelete.value = { id: userId, email: userEmail };
  showDeleteModal.value = true;
};

const hideDeleteModal = () => {
  showDeleteModal.value = false;
};

const confirmDelete = async () => {
  if (!userToDelete.value) return;

  try {
    const response = await fetch(`http://127.0.0.1:3000/logout`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email: userToDelete.value.email })
    });

    if (!response.ok) {
      throw new Error('Failed to delete user');
    }
        
    fetchUsers();
    toast.success("Deleted successfully");
  } catch (error) {
    console.error('Error deleting user:', error);
    toast.error("Failed to delete user");
  } finally {
    hideDeleteModal();
    userToDelete.value = null;
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
      throw new Error('Failed to update user');
    }
    
    // Reload users after update
    fetchUsers();
    
    // Success feedback
    toast.success("Updated successfully");
    resetForm();
    isUpdating.value = false;
    showForm.value = false;
  } catch (error) {
    console.error('Update user error:', error);
    toast.error("Failed to update user");
  }
};

const paginatedUsers = computed(() => {
  const start = (currentPage.value - 1) * usersPerPage.value;
  const end = start + usersPerPage.value;
  return users.value.slice(start, end);
});

const totalPages = computed(() => {
  return Math.ceil(users.value.length / usersPerPage.value);
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


</script>
<style>
.user_table {
  border-collapse: collapse;
  width: 100%;
  margin-bottom: 1rem;
}

.user_table th, .user_table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
  text-align: center;
}

.user_table th {
   background-color: #418062;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-content {
  background: #fff;
  padding: 2rem;
  border-radius: 8px;
  width: 90%;
  max-width: 500px;
}

.close {
  position: absolute;
  top: 10px;
  right: 15px;
  font-size: 20px;
  cursor: pointer;
}
.close:hover {
  color: #ff0000;
}

</style>
