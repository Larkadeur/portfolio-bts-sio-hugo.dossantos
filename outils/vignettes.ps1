<#
    vignettes.ps1 — genere des versions allegees des captures pour l'affichage.

    Les pages chargent les vignettes ; les fichiers d'origine, pleine
    resolution, restent utilises par les lightbox (data-gallery / data-full).

    Les vignettes sont ecrites dans vignettes/, en conservant l'arborescence
    de la source, avec l'extension .jpg.

    Exemple :
      .\outils\vignettes.ps1 -Dossier "preuves" -LargeurMax 400
      .\outils\vignettes.ps1 -Dossier "certifs" -LargeurMax 800 -Qualite 88

    Relancer le script regenere les vignettes manquantes ou perimees
    (une vignette plus ancienne que sa source est refaite).
#>
param(
    [Parameter(Mandatory = $true)][string]$Dossier,
    [int]$LargeurMax = 400,
    [int]$Qualite = 85,
    # Dossier de destination : "vignettes" pour les pages de lecture,
    # "vignettes-mini" pour les miniatures du dossier de preuves.
    [string]$Sortie = "vignettes",
    [switch]$Force
)

Add-Type -AssemblyName System.Drawing

$racine = Split-Path $PSScriptRoot -Parent
$source = Join-Path $racine $Dossier
if (-not (Test-Path $source)) { throw "Dossier introuvable : $source" }

$encodeur = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
            Where-Object { $_.MimeType -eq 'image/jpeg' }
$params = New-Object System.Drawing.Imaging.EncoderParameters(1)
$params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality, [long]$Qualite)

$faites = 0; $ignorees = 0; $poidsAvant = 0; $poidsApres = 0

Get-ChildItem $source -Recurse -Include *.png, *.jpg, *.jpeg -File | ForEach-Object {
    $rel = $_.FullName.Substring($racine.Length + 1)
    $cible = Join-Path $racine ($Sortie + "\" + [System.IO.Path]::ChangeExtension($rel, ".jpg"))

    if ((Test-Path $cible) -and -not $Force -and (Get-Item $cible).LastWriteTime -ge $_.LastWriteTime) {
        $ignorees++
        $poidsAvant += $_.Length; $poidsApres += (Get-Item $cible).Length
        return
    }

    $dir = Split-Path $cible -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    # Copie en memoire : evite de verrouiller le fichier source
    $octets = [System.IO.File]::ReadAllBytes($_.FullName)
    $flux = New-Object System.IO.MemoryStream(,$octets)
    $src = [System.Drawing.Image]::FromStream($flux)

    $largeur = [Math]::Min($LargeurMax, $src.Width)
    $hauteur = [int][Math]::Round($src.Height * ($largeur / $src.Width))

    $bmp = New-Object System.Drawing.Bitmap($largeur, $hauteur)
    $bmp.SetResolution(96, 96)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    # Fond blanc : les captures n'ont pas de transparence, et le JPEG n'en gere pas
    $g.Clear([System.Drawing.Color]::White)
    $g.DrawImage($src, 0, 0, $largeur, $hauteur)
    $g.Dispose()

    $bmp.Save($cible, $encodeur, $params)
    $bmp.Dispose(); $src.Dispose(); $flux.Dispose()

    $poidsAvant += $_.Length
    $poidsApres += (Get-Item $cible).Length
    $faites++
}

"{0} : {1} generees, {2} a jour | {3} Ko -> {4} Ko ({5} % du poids d'origine)" -f `
    $Dossier, $faites, $ignorees,
    [math]::Round($poidsAvant/1KB), [math]::Round($poidsApres/1KB),
    [math]::Round(100 * $poidsApres / [Math]::Max(1, $poidsAvant))
