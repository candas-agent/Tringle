// =====================================================================
//  Support de cintres (« triangles ») pour placard — en deux pièces
//
//  1. PLATINE : vissée seule dans les deux chevilles du mur (l'une
//     au-dessus de l'autre). Deux joues sur les côtés guident le support.
//  2. SUPPORT : glissé entre les joues, poussé contre l'étagère, vissé
//     dessous (2 vis), puis bloqué dans les joues par un boulon M4 qui
//     passe dans une fente verticale : la hauteur se règle d'elle-même,
//     pas besoin de mesurer précisément les chevilles.
//
//  Repère :  Y = profondeur (0 = mur, vers la porte)
//            Z = hauteur    (0 = dessous de l'étagère, vers le bas < 0)
//            X = largeur (centrée sur 0)
//
//  Impression : support couché sur le côté, platine couchée sur son dos.
//  Aucun support d'impression. Voir README.md.
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
largeur = 16;
// Épaisseur de la barre haute vissée sous l'étagère (mm)
ep_haut = 10;
// Épaisseur de la plaque de dos (mm)
ep_dos = 8;
// Épaisseur du bras sous le fond des logements (mm)
ep_bras = 10;
// Descente de la queue du dos sous le bras (zone des vis du fond) (mm)
descente_dos = 40;
// Rayon du grand arrondi avant-bas (mm)
r_galbe = 45;
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

/* [Platine sur les chevilles existantes] */
// Distance entre le dessous de l'étagère et le centre de la cheville du HAUT (mm)
z_cheville_haute = 17;
// Entraxe vertical des deux chevilles (mm)
entraxe_chevilles = 90;
// Vis des chevilles : diamètre de passage et de tête fraisée (mm)
d_vis_cheville = 5;
d_tete_cheville = 10;
// Creux au dos pour la collerette des chevilles : diamètre et profondeur (mm)
d_collerette = 11;
p_collerette = 1.5;
// Épaisseur de la plaque de la platine (mm)
ep_platine = 6;
// Joues : épaisseur et profondeur (mm)
ep_joue = 5;
prof_joue = 18;
// Jeu entre le support et les joues, de chaque côté (mm)
jeu_joue = 0.3;
// Réglage en hauteur permis par la fente du boulon : +/- (mm)
reglage = 8;
// Boulon de blocage M4 : passage, écrou (surplat, épaisseur)
d_boulon = 4.5;
ecrou_surplat = 7;
ecrou_ep = 3.2;

/* [Export] */
// Pièce à exporter : "support" ou "platine"
piece = "support"; // [support, platine, aucune]

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
z_queue_haut  = z_dos_bas + 34;     // fin de la face plane du dos
// Platine
z_ch_haut     = -z_cheville_haute;
z_ch_bas      = z_ch_haut - entraxe_chevilles;
z_plat_haut   = -3;                                 // jeu sous l'étagère
z_plat_bas    = min(z_ch_bas - 12, z_dos_bas);
z_joue_bas    = z_bras_bas;                         // joues le long du bloc arrière
z_boulon      = (z_plat_haut + z_joue_bas) / 2;     // axe du boulon de blocage
y_boulon      = 9;                                  // depuis le dos du support
x_joue        = largeur / 2 + jeu_joue;             // face intérieure des joues
larg_platine  = 2 * (x_joue + ep_joue);
vis_dans_bois = long_vis_etagere - ep_sous_tete;

// ---------------------------------------------------------------------
// Vérifications
// ---------------------------------------------------------------------
assert(ep_platine + longueur <= profondeur_etagere - 10,
       str("La pièce (", ep_platine + longueur, " mm avec la platine) dépasserait de l'étagère de ",
           profondeur_etagere, " mm (garder 10 mm de marge)"));
