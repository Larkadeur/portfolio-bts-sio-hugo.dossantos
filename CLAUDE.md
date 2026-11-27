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

Autres dossiers du site : `cv/` (CV public, sans téléphone, téléchargeable depuis l'accueil
et le dossier 03), `scripts/` (sources téléchargeables, ex. `Install-GLPIAgent.ps1`),
`preuves/`, `vignettes-mini/`, `veille-archives/`, `outils/` (scripts de travail).
Hors du site (jamais publiés) : `../CV-PRIVE/` (CV complet + source HTML du CV) et
`../PREUVES-SOURCES-PRIVEES/` (originaux non floutés).

## Mise en ligne
- Site public (GitHub Pages, depuis le 25/11/2026) :
  https://larkadeur.github.io/portfolio-bts-sio-hugo.dossantos/
- Dépôt public : https://github.com/Larkadeur/portfolio-bts-sio-hugo.dossantos (branche `main`)
- Publier = `git commit` + `git push` depuis le PC perso ; GitHub Pages reconstruit en 30-60 s.
  Le dépôt est public : rien de non flouté ni de privé ne doit entrer dans le dossier du site.
- Sur le PC du travail (pas de git) : on modifie les fichiers normalement, OneDrive les
  synchronise, et le commit/push se fait le soir depuis le PC perso.
- Si un push échoue en exit 128 : l'environnement force `GCM_INTERACTIVE=never`,
  `GIT_TERMINAL_PROMPT=0` et `GIT_ASKPASS` vide — les neutraliser pour ré-authentifier.

## Travail sur deux machines (OneDrive)
- Ne jamais éditer depuis les deux PC en même temps : OneDrive crée des copies en conflit
  (`fichier-NOMDUPC.html`) et le `.git` partagé supporte mal les écritures concurrentes.
- Avant d'ouvrir le projet, attendre que l'icône OneDrive indique « à jour ».
- Si VS Code affiche « The content of the file is newer » ou « fichier modifié sur le
  disque » : c'est OneDrive qui a remplacé le fichier pendant qu'il était ouvert.
  Choisir **Revert / Rétablir** (garde la version synchronisée) sauf si des modifications
  locales non enregistrées sont à conserver — dans ce cas **Compare** d'abord.
- En début de session, chercher d'éventuelles copies en conflit et les signaler à Hugo.

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

État au 27/11/2026 : 58 pièces fournies, 1 à fournir. **Les dossiers 01 à 10 et 12 sont
complets** ; seul le 11 reste ouvert, car son projet n'est pas lancé. Le 07 a été
débloqué le 27/11 avec 8 captures du commutateur Extreme Networks, et le 09 avec 6 photos
d'un déploiement PXE/MDT de bout en bout sur un poste de test.
Quatre cartes « À fournir » ont été retirées le 27/11 à la demande de Hugo, les preuves
n'existant pas ou étant déjà couvertes : photo de la baie (07), média d'installation (06),
mesure de la visibilité (04), GPO en console GPMC (09). **Ne pas les recréer.**
Quatre points à trancher sont notés en tête de `A-LIRE.txt` (date des tickets
de migration de juillet 2024, mots de passe en clair dans un ticket GLPI, date des
captures du switch, image MDT en retard de deux versions sur le parc).
Le cinquième est réglé : les captures AD du dossier 05 montraient un objet « Contact » ;
elles ont été refaites le 27/11 sur le compte de test `Test E5` dans `MLV/Test OU`
(05-07 formulaire « Nouvel objet – Utilisateur », 05-08 onglet « Membre de »).

Script GLPI : `scripts/Install-GLPIAgent.ps1` ne se réécrit pas. Il contient depuis le
27/11 le script de l'annexe de `projet-glpi.html` (ancre `#annexe`), à l'octet près, et
c'est bien ce script-là qui a servi au test sur un poste. La ligne `msiexec` seule reste
celle retenue pour le déploiement par GPO, comme l'explique la section 10.5 du rapport.
**Ne pas proposer d'en écrire une autre version.**

Les photos de déploiement sont des photos d'écran, pas des captures : elles vivent en
`.jpg` dans `preuves/09-deploiement-postes/`. Attention, `outils/flouter.ps1` enregistre
toujours en PNG — pour une photo, masquer et réduire avec un traitement dédié, sinon le
fichier passe de 300 Ko à plusieurs Mo.

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
