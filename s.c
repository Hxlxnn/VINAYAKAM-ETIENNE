#include <stdio.h>
#include <stdlib.h>

typedef struct Noeud {
    int id_trajet;
    float max_trajet;
    float min_trajet;
    float moy_trajet;
    int nb_trajet;
    struct Noeud *gauche;
    struct Noeud *droite;
    int hauteur;
} Noeud;

// Fonction utilitaire pour obtenir la hauteur d'un nœud
int hauteur(Noeud *N) {
    if (N == NULL)
        return 0;
    return N->hauteur;
}

// Fonction utilitaire pour obtenir le maximum entre deux entiers
int max(int a, int b) {
    return (a > b) ? a : b;
}

// Créer un nouveau nœud avec un trajet donné
Noeud *nouveauNoeud(int id_trajet, float distance_trajet) {
    Noeud *noeud = (Noeud *)malloc(sizeof(Noeud));
    noeud->id_trajet = id_trajet;
    noeud->max_trajet = distance_trajet;
    noeud->min_trajet = distance_trajet;
    noeud->moy_trajet=distance_trajet;
    noeud->nb_trajet=1;
    noeud->gauche = noeud->droite = NULL;
    noeud->hauteur = 1; // Nouveau nœud a une hauteur de 1
    return noeud;
}

// Rotation simple à droite (RR rotation)
Noeud *rotationDroite(Noeud *y) {
    Noeud *x = y->gauche;
    Noeud *T2 = x->droite;

    // Effectuer la rotation
    x->droite = y;
    y->gauche = T2;

    // Mettre à jour les hauteurs
    y->hauteur = max(hauteur(y->gauche), hauteur(y->droite)) + 1;
    x->hauteur = max(hauteur(x->gauche), hauteur(x->droite)) + 1;

    return x; // La nouvelle racine après la rotation
}

// Rotation simple à gauche (LL rotation)
Noeud *rotationGauche(Noeud *x) {
    Noeud *y = x->droite;
    Noeud *T2 = y->gauche;

    // Effectuer la rotation
    y->gauche = x;
    x->droite = T2;

    // Mettre à jour les hauteurs
    x->hauteur = max(hauteur(x->gauche), hauteur(x->droite)) + 1;
    y->hauteur = max(hauteur(y->gauche), hauteur(y->droite)) + 1;

    return y; // La nouvelle racine après la rotation
}

// Obtenir le facteur d'équilibre d'un nœud
int facteurEquilibre(Noeud *N) {
    if (N == NULL)
        return 0;
    return hauteur(N->gauche) - hauteur(N->droite);
}

// Insérer un nœud dans un arbre AVL
Noeud *insererAVL(Noeud *racine, int id_trajet, float distance_trajet) {
    // Étape d'insertion normale BST
    if (racine == NULL)
        return nouveauNoeud(id_trajet, distance_trajet);

    if (id_trajet < racine->id_trajet)
        racine->gauche = insererAVL(racine->gauche, id_trajet, distance_trajet);
    else if (id_trajet > racine->id_trajet)
        racine->droite = insererAVL(racine->droite, id_trajet, distance_trajet);
    else{
	racine->moy_trajet= racine->moy_trajet +distance_trajet;
	racine->nb_trajet++;
	if (distance_trajet > racine->max_trajet) //id trajet déjà présent dans l'AVL = Vérification maximum/minimum
	{racine->max_trajet=distance_trajet;
	return racine;}
    if (distance_trajet < racine->min_trajet){
	racine->min_trajet=distance_trajet;
	return racine;}}
	

    // Mettre à jour la hauteur du nœud actuel
    racine->hauteur = 1 + max(hauteur(racine->gauche), hauteur(racine->droite));

    // Obtenir le facteur d'équilibre de ce nœud pour vérifier l'équilibre
    int equilibre = facteurEquilibre(racine);

    // Cas de déséquilibre à gauche gauche
    if (equilibre > 1 && id_trajet < racine->gauche->id_trajet)
        return rotationDroite(racine);

    // Cas de déséquilibre à droite droite
    if (equilibre < -1 && id_trajet > racine->droite->id_trajet)
        return rotationGauche(racine);

    // Cas de déséquilibre à gauche droite
    if (equilibre > 1 && id_trajet > racine->gauche->id_trajet) {
        racine->gauche = rotationGauche(racine->gauche);
        return rotationDroite(racine);
    }

    // Cas de déséquilibre à droite gauche
    if (equilibre < -1 && id_trajet < racine->droite->id_trajet) {
        racine->droite = rotationDroite(racine->droite);
        return rotationGauche(racine);
    }

    return racine; // La racine inchangée si aucun cas de déséquilibre n'est rencontré
}

// Afficher l'arbre AVL (pour le débogage)
void afficherAVL(Noeud *racine) { // gauche droite racine
    if (racine != NULL) {
    afficherAVL(racine->gauche);
    afficherAVL(racine->droite);
        printf("ID Trajet : %d, Distance max: %.3lf, distance min:%f, moyenne:%f\n", racine->id_trajet, racine->max_trajet, racine->min_trajet, racine->moy_trajet/racine->nb_trajet);
        
    }
}

