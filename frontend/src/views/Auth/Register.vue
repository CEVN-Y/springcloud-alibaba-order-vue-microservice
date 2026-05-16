<template>
  <div class="register">
    <el-card class="register-card">
      <div class="register-header">
        <div class="logo-wrapper">
          <span class="logo-icon">🎯</span>
          <span class="logo-text">智选数码</span>
        </div>
        <div class="register-title">用户注册</div>
      </div>
      <el-form :model="form" label-width="80px" class="register-form">
        <el-form-item label="用户名">
          <el-input v-model="form.username" placeholder="请输入用户名" size="large" />
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" size="large" />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="form.phone" placeholder="请输入手机号" size="large" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="register" class="register-btn">注册</el-button>
        </el-form-item>
        <el-form-item>
          <el-button @click="$router.push('/login')" class="login-btn">返回登录</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, getCurrentInstance, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
const { proxy } = getCurrentInstance()
const form = ref({ username: '', password: '', phone: '' })

// 如果已登录，直接跳转到首页
onMounted(() => {
  if (localStorage.getItem('userId')) {
    proxy.$router.push('/')
  }
})

const register = async () => {
  if (!form.value.username || !form.value.password) {
    ElMessage.warning('请填写用户名和密码')
    return
  }
  
  try {
    await proxy.$axios.post('/user/register', form.value)
    ElMessage.success('注册成功')
    proxy.$router.push('/login')
  } catch (error) {
    ElMessage.error(error.message || '注册失败')
  }
}
</script>

<style scoped>
.register {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.register-card {
  width: 420px;
  padding: 40px;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
}
.register-header {
  text-align: center;
  margin-bottom: 30px;
}
.logo-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-bottom: 15px;
}
.logo-icon {
  font-size: 40px;
}
.logo-text {
  font-size: 28px;
  font-weight: bold;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.register-title {
  font-size: 24px;
  font-weight: bold;
  color: #333;
}
.register-form {
  margin-top: 20px;
}
.register-btn {
  width: 100%;
  height: 45px;
  border-radius: 8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  font-size: 16px;
  font-weight: 500;
}
.login-btn {
  width: 100%;
  height: 45px;
  border-radius: 8px;
  margin-top: 10px;
}
</style>