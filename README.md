# Support de cintres pour placard (OpenSCAD)

Remplace les deux supports de cintres d'origine, jugés fragiles. Le nouveau support est un **cadre fermé**, fixé à deux endroits :

* **sous l'étagère du haut**, avec 2 boulons M4 traversants (c'est la fixation qui porte la charge) ;
* **contre le fond du placard**, avec 2 vis à bois (en appui et pour le maintien).

Le bras porte **5 encoches** séparées par des bosses de 9 mm. Chaque cintre retombe dans son propre logement.

![aperçu](images/apercu.png)

| Pièce | Profil |
|---|---|
| ![pièce](images/piece.png) | ![profil](images/profil.png) |

## Pourquoi un cadre fermé

Les supports d'origine sont des porte-à-faux : toute la charge fait levier sur deux petites vis plantées dans le fond, qui est souvent un panneau mince. Ici, le bras est tenu **aux deux bouts**, par le dos d'un côté et par le poteau avant de l'autre. Le poteau avant est accroché à l'étagère. Le couple créé par les vestes est donc repris par les boulons de l'étagère, qui travaillent en traction avec un écrou et une rondelle. Ce montage tient beaucoup mieux qu'une vis dans de l'aggloméré.

Les crochets s'accrochent **par le côté**, à travers la fenêtre du cadre. On dispose de 60 mm de dégagement au-dessus du fond des encoches, ce qui laisse soulever un cintre au-dessus d'une bosse.

Ordre de grandeur pour 5 vestes de 2 kg : environ 15 N·m au niveau du dos, soit à peu près 80 N de traction sur le boulon avant. Un M4 encaisse plusieurs milliers de newtons, donc la marge est très large.

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
| `boulons_etagere` | [30, 220] | position des boulons depuis le fond |

Avec `apercu = true`, le fichier affiche l'étagère, le fond, la porte (trait rouge) et les cintres. **N'exportez pas le STL avec cette option active.**

## Impression

* **PETG recommandé.** Le PLA flue sous une charge permanente, surtout dans un placard chaud, et le bras finirait par s'affaisser.
* Imprimez la pièce **couchée sur le côté**, avec la grande face plate sur le plateau. Les couches suivent alors le cadre, ce qui donne l'orientation la plus solide. Aucun support n'est nécessaire.
* 5 périmètres (parois de 2 mm ou plus), 5 couches dessus et dessous, remplissage gyroïde de 40 %.
* Il faut un plateau d'au moins 250 mm (Prusa MK4, Bambu, etc.). Pour un plateau de 220 mm, réduisez `longueur` et `nb_cintres`/`pas`.

## Montage

Matériel :

* 2 boulons **M4** à tête large, avec rondelles et écrous M4. Longueur = épaisseur de l'étagère + 12 mm, arrondie au-dessus. Pour une étagère de 18 mm, prenez du M4×30 ou M4×35.
* 2 vis à bois **Ø4 à tête fraisée**, d'une longueur de 12 à 16 mm. Elles ne doivent pas traverser le fond.

Étapes :

1. Repérez sur le dessus de l'étagère l'axe du support, puis les deux trous à **30 mm et 220 mm du fond**. Percez à Ø4,5.
2. Glissez un écrou M4 dans chacun des logements hexagonaux, sous la barre haute (côté fenêtre).
3. Plaquez le support contre le fond et sous l'étagère. Passez les boulons par le dessus, avec une rondelle, puis serrez.
4. Vissez les 2 vis à bois dans le fond, sous le bras. On y accède de face.

Le fond d'une armoire est souvent un panneau mince de 3 mm. Ce n'est pas un problème ici, car il ne sert que d'appui : la charge passe par l'étagère.
