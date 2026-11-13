// =====================================================================
//  Support de cintres (« triangles ») pour placard
//  Vissé dans les deux chevilles existantes du mur, l'une au-dessus de
//  l'autre : une vis AU-DESSUS du bras, une vis EN DESSOUS, toutes deux
//  sur l'axe du support et vissées de face.
//
//  Repère :  Y = profondeur (0 = mur, vers la porte)
//            Z = hauteur    (0 = dessous de l'étagère, vers le bas < 0)
//            X = largeur de la pièce (centrée sur 0)
//
//  Principe : une plaque de dos portant les deux vis, et entre elles une
//  poutre ajourée (barre haute + bras reliés par des montants), avec un
//  logement en U par cintre. La poutre tient entre les deux vis, pour
//  que le tournevis passe librement au-dessus et en dessous.
//
//  Impression : à plat sur le côté (face X sur le plateau), sans support.
//  Voir README.md pour les réglages et le montage.
// =====================================================================

/* [Placard] */
// Profondeur de l'étagère du haut, depuis le mur (mm)
profondeur_etagere = 300;
// Espace entre le bord avant de l'étagère et la porte fermée (mm)
// (0 si inconnu : on reste alors sous l'étagère, par sécurité)
ecart_porte = 0;
// Épaisseur de veste qui dépasse devant le crochet le plus en avant (mm)
marge_veste = 60;

/* [Chevilles existantes au mur, l'une au-dessus de l'autre] */
// Distance entre le dessous de l'étagère et la cheville du HAUT (mm) - À MESURER
z_cheville_haute = 20;
// Entraxe vertical des deux chevilles (mm)
entraxe_chevilles = 90;
// Vis des chevilles : diamètre de passage et de tête fraisée (mm)
d_vis_cheville = 5;
d_tete_cheville = 10;
// Espace libre entre la tête de vis et la poutre, pour le tournevis (mm)
degagement = 4;

/* [Pièce] */
// Longueur totale de la pièce, dos compris (mm)
longueur = 245;
// Largeur de la pièce = largeur du bras sous le crochet (mm)
largeur = 16;
// Épaisseur de la plaque de dos (mm)
ep_dos = 8;
// Épaisseur de la barre haute de la poutre (mm)
ep_haut = 8;
// Épaisseur du bras sous le fond des logements (mm)
ep_bras = 9;
// Rayon du grand arrondi avant-bas (mm)
r_galbe = 45;
// Rayon de l'arrondi avant-haut (mm)
r_avant_haut = 15;
// Galbe du ventre sous le bras (mm, 0 = droit)
ventre = 2;
// Rayon des angles hauts des logements (mm)
r_haut = 10;
// Arrondi des arêtes de la face supérieure à l'impression (mm)
r_bord = 2.5;
// Largeur des montants entre deux logements (mm)
ep_montant = 7;

/* [Logements pour cintres] */
nb_cintres = 5;
// Distance entre deux cintres (mm)
pas = 40;
// Position du 1er cintre depuis le mur (mm)
premiere_encoche = 48;
// Hauteur du crochet de cintre au-dessus de son point d'appui (mm) - À VÉRIFIER
haut_crochet = 45;

/* [Aperçu] */
// Afficher étagère, mur, porte et cintres (ne PAS exporter avec)
apercu = false;

$fn = 48;

// ---------------------------------------------------------------------
// Grandeurs dérivées
// ---------------------------------------------------------------------
L             = longueur;
R             = r_galbe;
Rh            = r_avant_haut;
w             = pas - ep_montant;                   // largeur d'un logement
z_ch_haut     = -z_cheville_haute;                  // vis du haut
z_ch_bas      = z_ch_haut - entraxe_chevilles;      // vis du bas
r_tete        = d_tete_cheville / 2;
// La poutre tient entre les deux vis, avec le dégagement du tournevis
z_poutre_haut = z_ch_haut - r_tete - degagement;    // dessus de la barre haute
z_queue_haut  = z_ch_bas + r_tete + degagement;     // le ventre rejoint le dos ici
z_bras_bas    = z_queue_haut + 5;                   // dessous du bras
z_creux       = z_bras_bas + ep_bras;               // fond des logements
z_log_haut    = z_poutre_haut - ep_haut;            // haut des logements
hauteur_libre = z_log_haut - z_creux;               // au-dessus du crochet
// Plaque de dos : déborde de la poutre pour porter les deux vis
z_plaque_haut = min(-1, z_ch_haut + r_tete + 7);
z_dos_bas     = z_ch_bas - r_tete - 7;
conge_dos     = 3;                                  // dos / dessus de la poutre
derniere      = premiere_encoche + (nb_cintres - 1) * pas;
y_logements   = [for (i = [0 : nb_cintres - 1]) premiere_encoche + i * pas];
y_bloc_ar     = premiere_encoche - w / 2;           // début du 1er logement
y_bloc_av     = derniere + w / 2;                   // fin du dernier logement

