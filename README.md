# Support de cintres pour placard (OpenSCAD)

Remplace les deux supports de cintres d'origine, jugés fragiles. Le nouveau support est un **cadre fermé**, fixé à deux endroits :

* **sous l'étagère du haut**, avec 3 vis à bois posées par en dessous. Rien ne traverse l'étagère, et c'est cette fixation qui porte la charge ;
* **contre le fond du placard**, avec 2 vis à bois (en appui et pour le maintien).

Le bras porte **5 encoches** séparées par des bosses de 9 mm. Chaque cintre retombe dans son propre logement.

![aperçu](images/apercu.png)

| Pièce | Profil |
|---|---|
| ![pièce](images/piece.png) | ![profil](images/profil.png) |

## Pourquoi un cadre fermé

Les supports d'origine sont des porte-à-faux : toute la charge fait levier sur deux petites vis plantées dans le fond, qui est souvent un panneau mince. Ici, le bras est tenu **aux deux bouts**, par le dos d'un côté et par le poteau avant de l'autre. Le poteau avant est accroché à l'étagère. Le couple créé par les vestes est donc repris surtout par la vis avant de l'étagère, qui travaille en traction, et par l'appui de la barre haute contre l'étagère.

Les crochets s'accrochent **par le côté**, à travers la fenêtre du cadre. On dispose de 60 mm de dégagement au-dessus du fond des encoches, ce qui laisse soulever un cintre au-dessus d'une bosse.

Ordre de grandeur pour 5 vestes de 2 kg : environ 15 N·m au niveau du dos, soit à peu près 80 N de traction sur la vis avant. Une vis Ø4 enfoncée de 11 mm dans de l'aggloméré résiste à quelques centaines de newtons à l'arrachement, et les 3 vis se partagent l'effort vertical.

## Encombrement (valeurs par défaut)

* Profondeur de la pièce : **245 mm**.
* Encoches à 48, 88, 128, 168 et 208 mm du fond.
* La veste la plus en avant dépasse d'environ 60 mm devant son crochet, soit à peu près **268 mm**. On reste sous les **300 mm** de la porte.
* Hauteur : 136 mm. Largeur : 20 mm.

Le fichier contient des `assert` : si vous changez un paramètre et que la pièce ou la dernière veste risque de toucher la porte, **le rendu s'arrête avec un message**. Pensez à mesurer la profondeur réelle entre le fond et la porte fermée, puis à régler `profondeur_placard`.

## Paramètres principaux (`support_cintres.scad`)

| Paramètre | Défaut | Rôle |
|---|---|---|
| `profondeur_placard` | 300 | fond → porte fermée |
| `marge_veste` | 60 | épaisseur de veste devant le dernier crochet |
| `longueur` | 245 | profondeur de la pièce |
| `nb_cintres`, `pas` | 5, 40 | nombre d'encoches et entraxe |
| `haut_bosse` | 9 | hauteur des bosses entre encoches |
| `haut_crochet` | 45 | hauteur de vos crochets (à mesurer) |
| `largeur` | 20 | largeur du bras, qui doit passer dans le crochet |
| `vis_etagere` | [28, 148, 226] | position des vis de l'étagère depuis le fond |
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

Chaque vis de l'étagère passe par un trou de la barre haute. Sa tête est noyée dans un lamage Ø9, et il reste 5 mm de plastique sous la tête. Juste en dessous, un **trou d'accès Ø10 traverse le bras** : on passe le tournevis par en dessous, à travers le bras, puis à travers la fenêtre du cadre, jusqu'à la vis.

![dessous](images/dessous.png)

* Avec des vis de 16 mm, il en entre **11 mm dans le bois**. Pour une étagère de 18 mm, il reste donc 7 mm avant de ressortir sur le dessus.
* Si votre étagère est plus fine, indiquez `ep_etagere` : le fichier refuse de générer la pièce si les vis risquent de ressortir.
* Un tournevis de Ø9 maximum passe dans les trous d'accès : un tournevis cruciforme PH2 classique, ou un embout sur une rallonge fine.
* Il faut une longueur d'au moins 10 cm entre la poignée et la pointe.
* Prenez un embout aimanté, ou bien plantez la vis dans son trou avant de présenter la pièce.

### Matériel

* 3 vis à bois **Ø4 × 16 mm** pour l'étagère, à tête plate ou fraisée de Ø8 maximum.
* 2 vis à bois **Ø4 × 12 à 16 mm** à tête fraisée pour le fond. Elles ne doivent pas traverser le fond.

### Étapes

1. Mettez la pièce en place : plaquez-la contre le fond et sous l'étagère.
2. Pré-percez l'étagère à Ø2,5 sur 10 mm de profondeur, à travers les trous de la pièce. Pour ne pas percer trop loin, mettez un bout de scotch sur le foret comme repère.
3. Vissez les 3 vis de l'étagère par en dessous, à travers le bras. Commencez par la vis avant (la plus proche de la porte), c'est celle qui travaille le plus.
4. Vissez les 2 vis du fond, sous le bras. On y accède de face.

Le fond d'une armoire est souvent un panneau mince de 3 mm. Ce n'est pas un problème ici, car il ne sert que d'appui : la charge passe par l'étagère.
