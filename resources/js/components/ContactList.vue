<template>
  <div class="p-4">
    <h2 class="text-2xl mb-4">Contacts</h2>

    <form @submit.prevent="createContact" class="mb-4">
      <input v-model="form.name" placeholder="Name" required />
      <input v-model="form.email" placeholder="Email" required />
      <input type="file" @change="onFileChange" />
      <button type="submit">Add</button>
    </form>

    <ul>
      <li v-for="c in contacts" :key="c.id" class="mb-2 flex items-center">
        <img v-if="c.image_url" :src="c.image_url" class="w-12 h-12 mr-2" />
        <div>
          <div class="font-bold">{{ c.name }}</div>
          <div class="text-sm">{{ c.email }}</div>
        </div>
        <button @click="remove(c.id)" class="ml-auto">Delete</button>
      </li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      contacts: [],
      form: { name:'', email:'' },
      file: null
    }
  },
  mounted(){ this.fetch() },
  methods:{
    async fetch(){
      const res = await axios.get('/api/contacts');
      this.contacts = res.data.data || res.data;
    },
    onFileChange(e){ this.file = e.target.files[0]; },
    async createContact(){
      const fd = new FormData();
      fd.append('name', this.form.name);
      fd.append('email', this.form.email);
      if(this.file) fd.append('image', this.file);
      await axios.post('/api/contacts', fd, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      this.form.name=''; this.form.email=''; this.file=null;
      await this.fetch();
    },
    async remove(id){
      await axios.delete(`/api/contacts/${id}`);
      await this.fetch();
    }
  }
}
</script>
