<template>
  <div class="product-visualization-container">
    <el-card class="box-card" shadow="hover">
      <template slot="header">
        <div class="card-header">
          <img src="../../../file/可视化.png" alt="农产品可视化" class="header-icon">
          <span>农产品数据可视化</span>
        </div>
      </template>
      <div class="visualization-content">
        <!-- 数据概览 -->
        <div class="overview-section">
          <div class="overview-card">
            <div class="overview-icon">
              <i class="el-icon-s-grid"></i>
            </div>
            <div class="overview-content">
              <div class="overview-number">{{ totalProducts }}</div>
              <div class="overview-label">农产品总数</div>
            </div>
          </div>
          <div class="overview-card">
            <div class="overview-icon">
              <i class="el-icon-s-goods"></i>
            </div>
            <div class="overview-content">
              <div class="overview-number">{{ totalStock }}</div>
              <div class="overview-label">总库存量</div>
            </div>
          </div>
          <div class="overview-card">
            <div class="overview-icon">
              <i class="el-icon-s-order"></i>
            </div>
            <div class="overview-content">
              <div class="overview-number">{{ totalTrace }}</div>
              <div class="overview-label">溯源查询次数</div>
            </div>
          </div>
          <div class="overview-card">
            <div class="overview-icon">
              <i class="el-icon-s-shop"></i>
            </div>
            <div class="overview-content">
              <div class="overview-number">{{ totalCategories }}</div>
              <div class="overview-label">产品类别数</div>
            </div>
          </div>
        </div>

        <!-- 图表区域 -->
        <div class="charts-section">
          <!-- 产品类别分布 -->
          <div class="chart-card">
            <div class="chart-header">
              <h3>产品类别分布</h3>
            </div>
            <div class="chart-container">
              <div ref="categoryChart" class="chart"></div>
            </div>
          </div>

          <!-- 库存量趋势 -->
          <div class="chart-card">
            <div class="chart-header">
              <h3>库存量趋势</h3>
            </div>
            <div class="chart-container">
              <div ref="stockChart" class="chart"></div>
            </div>
          </div>

          <!-- 产地分布 -->
          <div class="chart-card">
            <div class="chart-header">
              <h3>产地分布</h3>
            </div>
            <div class="chart-container">
              <div ref="originChart" class="chart"></div>
            </div>
          </div>

          <!-- 溯源热度 -->
          <div class="chart-card">
            <div class="chart-header">
              <h3>溯源热度</h3>
            </div>
            <div class="chart-container">
              <div ref="traceChart" class="chart"></div>
            </div>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: "ProductVisualization",
  data() {
    return {
      totalProducts: 128,
      totalStock: 10240,
      totalTrace: 5678,
      totalCategories: 8,
      categoryChart: null,
      stockChart: null,
      originChart: null,
      traceChart: null
    };
  },
  mounted() {
    this.initCharts();
    window.addEventListener('resize', this.handleResize);
  },
  beforeDestroy() {
    // 销毁图表实例
    if (this.categoryChart) {
      this.categoryChart.dispose();
    }
    if (this.stockChart) {
      this.stockChart.dispose();
    }
    if (this.originChart) {
      this.originChart.dispose();
    }
    if (this.traceChart) {
      this.traceChart.dispose();
    }
    window.removeEventListener('resize', this.handleResize);
  },
  methods: {
    /**
     * 处理窗口大小变化
     */
    handleResize() {
      if (this.categoryChart) {
        this.categoryChart.resize();
      }
      if (this.stockChart) {
        this.stockChart.resize();
      }
      if (this.originChart) {
        this.originChart.resize();
      }
      if (this.traceChart) {
        this.traceChart.resize();
      }
    },

    /**
     * 初始化图表
     */
    initCharts() {
      this.initCategoryChart();
      this.initStockChart();
      this.initOriginChart();
      this.initTraceChart();
    },

    /**
     * 初始化产品类别分布图表
     */
    initCategoryChart() {
      this.categoryChart = echarts.init(this.$refs.categoryChart);
      const option = {
        backgroundColor: 'transparent',
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)',
          backgroundColor: 'rgba(10, 25, 45, 0.8)',
          borderColor: 'rgba(100, 255, 218, 0.3)',
          textStyle: {
            color: '#64ffda'
          }
        },
        legend: {
          orient: 'vertical',
          left: 10,
          top: 'center',
          textStyle: {
            color: '#a3bffa'
          },
          data: ['玉米', '大米', '小麦', '蔬菜', '水果', '肉类', '蛋类', '其他']
        },
        series: [
          {
            name: '产品类别',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            itemStyle: {
              borderRadius: 10,
              borderColor: 'rgba(16, 25, 45, 0.8)',
              borderWidth: 2,
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 123, 255, 0.3)'
            },
            label: {
              show: false,
              position: 'center'
            },
            emphasis: {
              label: {
                show: true,
                fontSize: '18',
                fontWeight: 'bold',
                color: '#64ffda'
              }
            },
            labelLine: {
              show: false
            },
            data: [
              { value: 35, name: '玉米', itemStyle: { color: '#007bff' } },
              { value: 25, name: '大米', itemStyle: { color: '#64ffda' } },
              { value: 15, name: '小麦', itemStyle: { color: '#00b4d8' } },
              { value: 10, name: '蔬菜', itemStyle: { color: '#4cc9f0' } },
              { value: 8, name: '水果', itemStyle: { color: '#4361ee' } },
              { value: 4, name: '肉类', itemStyle: { color: '#7209b7' } },
              { value: 2, name: '蛋类', itemStyle: { color: '#f72585' } },
              { value: 1, name: '其他', itemStyle: { color: '#3a0ca3' } }
            ]
          }
        ]
      };
      this.categoryChart.setOption(option);
    },

    /**
     * 初始化库存量趋势图表
     */
    initStockChart() {
      this.stockChart = echarts.init(this.$refs.stockChart);
      const option = {
        backgroundColor: 'transparent',
        tooltip: {
          trigger: 'axis',
          backgroundColor: 'rgba(10, 25, 45, 0.8)',
          borderColor: 'rgba(100, 255, 218, 0.3)',
          textStyle: {
            color: '#64ffda'
          }
        },
        legend: {
          data: ['库存量'],
          textStyle: {
            color: '#a3bffa'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
          axisLine: {
            lineStyle: {
              color: 'rgba(100, 255, 218, 0.3)'
            }
          },
          axisLabel: {
            color: '#a3bffa'
          }
        },
        yAxis: {
          type: 'value',
          axisLine: {
            lineStyle: {
              color: 'rgba(100, 255, 218, 0.3)'
            }
          },
          axisLabel: {
            color: '#a3bffa'
          },
          splitLine: {
            lineStyle: {
              color: 'rgba(100, 255, 218, 0.1)'
            }
          }
        },
        series: [
          {
            name: '库存量',
            type: 'line',
            stack: 'Total',
            data: [820, 932, 901, 934, 1290, 1330, 1320, 1420, 1530, 1630, 1730, 1830],
            lineStyle: {
              color: '#64ffda',
              width: 3,
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(100, 255, 218, 0.5)'
            },
            itemStyle: {
              color: '#64ffda',
              borderColor: '#0a192f',
              borderWidth: 2
            },
            areaStyle: {
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 0,
                y2: 1,
                colorStops: [{
                  offset: 0, color: 'rgba(100, 255, 218, 0.3)'
                }, {
                  offset: 1, color: 'rgba(100, 255, 218, 0.05)'
                }]
              }
            }
          }
        ]
      };
      this.stockChart.setOption(option);
    },

    /**
     * 初始化产地分布图表
     */
    initOriginChart() {
      this.originChart = echarts.init(this.$refs.originChart);
      const option = {
        backgroundColor: 'transparent',
        tooltip: {
          trigger: 'item',
          backgroundColor: 'rgba(10, 25, 45, 0.8)',
          borderColor: 'rgba(100, 255, 218, 0.3)',
          textStyle: {
            color: '#64ffda'
          }
        },
        legend: {
          top: '5%',
          left: 'center',
          textStyle: {
            color: '#a3bffa'
          }
        },
        series: [
          {
            name: '产地分布',
            type: 'pie',
            radius: '60%',
            data: [
              { value: 30, name: '山东', itemStyle: { color: '#007bff' } },
              { value: 25, name: '吉林', itemStyle: { color: '#64ffda' } },
              { value: 20, name: '黑龙江', itemStyle: { color: '#00b4d8' } },
              { value: 15, name: '河南', itemStyle: { color: '#4cc9f0' } },
              { value: 10, name: '其他', itemStyle: { color: '#4361ee' } }
            ],
            emphasis: {
              itemStyle: {
                shadowBlur: 15,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 123, 255, 0.5)'
              }
            }
          }
        ]
      };
      this.originChart.setOption(option);
    },

    /**
     * 初始化溯源热度图表
     */
    initTraceChart() {
      this.traceChart = echarts.init(this.$refs.traceChart);
      const option = {
        backgroundColor: 'transparent',
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          },
          backgroundColor: 'rgba(10, 25, 45, 0.8)',
          borderColor: 'rgba(100, 255, 218, 0.3)',
          textStyle: {
            color: '#64ffda'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'value',
          axisLine: {
            lineStyle: {
              color: 'rgba(100, 255, 218, 0.3)'
            }
          },
          axisLabel: {
            color: '#a3bffa'
          },
          splitLine: {
            lineStyle: {
              color: 'rgba(100, 255, 218, 0.1)'
            }
          }
        },
        yAxis: {
          type: 'category',
          data: ['玉米', '大米', '小麦', '蔬菜', '水果'],
          axisLine: {
            lineStyle: {
              color: 'rgba(100, 255, 218, 0.3)'
            }
          },
          axisLabel: {
            color: '#a3bffa'
          }
        },
        series: [
          {
            name: '溯源次数',
            type: 'bar',
            data: [1200, 980, 850, 720, 650],
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
                { offset: 0, color: '#007bff' },
                { offset: 1, color: '#64ffda' }
              ]),
              borderRadius: [0, 4, 4, 0],
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 123, 255, 0.3)'
            }
          }
        ]
      };
      this.traceChart.setOption(option);
    }
  }
};
</script>

