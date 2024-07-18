<template>
    <div class="register-container">
      <form @submit.prevent="register" class="register-form">
        <h2>Register</h2>
        <div class="form-group">
          <label for="first_name">first_name</label>
          <input type="text" id="first_name" v-model="form.first_name" required class="register-input" />
        </div>
        <div class="form-group">
          <label for="last_name">last_name</label>
          <input type="text" id="last_name" v-model="form.last_name" required class="register-input" />
        </div>
        <div class="form-group">
          <label for="email">Email</label>
          <input type="email" id="email" v-model="form.email" required class="register-input" />
        </div>
        <div class="form-group">
          <label for="phone">phone</label>
          <input type="integer" id="phone" v-model="form.phone" required class="register-input" />
        </div>
        <div class="form-group">
          <label for="dob">dob</label>
          <input type="date" id="dob" v-model="form.dob" required class="register-input" />
        </div>
        <div class="form-group">
          <label for="address">address</label>
          <input type="text" id="address" v-model="form.address" required class="register-input" />
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input type="password" id="password" v-model="form.password" required class="register-input" />
        </div>
        <div class="form-group">
          <label for="confirmPassword">Confirm Password</label>
          <input type="password" id="confirmPassword" v-model="form.confirmPassword" required class="register-input" />
        </div>
        <button type="submit" class="register-button">Register</button>
        <button type="button" @click="redirectToLogin" class="login-button">Already registered? Login</button>
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
            // Handle registration errors
          } else {
            const data = await response.json();
            console.log('Registration successful:', data);
            // Redirect to login page or another action on successful registration
            this.$router.push('/login');
          }
        } catch (error) {
          console.error('Registration failed:', error);
          // Handle registration errors
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
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: #f5f5f5;
  }
  
  .register-form {
    background: white;
    padding: 2rem;
    border-radius: 8px;
    margin-top: 120px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    max-width: 500px;
    width: 100%;
  }
  
  h2 {
    margin-bottom: 1rem;
    color: #333;
    text-align: center;
  }
  
  .form-group {
    margin-bottom: 15px;
  }
  
  label {
    margin-bottom: 5px;
    font-weight: bold;
    display: block;
  }
  
  .register-input {
    width: 100%;
    padding: 0.8rem;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 1rem;
  }
  
  .register-button,
  .login-button {
    width: 100%;
    padding: 0.8rem;
    background-color: #5cb85c;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin-top: 10px;
  }
  
  .register-button:hover,
  .login-button:hover {
    background-color: #4cae4c;
  }
  
  .login-button {
    background-color: #337ab7;
  }
  
  .login-button:hover {
    background-color: #286090;
  }
  </style>