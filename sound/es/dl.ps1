# Dossier de sortie : ici le dossier courant
$OutputDir = "."

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

#########################
# 1) Lettres A à Z
#########################

$baseUrlLetters = "https://aprenderespanol.org/ejercicios/gramatica/alfabeto/letras/{0}.mp3"

foreach ($c in 'a'..'z') {
    $lower = [string]$c
    $upper = $lower.ToUpper()

    $url = [string]::Format($baseUrlLetters, $lower)
    $outFile = Join-Path $OutputDir ("{0}.mp3" -f $upper)

    Write-Host "Téléchargement de la lettre $upper depuis $url ..."

    try {
        Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $outFile
        Write-Host "✅ Sauvegardé : $outFile"
    }
    catch {
        Write-Host "❌ Erreur pour la lettre $upper : $_"
    }
}

#########################
# 2) Chiffres 0 à 9
#########################

$baseUrlDigits = "https://aprenderespanol.org/ejercicios/vocabulario/numeros/audio/a-{0}.mp3"

foreach ($digit in 0..9) {
    $url = [string]::Format($baseUrlDigits, $digit)
    $outFile = Join-Path $OutputDir ("{0}.mp3" -f $digit)

    Write-Host "Téléchargement du chiffre $digit depuis $url ..."

    try {
        Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $outFile
        Write-Host "✅ Sauvegardé : $outFile"
    }
    catch {
        Write-Host "❌ Erreur pour le chiffre $digit : $_"
    }
}
