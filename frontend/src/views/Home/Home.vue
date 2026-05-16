<template>
  <div class="home">
    <!-- 顶部通栏 -->
    <div class="top-bar">
      <div class="top-left">欢迎回来，{{ username }}</div>
      <div class="top-right">
        <el-button type="text" @click="goRecharge">💰 充值</el-button>
        <el-button type="text" @click="goOrder">我的订单</el-button>
        <el-button type="text" @click="goCart">购物车({{ cartCount }})</el-button>
        <el-button type="text" @click="logout">退出登录</el-button>
      </div>
    </div>

    <!-- Logo + 搜索 -->
    <header class="header">
      <div class="logo">
        <span class="logo-icon">🎯</span>
        <span class="logo-text">智选数码</span>
      </div>
      <div class="search-box">
        <el-input 
          placeholder="搜索商品，发现更多好物..." 
          v-model="keyword" 
          class="search-input"
          @keyup.enter="search"
        />
        <el-button type="primary" class="search-btn" @click="search">搜索</el-button>
      </div>
    </header>

    <!-- 二级导航 -->
    <div class="nav-tab">
      <span :class="{active: currentNav === '手机'}" @click="changeNav('手机')">📱 手机</span>
      <span :class="{active: currentNav === '笔记本'}" @click="changeNav('笔记本')">💻 笔记本</span>
      <span :class="{active: currentNav === '手表'}" @click="changeNav('手表')">⌚ 手表</span>
      <span :class="{active: currentNav === '耳机'}" @click="changeNav('耳机')">🎧 耳机</span>
    </div>

    <div class="container">
      <!-- 左侧分类 -->
      <aside class="left-menu">
        <div class="menu-title">商品分类</div>
        <div class="menu-item" :class="{active: currentCategory === '全部商品'}" @click="changeCategory('全部商品')">
          <span class="icon">📦</span>全部商品
        </div>
        <div class="menu-item" :class="{active: currentCategory === '手机数码'}" @click="changeCategory('手机数码')">
          <span class="icon">📱</span>手机数码
        </div>
        <div class="menu-item" :class="{active: currentCategory === '电脑办公'}" @click="changeCategory('电脑办公')">
          <span class="icon">💻</span>电脑办公
        </div>
        <div class="menu-item" :class="{active: currentCategory === '智能穿戴'}" @click="changeCategory('智能穿戴')">
          <span class="icon">⌚</span>智能穿戴
        </div>
        <div class="menu-item" :class="{active: currentCategory === '智能设备'}" @click="changeCategory('智能设备')">
          <span class="icon">🎮</span>智能设备
        </div>
      </aside>

      <!-- 商品主区域 -->
      <main class="goods-list">
        <div class="list-header">
          <div class="list-title">{{ currentCategory }}</div>
          <div class="list-count">共 {{ filteredGoods.length }} 件商品</div>
        </div>
        <div class="goods-grid">
          <div class="goods-card" v-for="item in filteredGoods" :key="item.id" @click="goProduct(item.id)">
            <div class="goods-img-wrapper">
              <img :src="item.img" class="goods-img" />
              <div class="goods-badge" v-if="item.stock < 50">仅剩{{ item.stock }}件</div>
            </div>
            <div class="goods-info">
              <div class="goods-name">{{ item.name }}</div>
              <div class="goods-price">¥{{ item.price.toLocaleString() }}</div>
              <div class="goods-meta">
                <span class="goods-type">{{ item.category }}</span>
                <span class="goods-stock">库存: {{ item.stock }}</span>
              </div>
            </div>
          </div>
        </div>
        <div v-if="filteredGoods.length === 0" class="empty">
          <div class="empty-icon">🔍</div>
          <p>暂无找到相关商品</p>
          <el-button type="text" @click="keyword = ''; currentCategory = '全部商品'">查看全部商品</el-button>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, getCurrentInstance } from 'vue'
import { ElMessage } from 'element-plus'

const { proxy } = getCurrentInstance()

// 当前登录用户
const username = ref(localStorage.getItem('username') || '用户')

// 搜索关键词
const keyword = ref('')

// 当前导航和分类
const currentNav = ref('手机')
const currentCategory = ref('手机数码')

// 导航到分类的映射关系
const navToCategory = {
  '手机': '手机数码',
  '笔记本': '电脑办公',
  '手表': '智能穿戴',
  '耳机': '智能穿戴'
}

// 商品数据
const goodsList = ref([
  {id:1, name:'iPhone 15 Pro', price:8999, stock:99, category:'手机数码', img:'https://picsum.photos/seed/iphone15/200/200'},
  {id:2, name:'AirPods Pro 2', price:1899, stock:198, category:'智能穿戴', img:'https://picsum.photos/seed/airpods/200/200'},
  {id:3, name:'华为 Mate 60 Pro', price:6999, stock:80, category:'手机数码', img:'https://picsum.photos/seed/huawei/200/200'},
  {id:4, name:'小米 14 Ultra', price:6499, stock:90, category:'手机数码', img:'https://picsum.photos/seed/xiaomi14/200/200'},
  {id:5, name:'OPPO Find X7 Ultra', price:5999, stock:70, category:'手机数码', img:'https://picsum.photos/seed/oppo/200/200'},
  {id:6, name:'vivo X100 Pro', price:5999, stock:85, category:'手机数码', img:'https://picsum.photos/seed/vivo/200/200'},
  {id:7, name:'荣耀 Magic6 Pro', price:5699, stock:66, category:'手机数码', img:'https://picsum.photos/seed/honor/200/200'},
  {id:8, name:'三星 Galaxy Buds3 Pro', price:1599, stock:120, category:'智能穿戴', img:'https://picsum.photos/seed/samsung/200/200'},
  {id:9, name:'小米 Buds 5 Pro', price:899, stock:200, category:'智能穿戴', img:'https://picsum.photos/seed/xiaomibuds/200/200'},
  {id:10, name:'华为 FreeBuds Pro 4', price:1299, stock:150, category:'智能穿戴', img:'https://picsum.photos/seed/huaweibuds/200/200'},
])

