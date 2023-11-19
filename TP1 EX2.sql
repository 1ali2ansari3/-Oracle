SELECT * FROM usine WHERE ville = 'Rabat';

SELECT ref_mag FROM provenance WHERE ref_usine = 109 AND ref_prod = 1;

SELECT ref_prod, nom_prod FROM produit WHERE couleur = 'rouge';

SELECT ref_prod, nom_prod FROM produit WHERE nom_prod LIKE 'casse%';

SELECT ref_mag FROM provenance;

SELECT ref_mag FROM magasin EXCEPT SELECT ref_mag FROM provenance;

SELECT DISTINCT ON (ref_prod) nom_prod, couleur FROM produit NATURAL JOIN provenance WHERE ref_usine = 189;

SELECT ref_mag FROM provenance, produit WHERE ref_usine = 302 AND provenance.ref_prod = produit.ref_prod AND produit.couleur = 'rouge';

SELECT poids AS poids_livraisons FROM provenance WHERE ref_mag = 30 AND ref_usine = 189 AND ref_prod = 12;

SELECT poids AS poids_livraisons, ref_prod, ref_mag, ref_usine FROM provenance;

SELECT u.nom_usine, m.nom_mag, u.ville FROM usine u, magasin m WHERE u.ville = m.ville;

SELECT DISTINCT nom_mag FROM magasin WHERE ref_mag NOT IN (SELECT ref_mag FROM provenance WHERE ref_prod = 12);

SELECT DISTINCT nom_mag FROM magasin WHERE ref_mag IN (SELECT ref_mag FROM provenance JOIN produit ON provenance.ref_prod = produit.ref_prod WHERE produit.couleur = 'rouge');