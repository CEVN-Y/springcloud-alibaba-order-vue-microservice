import axios from 'axios'
const service = axios.create({
  baseURL: '/api',
  timeout: 5000
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data
    // 如果返回的是Result格式，直接返回data
    if (res.code !== undefined) {
      if (res.code === 200) {
        return res.data
      } else {
        return Promise.reject(new Error(res.msg || '请求失败'))
      }
    }
    return res
  },
  error => {
    return Promise.reject(error)
  }
)

export default service