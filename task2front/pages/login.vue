<template>
    <div class="login-container">
      <form @submit.prevent="login" class="login-form">
        <h2>Login</h2>
        <div class="form-group">
          <label for="email">Email</label>
          <input type="email" id="email" v-model="form.email" required class="login-input" />
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input type="password" id="password" v-model="form.password" required class="login-input" />
        </div>
        <button type="submit" class="login-button">Login</button>
        <button type="button" @click="redirectToRegister" class="register-button">Not registered? Register</button>
      </form>
    </div>
  </template>
  
  <script>
import { useToast } from 'vue-toastification';

const toast = useToast();
  export default {
    
    data() {
      return {
        form: {
          email: '',
          password: ''
        }
      };
    },
    methods: {
      async login() {
        try {
          const response = await fetch('http://localhost:3000/login', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
               
                email: this.form.email,
                password: this.form.password
              
            })
          });
  
          if (!response.ok) {
            const errorData = await response.json();
            console.error('Login failed:', errorData);
            alert('Login failed.');
          } else {
            const data = await response.json();
            console.log('Login successful:', data);
            toast.success("logged in")
                    localStorage.setItem('token', data.token);
        localStorage.setItem('user', JSON.stringify(data.user));

            localStorage.setItem('isLoggedIn', 'true');
  
         
            this.$router.push('/');
          }
        } catch (error) {
          console.error('Login failed:', error);
       
        }
      },
      redirectToRegister() {
        this.$router.push('/register');
      }
    }
  };
  </script>
  
  <style scoped>
  .login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: #f7f8fc;
  }
  
  .login-form {
    background: #fff;
    padding: 2rem;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    max-width: 400px;
    width: 100%;
  }
  
  h2 {
    margin-bottom: 1.5rem;
    color: #333;
    text-align: center;
    font-size: 1.8rem;
  }
  
  .form-group {
    margin-bottom: 1.5rem;
  }
  
  label {
    margin-bottom: 0.5rem;
    font-weight: bold;
    display: block;
    color: #555;
  }
  
  .login-input {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 1rem;
    box-sizing: border-box;
  }
  
  .login-input:focus {
    border-color: #337ab7;
    outline: none;
  }
  
  .login-button,
  .register-button {
    width: 100%;
    padding: 0.75rem;
    border: none;
    border-radius: 5px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin-top: 1rem;
  }
  
  .login-button {
    background-color: #337ab7;
    color: #fff;
  }
  
  .login-button:hover {
    background-color: #286090;
  }
  
  .register-button {
    background-color: #5cb85c;
    color: #fff;
  }
  
  .register-button:hover {
    background-color: #4cae4c;
  }
  
  @media (max-width: 480px) {
    .login-form {
      padding: 1.5rem;
    }
  
    h2 {
      font-size: 1.5rem;
    }
  
    .login-input,
    .login-button,
    .register-button {
      font-size: 0.9rem;
      padding: 0.6rem;
    }
  }
  </style>