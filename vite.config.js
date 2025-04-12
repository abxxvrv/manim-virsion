import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  base: './', // 设置为相对路径
  plugins: [
    vue(),
    {
      name: 'copy-assets',
      enforce: 'post',
      apply: 'build',
      generateBundle() {
        // 这个钩子允许我们在build时确保资源被正确处理
        console.log('Assets will be copied to the correct location');
      }
    },
    {
      name: 'vite-plugin-txt',
      transform(code, id) {
        if (id.endsWith('.txt')) {
          return {
            code: `export default ${JSON.stringify(code)};`,
            map: null
          };
        }
      }
    }
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  build: {
    assetsInlineLimit: 1024 * 1024 * 20, // 20MB阈值
    chunkSizeWarningLimit: 1500,
    rollupOptions: {
      output: {
        assetFileNames: 'assets/[name].[hash].[ext]', // 将资源输出到assets目录
        chunkFileNames: 'js/[name].[hash].js',
        manualChunks(id) {
          // 将资源分组存放
          if (id.includes('node_modules')) {
            return 'vendor';
          }
        }
      }
    }
  },
  server: {
    fs: {
      strict: false // 允许访问项目外部的视频文件
    },
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:8080',
        secure: false,
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
      },
      '/chat/message': {
        target: 'http://127.0.0.1:8080',
        secure: false,
        changeOrigin: true
      }
    }
  }
})
