<template>
  <div class="recharge">
    <!-- 返回首页 -->
    <div class="back-bar">
      <span @click="$router.push('/')">🏠 返回首页</span>
    </div>
    
    <div class="container">
      <div class="recharge-card">
        <div class="card-header">
          <div class="header-icon">💰</div>
          <h2>账户充值</h2>
          <p class="header-desc">点击即可充值，无需绑定支付方式</p>
        </div>
        
        <div class="user-info">
          <div class="info-row">
            <span class="label">当前用户</span>
            <span class="value">{{ username }}</span>
          </div>
          <div class="info-row balance-row">
            <span class="label">账户余额</span>
            <span class="value money">¥{{ user.money }}</span>
          </div>
        </div>
        
        <div class="amount-section">
          <h3>快速充值</h3>
          <div class="amount-grid">
            <button 
              v-for="amount in quickAmounts" 
              :key="amount"
              :class="['amount-btn', {active: selectedAmount === amount}]"
              @click="selectedAmount = amount"
            >
              ¥{{ amount }}
            </button>
          </div>
          
          <div class="custom-amount">
            <el-input 
              v-model="customAmount" 
              placeholder="输入自定义金额"
              type="number"
              @input="selectedAmount = null"
            />
          </div>
        </div>
        
        <button class="recharge-btn" @click="doRecharge">
          ⚡ 立即充值
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, getCurrentInstance } from 'vue'
import { ElMessage } from 'element-plus'

const { proxy } = getCurrentInstance()

const username = ref(localStorage.getItem('username') || '')
const user = ref({
  id: '',
  username: '',
  money: '0.00'
})

const quickAmounts = [100, 500, 1000, 5000, 10000]
const selectedAmount = ref(null)
const customAmount = ref('')

onMounted(async () => {
  if (!localStorage.getItem('userId')) {
    ElMessage.warning('请先登录')
    proxy.$router.push('/login')
    return
  }
  
  const userId = localStorage.getItem('userId')
  
  try {
    const userRes = await proxy.$axios.get('/user/' + userId)
    user.value = userRes
    username.value = userRes.username
  } catch (error) {
    ElMessage.error('加载用户信息失败：' + error.message)
  }
})

const doRecharge = async () => {
  const userId = localStorage.getItem('userId')
  let amount = selectedAmount.value || parseFloat(customAmount.value)
  
  if (!amount || amount <= 0) {
    ElMessage.warning('请选择或输入充值金额')
    return
  }
  
  try {
    await proxy.$axios.post('/user/recharge/' + userId + '/' + amount)
    ElMessage.success('✅ 充值成功！')
    
    // 刷新余额
    const userRes = await proxy.$axios.get('/user/' + userId)
    user.value = userRes
    
    // 清空选择
    selectedAmount.value = null
    customAmount.value = ''
  } catch (error) {
    ElMessage.error('❌ 充值失败：' + (error.response?.data?.message || error.message))
  }
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
  padding: 50px 150px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: calc(100vh - 60px);
  display: flex;
  justify-content: center;
}

.recharge-card {
  width: 500px;
  background: #fff;
  border-radius: 20px;
  padding: 40px;
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
}

.card-header {
  text-align: center;
  margin-bottom: 35px;
}

.header-icon {
  font-size: 60px;
  margin-bottom: 15px;
}

.card-header h2 {
  font-size: 28px;
  color: #333;
  margin-bottom: 8px;
}

.header-desc {
  color: #999;
  font-size: 14px;
}

.user-info {
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  border-radius: 12px;
  padding: 20px 25px;
  margin-bottom: 30px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
}

.info-row:not(:last-child) {
  border-bottom: 1px solid #dee2e6;
}

.info-row .label {
  color: #666;
  font-size: 15px;
}

.info-row .value {
  color: #333;
  font-weight: 500;
}

.info-row .value.money {
  color: #27ae60;
  font-size: 24px;
  font-weight: bold;
}

.amount-section {
  margin-bottom: 30px;
}

.amount-section h3 {
  font-size: 16px;
  color: #333;
  margin-bottom: 15px;
}

.amount-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 10px;
  margin-bottom: 20px;
}

.amount-btn {
  padding: 12px 10px;
  border: 2px solid #e0e0e0;
  border-radius: 10px;
  background: #fff;
  color: #555;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
}

.amount-btn:hover {
  border-color: #667eea;
  color: #667eea;
}

.amount-btn.active {
  border-color: #667eea;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
}

.custom-amount {
  margin-top: 15px;
}

.custom-amount .el-input__wrapper {
  border-radius: 10px;
  height: 48px;
}

.recharge-btn {
  width: 100%;
  height: 55px;
  font-size: 18px;
  font-weight: bold;
  color: #fff;
  background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
  border: none;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 15px rgba(243, 156, 18, 0.4);
}

.recharge-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(243, 156, 18, 0.5);
}

.recharge-btn:active {
  transform: translateY(0);
}
</style>