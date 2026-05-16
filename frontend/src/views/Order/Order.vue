<template>
  <div class="order">
    <!-- 返回首页 -->
    <div class="back-bar">
      <span @click="$router.push('/')">🏠 返回首页</span>
    </div>
    
    <div class="container">
      <el-card class="order-card">
        <div class="card-header">
          <h2>📋 我的订单</h2>
          <span class="order-count">共 {{ orderList.length }} 条订单</span>
        </div>
        
        <div v-if="orderList.length === 0" class="empty-order">
          <div class="empty-icon">📦</div>
          <p>暂无订单，快去选购心仪的商品吧！</p>
          <el-button type="primary" @click="$router.push('/')">去购物</el-button>
        </div>
        
        <div v-else class="table-wrapper">
          <el-table :data="orderList" border stripe style="width:100%">
            <el-table-column label="订单ID" prop="id" />
            <el-table-column label="订单编号" prop="orderNo" width="320" />
            <el-table-column label="商品ID" prop="productId" />
            <el-table-column label="商品名称" prop="productName" />
            <el-table-column label="下单时间" prop="createTime" />
            <el-table-column label="状态">
              <template #default="scope">
                <el-tag type="success" class="status-tag">✅ 已完成</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, getCurrentInstance } from 'vue'
import { ElMessage } from 'element-plus'

const { proxy } = getCurrentInstance()
const orderList = ref([])

// 商品名称映射（模拟数据）
const productNames = {
  1: 'iPhone 15 Pro',
  2: 'AirPods Pro 2',
  3: '华为 Mate 60 Pro',
  4: '小米 14 Ultra',
  5: 'OPPO Find X7 Ultra',
  6: 'vivo X100 Pro',
  7: '荣耀 Magic6 Pro',
  8: '三星 Galaxy Buds3 Pro',
  9: '小米 Buds 5 Pro',
  10: '华为 FreeBuds Pro 4'
}

onMounted(async () => {
  // 检查登录状态
  const userId = localStorage.getItem('userId')
  if (!userId) {
    ElMessage.warning('请先登录')
    proxy.$router.push('/login')
    return
  }
  
  try {
    const res = await proxy.$axios.get(`/order/list/${userId}`)
    // 添加商品名称和时间信息
    orderList.value = res.map(order => ({
      ...order,
      productName: productNames[order.productId] || '未知商品',
      createTime: new Date().toLocaleString('zh-CN')
    }))
  } catch (error) {
    ElMessage.error('加载订单失败：' + (error.response?.data?.message || error.message))
  }
})
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

.order-card {
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
.order-count {
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

.empty-order {
  text-align: center;
  padding: 80px 0;
  background: #fff;
}
.empty-icon {
  font-size: 80px;
  margin-bottom: 20px;
  opacity: 0.5;
}
.empty-order p {
  color: #999;
  font-size: 16px;
  margin-bottom: 25px;
}
.empty-order .el-button {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  padding: 12px 30px;
  border-radius: 25px;
}

.table-wrapper {
  padding: 20px 30px;
  background: #fff;
}

.status-tag {
  font-size: 13px;
  padding: 6px 14px;
  border-radius: 20px;
}
</style>