// Libérer la mémoire allouée pour l'arbre AVL
void libererAVL(Noeud *racine) {
    if (racine != NULL) {
        libererAVL(racine->gauche);
        libererAVL(racine->droite);
        free(racine);
    }
}
Noeud *NouveauNoeudAVL(Noeud *noeud) {
	Noeud *nouveaunoeud = malloc(sizeof(Noeud));
	nouveaunoeud->id_trajet = noeud->id_trajet;
	nouveaunoeud->gauche = NULL;
	nouveaunoeud->droite = NULL;
	nouveaunoeud->hauteur = 1;

	// Mise à jour des champs en fonction du nouveau nœud
	nouveaunoeud->max_trajet = noeud->max_trajet;
	nouveaunoeud->min_trajet = noeud->min_trajet;
	nouveaunoeud->moy_trajet = noeud->moy_trajet;
	nouveaunoeud->nb_trajet = noeud->nb_trajet;
	return nouveaunoeud;
}

	
// Insérer un nœud dans un arbre AVL trié par max_trajet
Noeud *insererAVLParMaxTrajet(Noeud *racine, Noeud *nouveauNoeud) {
    // insertion normale
	if (racine == NULL)
        	return NouveauNoeudAVL(nouveauNoeud);

	if (nouveauNoeud->max_trajet <= racine->max_trajet)
		racine->gauche = insererAVLParMaxTrajet(racine->gauche, nouveauNoeud);
	else if (nouveauNoeud->max_trajet > racine->max_trajet)
		racine->droite = insererAVLParMaxTrajet(racine->droite, nouveauNoeud);
   

    // Mettre à jour la hauteur du nœud actuel
	racine->hauteur = 1 + max(hauteur(racine->gauche), hauteur(racine->droite));

    // Obtenir le facteur d'équilibre de ce nœud pour vérifier l'équilibre
	int equilibre = facteurEquilibre(racine);

    // Cas de déséquilibre à gauche gauche
	if (equilibre > 1 && nouveauNoeud->max_trajet < racine->gauche->max_trajet)
		return rotationDroite(racine);

    // Cas de déséquilibre à droite droite
	if (equilibre < -1 && nouveauNoeud->max_trajet > racine->droite->max_trajet)
		return rotationGauche(racine);

    // Cas de déséquilibre à gauche droite
    if (equilibre > 1 && nouveauNoeud->max_trajet > racine->gauche->max_trajet) {
        racine->gauche = rotationGauche(racine->gauche);
        return rotationDroite(racine);
    }

    // Cas de déséquilibre à droite gauche
    if (equilibre < -1 && nouveauNoeud->max_trajet < racine->droite->max_trajet) {
        racine->droite = rotationDroite(racine->droite);
        return rotationGauche(racine);
    }

    return racine; // La racine inchangée si aucun cas de déséquilibre n'est rencontré
}
 // Parcours en ordre de l'arbre initial et insertion dans le nouvel AVL
   Noeud *insererDansAVLParMaxTrajet(Noeud *noeud, Noeud *arbreMaxTrajet) {
   if(arbreMaxTrajet==NULL){
   return NouveauNoeudAVL(noeud);
   }
   else{
    if (noeud != NULL) {
        arbreMaxTrajet = insererAVLParMaxTrajet(arbreMaxTrajet, noeud);
        arbreMaxTrajet = insererDansAVLParMaxTrajet(noeud->gauche, arbreMaxTrajet);
        arbreMaxTrajet = insererDansAVLParMaxTrajet(noeud->droite, arbreMaxTrajet);
    }
    return arbreMaxTrajet;}
}


// Fonction pour créer un nouvel AVL trié par max_trajet
Noeud *creerAVLParMaxTrajet(Noeud *arbreInitial, Noeud *arbreMaxTrajet) {
    if (arbreMaxTrajet == NULL) {
        return insererDansAVLParMaxTrajet(arbreInitial, arbreMaxTrajet);
    } else {
        return insererDansAVLParMaxTrajet(arbreInitial, arbreMaxTrajet);
    }
}

void afficherAVLDecroissant(Noeud *racine) { //Droite-racine-gauche
    if (racine != NULL) {
        afficherAVLDecroissant(racine->droite);  
        printf("ID Trajet : %d, Distance max: %.3lf, distance min:%f, moyenne:%f\n", racine->id_trajet, racine->max_trajet, racine->min_trajet, racine->moy_trajet/racine->nb_trajet);
        afficherAVLDecroissant(racine->gauche); 
    }
}


int main() {
    FILE *fichier = fopen("data.csv", "r");
    if (fichier == NULL) {
        fprintf(stderr, "Impossible d'ouvrir le fichier data.csv.\n");
        return 1;
    }

    char ligne[100];
    Noeud *arbreTrajets = NULL;

    // Lire chaque ligne du fichier
    while (fgets(ligne, sizeof(ligne), fichier) != NULL) {
        int id_trajet;
        float distance_trajet;

        // Extraire les données du trajet
        sscanf(ligne, "%d;%*d;%*[^;];%*[^;];%f;%*[^;]", &id_trajet, &distance_trajet);

        // Insérer le trajet dans l'AVL
        arbreTrajets = insererAVL(arbreTrajets, id_trajet, distance_trajet);
    }

    fclose(fichier);

// Créer un nouvel AVL trié par max_trajet
    Noeud *arbreMaxTrajet = NULL;
    arbreMaxTrajet=creerAVLParMaxTrajet(arbreTrajets, arbreMaxTrajet);
	afficherAVL(arbreTrajets);
	printf("\n Nouvel AVL!!!!!\n");
    // Afficher l'AVL trié par max_trajet
    afficherAVLDecroissant(arbreMaxTrajet);

    // Libérer la mémoire allouée pour les deux arbres
    libererAVL(arbreTrajets);
    libererAVL(arbreMaxTrajet);

    // Afficher l'AVL (pour le débogage)
    //afficherAVL(arbreTrajets);

    

    return 0;
}


//Régler problème de noeud
