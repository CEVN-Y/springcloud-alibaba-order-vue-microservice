<template>
  <div class="login">
    <el-card class="login-card">
      <div class="login-header">
        <div class="logo-wrapper">
          <span class="logo-icon">🎯</span>
          <span class="logo-text">智选数码</span>
        </div>
        <div class="login-title">账号登录</div>
      </div>
      <el-form :model="form" label-width="80px" class="login-form">
        <el-form-item label="用户名">
          <el-input v-model="form.username" placeholder="请输入用户名" size="large" />
        </el-form-item>
        <el-form-item label="密码">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" size="large" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="login" class="login-btn">登录</el-button>
        </el-form-item>
        <el-form-item>
          <el-button @click="$router.push('/register')" class="register-btn">注册</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, getCurrentInstance, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
const { proxy } = getCurrentInstance()
const form = ref({ username: '', password: '' })

// 如果已登录，直接跳转到首页
onMounted(() => {
  if (localStorage.getItem('userId')) {
    proxy.$router.push('/')
  }
})

const login = async () => {
  if (!form.value.username || !form.value.password) {
    ElMessage.warning('请填写用户名和密码')
    return
  }
  
  try {
    const res = await proxy.$axios.post('/user/login', form.value)
    localStorage.setItem('userId', res.id)
    localStorage.setItem('username', res.username)
    ElMessage.success('登录成功')
    proxy.$router.push('/')
  } catch (error) {
    ElMessage.error(error.message || '登录失败')
  }
}
</script>

<style scoped>
.login {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.login-card {
  width: 420px;
  padding: 40px;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
}
.login-header {
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
.login-title {
  font-size: 24px;
  font-weight: bold;
  color: #333;
}
.login-form {
  margin-top: 20px;
}
.login-btn {
  width: 100%;
  height: 45px;
  border-radius: 8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  font-size: 16px;
  font-weight: 500;
}
.register-btn {
  width: 100%;
  height: 45px;
  border-radius: 8px;
  margin-top: 10px;
}
</style>