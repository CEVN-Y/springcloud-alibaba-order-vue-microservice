<template>
  <div class="product">
    <!-- 返回首页 -->
    <div class="back-bar">
      <span @click="$router.push('/')">🏠 返回首页</span>
    </div>
    
    <div class="container">
      <div class="detail-card">
        <div class="img-box"><img :src="goods.img" /></div>
        <div class="info-box">
          <h2>{{ goods.name }}</h2>
          <div class="price-section">
            <span class="price-label">售价</span>
            <div class="price">¥{{ goods.price.toLocaleString() }}</div>
          </div>
          <div class="stock">库存：<strong>{{ goods.stock }}</strong> 件</div>
          <div class="category">分类：<span class="category-badge">{{ goods.category }}</span></div>
          <div class="user-info">
            <p>当前用户：<span class="username">{{ username }}</span></p>
            <p>账户余额：<span class="money">{{ user.money }} 元</span></p>
          </div>
          <div class="btns">
            <el-button class="add-cart-btn" @click="addCart">🛒 加入购物车</el-button>
            <el-button class="buy-now-btn" @click="createOrder">⚡ 立即下单</el-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, getCurrentInstance } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'

// 导入商品图片
import img1 from '../../assets/images/products/iPhone15Pro.jpg'
import img2 from '../../assets/images/products/AirPodsPro2.jpg'
import img3 from '../../assets/images/products/华为Mate60Pro.jpg'
import img4 from '../../assets/images/products/小米14Ultra.jpg'
import img5 from '../../assets/images/products/OPPOFindX7Ultra.jpg'
import img6 from '../../assets/images/products/vivoX100Pro.jpg'
import img7 from '../../assets/images/products/荣耀Magic6Pro.jpg'
import img8 from '../../assets/images/products/三星GalaxyBuds3Pro.jpg'
import img9 from '../../assets/images/products/小米Buds5Pro.jpg'
import img10 from '../../assets/images/products/华为FreeBudsPro4.jpg'

const { proxy } = getCurrentInstance()
const route = useRoute()
const id = route.params.id

const goods = ref({
  id: '',
  name: '',
  price: 0,
  stock: 0,
  category: '',
  img: ''
})

const user = ref({
  id: '',
  username: '',
  money: '0.00'
})

const username = ref(localStorage.getItem('username') || '')

// 本地商品数据补充
const localGoodsData = {
  1: { name: 'iPhone 15 Pro', category: '手机数码', img: img1 },
  2: { name: 'AirPods Pro 2', category: '智能穿戴', img: img2 },
  3: { name: '华为 Mate 60 Pro', category: '手机数码', img: img3 },
  4: { name: '小米 14 Ultra', category: '手机数码', img: img4 },
  5: { name: 'OPPO Find X7 Ultra', category: '手机数码', img: img5 },
  6: { name: 'vivo X100 Pro', category: '手机数码', img: img6 },
  7: { name: '荣耀 Magic6 Pro', category: '手机数码', img: img7 },
  8: { name: '三星 Galaxy Buds3 Pro', category: '智能穿戴', img: img8 },
  9: { name: '小米 Buds 5 Pro', category: '智能穿戴', img: img9 },
  10: { name: '华为 FreeBuds Pro 4', category: '智能穿戴', img: img10 }
}

// 加载商品&用户
onMounted(async () => {
  // 检查登录状态
  if (!localStorage.getItem('userId')) {
    ElMessage.warning('请先登录')
    proxy.$router.push('/login')
    return
  }
  
  const userId = localStorage.getItem('userId')
  
  try {
    // 获取商品详情
    const goodsRes = await proxy.$axios.get('/product/' + id)
    goods.value = goodsRes
    
    // 如果后端返回的数据缺少字段，使用本地数据补充
    const localData = localGoodsData[id]
    if (localData) {
      if (!goods.value.name || goods.value.name === '') {
        goods.value.name = localData.name
      }
      if (!goods.value.category || goods.value.category === '') {
        goods.value.category = localData.category
      }
      if (!goods.value.img || goods.value.img === '') {
        goods.value.img = localData.img
      }
    }
    
    // 获取用户信息
    const userRes = await proxy.$axios.get('/user/' + userId)
    user.value = userRes
    username.value = userRes.username
  } catch (error) {
    ElMessage.error('加载数据失败：' + error.message)
  }
})

