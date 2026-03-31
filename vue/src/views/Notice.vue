<template>
  <div>
    <div>
      <!--      搜索栏-->
      <el-input style="width: 200px;margin-right: 20px" placeholder="请输入标题" v-model="title"
                prefix-icon="el-icon-user"></el-input>
      <el-input style="width: 200px;margin-right: 20px" placeholder="请输入创建者" v-model="user"
                prefix-icon="el-icon-user"></el-input>
      <el-button style="margin-left: 10px;" type="primary" @click="load" class="el-icon-search">搜索</el-button>
      <el-button style="margin-left: 10px;" type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
    </div>

    <div style="margin-top:20px;margin-bottom: 20px;">
      <!--      新增。批量删除-->
      <el-button style="margin-right: 10px;" type="success" class="el-icon-plus" @click="save">新增</el-button>
      <el-popconfirm
          confirm-button-text='确定'
          cancel-button-text='取消'
          icon="el-icon-info"
          icon-color="red"
          title="确定删除这些数据吗？"
          @confirm="deleteBatch"
          @cancel="cancel">
        <el-button slot="reference" type="danger" style="margin-left:5px;" class="el-icon-delete">批量删除</el-button>
      </el-popconfirm>
    </div>

    <el-table :data="tableData" border stripe :header-cell-style="getRowClass"
              @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="id" label="id"></el-table-column>
      <el-table-column prop="title" label="公告标题"></el-table-column>
      <el-table-column prop="content" label="公告内容">
        <template slot-scope="scope">
          <el-card>{{ scope.row.content }}</el-card>
        </template>
      </el-table-column>
      <el-table-column prop="user" label="创建者"></el-table-column>
      <el-table-column prop="createTime" label="创建时间"></el-table-column>
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button type="primary" class="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
          <el-popconfirm
              confirm-button-text='确定'
              cancel-button-text='取消'
              icon="el-icon-info"
              icon-color="red"
              title="确定删除这些数据吗？"
              @confirm="handleDelete(scope.row.id)"
              @cancel="cancel">
            <el-button slot="reference" type="danger" style="margin-left:5px;" class="el-icon-delete">删除</el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>

    <div class="block" style="padding:10px 0;align-content: center;margin-left: 30%;margin-top:30px;">
      <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-sizes="[5, 10, 15, 20]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total">
      </el-pagination>
    </div>

    <el-dialog title="公告信息" :visible.sync="dialogFormVisible" width="30%" @close="handleCancel">
      <el-form :model="form" :rules="rules">
        <el-form-item label="公告标题" :label-width="formLabelWidth" prop="title">
          <el-input v-model="form.title" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="公告内容" :label-width="formLabelWidth" prop="content">
          <el-input v-model="form.content" autocomplete="off" type="textarea" :rows="10"></el-input>
        </el-form-item>

      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleCancel">取 消</el-button>
        <el-button type="primary" @click="handleAdd">确 定</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
import DataSelect from "@/components/DataSelect";
import ImgUpload from "@/components/ImgUpload";
export default {
  name: "Notice",
  components: {ImgUpload, DataSelect},
  data() {
    return {
      pageSize: 10,
      pageNum: 1,
      title: '',
      user: '',
      tableData: [],
      dialogFormVisible: false,
      form: {
        title: '',
        content: ''
      },
      formLabelWidth: '80px',
      multipleSelection: [],
      total: 0,
      rules: {
        title: [
          {required: true, message: '请输入公告标题', trigger: 'blur'}
        ],
        content: [
          {required: true, message: '请输入公告内容', trigger: 'blur'}
        ]
      }
    }
  },
  created() {
    this.load();
  },
  methods: {
    load() {
      this.request.get("/notice/findPage", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          title: this.title,
          user: this.user,
        }
      }).then(res => {
        this.tableData = res.data.records;
        this.total = res.data.total;
      })
    },
    getRowClass({rowIndex, columnIndex}) {
      if (rowIndex === 0) {
        return 'background:#ccc'
      }
    },
    reset() {
      this.title = '';
      this.user = '';
      this.load();
    },
    save() {
      this.dialogFormVisible = true;
      this.form = {};
    },
    handleCancel(){
      this.dialogFormVisible = false;
      Object.keys(this.form).forEach(key => {
        this.form[key] = ''; // 将每个值设置为 ''
      });
      console.log(this.form);
    },
    handleAdd() {
      this.request.post("/notice/save", this.form).then(res => {
        if (res.code === '200') {
          if (this.form.id) {
            this.$message.success('编辑成功');
          } else {
            this.$message.success('新增成功');
          }
          this.dialogFormVisible = false;
          this.load();
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row));
      this.dialogFormVisible = true;
    },
    handleDelete(id) {
      if (id) {
        this.request.delete('/notice/deleteById/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除数据成功');
            this.handleCalPageNum();
          } else {
            this.$message.error(res.msg)
          }
        })
      } else {
        this.$message.error('没有id信息，无法删除');
      }
    },
    cancel() {
      this.$message.success('取消操作成功');
    },
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    deleteBatch() {
      //批量删除数据
      if (this.multipleSelection.length === 0) {
        this.$message.warning("请先选择要删除的数据");
        return
      }
      const ids = this.multipleSelection.map(v => v.id);
      this.request.post('/notice/deleteBatch', ids).then(res => {
        if (res.code === '200') {
          this.$message.success('批量删除成功');
          this.handleCalPageNum();
        } else {
          this.$message.error(res.msg);
        }
      })
    },
    handleSizeChange(val) {
      this.pageSize = val;
      this.load();
    },
    handleCurrentChange(val) {
      this.pageNum = val;
      this.load();
    },
    handleCalPageNum() {
      this.request.get("/notice/findPage", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
        }
      }).then(res => {
        this.total = res.data.total;
        this.pageNum = (this.total % this.pageSize === 0) ? (this.total / this.pageSize) : Math.floor((this.total / this.pageSize) + 1);
        if (this.pageNum < 1) {
          this.pageNum = 1;
        }
        this.load();
      })
    }
  }
}
</script>

<style scoped>

</style>
