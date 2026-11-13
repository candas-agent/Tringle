# Support de cintres pour placard (OpenSCAD)

Remplace les deux supports de cintres d'origine, jugés fragiles. Le nouveau support est une **poutre ajourée** en une seule pièce, avec 5 logements en U, un par cintre. Le crochet glisse tout seul au point bas de son logement et ne peut pas passer dans le voisin.

Il se visse dans les **deux chevilles déjà présentes au mur**, l'une au-dessus de l'autre (entraxe 90 mm) :

* **une vis au-dessus de la poutre** et **une vis en dessous**, toutes deux sur l'axe du support, dans une plaque de dos plaquée contre le mur ;
* la poutre tient entre les deux vis, avec 4 mm de dégagement : le tournevis passe librement, de face, au-dessus et en dessous.

Le support ne touche pas l'étagère : il ne dépend que des chevilles.

![aperçu](images/apercu.png)

| Pièce | Profil |
|---|---|
| ![pièce](images/piece.png) | ![profil](images/profil.png) |

## Forme

Seule la face du dos, contre le mur, est plane. Tout le reste est galbé :

* 5 logements identiques, aux angles hauts arrondis et au fond en demi-cercle, séparés par des montants qui relient la barre haute au bras ;
* l'avant s'enroule en haut (R15) et en bas (grand arrondi R45) ;
* le dessous du bras forme une seule courbe qui rejoint la plaque de dos juste au-dessus de la vis du bas ;
* les arêtes sont adoucies : quart de rond sur le dessus à l'impression, chanfrein à 45° côté plateau pour éviter les supports.

Pour régler la forme : `r_galbe` (arrondi avant-bas), `r_avant_haut`, `ventre` (galbe sous le bras), `r_haut` (angles hauts des logements), `ep_montant` (largeur des montants) et `r_bord` (arrondi des arêtes).

## Comment ça tient

* La **vis du haut** travaille en traction : c'est elle qui empêche le support de basculer vers l'avant.
* Le **bas de la plaque** appuie contre le mur, et la **vis du bas** tient le support en hauteur.
* Les deux vis sont espacées de 90 mm, ce qui donne un bon bras de levier contre le basculement.
* Le bras est relié à la barre haute tous les 40 mm par les montants, donc toute la poutre travaille comme un seul bloc.

Ordre de grandeur pour 5 vestes de 2 kg : environ 15 N·m au mur, soit à peu près 150 N de traction sur la vis du haut. Une vis Ø5 dans une cheville en bon état, dans un vrai mur, tient bien davantage.

Les crochets s'accrochent **par le côté**, dans leur logement. Avec des chevilles espacées de 90 mm, chaque logement offre 33 mm de large et **50 mm de haut** au-dessus de son point bas. Le fichier refuse de générer la pièce si cette hauteur ne suffit pas pour `haut_crochet`.

## Encombrement (valeurs par défaut)

* Profondeur : **245 mm**. Le support reste **55 mm en retrait** du bord avant de l'étagère de **300 mm**.
* Cintres à 48, 88, 128, 168 et 208 mm du mur.
* La veste la plus en avant dépasse d'environ 60 mm devant son crochet, soit à peu près **268 mm**. Elle reste elle aussi sous l'étagère, avant même de compter l'espace jusqu'à la porte.
* Hauteur : 114 mm pour la plaque de dos, 67 mm pour la poutre. Largeur : 16 mm.

Le fichier contient des `assert` : si un réglage fait dépasser la pièce de l'étagère, toucher la porte par la dernière veste, ou laisse trop peu de hauteur pour les crochets, **le rendu s'arrête avec un message**.

## Paramètres principaux (`support_cintres.scad`)

| Paramètre | Défaut | Rôle |
|---|---|---|
| `z_cheville_haute` | 20 | distance entre le dessous de l'étagère et la cheville du haut (**à mesurer**) |
| `entraxe_chevilles` | 90 | écart vertical entre les deux chevilles |
| `d_vis_cheville`, `d_tete_cheville` | 5, 10 | passage et tête fraisée des vis |
| `degagement` | 4 | espace entre la tête de vis et la poutre, pour le tournevis |
| `haut_crochet` | 45 | hauteur de vos crochets (**à vérifier**) |
| `profondeur_etagere` | 300 | profondeur de l'étagère du haut |
| `ecart_porte` | 0 | bord de l'étagère → porte fermée (0 si inconnu) |
| `marge_veste` | 60 | épaisseur de veste devant le dernier crochet |
| `longueur` | 245 | profondeur du support |
| `nb_cintres`, `pas` | 5, 40 | nombre de logements et entraxe |
| `ep_montant` | 7 | largeur des montants (logements de `pas - ep_montant` = 33 mm) |
| `largeur` | 16 | largeur du support, qui doit passer dans le crochet |
| `ep_dos`, `ep_haut`, `ep_bras` | 8, 8, 9 | épaisseurs de la plaque, de la barre haute et du bras |

Avec `apercu = true`, le fichier affiche l'étagère, le mur, la porte (trait rouge, au bord de l'étagère si `ecart_porte = 0`), les vis et les cintres. **N'exportez pas le STL avec cette option active.**

## Impression

* **PETG de préférence, PLA possible.** Sous une charge permanente, le PLA se déforme lentement (fluage), surtout au chaud. Ici, les efforts restent modérés. Dans un placard à température ambiante, loin d'un radiateur et du soleil, du PLA devrait tenir. Le PETG garde simplement plus de marge.
* Imprimez le support **couché sur le côté**, avec la grande face plate sur le plateau. Les couches suivent alors le profil, ce qui donne l'orientation la plus solide. Aucun support d'impression n'est nécessaire. Encombrement : 245 × 114 mm sur le plateau, 16 mm de haut. Il faut un plateau d'au moins 250 mm dans un sens (Bambu P1S/A1/X1, Prusa MK4, etc.).
* 4 périmètres, 4 à 5 couches dessus et dessous, remplissage gyroïde de 25 % : **environ 105 g** (estimation à ±20 %, votre logiciel de découpe donnera le chiffre exact). Avec 5 périmètres et 40 %, comptez environ 135 g.

## Montage

### Avant d'imprimer

Mesurez **la distance entre le dessous de l'étagère et le centre de la cheville du haut**, et indiquez-la dans `z_cheville_haute`. Elle place la pièce en hauteur par rapport à l'étagère : l'aperçu et la vérification des 300 mm en dépendent. Les deux trous restent toujours à 90 mm l'un de l'autre (`entraxe_chevilles`). Vérifiez aussi cet entraxe au mètre.

### Matériel

* **2 vis identiques** adaptées à vos chevilles, de Ø5 maximum, à **tête fraisée de Ø10 maximum**.
* Longueur = 8 mm de plaque + la profondeur de la cheville : par exemple 5 × 40 pour une cheville de 30 mm.
* Le plus simple est de reprendre les vis d'origine et d'ajouter 8 mm, moins l'épaisseur de la plaque de l'ancien support.

### Étapes

1. Plaquez le support contre le mur, les trous en face des chevilles.
2. Vissez la vis du haut, au-dessus de la poutre, puis la vis du bas, en dessous. Le tournevis passe de face, sans rien traverser.
