<template>
  <div class="login">
    <div class="visual">
      <div class="rings"></div>
      <div class="visual-copy">
        <div class="logo"><el-icon><Reading/></el-icon></div>
        <h1>让每一次阅读<br/>都触手可及</h1>
        <p>基于微服务架构的智慧图书馆管理平台</p>
        <div class="features"><span><el-icon><Search/></el-icon>智能检索</span><span><el-icon><Clock/></el-icon>借阅提醒</span><span><el-icon><DataAnalysis/></el-icon>数据分析</span></div>
      </div>
      <div class="quote">“书籍是屹立在时间汪洋大海中的灯塔。”</div>
    </div>
    <div class="panel"><div class="form">
      <div class="mobile-logo"><el-icon><Reading/></el-icon></div><h2>欢迎回来</h2><p>登录后进入智慧图书馆管理平台</p>
      <el-form label-position="top" @keyup.enter="submit">
        <el-form-item label="用户名"><el-input v-model="data.username" size="large" placeholder="请输入用户名"><template #prefix><el-icon><User/></el-icon></template></el-input></el-form-item>
        <el-form-item label="密码"><el-input v-model="data.password" size="large" type="password" show-password placeholder="请输入密码"><template #prefix><el-icon><Lock/></el-icon></template></el-input></el-form-item>
        <div class="remember"><el-checkbox v-model="remember">记住我</el-checkbox><span>忘记密码？</span></div>
        <el-button type="primary" size="large" :loading="loading" @click="submit">登 录</el-button>
        <div class="demo"><b>演示账号</b><span @click="fill('admin','Admin@123')">管理员</span><span @click="fill('librarian','Library@123')">图书管理员</span><span @click="fill('reader','Reader@123')">读者</span></div>
      </el-form><footer>© 2026 Library Cloud · 智慧图书馆</footer>
    </div></div>
  </div>
</template>
<script setup lang="ts">import{reactive,ref}from'vue';import{useRouter}from'vue-router';import{ElMessage}from'element-plus';import api from'../api';const router=useRouter(),loading=ref(false),remember=ref(true),data=reactive({username:'admin',password:'Admin@123'});function fill(u:string,p:string){data.username=u;data.password=p}async function submit(){if(!data.username||!data.password)return ElMessage.warning('请输入用户名和密码');loading.value=true;try{const r:any=await api.post('/api/auth/login',data);localStorage.setItem('token',r.token);localStorage.setItem('user',JSON.stringify(r.user));ElMessage.success('登录成功');router.push('/dashboard')}finally{loading.value=false}}</script>
<style scoped>.login{min-height:100vh;display:grid;grid-template-columns:1.15fr .85fr;background:#fff}.visual{background:linear-gradient(145deg,#102b43,#174961 70%,#19745f);position:relative;overflow:hidden;color:#fff;padding:70px}.rings{position:absolute;width:620px;height:620px;border:1px solid rgba(255,255,255,.08);border-radius:50%;left:-150px;top:-180px;box-shadow:0 0 0 80px rgba(255,255,255,.025),0 0 0 160px rgba(255,255,255,.018)}.visual-copy{position:relative;top:14%;max-width:590px}.logo,.mobile-logo{width:52px;height:52px;background:#38b98c;border-radius:15px;display:grid;place-items:center;font-size:25px;box-shadow:0 12px 26px rgba(40,202,144,.25)}h1{font-size:52px;line-height:1.22;margin:38px 0 18px;letter-spacing:2px}.visual-copy p{font-size:16px;color:#bdd3db}.features{display:flex;gap:28px;margin-top:45px}.features span{display:flex;align-items:center;gap:8px;color:#d4e6e9;font-size:13px}.quote{position:absolute;bottom:55px;color:#8db2be;font-size:13px}.panel{display:grid;place-items:center;padding:40px}.form{width:390px}.mobile-logo{display:none}h2{font-size:30px;margin:0 0 8px;color:#172a3d}.form>p{color:#94a0af;margin:0 0 35px}.el-button--primary{width:100%;background:#20946f;border-color:#20946f;margin-top:8px}.remember{display:flex;justify-content:space-between;font-size:13px;margin:-2px 0 18px}.remember span{color:#238f70}.demo{display:flex;align-items:center;gap:12px;margin-top:25px;font-size:12px;color:#8a97a6}.demo span{color:#258c6e;background:#edf8f4;padding:5px 8px;border-radius:6px;cursor:pointer}.demo b{color:#607083}footer{text-align:center;margin-top:70px;color:#b2bbc5;font-size:11px}@media(max-width:900px){.login{grid-template-columns:1fr}.visual{display:none}.mobile-logo{display:grid;margin-bottom:30px}.form{max-width:100%}}</style>
