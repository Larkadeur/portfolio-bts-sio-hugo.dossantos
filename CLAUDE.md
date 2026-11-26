# Portfolio BTS SIO SISR — Contexte projet

## Structure
Site en 4 pages HTML, sans build :
- `index.html` — page d'accueil, contient le tableau de synthèse E5
- `preuves-E5.html` — dossier de preuves de l'épreuve E5
- `veille-cryptographie.html` — veille technologique
- `projet-glpi.html` — page projet GLPI

Le projet est sur OneDrive et s'ouvre sous deux chemins selon la machine :
`C:\Users\hugor\...` (PC perso, git installé) et
`C:\Users\hugo.dossantos\...` (PC du travail, pas de git).

## Charte graphique
- Thème unifié vert/bleu
- Typographies : DM Serif Display (titres), Outfit (texte courant), DM Mono (code/accents techniques)

## Fonctionnalités
- Galerie de certifications en lightbox (Cisco, ANSSI EBIOS, CNIL RGPD)
- Tableau de compétences E5 synchronisé en direct avec un fichier .xlsx

## Page veille cryptographie
- Cadence : un article par mois
- Objectif : ~12 articles d'ici mars-avril 2027
- Articles collectés jusqu'à novembre 2026 (12 articles)
- Dernier article en date : suppression de l'article 16 bis interdisant les portes dérobées (novembre 2026)
- Une copie PDF de chaque article est archivée dans `veille-archives/`, nommée `AAAA-MM_source_sujet.pdf`
- Au 26/11/2026 : 12 PDF archivés sur 12. Celui du 16 juin 2026 (Tech Insider) vient d'une
  copie Web Archive, l'original étant supprimé (410 Gone)
- Dans `preuves-E5.html`, la carte « Articles archivés en PDF » ouvre une fenêtre listant
  tous les PDF (`#pdf-modal`) : ajouter une ligne `<li>` à chaque nouvel article archivé
- Source des PDF bruts : `../Veille Informatique cryptographie/journaux intéréssants/`

## Dossier de preuves E5
Hugo dépose ses captures en vrac dans `PREUVES-A-TRIER/` et dit « intègre les preuves ».
Le travail attendu : identifier chaque fichier en l'ouvrant, flouter, ranger dans
`preuves/NN-nom/NN-MM_sujet.png`, générer les vignettes, écrire la légende dans
`preuves-E5.html`, déplacer les originaux vers `../PREUVES-SOURCES-PRIVEES/AAAA-MM-JJ/`
(hors du site), puis mettre à jour `PREUVES-A-TRIER/A-LIRE.txt`.

**`PREUVES-A-TRIER/A-LIRE.txt` est la source de vérité** sur ce qui reste à fournir.
Le lire avant de répondre à « qu'est-ce qu'il me reste à faire ». Chaque pièce manquante
y est taguée `[TT]` (faisable de chez lui) ou `[SITE]` (nécessite d'être dans l'entreprise).

Outils : `outils/flouter.ps1` (pixellise ; option `-Plein` pour un masque noir opaque,
obligatoire sur les mots de passe) et `outils/vignettes.ps1` (vignettes 400 px dans
`vignettes-mini/` ; les lightbox chargent les PNG pleine résolution).

### Anonymisation
Masquer : nom d'hôte du contrôleur de domaine, identités de tiers, numéros de série,
comptes de service, secrets. Laisser visible : le nom de domaine, les unités
d'organisation, les adresses IP privées, le nom de Hugo. **Ne pas surflouter** — la
substance technique est ce qui prouve la compétence.

### Rédaction des cartes
Une seule phrase de 15 mots maximum, disant ce que montre la capture. Pas de détail
technique ni d'énumération. Garder les précisions d'honnêteté en version courte
(« sur un compte de test »). Les mentions de floutage vont dans les légendes de la
lightbox, pas sur la carte. Les cartes « À fournir » gardent leur texte long.

## Instructions pour Claude Code
- Respecter la charte graphique et les typographies ci-dessus pour toute nouvelle page ou section
- Le tableau E5 doit rester synchronisé avec le fichier xlsx source — demander où il se trouve si non fourni
- Pour la page veille, respecter le rythme mensuel et le format des articles déjà en place
- Pour ce jury, une capture lisible vaut mieux qu'un fichier texte (sauf pour du code)
