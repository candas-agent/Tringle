# Support de cintres pour placard (OpenSCAD)

Remplace les deux supports de cintres d'origine, jugés fragiles. Le nouveau support est une **poutre ajourée**, fixée à deux endroits :

* **sous l'étagère du haut**, avec 2 vis à bois posées par en dessous. Rien ne traverse l'étagère, et c'est cette fixation qui porte la charge ;
* **contre le fond du placard**, avec 2 vis à bois (en appui et pour le maintien).

Il compte **5 logements en U**, un par cintre. Le crochet glisse tout seul au point bas de son logement et ne peut pas passer dans le voisin.

![aperçu](images/apercu.png)

| Pièce | Profil |
|---|---|
| ![pièce](images/piece.png) | ![profil](images/profil.png) |

## Forme

Seules les deux faces d'appui sont planes : le dessus, contre l'étagère, et le dos, contre le fond du placard. Tout le reste est galbé :

* 5 logements identiques, aux angles hauts arrondis et au fond en demi-cercle, séparés par des montants qui relient la barre haute au bras ;
* l'avant descend droit puis s'enroule dans un grand arrondi (R45) vers le dessous ;
* le dessous du bras forme une seule courbe, plus épaisse près du fond, là où l'effort est le plus grand, qui plonge en douceur dans la queue portant les vis du fond ;
* les arêtes sont adoucies : quart de rond sur le dessus à l'impression, chanfrein à 45° côté plateau pour éviter les supports.

Pour régler la forme : `r_galbe` (arrondi avant-bas), `ventre` (galbe sous le bras), `r_haut` (angles hauts des logements), `ep_montant` (largeur des montants) et `r_bord` (arrondi des arêtes).

## Pourquoi une poutre ajourée

Les supports d'origine sont des porte-à-faux : toute la charge fait levier sur deux petites vis plantées dans le fond, qui est souvent un panneau mince. Ici, le bras est relié à la barre haute tous les 40 mm par les montants, et la barre haute est vissée sous l'étagère. Le couple créé par les vestes est donc repris surtout par la vis avant de l'étagère, qui travaille en traction, et par l'appui de la barre haute contre l'étagère.

Les crochets s'accrochent **par le côté**, dans leur logement. Chaque logement offre 32 mm de large et 55 mm de haut au-dessus de son point bas.

Ordre de grandeur pour 5 vestes de 2 kg : environ 15 N·m au niveau du dos, soit à peu près 80 N de traction sur la vis avant. Une vis Ø4 enfoncée de 11 mm dans de l'aggloméré résiste à quelques centaines de newtons à l'arrachement. Avec les montants, toute la pièce travaille comme un seul bloc.

## Encombrement (valeurs par défaut)

* Profondeur de la pièce : **245 mm**.
* Cintres à 48, 88, 128, 168 et 208 mm du fond.
* La veste la plus en avant dépasse d'environ 60 mm devant son crochet, soit à peu près **268 mm**. On reste sous les **300 mm** de la porte.
* Hauteur : 151 mm. Largeur : 20 mm.

Le fichier contient des `assert` : si vous changez un paramètre et que la pièce ou la dernière veste risque de toucher la porte, **le rendu s'arrête avec un message**. Pensez à mesurer la profondeur réelle entre le fond et la porte fermée, puis à régler `profondeur_placard`.

## Paramètres principaux (`support_cintres.scad`)

| Paramètre | Défaut | Rôle |
|---|---|---|
| `profondeur_placard` | 300 | fond → porte fermée |
| `marge_veste` | 60 | épaisseur de veste devant le dernier crochet |
| `longueur` | 245 | profondeur de la pièce |
| `nb_cintres`, `pas` | 5, 40 | nombre de logements et entraxe |
| `ep_montant` | 8 | largeur des montants (logements de `pas - ep_montant` = 32 mm) |
| `haut_crochet` | 45 | hauteur de vos crochets (à mesurer) |
| `largeur` | 20 | largeur du bras, qui doit passer dans le crochet |
| `r_galbe`, `ventre`, `r_haut`, `r_bord` | 45, 5, 10, 2,5 | arrondis et galbes |
| `ep_etagere` | 18 | épaisseur de l'étagère (**à mesurer**) |
| `long_vis_etagere` | 16 | longueur des vis de l'étagère |

Avec `apercu = true`, le fichier affiche l'étagère, le fond, la porte (trait rouge) et les cintres. **N'exportez pas le STL avec cette option active.**

## Impression

* **PETG recommandé.** Le PLA flue sous une charge permanente, surtout dans un placard chaud, et le bras finirait par s'affaisser.
* Imprimez la pièce **couchée sur le côté**, avec la grande face plate sur le plateau. Les couches suivent alors le cadre, ce qui donne l'orientation la plus solide. Aucun support n'est nécessaire.
* 5 périmètres (parois de 2 mm ou plus), 5 couches dessus et dessous, remplissage gyroïde de 40 %.
* Il faut un plateau d'au moins 250 mm (Prusa MK4, Bambu, etc.). Pour un plateau de 220 mm, réduisez `longueur` et `nb_cintres`/`pas`.

## Montage

### Comment on visse sous l'étagère

Les 2 vis de l'étagère sont placées dans les deux parties pleines de la pièce : à l'arrière, entre le dos et le 1er logement (à 20 mm du fond), et à l'avant, devant le dernier logement (à 234,5 mm du fond). Leur position est calculée automatiquement. Chaque vis a sa tête noyée dans un lamage Ø9, avec 5 mm de plastique sous la tête. Un **tunnel vertical Ø10** traverse la partie pleine depuis le dessous : on y passe le tournevis par en dessous pour atteindre la vis.

![dessous](images/dessous.png)

* Avec des vis de 16 mm, il en entre **11 mm dans le bois**. Pour une étagère de 18 mm, il reste donc 7 mm avant de ressortir sur le dessus.
* Si votre étagère est plus fine, indiquez `ep_etagere` : le fichier refuse de générer la pièce si les vis risquent de ressortir.
* Un tournevis de Ø9 maximum passe dans les tunnels : un tournevis cruciforme PH2 classique, ou un embout sur une rallonge fine.
* Il faut une longueur d'au moins 10 cm entre la poignée et la pointe.
* Prenez un embout aimanté, ou bien plantez la vis dans son trou avant de présenter la pièce.

### Matériel

* 2 vis à bois **Ø4 × 16 mm** pour l'étagère, à tête plate ou fraisée de Ø8 maximum.
* 2 vis à bois **Ø4 × 12 à 16 mm** à tête fraisée pour le fond. Elles ne doivent pas traverser le fond.

### Étapes

1. Mettez la pièce en place : plaquez-la contre le fond et sous l'étagère.
2. Pré-percez l'étagère à Ø2,5 sur 10 mm de profondeur, à travers les trous de la pièce. Pour ne pas percer trop loin, mettez un bout de scotch sur le foret comme repère.
3. Vissez les 2 vis de l'étagère par en dessous, à travers les tunnels. Commencez par la vis avant (la plus proche de la porte), c'est celle qui travaille le plus.
4. Vissez les 2 vis du fond, sous le bras. On y accède de face.

Le fond d'une armoire est souvent un panneau mince de 3 mm. Ce n'est pas un problème ici, car il ne sert que d'appui : la charge passe par l'étagère.