// 购物车数量
const cartList = ref(JSON.parse(localStorage.getItem('cart') || '[]'))
const cartCount = computed(() => cartList.value.length)

// 筛选后的商品
const filteredGoods = computed(() => {
  let result = goodsList.value
  
  // 按分类筛选
  if (currentCategory.value !== '全部商品') {
    result = result.filter(item => item.category === currentCategory.value)
  }
  
  // 按关键词搜索
  if (keyword.value) {
    const kw = keyword.value.toLowerCase()
    result = result.filter(item => item.name.toLowerCase().includes(kw))
  }
  
  return result
})

// 检查登录状态
onMounted(() => {
  if (!localStorage.getItem('userId')) {
    ElMessage.warning('请先登录')
    proxy.$router.push('/login')
  }
})

// 导航方法
const goRecharge = () => {
  proxy.$router.push('/recharge')
}

const goOrder = () => {
  proxy.$router.push('/order')
}

const goCart = () => {
  proxy.$router.push('/cart')
}

const goProduct = (id) => {
  proxy.$router.push('/product/' + id)
}

// 搜索
const search = () => {
  // 搜索逻辑已在computed中实现
}

// 切换导航（同时切换对应的分类）
const changeNav = (nav) => {
  currentNav.value = nav
  // 根据导航切换到对应的分类
  currentCategory.value = navToCategory[nav] || '全部商品'
}

// 切换分类
const changeCategory = (category) => {
  currentCategory.value = category
}

// 退出登录
const logout = () => {
  localStorage.removeItem('userId')
  localStorage.removeItem('username')
  ElMessage.success('已退出登录')
  proxy.$router.push('/login')
}
</script>

<style scoped>
.top-bar {
  display: flex;
  justify-content: space-between;
  padding: 10px 150px;
  font-size: 14px;
  color: #666;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.top-bar .top-left {
  color: #fff;
  font-weight: 500;
}
.top-bar .top-right {
  display: flex;
  gap: 20px;
}
.top-bar .el-button--text {
  color: rgba(255, 255, 255, 0.9);
}
.top-bar .el-button--text:hover {
  color: #fff;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 25px 150px;
  background: #fff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}
.logo {
  display: flex;
  align-items: center;
  gap: 10px;
}
.logo-icon {
  font-size: 36px;
}
.logo-text {
  font-size: 32px;
  font-weight: bold;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.search-box {
  display: flex;
  align-items: center;
}
.search-input {
  width: 550px !important;
  border-radius: 25px 0 0 25px !important;
  height: 40px;
  border-right: none;
}
.search-btn {
  border-radius: 0 25px 25px 0 !important;
  height: 40px;
  padding: 0 30px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
}

.nav-tab {
  padding: 15px 150px;
  background: #fff;
  display: flex;
  gap: 50px;
  font-size: 16px;
  border-bottom: 1px solid #eee;
}
.nav-tab span {
  cursor: pointer;
  padding: 8px 16px;
  border-radius: 20px;
  transition: all 0.3s;
}
.nav-tab span:hover {
  background: #f5f5f5;
}
.nav-tab span.active {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  font-weight: 500;
}

.container {
  display: flex;
  padding: 25px 150px;
  gap: 25px;
  background: #f8f9fa;
  min-height: calc(100vh - 220px);
}
.left-menu {
  width: 200px;
  background: #fff;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
}
.menu-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 2px solid #f0f0f0;
}
.menu-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 15px;
  cursor: pointer;
  border-radius: 8px;
  margin-bottom: 6px;
  transition: all 0.2s;
  color: #555;
}
.menu-item .icon {
  font-size: 18px;
}
.menu-item:hover {
  background: #f5f7fa;
  transform: translateX(5px);
}
.menu-item.active {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  font-weight: 500;
}

.goods-list {
  flex: 1;
}
.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.list-title {
  font-size: 20px;
  font-weight: bold;
  color: #333;
}
.list-count {
  font-size: 14px;
  color: #888;
}
.goods-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
}
.goods-card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}
.goods-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
}
.goods-img-wrapper {
  position: relative;
  width: 100%;
  height: 200px;
  overflow: hidden;
}
.goods-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}
.goods-card:hover .goods-img {
  transform: scale(1.05);
}
.goods-badge {
  position: absolute;
  top: 10px;
  right: 10px;
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a5a 100%);
  color: #fff;
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 15px;
}
.goods-info {
  padding: 15px;
}
.goods-name {
  font-size: 15px;
  color: #333;
  font-weight: 500;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-bottom: 10px;
}
.goods-price {
  font-size: 22px;
  color: #e74c3c;
  font-weight: bold;
  margin-bottom: 10px;
}
.goods-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.goods-type {
  font-size: 12px;
  color: #888;
  background: #f5f5f5;
  padding: 4px 10px;
  border-radius: 10px;
}
.goods-stock {
  font-size: 12px;
  color: #888;
}

.empty {
  text-align: center;
  padding: 80px 0;
  background: #fff;
  border-radius: 12px;
}
.empty-icon {
  font-size: 60px;
  margin-bottom: 20px;
  opacity: 0.5;
}
.empty p {
  color: #999;
  font-size: 16px;
  margin-bottom: 20px;
}
</style>