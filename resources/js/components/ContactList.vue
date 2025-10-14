<template>
  <div class="max-w-2xl mx-auto p-6">
    <h2 class="text-3xl font-semibold mb-6 text-gray-800 border-b pb-2 text-center">
      📇 Contact Manager
    </h2>

    <!-- Contact Form -->
    <form
      @submit.prevent="createContact"
      class="bg-white shadow-md rounded-lg p-6 mb-8 border border-gray-100"
    >
      <div class="grid gap-4 md:grid-cols-2 mb-4">
        <input
          v-model="form.name"
          placeholder="Full Name"
          required
          class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-400 focus:outline-none"
        />
        <input
          v-model="form.email"
          placeholder="Email Address"
          type="email"
          required
          class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-400 focus:outline-none"
        />
      </div>

      <div class="flex flex-col items-center justify-center gap-4">
        <!-- Image Preview -->
        <div v-if="preview" class="relative">
          <img
            :src="preview"
            alt="Preview"
            class="w-24 h-24 object-cover rounded-full border border-gray-300 shadow-sm"
          />
          <button
            type="button"
            @click="removePreview"
            class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs"
          >
            ×
          </button>
        </div>

        <!-- File Input -->
        <input
          type="file"
          accept="image/*"
          @change="onFileChange"
          class="text-sm text-gray-600 file:mr-3 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-medium file:bg-blue-50 file:text-blue-600 hover:file:bg-blue-100 cursor-pointer"
        />

        <!-- Add Button -->
        <button
          type="submit"
          class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-md shadow-md transition-all"
        >
          ➕ Add Contact
        </button>
      </div>
    </form>

    <!-- Contact List -->
    <div v-if="contacts.length" class="space-y-3">
      <div
        v-for="c in contacts"
        :key="c.id"
        class="flex items-center bg-white shadow-sm border border-gray-100 rounded-lg p-4 hover:shadow-md transition"
      >
        <img
          v-if="c.image_url"
          :src="c.image_url"
          class="w-12 h-12 rounded-full object-cover mr-3 border border-gray-200"
        />
        <div class="flex-1">
          <div class="font-semibold text-gray-800">{{ c.name }}</div>
          <div class="text-sm text-gray-500">{{ c.email }}</div>
        </div>
        <button
          @click="remove(c.id)"
          class="ml-auto text-red-500 hover:text-red-700 font-medium transition"
        >
          Delete
        </button>
      </div>
    </div>

    <div v-else class="text-center text-gray-500 mt-6">
      No contacts yet. Add your first contact above 👆
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      contacts: [],
      form: { name: '', email: '' },
      file: null,
      preview: null,
    };
  },
  mounted() {
    this.fetch();
  },
  methods: {
    async fetch() {
      const res = await axios.get('/api/contacts');
      this.contacts = res.data.data || res.data;
    },
    onFileChange(e) {
      const file = e.target.files[0];
      this.file = file;
      if (file) {
        this.preview = URL.createObjectURL(file);
      }
    },
    removePreview() {
      this.file = null;
      this.preview = null;
    },
    async createContact() {
      const fd = new FormData();
      fd.append('name', this.form.name);
      fd.append('email', this.form.email);
      if (this.file) fd.append('image', this.file);

      await axios.post('/api/contacts', fd, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });

      this.form.name = '';
      this.form.email = '';
      this.file = null;
      this.preview = null;
      await this.fetch();
    },
    async remove(id) {
      await axios.delete(`/api/contacts/${id}`);
      await this.fetch();
    },
  },
};
</script>

<style scoped>
body {
  background-color: #f9fafb;
}
</style>
