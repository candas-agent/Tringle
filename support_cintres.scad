// =====================================================================
//  Support de cintres (« triangles ») pour placard
//  Fixé à la fois SOUS l'étagère du haut (3 vis à bois, sans percer
//  l'étagère de part en part) et CONTRE le fond du placard (2 vis à bois).
//
//  Repère :  Y = profondeur (0 = fond du placard, vers la porte)
//            Z = hauteur    (0 = dessous de l'étagère, vers le bas < 0)
//            X = largeur de la pièce (centrée sur 0)
//
//  Principe : une poutre ajourée (barre haute + bras reliés par des
//  montants), un logement en U par cintre. Le bras ne travaille plus en
//  porte-à-faux comme les supports d'origine. Les cintres s'accrochent
//  par le côté, dans leur logement.
//
//  Impression : à plat sur le côté (face X sur le plateau), sans support.
//  Voir README.md pour les réglages et le montage.
// =====================================================================

/* [Placard] */
// Profondeur de l'étagère du haut, depuis le fond du placard (mm)
profondeur_etagere = 300;
// Espace entre le bord avant de l'étagère et la porte fermée (mm)
// (0 si inconnu : on reste alors sous l'étagère, par sécurité)
ecart_porte = 0;
// Épaisseur de veste qui dépasse devant le crochet le plus en avant (mm)
marge_veste = 60;

/* [Pièce] */
// Longueur totale de la pièce, dos compris (mm)
longueur = 245;
// Largeur de la pièce = largeur du bras sous le crochet (mm)
largeur = 20;
// Épaisseur de la barre haute vissée sous l'étagère (mm)
ep_haut = 12;
// Épaisseur de la plaque de dos (mm)
ep_dos = 8;
// Épaisseur du bras sous le fond des logements (mm)
ep_bras = 14;
// Descente de la queue du dos sous le bras (zone des vis du fond) (mm)
descente_dos = 70;
// Rayon du grand arrondi avant-bas (mm)
r_galbe = 45;
// Galbe du ventre sous le bras (mm, 0 = droit)
ventre = 5;
// Rayon des angles hauts des logements (mm)
r_haut = 10;
// Arrondi des arêtes de la face supérieure à l'impression (mm)
r_bord = 2.5;
// Largeur des montants entre deux logements (mm)
ep_montant = 8;

/* [Logements pour cintres] */
nb_cintres = 5;
// Distance entre deux cintres (mm)
pas = 40;
// Position du 1er cintre depuis le fond (mm)
premiere_encoche = 48;
// Hauteur du crochet de cintre au-dessus de son point d'appui (mm)
haut_crochet = 45;

/* [Fixations] */
// Épaisseur de l'étagère (mm) - À MESURER
ep_etagere = 18;
// Longueur des vis de l'étagère (mm)
long_vis_etagere = 16;
// Plastique restant sous la tête de vis (mm)
ep_sous_tete = 5;
// Diamètre du lamage pour la tête de vis (mm)
d_lamage = 9;
// Diamètre des tunnels d'accès du tournevis (mm)
d_acces = 10;
// Diamètre de passage des vis
d_passage = 4.5;
// Diamètre de tête des vis à bois fraisées (vis du fond)
d_tete_vis = 8.5;

/* [Aperçu] */
// Afficher étagère, fond, porte et cintres (ne PAS exporter avec)
apercu = false;

$fn = 48;

// ---------------------------------------------------------------------
// Grandeurs dérivées
// ---------------------------------------------------------------------
L             = longueur;
R             = r_galbe;
w             = pas - ep_montant;                    // largeur d'un logement
jeu_crochet   = 10;
z_creux       = -ep_haut - (haut_crochet + jeu_crochet); // fond des logements
z_bras_bas    = z_creux - ep_bras;
z_dos_bas     = z_bras_bas - descente_dos;
derniere      = premiere_encoche + (nb_cintres - 1) * pas;
y_logements   = [for (i = [0 : nb_cintres - 1]) premiere_encoche + i * pas];
y_bloc_ar     = premiere_encoche - w / 2;           // début du 1er logement
y_bloc_av     = derniere + w / 2;                   // fin du dernier logement
// Vis de l'étagère : au milieu des deux blocs pleins (arrière et avant),
// posées par en dessous à travers un tunnel vertical.
vis_etagere   = [(ep_dos + y_bloc_ar) / 2, (y_bloc_av + L) / 2];
vis_fond_z    = [z_dos_bas + 13, z_dos_bas + 33];
z_queue_haut  = z_dos_bas + 42;     // fin de la face plane des vis du fond
vis_dans_bois = long_vis_etagere - ep_sous_tete;

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
assert(y_bloc_ar - ep_dos >= d_acces + 8,
       "Pas assez de place derrière le 1er logement pour la vis arrière");