<style scoped>
.product-visualization-container {
  padding: 0;
  min-height: 100vh;
  background: linear-gradient(135deg, #0a192f 0%, #172a45 100%);
  position: relative;
  overflow: hidden;
}

.product-visualization-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxkZWZzPjxwYXR0ZXJuIGlkPSJwYXR0ZXJuIiBwYXR0ZXJuVW5pdHM9InVzZXJTcGFjZU9uVXNlIiB3aWR0aD0iNDAiIGhlaWdodD0iNDAiPjxwYXRoIGQ9Ik0wIDBoNDB2NDBoLTQweiIvPjwvcGF0dGVybj48L2RlZnM+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0idXJsKCNwYXR0ZXJuKSIvPjwvc3ZnPg==') repeat;
  opacity: 0.1;
  z-index: 0;
}

.box-card {
  margin: 0;
  width: 100%;
  height: 100vh;
  border-radius: 0;
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(0, 123, 255, 0.2);
  transition: all 0.3s ease;
  background: rgba(16, 25, 45, 0.8);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(100, 255, 218, 0.2);
  position: relative;
  z-index: 1;
}

.box-card:hover {
  box-shadow: 0 12px 48px rgba(0, 123, 255, 0.3);
  transform: translateY(-2px);
}

.card-header {
  display: flex;
  align-items: center;
  padding: 20px;
  background: linear-gradient(90deg, #0f172a 0%, #1e293b 100%);
  color: #64ffda;
  border-bottom: 1px solid rgba(100, 255, 218, 0.3);
  position: relative;
  overflow: hidden;
}

.card-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(100, 255, 218, 0.1), transparent);
  transition: left 0.5s;
}

