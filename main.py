import hashlib
import json
import os
import shutil
import uuid
from git import Repo

def calculer_hash(image_path):
    sha256 = hashlib.sha256()
    with open(image_path, 'rb') as f:
        # Mettez à jour le hachage avec les données du fichier
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256.update(byte_block)
    # Retourne la représentation hexadécimale du hachage
    return sha256.hexdigest()

def renommer_et_ajouter_sur_git(image_path, repo):
    # Calcul du hash
    hash_result = calculer_hash(image_path)

    # Générer un UUID unique
    unique_id = str(uuid.uuid4()).replace('-', '')

    # Obtenir le nom du fichier et l'extension
    nom_fichier, extension = os.path.splitext(os.path.basename(image_path))

    # Construire le nouveau nom de fichier avec le hash, l'UUID et l'extension
    nouveau_nom = f"{hash_result}_{unique_id}{extension}"

    # Construire le chemin pour le nouveau fichier renommé
    nouveau_path = os.path.join(os.path.dirname(image_path), nouveau_nom)

    # Renommer le fichier
    os.rename(image_path, nouveau_path)

    # Ajouter le nouveau fichier renommé au suivi de Git
    repo.index.add([nouveau_path])



# Exemple d'utilisation
repo_url = 'https://github.com/helene-moore/archeSatoshi.git'
destination_folder = 'm'

# Cloner le référentiel Git
repo = Repo.clone_from(repo_url, destination_folder)

# Récupérer la liste des fichiers d'images dans le référentiel
images = [f for f in repo.git.ls_files().split('\n') if f.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.bmp'))]


def createJsonOfImages(image_json):
    data = {}
    data[image_json]= {
                "nom": input("Entrez le nom : "),
                "prenom": input("Entrez le prénom : "),
                "date de creation": input("Entrez la date de création : "),
                "Artiste": input("Entrez le nom de l'artiste : ")
    }

    imageChange = os.path.splitext(image_json)[0]
    json_object = json.dumps(data)
    with open(f"{destination_folder}/{imageChange}.json", 'w') as outfile:
        outfile.write(json_object)
        repo.index.add([f"{imageChange}.json"])
    #return json.dumps(data, indent=4)

# Renommer et ajouter chaque image renommée au suivi de Git
for image in images:
    image_path = os.path.join(destination_folder, image)
    image_path_absolute = os.path.abspath(image_path)
    renommer_et_ajouter_sur_git(image_path_absolute, repo)
for image_json in images:
    createJsonOfImages(image_json)



# Commit et push des changements
repo.index.commit("Renommage et ajout automatiques d'images")
repo.remote().push()


