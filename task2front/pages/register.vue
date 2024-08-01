<template>
  <div class="register-container flex items-center justify-center min-h-screen bg-gray-100">
    <form @submit.prevent="register" class="register-form bg-white p-8 rounded-lg shadow-lg w-full max-w-lg">
      <h2 class="text-3xl font-semibold mb-8 text-center text-gray-800">Register</h2>
      <div class="form-group mb-6">
        <label for="first_name" class="block mb-2 text-lg  font-medium text-gray-700">First Name</label>
        <input type="text" id="first_name" v-model="form.first_name" required class="register-input" />
      </div>
      <div class="form-group mb-6">
        <label for="last_name" class="block mb-2 text-lg font-medium text-gray-700">Last Name</label>
        <input type="text" id="last_name" v-model="form.last_name" required class="register-input" />
      </div>
      <div class="form-group mb-6">
        <label for="email" class="block mb-2 text-lg font-medium text-gray-700">Email</label>
        <input type="email" id="email" v-model="form.email" required class="register-input" />
      </div>
      <div class="form-group mb-6">
        <label for="phone" class="block mb-2 text-lg font-medium text-gray-700">Phone</label>
        <input type="text" id="phone" v-model="form.phone" required class="register-input" />
      </div>
      <div class="form-group mb-6">
        <label for="dob" class="block mb-2 text-lg font-medium text-gray-700">Date of Birth</label>
        <input type="date" id="dob" v-model="form.dob" required class="register-input" />
      </div>
      <div class="form-group mb-6">
        <label for="address" class="block mb-2 text-lg font-medium text-gray-700">Address</label>
        <input type="text" id="address" v-model="form.address" required class="register-input" />
      </div>
      <div class="form-group mb-6">
        <label for="password" class="block mb-2 text-lg font-medium text-gray-700">Password</label>
        <input type="password" id="password" v-model="form.password" required class="register-input" />
      </div>
      <div class="form-group mb-8">
        <label for="confirmPassword" class="block mb-2 text-lg font-medium text-gray-700">Confirm Password</label>
        <input type="password" id="confirmPassword" v-model="form.confirmPassword" required class="register-input" />
      </div>
      <button type="submit" class="register-button w-full py-3 mb-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Register</button>
      <button type="button" @click="redirectToLogin" class="login-button w-full py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700">Already registered? Login</button>
    </form>
  </div>
</template>

  <script>
  export default {
    
       data() {
      return {
        form: {
          first_name: '',
          last_name: '',
          email: '',
          phone: '',
          dob: '',
          address: '',
          password: '',
          confirmPassword: ''
        }
      };
    },
    methods: {

         
      async register() {
        if (this.form.password !== this.form.confirmPassword) {
          alert("Passwords do not match!");
          return;
        }
  
        try {
          const response = await fetch('http://localhost:3000/signup', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              user: {
                first_name: this.form.first_name,
                last_name: this.form.last_name,
                phone: this.form.phone,
                dob: this.form.dob,
                address: this.form.address,
                email: this.form.email,
                password: this.form.password
              }
            })
          });
  
          if (!response.ok) {
            const errorData = await response.json();
            console.error('Registration failed:', errorData);
           
          } else {
            const data = await response.json();
            console.log('Registration successful:', data);
            alert("registration sucessfully")
            this.$router.push('/login');
          }
        } catch (error) {
          console.error('Registration failed:', error);
          alert(error)
        }
      },
      redirectToLogin() {
        this.$router.push('/login');
      }
    }
  };
  </script>
  <style scoped>
  .register-container {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 100vh;
    background-color: #f7fafc; 
  }
  
  .register-form {
    background-color: white;
    padding: 2rem; 
    border-radius: 0.5rem; 
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05); /* shadow-lg */
    width: 100%;
    max-width: 32rem; 
  }
  
  h2 {
    font-size: 1.875rem; 
    font-weight: 600; 
    margin-bottom: 2rem; 
    text-align: center;
    color: #1f2937;
  }
  
  .form-group {
    margin-bottom: 1.5rem; 
  }
  
  label {
    display: block;
    margin-bottom: 0.5rem; 
    font-size: 1.125rem; 
    font-weight: 500; 
    color: #4a5568; 
  }
  
  .register-input {
    width: 100%;
    padding: 0.5rem 0.75rem; 
    border: 1px solid #d2d6dc; 
    border-radius: 0.5rem; 
    outline: none;
  }
  
  .register-input:focus {
    box-shadow: 0 0 0 2px #ebf4ff; 
    border-color: #4299e1; 
  }
  
  .register-button {
    width: 100%;
    padding: 0.75rem; 
    margin-bottom: 1rem; 
    background-color: #4299e1; 
    color: white;
    border: none;
    border-radius: 0.5rem; 
    cursor: pointer;
  }
  
  .register-button:hover {
    background-color: #3182ce; 
  }
  
  .login-button {
    width: 100%;
    padding: 0.75rem; 
    background-color: green; 
    color: white;
    border: none;
    border-radius: 0.5rem;
    cursor: pointer;
  }
  
  .login-button:hover {
    background-color: #2d3748; 
  }
  </style>
  
 