.card-header:hover::before {
  left: 100%;
}

.header-icon {
  width: 40px;
  height: 40px;
  margin-right: 12px;
  object-fit: contain;
  filter: drop-shadow(0 0 10px rgba(100, 255, 218, 0.5));
}

.card-header span {
  flex: 1;
  font-size: 18px;
  font-weight: bold;
  text-shadow: 0 0 10px rgba(100, 255, 218, 0.3);
}

.visualization-content {
  padding: 20px;
  background-color: rgba(16, 25, 45, 0.9);
  height: calc(100% - 70px);
  overflow-y: auto;
}

/* 数据概览 */
.overview-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.overview-card {
  background: rgba(10, 25, 45, 0.8);
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 123, 255, 0.1);
  display: flex;
  align-items: center;
  transition: all 0.3s ease;
  border: 1px solid rgba(100, 255, 218, 0.2);
  position: relative;
  overflow: hidden;
}

.overview-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: linear-gradient(180deg, #007bff, #64ffda);
  box-shadow: 0 0 10px rgba(100, 255, 218, 0.5);
}

.overview-card::after {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(45deg, transparent, rgba(100, 255, 218, 0.05), transparent);
  transform: rotate(45deg);
  animation: shimmer 3s infinite;
}

@keyframes shimmer {
  0% {
    transform: translateX(-100%) rotate(45deg);
  }
  100% {
    transform: translateX(100%) rotate(45deg);
  }
}

