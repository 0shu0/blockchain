<template>
  <div class="product-visualization-container">
    <el-card class="box-card" shadow="hover">
      <div ref="visualizationContent" class="visualization-content">
        <iframe
          ref="ldvsIframe"
          class="visualization-iframe"
          :src="ldvsUrl"
          @load="handleIframeLoad"
          frameborder="0"
          scrolling="no"
          title="Large Data Visualization Screen"
        />
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "ProductVisualization",
  data() {
    return {
      ldvsUrl: '/LDVS/Large%20data%20visualization%20screen.html'
    };
  },
  methods: {
    handleIframeLoad() {
      const iframe = this.$refs.ldvsIframe;
      if (!iframe) return;
      const iframeDoc = iframe.contentDocument || (iframe.contentWindow && iframe.contentWindow.document);
      if (!iframeDoc) return;
      const style = iframeDoc.createElement('style');
      style.textContent = `
        html, body {
          width: 100%;
          height: 100%;
          overflow: hidden !important;
        }
        .loading,
        .copyright {
          display: none !important;
        }
        .head {
          display: block !important;
          height: 0.86rem !important;
        }
        .head h1 {
          line-height: 0.72rem !important;
          font-size: 0.34rem !important;
        }
        .mainbox {
          padding: 0.08rem 0.1rem 0 0.1rem !important;
          margin: 0 !important;
          width: 100% !important;
          height: calc(100vh - 0.86rem) !important;
          overflow: hidden !important;
        }
      `;
      iframeDoc.head.appendChild(style);
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

.visualization-content {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
  background: #00164a;
}

.visualization-iframe {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border: 0;
}

:deep(.el-card__body) {
  padding: 0;
  height: 100%;
}

@media (max-width: 768px) {
  .product-visualization-container {
    padding: 0;
  }
  
  .box-card {
    width: 100%;
    height: 100vh;
  }
}
</style>