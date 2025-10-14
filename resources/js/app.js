import './bootstrap';

import { createApp } from 'vue';
import ContactList from './components/ContactList.vue';

const app = createApp({});
app.component('contact-list', ContactList);
app.mount('#app');