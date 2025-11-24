# Dossier de sortie : dossier courant
$OutputDir = "."

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

# -------------------------
# Headers communs
# -------------------------
$headers = @{
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36"
    "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
    "Cookie" = "AKA_A2=A"
}

#########################
# 1) Lettres A à Z
#########################

$baseUrlLetters = "https://www.lepointdufle.net/apprendre_a_lire/a/let/{0}.mp3"

foreach ($c in 'a'..'z') {
    $lower = [string]$c
    $upper = $lower.ToUpper()

    $url = [string]::Format($baseUrlLetters, $lower)
    $outFile = Join-Path $OutputDir ("{0}.mp3" -f $upper)

    Write-Host "Téléchargement de la lettre $upper depuis $url ..."

    try {
        Invoke-WebRequest -Uri $url -Headers $headers -OutFile $outFile -UseBasicParsing
        Write-Host "✅ Sauvegardé : $outFile"
    }
    catch {
        Write-Host "❌ Erreur pour la lettre $upper : $_"
    }
}

#########################
# 2) Chiffres 0 à 9
#########################
# Session identique à celle copiée depuis Chrome
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36"
$session.Cookies.Add((New-Object System.Net.Cookie("AKA_A2", "A", "/", ".tv5monde.com")))

# Dossier de sortie : courant
$OutputDir = "."

# Headers de base (repris de ta requête)
$headers = @{
    "authority"              = "apprendre.tv5monde.com"
    "accept"                 = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
    "accept-encoding"        = "gzip, deflate, br, zstd"
    "accept-language"        = "fr-FR,fr;q=0.9"
    "cache-control"          = "no-cache"
    "pragma"                 = "no-cache"
    "priority"               = "u=0, i"
    "sec-ch-ua"              = "`"Chromium`";v=`"142`", `"Google Chrome`";v=`"142`", `"Not_A Brand`";v=`"99`""
    "sec-ch-ua-mobile"       = "?0"
    "sec-ch-ua-platform"     = "`"Windows`""
    "sec-fetch-dest"         = "document"
    "sec-fetch-mode"         = "navigate"
    "sec-fetch-site"         = "none"
    "sec-fetch-user"         = "?1"
    "upgrade-insecure-requests" = "1"
    # "method", "scheme" et "path" seront mis à jour / gérés par PowerShell ou dans la boucle
}

$baseUrl = "https://apprendre.tv5monde.com/sites/apprendre.tv5monde.com/files/audio"

# Mapping chiffre -> nom de fichier sur le site
$digitFiles = @{
    "0" = "1947_vignette_aide-zero.mp3"
    "1" = "1812_vignette_structurer-un_0.mp3"
    "2" = "1949_vignette_aide-deux.mp3"
    "3" = "1950_vignette_aide-trois.mp3"
    "4" = "1951_vignette_aide-quatre.mp3"
    "5" = "1952_vignette_aide-cinq.mp3"
    "6" = "1953_vignette_aide-six.mp3"
    "7" = "1954_vignette_aide-sept.mp3"
    "8" = "1955_vignette_aide-huit.mp3"
    "9" = "1956_vignette_aide-neuf.mp3"
}

foreach ($digit in $digitFiles.Keys) {
    $remoteName = $digitFiles[$digit]
    $url = "$baseUrl/$remoteName"

    # Si tu veux rester au plus proche de Chrome, on peut mettre à jour le header path :
    $headers["path"] = "/sites/apprendre.tv5monde.com/files/audio/$remoteName"
    $headers["method"] = "GET"
    $headers["scheme"] = "https"

    $outFile = Join-Path $OutputDir ("{0}.mp3" -f $digit)

    Write-Host "Téléchargement du chiffre $digit depuis $url ..."

    try {
        Invoke-WebRequest -UseBasicParsing -Uri $url -WebSession $session -Headers $headers -OutFile $outFile
        Write-Host "✅ Sauvegardé : $outFile"
    }
    catch {
        Write-Host "❌ Erreur pour le chiffre $digit : $_"
    }
}