// 立即下单（Seata分布式事务）
const createOrder = async () => {
  const userId = localStorage.getItem('userId')
  
  if (!userId) {
    ElMessage.warning('请先登录')
    proxy.$router.push('/login')
    return
  }
  
  if (goods.value.stock <= 0) {
    ElMessage.warning('📦 库存不足，无法下单')
    return
  }
  
  try {
    // request.js 拦截器已经处理了：成功直接返回 data，失败直接 reject
    const response = await proxy.$axios.get('/order/create/' + userId + '/' + id)
    ElMessage.success('✅ 下单成功！')
    // 下单成功后刷新库存和用户余额
    refreshData()
  } catch (error) {
    const errorMsg = error.response?.data?.message || error.response?.data?.msg || error.message
    if (errorMsg.includes('余额')) {
      ElMessage.warning('💰 ' + errorMsg)
    } else if (errorMsg.includes('库存')) {
      ElMessage.warning('📦 ' + errorMsg)
    } else {
      ElMessage.error('❌ 下单失败：' + errorMsg)
    }
  }
}

// 刷新数据
const refreshData = async () => {
  try {
    const userId = localStorage.getItem('userId')
    
    // 获取商品详情
    const goodsRes = await proxy.$axios.get('/product/' + id)
    goods.value = goodsRes
    
    // 处理字段映射（后端是productName，前端期望是name）
    if (goods.value.productName && !goods.value.name) {
      goods.value.name = goods.value.productName
    }
    
    // 如果后端返回的数据缺少字段，使用本地数据补充
    const localData = localGoodsData[id]
    if (localData) {
      if (!goods.value.name || goods.value.name === '') {
        goods.value.name = localData.name
      }
      if (!goods.value.category || goods.value.category === '') {
        goods.value.category = localData.category
      }
      if (!goods.value.img || goods.value.img === '') {
        goods.value.img = localData.img
      }
    }
    
    // 获取用户信息（更新余额）
    const userRes = await proxy.$axios.get('/user/' + userId)
    user.value = userRes
    username.value = userRes.username
  } catch (error) {
    ElMessage.error('刷新数据失败：' + error.message)
  }
}

// 加入购物车（本地存储）
const addCart = () => {
  if (goods.value.stock <= 0) {
    ElMessage.warning('库存不足，无法加入购物车')
    return
  }
  
  let cart = JSON.parse(localStorage.getItem('cart') || '[]')
  
  // 检查是否已在购物车
  const exist = cart.find(item => item.id === goods.value.id)
  if (exist) {
    ElMessage.warning('该商品已在购物车中')
    return
  }
  
  cart.push(goods.value)
  localStorage.setItem('cart', JSON.stringify(cart))
  ElMessage.success('已加入购物车')
}
</script>

<style scoped>
.back-bar {
  padding: 12px 150px;
  background: #fff;
  border-bottom: 1px solid #eee;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}
.back-bar span {
  cursor: pointer;
  color: #666;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 5px;
}
.back-bar span:hover {
  color: #667eea;
}

.container {
  padding: 40px 150px;
  background: #f8f9fa;
  min-height: calc(100vh - 60px);
}
.detail-card {
  display: flex;
  gap: 80px;
  background: #fff;
  padding: 50px;
  border-radius: 16px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
}

.img-box {
  position: relative;
  width: 450px;
  height: 450px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}
.img-box img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.info-box {
  flex: 1;
}
.info-box h2 {
  font-size: 30px;
  margin-bottom: 25px;
  color: #333;
  font-weight: bold;
}

.price-section {
  display: flex;
  align-items: baseline;
  gap: 10px;
  margin-bottom: 25px;
}
.price {
  font-size: 36px;
  color: #e74c3c;
  font-weight: bold;
}
.price-label {
  font-size: 14px;
  color: #999;
}

.stock {
  font-size: 16px;
  color: #666;
  margin-bottom: 10px;
}
.stock strong {
  color: #27ae60;
}

.category {
  font-size: 16px;
  color: #666;
  margin-bottom: 30px;
}
.category-badge {
  display: inline-block;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  font-size: 12px;
  padding: 6px 14px;
  border-radius: 20px;
  margin-left: 10px;
}

.user-info {
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8ec 100%);
  padding: 20px 25px;
  border-radius: 12px;
  margin-bottom: 35px;
}
.user-info p {
  margin: 8px 0;
  color: #555;
  font-size: 15px;
}
.username {
  color: #667eea;
  font-weight: bold;
}
.money {
  color: #27ae60;
  font-weight: bold;
  font-size: 20px;
}

.btns {
  display: flex;
  gap: 20px;
}
.add-cart-btn {
  width: 160px;
  height: 50px;
  font-size: 16px;
  border-radius: 10px;
  background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
  border: none;
  font-weight: 500;
}
.buy-now-btn {
  width: 200px;
  height: 50px;
  font-size: 16px;
  border-radius: 10px;
  background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
  border: none;
  font-weight: 500;
}
</style>