assert(L - y_bloc_av >= d_acces + 8,
       "Pas assez de place devant le dernier logement pour la vis avant");
assert(vis_dans_bois <= ep_etagere - 3,
       str("Les vis (", long_vis_etagere, " mm) traverseraient l'étagère de ",
           ep_etagere, " mm : prendre des vis plus courtes"));
assert(vis_dans_bois >= 8, "Vis trop courtes : moins de 8 mm dans l'étagère");
assert(ep_haut - ep_sous_tete >= 4, "Lamage trop profond pour la barre haute");

echo(str("Encombrement : ", longueur, " mm de profondeur x ",
         -z_dos_bas, " mm de haut x ", largeur, " mm de large"));
echo(str("Cintres à : ", y_logements, " mm du fond"));
echo(str("Vis étagère à : ", vis_etagere, " mm du fond, longueur ",
         long_vis_etagere, " mm dont ", vis_dans_bois, " mm dans le bois"));
echo(str("Pièce : ", longueur, " mm, soit ", profondeur_etagere - longueur,
         " mm en retrait du bord de l'étagère"));
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

// Contour extérieur : dessus plat (étagère), dos plat (fond),
// tout le reste en courbes.
module contour() {
    k = 0.55;                           // ~ quart de cercle
    polygon(concat(
        [[0, 0], [L - 6, 0]],
        bez([L - 6, 0], [L - 6 + 6 * k, 0], [L, -6 + 6 * k], [L, -6], 8),
        // face avant, puis grand arrondi vers le dessous du bras
        bez([L, z_bras_bas + R], [L, z_bras_bas + R * (1 - k)],
            [L - R * (1 - k), z_bras_bas], [L - R, z_bras_bas]),
        // ventre du bras qui plonge en une seule courbe dans la queue du dos
        bez([L - R, z_bras_bas], [(L - R) * 0.35, z_bras_bas - ventre],
            [ep_dos + 4, z_bras_bas - ventre - 6], [ep_dos, z_queue_haut], 48),
        // face plane des vis du fond, puis pointe arrondie
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
            translate([yc + s * (w / 2 - r_haut), -ep_haut - r_haut]) circle(r = r_haut);
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

        // Vis à bois dans l'étagère, posées par en dessous :
        //  - trou de passage + lamage dans la barre haute (tête noyée)
        //  - tunnel vertical à travers le bloc plein pour le tournevis
        for (y = vis_etagere) translate([0, y, 0]) {
            translate([0, 0, -ep_haut - 1]) cylinder(d = d_passage, h = ep_haut + 2);
            translate([0, 0, -ep_haut - 1]) cylinder(d = d_lamage, h = ep_haut - ep_sous_tete + 1);
            translate([0, 0, z_dos_bas])
                cylinder(d = d_acces, h = -ep_haut - z_dos_bas);
        }

        // Vis à bois fraisées dans le fond (sous le bras, accessibles de face)
        for (z = vis_fond_z) translate([0, 0, z]) rotate([-90, 0, 0]) {
            translate([0, 0, -1]) cylinder(d = d_passage, h = ep_dos + 2);
            translate([0, 0, ep_dos - (d_tete_vis - d_passage) / 2])
                cylinder(d1 = d_passage, d2 = d_tete_vis, h = (d_tete_vis - d_passage) / 2 + 0.01);
            translate([0, 0, ep_dos]) cylinder(d = d_tete_vis, h = 30);
        }
    }
}

// ---------------------------------------------------------------------
// Aperçu de l'environnement
// ---------------------------------------------------------------------
module crochet(y) {
    // crochet métallique simplifié posé dans l'encoche
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
    color("white", 0.6) translate([-200, 0, 0]) cube([400, profondeur_etagere, 18]);
    color("tan", 0.6) translate([-200, -3, z_dos_bas - 60]) cube([400, 3, 78 - z_dos_bas]);
    // trait rouge = position de la porte fermée
    color("red") translate([-200, profondeur_etagere + ecart_porte, -2]) cube([400, 2, 4]);
    color("silver") for (i = [0:nb_cintres-1]) crochet(premiere_encoche + i * pas);
} else {
    support();
}
