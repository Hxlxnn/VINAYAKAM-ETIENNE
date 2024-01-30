# Définit le compilateur
CC = gcc
# Définit l'emplacement des fichiers
FILES_DIR = progc
# Définit le répertoire de construction
BUILD_DIR = $(FILES_DIR)/bin
# Définit le répertoire des objets
OBJ_DIR = $(FILES_DIR)/obj
# Définit le répertoire source
SRC_DIR = $(FILES_DIR)/src
# Définit le nom exécutable
EXEC_NAME = CYTruck

# Obtient tous les fichiers c
SRC=$(wildcard $(SRC_DIR)/*.c)
# Obtient tous les fichiers o
OBJ=$(SRC:.c=.o)
# Supprime le chemin du répertoire source des noms
OBJ_STRIP=$(OBJ:$(SRC_DIR)/%=%)
# Liste des fichiers o dans le répertoire des objets
OBJ_IN_DIR=$(addprefix $(OBJ_DIR)/, $(OBJ_STRIP))

# Construit tout
all: objdir builddir exec

# Construit l'exécutable
exec: $(OBJ_IN_DIR)
	$(CC) $^ -o $(BUILD_DIR)/$(EXEC_NAME)

# Crée le répertoire bin
builddir: 
	mkdir -p $(BUILD_DIR)

# Crée le répertoire obj
objdir:
	mkdir -p $(OBJ_DIR)

# Supprime les répertoires bin et obj, avec tous les fichiers, sauf l'exécutable gnuplot
clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OBJ_DIR)

# Construit les fichiers o
$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c $(OBJ_DIR) objdir # Compile .c en .o
	$(CC) -c $< -o $@