assert(ep_platine + derniere + marge_veste <= profondeur_etagere + ecart_porte,
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
assert(ep_platine - p_collerette - (d_tete_cheville - d_vis_cheville) / 2 >= 1.5,
       "Platine trop fine pour le creux des chevilles et la tête fraisée");
assert(z_ch_haut + d_collerette / 2 <= z_plat_haut - 1.5,
       "Cheville du haut trop près de l'étagère pour la platine");
assert(y_boulon + d_boulon / 2 + 3 <= vis_etagere[0] - d_acces / 2,
       "Le boulon de blocage touche le tunnel de la vis arrière");
assert(z_boulon + reglage + d_boulon / 2 + 4 <= -ep_haut
       && z_boulon - reglage - d_boulon / 2 - 4 >= z_joue_bas,
       "Fente de réglage trop longue pour les joues");

echo(str("Encombrement : ", longueur, " mm de profondeur x ",
         -z_dos_bas, " mm de haut x ", largeur, " mm de large"));
echo(str("Cintres à : ", [for (y = y_logements) y + ep_platine], " mm du mur"));
echo(str("Platine : ", larg_platine, " x ", z_plat_haut - z_plat_bas, " mm, chevilles à ",
         z_cheville_haute, " et ", z_cheville_haute + entraxe_chevilles,
         " mm sous l'étagère ; réglage en hauteur +/-", reglage, " mm"));
echo(str("Vis étagère à : ", vis_etagere, " mm du fond, longueur ",
         long_vis_etagere, " mm dont ", vis_dans_bois, " mm dans le bois"));
echo(str("Ensemble : ", ep_platine + longueur, " mm, soit ",
         profondeur_etagere - longueur - ep_platine, " mm en retrait du bord de l'étagère"));
echo(str("Veste la plus en avant jusqu'à ~", ep_platine + derniere + marge_veste,
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

        // Fente verticale du boulon de blocage (réglage en hauteur)
        translate([0, y_boulon, z_boulon]) rotate([0, 90, 0])
            linear_extrude(2 * largeur, center = true)
                hull() for (s = [-1, 1]) translate([s * reglage, 0]) circle(d = d_boulon);
    }
}

// ---------------------------------------------------------------------
// Platine : vissée dans les chevilles, elle reçoit le dos du support
// entre ses deux joues. Repère d'assemblage : son dos est contre le mur
// (y = 0), le support commence à y = ep_platine.
// ---------------------------------------------------------------------
module platine() {
    hp = z_plat_haut - z_plat_bas;
    difference() {
        union() {
            // plaque contre le mur
            translate([0, ep_platine, 0]) rotate([90, 0, 0])
                linear_extrude(ep_platine)
                    union() {
                        offset(r = 5) offset(delta = -5)
                            translate([-larg_platine / 2, z_plat_bas]) square([larg_platine, hp]);
                        // coins hauts droits, sous les joues
                        translate([-larg_platine / 2, z_joue_bas]) square([larg_platine, z_plat_haut - z_joue_bas]);
                    }
            // joues de part et d'autre du support
            for (m = [0, 1]) mirror([m, 0, 0])
                translate([x_joue, 0, 0]) rotate([90, 0, 90])
                    linear_extrude(ep_joue)
                        union() {
                            // arrondis seulement à l'avant ; à l'arrière la joue
                            // part du plateau d'impression, sans porte-à-faux
                            offset(r = 4) offset(delta = -4)
                                translate([0, z_joue_bas]) square([ep_platine + prof_joue, z_plat_haut - z_joue_bas]);
                            translate([0, z_joue_bas]) square([ep_platine, z_plat_haut - z_joue_bas]);
                        }
        }
        // vis des chevilles, têtes fraisées côté support
        for (z = [z_ch_haut, z_ch_bas]) translate([0, 0, z]) rotate([-90, 0, 0]) {
            k = (d_tete_cheville - d_vis_cheville) / 2;
            translate([0, 0, -1]) cylinder(d = d_vis_cheville, h = ep_platine + 2);
            translate([0, 0, ep_platine - k])
                cylinder(d1 = d_vis_cheville, d2 = d_tete_cheville, h = k + 0.01);
            // creux pour la collerette de la cheville, au dos
            translate([0, 0, -1]) cylinder(d = d_collerette, h = p_collerette + 1);
        }
        // trou du boulon de blocage, écrou noyé dans la joue droite (-X)
        translate([0, ep_platine + y_boulon, z_boulon]) rotate([0, 90, 0]) {
            cylinder(d = d_boulon, h = 4 * larg_platine, center = true);
            translate([0, 0, -larg_platine / 2 - 1])
                cylinder(d = (ecrou_surplat + 0.3) / cos(30), h = ecrou_ep + 1.4, $fn = 6);
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
    color("royalblue") platine();
    color("orange") translate([0, ep_platine, 0]) support();
    color("white", 0.6) translate([-200, 0, 0]) cube([400, profondeur_etagere, 18]);
    color("tan", 0.6) translate([-200, -3, z_plat_bas - 60]) cube([400, 3, 78 - z_plat_bas]);
    // trait rouge = position de la porte fermée
    color("red") translate([-200, profondeur_etagere + ecart_porte, -2]) cube([400, 2, 4]);
    color("silver") for (i = [0:nb_cintres-1])
        translate([0, ep_platine, 0]) crochet(premiere_encoche + i * pas);
} else if (piece == "platine") {
    // couchée sur son dos (face contre le mur sur le plateau)
    rotate([90, 0, 0]) translate([0, 0, -z_plat_bas]) platine();
} else if (piece == "support") {
    support();
}
