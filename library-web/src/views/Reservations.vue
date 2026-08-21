<template>
  <div class="page">
    <div class="page-head">
      <div>
        <h1 class="page-title">预约管理</h1>
        <div class="page-sub">查看预约队列、到书通知和失效情况</div>
      </div>
    </div>

    <div class="toolbar">
      <el-radio-group v-model="filter">
        <el-radio-button label="全部" value="" />
        <el-radio-button label="等待中" value="WAITING" />
        <el-radio-button label="已到书" value="AVAILABLE" />
        <el-radio-button label="已取消" value="CANCELLED" />
        <el-radio-button label="已失效" value="EXPIRED" />
      </el-radio-group>
    </div>

    <el-card class="table-card">
      <el-table :data="shown" v-loading="loading">
        <el-table-column prop="id" label="预约编号" width="100" />
        <el-table-column prop="readerNo" label="读者编号" width="135" />
        <el-table-column prop="realName" label="读者姓名" width="110" />
        <el-table-column prop="bookTitle" label="预约图书" min-width="220" />
        <el-table-column label="排队序号" width="110">
          <template #default="{ row }">
            <b>第 {{ row.queueNo }} 位</b>
          </template>
        </el-table-column>
        <el-table-column prop="reserveTime" label="预约时间" width="175" />
        <el-table-column prop="expireTime" label="失效时间" width="175">
          <template #default="{ row }">{{ row.expireTime || '—' }}</template>
        </el-table-column>
        <el-table-column label="状态" width="105">
          <template #default="{ row }">
            <el-tag :type="statusType(row.status)">{{ statusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="110" fixed="right">
          <template #default="{ row }">
            <el-button
              v-if="row.status === 'WAITING' || row.status === 'AVAILABLE'"
              link
              type="danger"
              @click="cancel(row.id)"
            >
              取消预约
            </el-button>
            <span v-else class="muted">已结束</span>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import api from '../api'
import { ElMessage } from 'element-plus'

const rows = ref<any[]>([])
const filter = ref('')
const loading = ref(false)
const shown = computed(() =>
  filter.value ? rows.value.filter(row => row.status === filter.value) : rows.value
)

onMounted(load)

async function load() {
  loading.value = true
  try {
    rows.value = await api.get('/api/reservations')
  } finally {
    loading.value = false
  }
}

function statusText(status: string) {
  return ({
    WAITING: '等待中',
    AVAILABLE: '已到书',
    CANCELLED: '已取消',
    EXPIRED: '已失效'
  } as any)[status] || status
}

function statusType(status: string) {
  return ({
    WAITING: 'warning',
    AVAILABLE: 'success',
    CANCELLED: 'info',
    EXPIRED: 'danger'
  } as any)[status] || 'info'
}

async function cancel(id: number) {
  await api.delete(`/api/reservations/${id}`)
  ElMessage.success('预约已取消')
  load()
}
</script>
