# Co-Scientist

Un système multi-agent basé sur n8n pour l'assistance à la recherche en économie écologique.

## Description

Co-Scientist est un assistant de recherche intelligent composé de plusieurs agents spécialisés :
- **Agent Bibliographe** : Recherche et analyse de la littérature scientifique
- **Agent Analyste** : Analyse de données et création de visualisations
- **Agent Générateur d'Hypothèses** : Formulation d'hypothèses de recherche testables
- **Agent Concepteur d'Expériences** : Conception de protocoles expérimentaux
- **Agent Coordinateur** : Orchestration des différents agents et interface utilisateur

## Guide d'installation simple

### Prérequis
- Docker et Docker Compose déjà installés
- Ollama déjà installé et fonctionnel

### Option 1 : Installation minimale (n8n + Ollama uniquement)

Si vous souhaitez simplement utiliser n8n avec votre instance locale d'Ollama :

1. Créez un fichier docker-compose.yml dans votre dossier n8n avec ce contenu :

```yaml
version: '3'

services:
  n8n:
    image: n8nio/n8n
    restart: always
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=votremotdepasse
      - NODE_ENV=production
      - N8N_HOST=localhost
      - N8N_PROTOCOL=http
      - N8N_PORT=5678
    volumes:
      - n8n_data:/home/node/.n8n
    extra_hosts:
      - "host.docker.internal:host-gateway"

volumes:
  n8n_data:
    external: false
```

2. Lancez n8n avec :
```
docker-compose up -d
```

3. Dans n8n, utilisez l'URL `http://host.docker.internal:11434` pour vous connecter à Ollama.

### Option 2 : Installation complète (avec PostgreSQL)

Pour une installation complète avec base de données PostgreSQL (recommandé pour projets avancés) :

**Instructions détaillées à venir**

## Utilisation des agents

### Agent Bibliographe

1. Créez un nouveau workflow dans n8n
2. Ajoutez un déclencheur "When chat message received"
3. Ajoutez un nœud Ollama avec l'URL `http://host.docker.internal:11434`
4. Configurez le prompt pour l'Agent Bibliographe
5. Testez avec le chat n8n

## Structure du projet

- **workflows/** : Exemples de workflows n8n pour les différents agents
- **docker-compose.yml** : Configuration pour les services Docker
- **init-db.sh** : Script d'initialisation pour PostgreSQL (option 2 uniquement)

## Développement

Pour l'instant, concentrez-vous sur la création et l'amélioration des workflows n8n pour chaque agent. La documentation sera enrichie au fur et à mesure.
