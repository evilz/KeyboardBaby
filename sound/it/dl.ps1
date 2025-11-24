# Dossier de sortie : ici le dossier courant
$OutputDir = "."

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

# Mapping lettre -> URL audio
$letters = @{
    "A" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180375-RI1_LC_1.5_57.mp3"
    "B" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180376-RI1_LC_1.5_58.mp3"
    "C" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180377-RI1_LC_1.5_59.mp3"
    "D" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180378-RI1_LC_1.5_60.mp3"
    "E" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180379-RI1_LC_1.5_61.mp3"
    "F" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180380-RI1_LC_1.5_62.mp3"
    "G" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180381-RI1_LC_1.5_63.mp3"
    "H" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180382-RI1_LC_1.5_64.mp3"
    "I" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180383-RI1_LC_1.5_65.mp3"
    "J" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180384-RI1_LC_1.5_66.mp3"
    "K" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180385-RI1_LC_1.5_67.mp3"
    "L" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180386-RI1_LC_1.5_68.mp3"
    "M" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180387-RI1_LC_1.5_69.mp3"
    "N" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180388-RI1_LC_1.5_70.mp3"
    "O" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180389-RI1_LC_1.5_71.mp3"
    "P" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180390-RI1_LC_1.5_72.mp3"
    "Q" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180391-RI1_LC_1.5_73.mp3"
    "R" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180392-RI1_LC_1.5_74.mp3"
    "S" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180393-RI1_LC_1.5_75.mp3"
    "T" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180394-RI1_LC_1.5_76.mp3"
    "U" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180395-RI1_LC_1.5_77.mp3"
    "V" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180396-RI1_LC_1.5_78.mp3"
    "W" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180397-RI1_LC_1.5_79.mp3"
    "X" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180398-RI1_LC_1.5_80.mp3"
    "Y" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180399-RI1_LC_1.5_81.mp3"
    "Z" = "https://d2jkfj9lazd7el.cloudfront.net/audio/phrase/italian/180400-RI1_LC_1.5_82.mp3"
}

foreach ($letter in $letters.Keys) {
    $url = $letters[$letter]
    $outFile = Join-Path $OutputDir ("{0}.mp3" -f $letter)

    Write-Host "Téléchargement de la lettre $letter depuis $url ..."

    try {
        Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $outFile
        Write-Host "✅ Sauvegardé : $outFile"
    }
    catch {
        Write-Host "❌ Erreur pour la lettre $letter : $_"
    }
}

#########################
# 2) Chiffres italiens 0 à 9 via Readle Polly
#    URL de base : https://readle-app.com/polly/?text=<mot>&language=it
#########################

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36"

$numberWords = @{
    "0" = "zero"
    "1" = "uno"
    "2" = "due"
    "3" = "tre"
    "4" = "quattro"
    "5" = "cinque"
    "6" = "sei"
    "7" = "sette"
    "8" = "otto"
    "9" = "nove"
}

foreach ($digit in $numberWords.Keys) {
    $word = $numberWords[$digit]
    $encoded = [uri]::EscapeDataString($word)

    $url     = "https://readle-app.com/polly/?text=$encoded&language=it"
    $outFile = Join-Path $OutputDir ("{0}.mp3" -f $digit)

    Write-Host "Téléchargement du chiffre $digit ($word) depuis $url ..."

    try {
        Invoke-WebRequest -UseBasicParsing -Uri $url -WebSession $session -OutFile $outFile
        Write-Host "✅ Sauvegardé : $outFile"
    }
    catch {
        Write-Host "❌ Erreur pour le chiffre $digit : $_"
    }
}