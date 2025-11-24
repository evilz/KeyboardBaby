# Dossier de sortie : courant
$OutputDir = ".\de_audio"
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36"

# Chiffres 0-9 en allemand
$numbers = @{
    "0" = "null"; "1" = "eins"; "2" = "zwei"; "3" = "drei"; "4" = "vier";
    "5" = "fünf"; "6" = "sechs"; "7" = "sieben"; "8" = "acht"; "9" = "neun"
}

foreach ($digit in $numbers.Keys) {
    $text = [uri]::EscapeDataString($numbers[$digit])
    $url = "https://readle-app.com/polly/?text=$text&language=de"
    $outFile = Join-Path $OutputDir ("{0}.mp3" -f $digit)
    Write-Host "Téléchargement du chiffre $digit ($text) depuis $url …"
    try {
        Invoke-WebRequest -Uri $url -WebSession $session -OutFile $outFile -UseBasicParsing
        Write-Host "✅ Sauvegardé : $outFile"
    }
    catch {
        Write-Host "❌ Erreur pour le chiffre $digit : $_"
    }
}

# Lettres A-Z en allemand
foreach ($c in 'A'..'Z') {
    $text = [uri]::EscapeDataString($c)
    $url = "https://readle-app.com/polly/?text=$text&language=de"
    $outFile = Join-Path $OutputDir ("{0}.mp3" -f $c)
    Write-Host "Téléchargement de la lettre $c depuis $url …"
    try {
        Invoke-WebRequest -Uri $url -WebSession $session -OutFile $outFile -UseBasicParsing
        Write-Host "✅ Sauvegardé : $outFile"
    }
    catch {
        Write-Host "❌ Erreur pour la lettre $c : $_"
    }
}
