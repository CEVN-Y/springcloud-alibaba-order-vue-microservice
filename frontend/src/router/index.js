import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Auth/Login.vue'
import Register from '../views/Auth/Register.vue'
import Home from '../views/Home/Home.vue'
import Product from '../views/Product/Product.vue'
import Cart from '../views/Cart/Cart.vue'
import Order from '../views/Order/Order.vue'
import Recharge from '../views/User/Recharge.vue'

const routes = [
  { path: '/login', component: Login, name: 'login' },
  { path: '/register', component: Register, name: 'register' },
  { path: '/', component: Home, name: 'home' },
  { path: '/product/:id', component: Product, name: 'product' },
  { path: '/cart', component: Cart, name: 'cart' },
  { path: '/order', component: Order, name: 'order' },
  { path: '/recharge', component: Recharge, name: 'recharge' }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router