// ---------------------------------------------------------------------
// Vérifications
// ---------------------------------------------------------------------
assert(longueur <= profondeur_etagere - 10,
       str("La pièce (", longueur, " mm) dépasserait de l'étagère de ",
           profondeur_etagere, " mm (garder 10 mm de marge)"));
assert(derniere + marge_veste <= profondeur_etagere + ecart_porte,
       str("La veste du dernier cintre (à ", derniere,
           " mm) toucherait la porte"));
assert(w >= 2 * r_haut + 6, "Logements trop étroits : augmenter pas");
assert(y_bloc_ar - ep_dos >= 8, "Le 1er logement est trop près du dos");
assert(L - y_bloc_av >= 10, "Le dernier logement est trop près de l'avant");
assert(z_cheville_haute - r_tete >= 2, "Cheville du haut trop près de l'étagère");
assert(hauteur_libre >= haut_crochet + 4,
       str("Logements trop bas pour les crochets (", hauteur_libre,
           " mm libres pour des crochets de ", haut_crochet,
           " mm) : chevilles trop rapprochées ou épaisseurs à réduire"));
assert(z_poutre_haut - Rh >= z_bras_bas + R,
       "Poutre trop basse pour ses arrondis avant : réduire r_galbe ou r_avant_haut");
assert(degagement - conge_dos >= 0, "Le congé du dos gênerait le tournevis");

echo(str("Encombrement : ", longueur, " mm de profondeur x ",
         z_plaque_haut - z_dos_bas, " mm de haut x ", largeur, " mm de large"));
echo(str("Vis des chevilles à ", z_cheville_haute, " et ",
         z_cheville_haute + entraxe_chevilles, " mm sous l'étagère"));
echo(str("Poutre de ", z_poutre_haut - z_bras_bas, " mm de haut ; ",
         hauteur_libre, " mm libres au-dessus du point d'appui des crochets"));
echo(str("Cintres à : ", y_logements, " mm du mur"));
echo(str("Veste la plus en avant jusqu'à ~", derniere + marge_veste,
         " mm (bord de l'étagère à ", profondeur_etagere, " mm, porte à ",
         profondeur_etagere + ecart_porte, " mm ou plus)"));

// ---------------------------------------------------------------------
// Profil 2D (y, z)
// ---------------------------------------------------------------------
// Courbe de Bézier cubique échantillonnée (sans le dernier point)
function bez(p0, p1, p2, p3, n = 32) =
    [for (i = [0 : n - 1]) let (t = i / n)
        pow(1 - t, 3) * p0 + 3 * pow(1 - t, 2) * t * p1
        + 3 * (1 - t) * t * t * p2 + pow(t, 3) * p3];

// Contour extérieur : dos plat (mur), tout le reste en courbes.
module contour() {
    k = 0.55;                           // ~ quart de cercle
    c = conge_dos;
    polygon(concat(
        // haut de la plaque de dos, arrondi
        bez([0, z_plaque_haut], [ep_dos * 0.5, z_plaque_haut],
            [ep_dos, z_plaque_haut - 1], [ep_dos, z_plaque_haut - ep_dos], 10),
        // face avant de la plaque (vis du haut), petit congé vers la poutre
        bez([ep_dos, z_poutre_haut + c], [ep_dos, z_poutre_haut + c * (1 - k)],
            [ep_dos + c * (1 - k), z_poutre_haut], [ep_dos + c, z_poutre_haut], 6),
        // dessus de la poutre, puis arrondi avant-haut
        bez([L - Rh, z_poutre_haut], [L - Rh * (1 - k), z_poutre_haut],
            [L, z_poutre_haut - Rh * (1 - k)], [L, z_poutre_haut - Rh], 12),
        // face avant, puis grand arrondi vers le dessous du bras
        bez([L, z_bras_bas + R], [L, z_bras_bas + R * (1 - k)],
            [L - R * (1 - k), z_bras_bas], [L - R, z_bras_bas]),
        // ventre du bras qui rejoint la plaque de dos en une seule courbe
        bez([L - R, z_bras_bas], [(L - R) * 0.35, z_bras_bas - ventre],
            [ep_dos, z_bras_bas - ventre], [ep_dos, z_queue_haut], 48),
        // face avant de la plaque (vis du bas), puis pointe arrondie
        [[ep_dos, z_queue_haut]],
        bez([ep_dos, z_dos_bas + ep_dos], [ep_dos, z_dos_bas + 1],
            [ep_dos * 0.5, z_dos_bas], [0, z_dos_bas], 10),
        [[0, z_dos_bas]]
    ));
}

