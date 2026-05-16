<template>
  <div class="cart">
    <!-- 返回首页 -->
    <div class="back-bar">
      <span @click="$router.push('/')">🏠 返回首页</span>
    </div>
    
    <div class="container">
      <el-card class="cart-card">
        <div class="card-header">
          <h2>🛒 我的购物车</h2>
          <span class="cart-count">共 {{ cartList.length }} 件商品</span>
        </div>
        
        <div v-if="cartList.length === 0" class="empty-cart">
          <div class="empty-icon">🛒</div>
          <p>购物车是空的，快去挑选心仪的商品吧！</p>
          <el-button type="primary" @click="$router.push('/')">去逛逛</el-button>
        </div>
        
        <div v-else class="table-wrapper">
          <el-table :data="cartList" border stripe style="width:100%">
            <el-table-column label="商品图片" width="130">
              <template #default="scope">
                <img :src="scope.row.img" style="width:90px;height:90px;object-fit:cover;border-radius:8px" />
              </template>
            </el-table-column>
            <el-table-column label="商品名称" prop="name" width="220" />
            <el-table-column label="分类" prop="category" />
            <el-table-column label="价格" prop="price">
              <template #default="scope">¥{{ scope.row.price.toLocaleString() }}</template>
            </el-table-column>
            <el-table-column label="库存" prop="stock" />
            <el-table-column label="操作">
              <template #default="scope">
                <el-button type="primary" size="small" @click="singleBuy(scope.row)">立即购买</el-button>
                <el-button type="danger" size="small" @click="del(scope.$index)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
        
        <div v-if="cartList.length > 0" class="total">
          <div class="total-info">
            <span class="total-label">合计：</span>
            <span class="total-price">¥{{ totalPrice.toLocaleString() }}</span>
            <span class="item-count">共 {{ cartList.length }} 件商品</span>
          </div>
          <el-button class="checkout-btn" @click="batchBuy">⚡ 批量结算下单</el-button>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, getCurrentInstance } from 'vue'
import { ElMessage } from 'element-plus'

const { proxy } = getCurrentInstance()
const cartList = ref(JSON.parse(localStorage.getItem('cart') || '[]'))
const totalPrice = computed(() => cartList.value.reduce((s, i) => s + i.price, 0))

// 检查登录状态
onMounted(() => {
  if (!localStorage.getItem('userId')) {
    ElMessage.warning('请先登录')
    proxy.$router.push('/login')
  }
})

// 单个下单
const singleBuy = async (item) => {
  const userId = localStorage.getItem('userId')
  
  if (!userId) {
    ElMessage.warning('请先登录')
    proxy.$router.push('/login')
    return
  }
  
  try {
    await proxy.$axios.get('/order/create/' + userId + '/' + item.id)
    ElMessage.success('下单成功！')
    // 从购物车移除
    const index = cartList.value.findIndex(i => i.id === item.id)
    if (index > -1) {
      cartList.value.splice(index, 1)
      localStorage.setItem('cart', JSON.stringify(cartList.value))
    }
  } catch (error) {
    ElMessage.error('下单失败：' + (error.response?.data?.message || error.message))
  }
}

// 批量下单
const batchBuy = async () => {
  const userId = localStorage.getItem('userId')
  
  if (!userId) {
    ElMessage.warning('请先登录')
    proxy.$router.push('/login')
    return
  }
  
  if (cartList.value.length === 0) {
    ElMessage.warning('购物车是空的')
    return
  }
  
  let successCount = 0
  let failCount = 0
  const failItems = []
  
  for (let item of cartList.value) {
    try {
      await proxy.$axios.get('/order/create/' + userId + '/' + item.id)
      successCount++
    } catch (error) {
      failCount++
      failItems.push(item.name)
    }
  }
  
  // 清空购物车
  localStorage.removeItem('cart')
  cartList.value = []
  
  if (failCount === 0) {
    ElMessage.success('全部下单成功！')
  } else if (successCount === 0) {
    ElMessage.error('全部下单失败')
  } else {
    ElMessage.success(`成功：${successCount} 件，失败：${failCount} 件`)
    if (failItems.length > 0) {
      ElMessage.warning('失败商品：' + failItems.join('、'))
    }
  }
}

// 删除商品
const del = (idx) => {
  cartList.value.splice(idx, 1)
  localStorage.setItem('cart', JSON.stringify(cartList.value))
  ElMessage.success('已删除')
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

.cart-card {
  border-radius: 16px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 25px 30px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.card-header h2 {
  margin: 0;
  color: #fff;
  font-size: 22px;
  font-weight: bold;
}
.cart-count {
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

.empty-cart {
  text-align: center;
  padding: 80px 0;
  background: #fff;
}
.empty-icon {
  font-size: 80px;
  margin-bottom: 20px;
  opacity: 0.5;
}
.empty-cart p {
  color: #999;
  font-size: 16px;
  margin-bottom: 25px;
}
.empty-cart .el-button {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  padding: 12px 30px;
  border-radius: 25px;
}

.table-wrapper {
  padding: 0 30px;
  background: #fff;
}

.total {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 25px 30px;
  background: #f8f9fa;
  border-top: 1px solid #eee;
}
.total-info {
  display: flex;
  gap: 25px;
  align-items: center;
}
.total-label {
  font-size: 16px;
  color: #666;
}
.total-price {
  font-size: 30px;
  color: #e74c3c;
  font-weight: bold;
}
.item-count {
  color: #888;
  font-size: 14px;
}
.checkout-btn {
  background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
  border: none;
  padding: 15px 40px;
  font-size: 16px;
  font-weight: 500;
  border-radius: 10px;
}
</style>