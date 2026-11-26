<#
    flouter.ps1 — pixellise des zones d'une capture d'écran avant publication.

    Sert à masquer les données internes (noms d'utilisateurs, numéros de série,
    adresses, identifiants) sur les preuves publiées dans preuves-E5.html.

    Exemple :
      .\outils\flouter.ps1 -In "source.png" -Out "cible.png" -Zones "10,20,300,40; 500,20,200,40"

    Les zones sont en pixels : x,y,largeur,hauteur, séparées par des points-virgules.
    La pixellisation est destructive : le fichier de sortie ne permet pas de
    retrouver le contenu masqué.
#>
param(
    [Parameter(Mandatory = $true)][string]$In,
    [Parameter(Mandatory = $true)][string]$Out,
    [Parameter(Mandatory = $true)][string]$Zones,
    [int]$Bloc = 10,
    # Remplit les zones en noir plein au lieu de les pixelliser.
    # A utiliser pour les secrets (mots de passe, cles) : la pixellisation
    # d'un texte court laisse une empreinte theoriquement exploitable.
    [switch]$Plein
)

Add-Type -AssemblyName System.Drawing

# Copie en mémoire pour ne pas garder le fichier source verrouillé
$bytes  = [System.IO.File]::ReadAllBytes($In)
$stream = New-Object System.IO.MemoryStream(,$bytes)
$src    = [System.Drawing.Image]::FromStream($stream)
$bmp    = New-Object System.Drawing.Bitmap($src)
$src.Dispose()
$stream.Dispose()

$g = [System.Drawing.Graphics]::FromImage($bmp)

foreach ($zone in ($Zones -split ';')) {
    $zone = $zone.Trim()
    if (-not $zone) { continue }
    $p = $zone -split ',' | ForEach-Object { [int]$_.Trim() }
    if ($p.Count -ne 4) { throw "Zone invalide : '$zone' (attendu x,y,largeur,hauteur)" }

    # On reste dans les limites de l'image
    $x = [Math]::Max(0, $p[0]); $y = [Math]::Max(0, $p[1])
    $w = [Math]::Min($p[2], $bmp.Width  - $x)
    $h = [Math]::Min($p[3], $bmp.Height - $y)
    if ($w -le 0 -or $h -le 0) { continue }

    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)

    if ($Plein) {
        $g.FillRectangle([System.Drawing.Brushes]::Black, $rect)
        continue
    }

    $petitW = [Math]::Max(1, [int]($w / $Bloc))
    $petitH = [Math]::Max(1, [int]($h / $Bloc))

    # Réduction (moyenne les couleurs) puis agrandissement en blocs nets
    $petit = New-Object System.Drawing.Bitmap($petitW, $petitH)
    $gp = [System.Drawing.Graphics]::FromImage($petit)
    $gp.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBilinear
    $gp.DrawImage($bmp, (New-Object System.Drawing.Rectangle(0, 0, $petitW, $petitH)), $rect, [System.Drawing.GraphicsUnit]::Pixel)
    $gp.Dispose()

    $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
    $g.DrawImage($petit, $rect)
    $petit.Dispose()
}

$g.Dispose()

$dossier = Split-Path $Out -Parent
if ($dossier -and -not (Test-Path $dossier)) { New-Item -ItemType Directory -Path $dossier -Force | Out-Null }

$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

Write-Output "OK : $Out"
