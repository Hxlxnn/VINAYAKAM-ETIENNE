#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Etape {
    char ville[50];
    struct Etape *gauche;
    struct Etape *droite;
    int hauteur;
} Etape;

// Fonction utilitaire pour obtenir la hauteur d'un nœud
int hauteur(Etape *N) {
    if (N == NULL)
        return 0;
    return N->hauteur;
}

// Fonction utilitaire pour obtenir le maximum entre deux entiers
int max(int a, int b) {
    return (a > b) ? a : b;
}

// Créer un nouveau nœud avec une ville donnée
Etape *nouvelEtape(char *ville) {
    Etape *et = (Etape *)malloc(sizeof(Etape));
    strcpy(et->ville, ville);
    et->gauche = et->droite = NULL;
    et->hauteur = 1; // Nouveau nœud a une hauteur de 1
    return et;
}

// Rotation simple à droite (RR rotation)
Etape *rotationDroite(Etape *y) {
    Etape *x = y->gauche;
    Etape *T2 = x->droite;

    // Effectuer la rotation
    x->droite = y;
    y->gauche = T2;

    // Mettre à jour les hauteurs
    y->hauteur = max(hauteur(y->gauche), hauteur(y->droite)) + 1;
    x->hauteur = max(hauteur(x->gauche), hauteur(x->droite)) + 1;

    return x; // La nouvelle racine après la rotation
}

// Rotation simple à gauche (LL rotation)
Etape *rotationGauche(Etape *x) {
    Etape *y = x->droite;
    Etape *T2 = y->gauche;

    // Effectuer la rotation
    y->gauche = x;
    x->droite = T2;

    // Mettre à jour les hauteurs
    x->hauteur = max(hauteur(x->gauche), hauteur(x->droite)) + 1;
    y->hauteur = max(hauteur(y->gauche), hauteur(y->droite)) + 1;

    return y; // La nouvelle racine après la rotation
}

// Obtenir le facteur d'équilibre d'un nœud
int facteurEquilibre(Etape *N) {
    if (N == NULL)
        return 0;
    return hauteur(N->gauche) - hauteur(N->droite);
}

// Insérer un nœud dans un arbre AVL
Etape *inserer(Etape *racine, char *ville) {
    // Étape d'insertion normale BST
    if (racine == NULL)
        return nouvelEtape(ville);

    if (strcmp(ville, racine->ville) < 0)
        racine->gauche = inserer(racine->gauche, ville);
    else if (strcmp(ville, racine->ville) > 0)
        racine->droite = inserer(racine->droite, ville);
    else // Ne pas permettre les villes en double
        return racine;

    // Mettre à jour la hauteur du nœud actuel
    racine->hauteur = 1 + max(hauteur(racine->gauche), hauteur(racine->droite));

    // Obtenir le facteur d'équilibre de ce nœud pour vérifier l'équilibre
    int equilibre = facteurEquilibre(racine);

    // Cas de déséquilibre à gauche gauche
    if (equilibre > 1 && strcmp(ville, racine->gauche->ville) < 0)
        return rotationDroite(racine);

    // Cas de déséquilibre à droite droite
    if (equilibre < -1 && strcmp(ville, racine->droite->ville) > 0)
        return rotationGauche(racine);

    // Cas de déséquilibre à gauche droite
    if (equilibre > 1 && strcmp(ville, racine->gauche->ville) > 0) {
        racine->gauche = rotationGauche(racine->gauche);
        return rotationDroite(racine);
    }

    // Cas de déséquilibre à droite gauche
    if (equilibre < -1 && strcmp(ville, racine->droite->ville) < 0) {
        racine->droite = rotationDroite(racine->droite);
        return rotationGauche(racine);
    }

    return racine; // La racine inchangée si aucun cas de déséquilibre n'est rencontré
}

// Afficher l'arbre AVL par ordre alphabétique
void afficherAVL(Etape *racine) {
    if (racine != NULL) {
        afficherAVL(racine->gauche);
        printf("%s\n", racine->ville);
        afficherAVL(racine->droite);
    }
}

// Libérer la mémoire allouée pour l'arbre AVL
void libererAVL(Etape *racine) {
    if (racine != NULL) {
        libererAVL(racine->gauche);
        libererAVL(racine->droite);
        free(racine);
    }
}

char* extraireVille(char* ligne) {
    char* debut = ligne;
    char* fin = strchr(debut, ',');

    if (fin != NULL) {
        // Ignorer les espaces après la virgule
        while (*(fin + 1) == ' ' || *(fin + 1) == '\t') {
            ++fin;
        }

        // Calculer la longueur de la ville
        size_t longueur = fin - debut;

        // Allouer de la mémoire pour la ville
        char* ville = (char*)malloc(longueur + 1);

        // Copier la ville dans la nouvelle mémoire allouée
        strncpy(ville, debut, longueur);

        // Ajouter le caractère de fin de chaîne
        ville[longueur] = '\0';

        return ville;
    }

    return NULL;
}

int main() {
    FILE *fichier = fopen("resultats.txt", "r");
    if (fichier == NULL) {
        fprintf(stderr, "Impossible d'ouvrir le fichier resultats.txt.\n");
        return 1;
    }

    char ligne[100];
    Etape *arbreVilles = NULL;

    // Lire chaque ligne du fichier
    while (fgets(ligne, sizeof(ligne), fichier) != NULL) {
        char* ville = extraireVille(ligne);
        
        // Insérer la ville dans l'arbre AVL
        arbreVilles = inserer(arbreVilles, ville);
    }

    fclose(fichier);

    // Afficher l'arbre AVL trié par ordre alphabétique
    afficherAVL(arbreVilles);

    // Libérer la mémoire allouée pour l'arbre AVL
    libererAVL(arbreVilles);

    return 0;
}
