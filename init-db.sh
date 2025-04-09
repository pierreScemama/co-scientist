#!/bin/bash
set -e

# Function to create a new database if it doesn't exist
create_user_and_database() {
    local database=$1
    echo "Creating user and database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE DATABASE $database;
        GRANT ALL PRIVILEGES ON DATABASE $database TO $POSTGRES_USER;
EOSQL
}

# Create a database for n8n if it doesn't exist already
if [ "$POSTGRES_MULTIPLE_DATABASES" ]; then
    echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
    for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
        create_user_and_database $db
    done
    echo "Multiple databases created"
fi

# Create tables for co-scientist in the dedicated database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "coscientist" <<-EOSQL
    -- Create schema
    CREATE SCHEMA IF NOT EXISTS co_scientist;

    -- Create publications table
    CREATE TABLE IF NOT EXISTS co_scientist.publications (
        id SERIAL PRIMARY KEY,
        title TEXT NOT NULL,
        authors TEXT,
        year INTEGER,
        source TEXT,
        abstract TEXT,
        keywords TEXT[],
        zotero_key TEXT UNIQUE,
        notion_id TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    -- Create hypotheses table
    CREATE TABLE IF NOT EXISTS co_scientist.hypotheses (
        id SERIAL PRIMARY KEY,
        content TEXT NOT NULL,
        supporting_evidence TEXT,
        related_publications INTEGER[],
        status TEXT DEFAULT 'proposed',
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    -- Create experiments table
    CREATE TABLE IF NOT EXISTS co_scientist.experiments (
        id SERIAL PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        protocol TEXT,
        related_hypotheses INTEGER[],
        status TEXT DEFAULT 'designed',
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    -- Create agent_memory table to store context across sessions
    CREATE TABLE IF NOT EXISTS co_scientist.agent_memory (
        id SERIAL PRIMARY KEY,
        agent_name TEXT NOT NULL,
        memory_key TEXT NOT NULL,
        memory_value JSONB NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(agent_name, memory_key)
    );

    -- Create conversations table
    CREATE TABLE IF NOT EXISTS co_scientist.conversations (
        id SERIAL PRIMARY KEY,
        session_id TEXT NOT NULL,
        speaker TEXT NOT NULL,
        message TEXT NOT NULL,
        timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        metadata JSONB
    );

    -- Create indexes for better performance
    CREATE INDEX IF NOT EXISTS idx_publications_zotero_key ON co_scientist.publications(zotero_key);
    CREATE INDEX IF NOT EXISTS idx_publications_year ON co_scientist.publications(year);
    CREATE INDEX IF NOT EXISTS idx_hypotheses_status ON co_scientist.hypotheses(status);
    CREATE INDEX IF NOT EXISTS idx_experiments_status ON co_scientist.experiments(status);
    CREATE INDEX IF NOT EXISTS idx_conversations_session ON co_scientist.conversations(session_id);
EOSQL
