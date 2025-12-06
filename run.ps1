# 运行鸿蒙一键构建部署脚本（单模块模式）- Windows PowerShell版本
# 使用前请确保 hdc 已连接设备，DevEco Studio 工具链已安装

# ================== 可配置变量 ==================
# 项目包名(根据实际项目包名修改!!!!!)  
$BUNDLE_NAME = "com.example.Mood Journal Calendar"
# ================== 可配置变量 ==================

# ================== 固定的变量 ==================
# 临时目录名（使用随机字符串避免冲突）
$TMP_DIR = "hm_deploy_tmp_" + [System.Guid]::NewGuid().ToString("N").Substring(0, 16)
# HAP 包路径
$ENTRY_HAP = "entry\build\default\outputs\default\entry-default-unsigned.hap"
# ================== 固定的变量 ==================

# 设置错误时停止执行
$ErrorActionPreference = "Stop"

try {
    Write-Host "1. 安装依赖..." -ForegroundColor Green
    ohpm install --all --registry https://ohpm.openharmony.cn/ohpm/ --strict_ssl true

    Write-Host "2. 构建项目..." -ForegroundColor Green
    hvigorw assembleApp

    Write-Host "3. 停止正在运行的应用..." -ForegroundColor Green
    try {
        hdc shell aa force-stop "$BUNDLE_NAME"
    } catch {
        Write-Host "应用未运行或停止失败，继续执行..." -ForegroundColor Yellow
    }

    Write-Host "4. 创建设备临时目录..." -ForegroundColor Green
    Write-Host "  执行命令: hdc shell mkdir -p data/local/tmp/$TMP_DIR" -ForegroundColor Gray
    hdc shell mkdir -p "data/local/tmp/$TMP_DIR"

    Write-Host "5. 传输 HAP 包到设备..." -ForegroundColor Green
    Write-Host "  - 传输 entry.hap..." -ForegroundColor Cyan
    Write-Host "  执行命令: hdc file send $ENTRY_HAP data/local/tmp/$TMP_DIR/" -ForegroundColor Gray
    hdc file send "$ENTRY_HAP" "data/local/tmp/$TMP_DIR/"

    Write-Host "6. 安装应用包..." -ForegroundColor Green
    hdc shell bm install -p "data/local/tmp/$TMP_DIR"

    Write-Host "7. 清理设备临时文件..." -ForegroundColor Green
    hdc shell rm -rf "data/local/tmp/$TMP_DIR"

    Write-Host "8. 启动应用..." -ForegroundColor Green
    hdc shell aa start -a EntryAbility -b "$BUNDLE_NAME" -m entry

    Write-Host "✅ 构建部署完成！应用已成功启动" -ForegroundColor Green

} catch {
    Write-Host "❌ 构建部署失败: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "请检查错误信息并重试" -ForegroundColor Red
    exit 1
}
