# Phase 1 Patch Applier - Qualified Candidates Frontend
Write-Host "🚀 Starting Phase 1 Patches..." -ForegroundColor Cyan

if (Test-Path "src\App.tsx") {
    Copy-Item "src\App.tsx" "src\App.tsx.backup" -Force
    Write-Host "✅ Backed up App.tsx → src\App.tsx.backup" -ForegroundColor Green
}

if (Test-Path "App.tsx.cleaned") {
    Copy-Item "App.tsx.cleaned" "src\App.tsx" -Force
    Write-Host "✅ Applied cleaned App.tsx successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Error: App.tsx.cleaned not found!" -ForegroundColor Red
    exit 1
}

Write-Host "`n🎉 Phase 1 patches applied successfully!" -ForegroundColor Green
Write-Host "Run this to test:" -ForegroundColor Yellow
Write-Host "npm run dev" -ForegroundColor White

Read-Host "`nPress Enter to exit"