// Un logement : angles hauts arrondis, fond en demi-cercle.
// Le crochet glisse tout seul au point bas, au centre.
module logement(yc) {
    hull() {
        translate([yc, z_creux + w / 2]) circle(d = w, $fn = 96);
        for (s = [-1, 1])
            translate([yc + s * (w / 2 - r_haut), z_log_haut - r_haut]) circle(r = r_haut);
    }
}

module profil() {
    difference() {
        offset(r = 2) offset(delta = -2) contour();   // aucune arête vive
        for (y = y_logements) logement(y);
    }
}

// ---------------------------------------------------------------------
// Pièce 3D
// ---------------------------------------------------------------------
// 2D (a, b) extrudé de e  ->  X = e, Y = a, Z = b
// Extrusion du profil avec arêtes adoucies :
//  - face +X (dessus à l'impression) : quart de rond
//  - face -X (sur le plateau) : chanfrein à 45°, imprimable sans support
module extrusion_adoucie(n = 5) {
    e = largeur / 2;
    translate([0, 0, -e + r_bord]) linear_extrude(largeur - 2 * r_bord) profil();
    for (i = [0 : n - 1]) {
        // dessus : quart de rond
        a0 = 90 * i / n;  a1 = 90 * (i + 1) / n;
        translate([0, 0, e - r_bord + r_bord * sin(a0)])
            linear_extrude(r_bord * (sin(a1) - sin(a0)) + 0.01)
                offset(delta = -r_bord * (1 - cos(a1))) profil();
        // dessous : chanfrein 45°
        h0 = r_bord * i / n;
        translate([0, 0, -e + h0])
            linear_extrude(r_bord / n + 0.01)
                offset(delta = -(r_bord - h0)) profil();
    }
}

module support() {
    difference() {
        rotate([90, 0, 90]) extrusion_adoucie();

        // Vis des chevilles : une au-dessus, une en dessous de la poutre,
        // têtes fraisées, vissées de face sans rien traverser.
        for (z = [z_ch_haut, z_ch_bas]) translate([0, 0, z]) rotate([-90, 0, 0]) {
            k = (d_tete_cheville - d_vis_cheville) / 2;
            translate([0, 0, -1]) cylinder(d = d_vis_cheville, h = ep_dos + 2);
            translate([0, 0, ep_dos - k])
                cylinder(d1 = d_vis_cheville, d2 = d_tete_cheville, h = k + 0.01);
        }
    }
}

// ---------------------------------------------------------------------
// Aperçu de l'environnement
// ---------------------------------------------------------------------
module crochet(y) {
    // crochet métallique simplifié posé dans le logement
    r = largeur / 2 + 4;
    translate([0, y, z_creux - r + 2])
        rotate([90, 0, 0]) {
            rotate_extrude(angle = 200) translate([r, 0]) circle(d = 4, $fn = 12);
            translate([r, 0, 0]) rotate([90, 0, 0]) cylinder(d = 4, h = 60, $fn = 12);
        }
    // épaules du cintre
    translate([0, y, z_creux - r - 55]) cube([300, 10, 14], center = true);
}

if (apercu) {
    color("orange") support();
    // vis des chevilles
    color("dimgray") for (z = [z_ch_haut, z_ch_bas]) translate([0, -3, z])
        rotate([-90, 0, 0]) cylinder(d = 5, h = 3 + ep_dos);
    color("white", 0.6) translate([-200, 0, 0]) cube([400, profondeur_etagere, 18]);
    color("tan", 0.6) translate([-200, -3, z_dos_bas - 60]) cube([400, 3, 78 - z_dos_bas]);
    // trait rouge = position de la porte fermée
    color("red") translate([-200, profondeur_etagere + ecart_porte, -2]) cube([400, 2, 4]);
    color("silver") for (i = [0:nb_cintres-1]) crochet(premiere_encoche + i * pas);
} else {
    support();
}
