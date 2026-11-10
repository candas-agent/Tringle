// =====================================================================
//  Support de cintres (« triangles ») pour placard
//  Fixé à la fois SOUS l'étagère du haut (boulons M4 traversants)
//  et CONTRE le fond du placard (2 vis à bois).
//
//  Repère :  Y = profondeur (0 = fond du placard, vers la porte)
//            Z = hauteur    (0 = dessous de l'étagère, vers le bas < 0)
//            X = largeur de la pièce (centrée sur 0)
//
//  Principe : un cadre fermé (dos + barre haute + poteau avant + bras
//  à encoches). Le bras est soutenu aux DEUX bouts, il ne travaille donc
//  plus en porte-à-faux comme les supports d'origine. Les cintres
//  s'accrochent par le côté, à travers la fenêtre du cadre.
//
//  Impression : à plat sur le côté (face X sur le plateau), sans support.
//  Voir README.md pour les réglages et le montage.
// =====================================================================

/* [Placard] */
// Profondeur libre entre le fond du placard et la porte fermée (mm)
profondeur_placard = 300;
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
// Épaisseur du poteau avant (mm)
ep_poteau = 14;
// Épaisseur du bras sous le fond des encoches (mm)
ep_bras = 14;
// Descente de la plaque de dos sous le bras (zone des vis du fond) (mm)
descente_dos = 50;
// Chanfrein de renfort entre le dos et le dessous du bras (mm)
chanfrein = 12;

/* [Encoches pour cintres] */
nb_cintres = 5;
// Distance entre deux cintres (mm)
pas = 40;
// Position de la 1re encoche depuis le fond (mm)
premiere_encoche = 48;
// Hauteur des bosses entre les encoches (mm)
haut_bosse = 9;
// Hauteur du crochet de cintre au-dessus de son point d'appui (mm)
haut_crochet = 45;

/* [Fixations] */
// Positions (Y) des boulons M4 dans l'étagère
boulons_etagere = [30, 220];
// Diamètre de passage des boulons / vis
d_passage = 4.5;
// Écrou M4 : surplat (mm) et épaisseur (mm)
ecrou_surplat = 7;
ecrou_ep = 3.2;
// Diamètre de tête des vis à bois fraisées (vis du fond)
d_tete_vis = 8.5;

/* [Aperçu] */
// Afficher étagère, fond, porte et cintres (ne PAS exporter avec)
apercu = false;

$fn = 48;

// ---------------------------------------------------------------------
// Grandeurs dérivées
// ---------------------------------------------------------------------
jeu_crochet   = 6;
z_fenetre_h   = -ep_haut;
z_creux       = -ep_haut - (haut_crochet + haut_bosse + jeu_crochet);
z_bosse       = z_creux + haut_bosse;
z_bras_bas    = z_creux - ep_bras;
z_dos_bas     = z_bras_bas - descente_dos;
y_poteau      = longueur - ep_poteau;
derniere      = premiere_encoche + (nb_cintres - 1) * pas;
vis_fond_z    = [z_dos_bas + 12, z_bras_bas - chanfrein - 6];
r_conge       = 6;

// ---------------------------------------------------------------------
// Vérifications : la pièce ne doit pas toucher la porte
// ---------------------------------------------------------------------
assert(longueur <= profondeur_placard - 10,
       str("Pièce trop longue : ", longueur, " mm pour ", profondeur_placard,
           " mm de profondeur (garder 10 mm de marge)"));
assert(derniere + marge_veste <= profondeur_placard,
       str("La veste du dernier cintre (encoche à ", derniere,
           " mm) toucherait la porte"));
assert(derniere + pas / 2 <= y_poteau - 2,
       "Les encoches débordent sur le poteau avant : réduire pas ou nb_cintres");
assert(premiere_encoche - pas / 2 >= ep_dos + 2,
       "La première encoche est trop près du fond");

echo(str("Encombrement : ", longueur, " mm de profondeur x ",
         -z_dos_bas, " mm de haut x ", largeur, " mm de large"));
echo(str("Encoches à : ", [for (i = [0:nb_cintres-1]) premiere_encoche + i * pas], " mm du fond"));
echo(str("Veste la plus en avant jusqu'à ~", derniere + marge_veste,
         " mm (porte à ", profondeur_placard, " mm)"));

// ---------------------------------------------------------------------
// Profil 2D (y, z)
// ---------------------------------------------------------------------
// Hauteur du dessus du bras en fonction de y : creux sinusoïdaux
function dessus_bras(y) =
    (y < premiere_encoche - pas / 2 || y > derniere + pas / 2)
        ? z_bosse
        : z_creux + haut_bosse * (1 - cos(360 * (y - premiere_encoche) / pas)) / 2;

module contour() {
    polygon([
        [0, 0],
        [longueur, 0],
        [longueur, z_bras_bas],
        [ep_dos + chanfrein, z_bras_bas],
        [ep_dos, z_bras_bas - chanfrein],
        [ep_dos, z_dos_bas],
        [0, z_dos_bas],
    ]);
}

module fenetre() {
    pts_bras = [for (y = [y_poteau : -0.5 : ep_dos]) [y, dessus_bras(y)]];
    // ouverture morphologique = congés dans les angles du cadre
    offset(r = r_conge) offset(delta = -r_conge)
        polygon(concat([[ep_dos, z_fenetre_h], [y_poteau, z_fenetre_h]], pts_bras));
}

module profil() {
    difference() {
        offset(r = 2) offset(delta = -2) contour();   // arrondit les arêtes vives
        fenetre();
    }
}

// ---------------------------------------------------------------------
// Pièce 3D
// ---------------------------------------------------------------------
// 2D (a, b) extrudé de e  ->  X = e, Y = a, Z = b
module support() {
    difference() {
        rotate([90, 0, 90])
            linear_extrude(height = largeur, center = true) profil();

        // Boulons M4 dans l'étagère + logement d'écrou côté fenêtre
        for (y = boulons_etagere) translate([0, y, 0]) {
            translate([0, 0, -ep_haut - 1]) cylinder(d = d_passage, h = ep_haut + 2);
            // écrou hexagonal, pointe vers +X (= vers le haut à l'impression)
            translate([0, 0, -ep_haut - 0.01])
                cylinder(d = (ecrou_surplat + 0.3) / cos(30), h = ecrou_ep + 0.4, $fn = 6);
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
    translate([0, y, dessus_bras(y) - r + 2])
        rotate([90, 0, 0]) {
            rotate_extrude(angle = 200) translate([r, 0]) circle(d = 4, $fn = 12);
            translate([r, 0, 0]) rotate([90, 0, 0]) cylinder(d = 4, h = 60, $fn = 12);
        }
    // épaules du cintre
    translate([0, y, dessus_bras(y) - r - 55]) cube([300, 10, 14], center = true);
}

if (apercu) {
    color("orange") support();
    color("white", 0.6) translate([-200, 0, 0]) cube([400, profondeur_placard - 20, 18]);
    color("tan", 0.6) translate([-200, -3, z_dos_bas - 60]) cube([400, 3, 78 - z_dos_bas]);
    // trait rouge = position de la porte fermée
    color("red") translate([-200, profondeur_placard, -2]) cube([400, 2, 4]);
    color("silver") for (i = [0:nb_cintres-1]) crochet(premiere_encoche + i * pas);
} else {
    support();
}