.overview-card:hover {
  transform: translateY(-5px) scale(1.02);
  box-shadow: 0 8px 24px rgba(0, 123, 255, 0.3);
  border-color: rgba(100, 255, 218, 0.5);
}

.overview-icon {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: linear-gradient(135deg, #007bff 0%, #64ffda 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  color: #0a192f;
  font-size: 20px;
  box-shadow: 0 0 20px rgba(0, 123, 255, 0.3);
}

.overview-content {
  flex: 1;
}

.overview-number {
  font-size: 24px;
  font-weight: bold;
  color: #64ffda;
  margin-bottom: 4px;
  text-shadow: 0 0 10px rgba(100, 255, 218, 0.3);
}

.overview-label {
  font-size: 14px;
  color: #a3bffa;
}

/* 图表区域 */
.charts-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
  gap: 20px;
}

.chart-card {
  background: rgba(10, 25, 45, 0.8);
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 123, 255, 0.1);
  transition: all 0.3s ease;
  border: 1px solid rgba(100, 255, 218, 0.2);
  position: relative;
  overflow: hidden;
}

.chart-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, #007bff, #64ffda);
  box-shadow: 0 0 10px rgba(100, 255, 218, 0.5);
}

.chart-card::after {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(45deg, transparent, rgba(100, 255, 218, 0.05), transparent);
  transform: rotate(45deg);
  animation: shimmer 3s infinite;
}

.chart-card:hover {
  transform: translateY(-3px) scale(1.01);
  box-shadow: 0 8px 24px rgba(0, 123, 255, 0.3);
  border-color: rgba(100, 255, 218, 0.5);
}

.chart-header {
  margin-bottom: 20px;
}

.chart-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: #64ffda;
  text-shadow: 0 0 10px rgba(100, 255, 218, 0.3);
}

.chart-container {
  height: 350px;
  position: relative;
}

.chart {
  width: 100%;
  height: 100%;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .charts-section {
    grid-template-columns: 1fr;
  }
  
  .chart-container {
    height: 300px;
  }
}

@media (max-width: 768px) {
  .product-visualization-container {
    padding: 0;
  }
  
  .box-card {
    width: 100%;
    height: 100vh;
  }
  
  .visualization-content {
    padding: 15px;
    height: calc(100% - 60px);
  }
  
  .overview-section {
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
  }
  
  .overview-card {
    padding: 15px;
  }
  
  .chart-container {
    height: 250px;
  }
  
  .chart-card {
    padding: 15px;
  }
}

@media (max-width: 480px) {
  .overview-section {
    grid-template-columns: 1fr;
  }
  
  .overview-card {
    flex-direction: column;
    text-align: center;
  }
  
  .overview-icon {
    margin-right: 0;
    margin-bottom: 12px;
  }
  
  .chart-container {
    height: 200px;
  }
  
  .card-header {
    padding: 15px;
  }
  
  .card-header span {
    font-size: 16px;
  }
  
  .header-icon {
    width: 30px;
    height: 30px;
  }
}
</style>