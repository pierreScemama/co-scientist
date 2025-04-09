# Co-Scientist

Un système multi-agent basé sur n8n pour l'assistance à la recherche en économie écologique.

## Description

Co-Scientist est un assistant de recherche intelligent composé de plusieurs agents spécialisés :
- **Agent Bibliographe** : Recherche et analyse de la littérature scientifique
- **Agent Analyste** : Analyse de données et création de visualisations
- **Agent Générateur d'Hypothèses** : Formulation d'hypothèses de recherche testables
- **Agent Concepteur d'Expériences** : Conception de protocoles expérimentaux
- **Agent Coordinateur** : Orchestration des différents agents et interface utilisateur

## Prérequis

- Docker et Docker Compose
- Ollama (pour l'exécution locale de modèles de langage)
- Au moins un modèle installé dans Ollama (ex: `ollama pull mistral` ou `ollama pull llama3`)

## Installation

1. Clonez ce dépôt :
```bash
git clone https://github.com/pierreScemama/co-scientist.git
cd co-scientist
```

2. Assurez-vous que le script d'initialisation est exécutable :
```bash
chmod +x init-db.sh
```

3. Modifiez le fichier docker-compose.yml si nécessaire (adaptez les mots de passe, etc.)

4. Démarrez les services :
```bash
docker-compose up -d
```

5. Accédez à n8n via http://localhost:5678 et configurez vos workflows

## Configuration de l'agent IA local

1. Assurez-vous qu'Ollama est en cours d'exécution sur votre machine hôte
2. Dans n8n, utilisez les nœuds Ollama avec l'URL de base : `http://host.docker.internal:11434`

## Structure de la base de données

La base de données PostgreSQL inclut plusieurs tables pour le stockage des données des agents :

- **publications** : Stocke les informations sur les publications scientifiques
- **hypotheses** : Conserve les hypothèses générées par l'agent correspondant
- **experiments** : Détaille les protocoles expérimentaux conçus
- **agent_memory** : Stocke le contexte et la mémoire de chaque agent
- **conversations** : Archive les interactions avec les utilisateurs

## Développement

Pour ajouter de nouveaux agents ou modifier la structure de la base de données :

1. Mettez à jour le script init-db.sh avec les nouvelles tables requises
2. Reconstruisez les services :
```bash
docker-compose down
docker-compose up -d --build
```

## Liens avec d'autres outils

- **Zotero** : Utilise l'API Zotero pour accéder à votre bibliothèque de recherche
- **Notion** : Peut se synchroniser avec vos bases de données Notion via l'API
