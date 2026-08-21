<template>
  <div class="page">
    <div class="page-head">
      <div>
        <h1 class="page-title">图书分类</h1>
        <div class="page-sub">按分类集中查看和维护馆藏图书</div>
      </div>
      <el-button type="primary" @click="open()">
        <el-icon><Plus /></el-icon>
        新增分类
      </el-button>
    </div>

    <el-card class="table-card">
      <el-table :data="rows" v-loading="loading">
        <el-table-column prop="code" label="分类编码" width="150" />
        <el-table-column label="分类名称" width="180">
          <template #default="{ row }">
            <div class="category-name">
              <b>{{ row.name }}</b>
              <el-tag size="small" round>{{ booksByCategory(row.id).length }} 本</el-tag>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="该分类包含的图书" min-width="520">
          <template #default="{ row }">
            <div v-if="booksByCategory(row.id).length" class="book-list">
              <el-tag
                v-for="book in booksByCategory(row.id)"
                :key="book.id"
                effect="plain"
                type="success"
              >
                {{ book.title }}
              </el-tag>
            </div>
            <span v-else class="empty-text">该分类暂时没有图书</span>
          </template>
        </el-table-column>
        <el-table-column prop="sortNo" label="排序" width="80" />
        <el-table-column label="状态" width="90">
          <template #default="{ row }">
            <el-tag :type="row.status === 0 ? 'info' : 'success'">
              {{ row.status === 0 ? '停用' : '启用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="140" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="open(row)">编辑</el-button>
            <el-popconfirm title="确定删除吗？" @confirm="remove(row.id)">
              <template #reference>
                <el-button link type="danger">删除</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="visible" :title="form.id ? '编辑分类' : '新增分类'" width="460">
      <el-form label-position="top">
        <el-form-item label="分类名称"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="分类编码"><el-input v-model="form.code" /></el-form-item>
        <el-form-item label="排序"><el-input-number v-model="form.sortNo" :min="0" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="visible = false">取消</el-button>
        <el-button type="primary" @click="save">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import api from '../api'
import { ElMessage } from 'element-plus'

const rows = ref<any[]>([])
const books = ref<any[]>([])
const loading = ref(false)
const visible = ref(false)
const form = reactive<any>({})

onMounted(load)

async function load() {
  loading.value = true
  try {
    const [categoryData, bookData]: any = await Promise.all([
      api.get('/api/categories'),
      api.get('/api/books', { params: { page: 1, size: 100, keyword: '' } })
    ])
    rows.value = categoryData
    books.value = bookData.records || []
  } finally {
    loading.value = false
  }
}

function booksByCategory(categoryId: number) {
  return books.value.filter(book => Number(book.categoryId) === Number(categoryId))
}

function open(row: any = {}) {
  Object.keys(form).forEach(key => delete form[key])
  Object.assign(form, row, { sortNo: row.sortNo ?? 0, status: row.status ?? 1 })
  visible.value = true
}

async function save() {
  form.id
    ? await api.put(`/api/categories/${form.id}`, form)
    : await api.post('/api/categories', form)
  ElMessage.success('保存成功')
  visible.value = false
  load()
}

async function remove(id: number) {
  await api.delete(`/api/categories/${id}`)
  ElMessage.success('删除成功')
  load()
}
</script>

<style scoped>
.category-name {
  display: flex;
  align-items: center;
  gap: 10px;
}
.book-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding: 4px 0;
}
.empty-text {
  color: #a5afbb;
}
</style>
