#!/bin/bash

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    uv venv
fi

# Ensure pip is available in the venv
echo "Installing pip in virtual environment..."
uv run python -m ensurepip --upgrade

# Install dependencies with compatible Elasticsearch version
echo "Installing dependencies..."
uv pip install PyYAML datasets "elasticsearch<8.0" tqdm spacy torch transformers "numpy<2"

# Download spacy model (backup)
echo "Ensuring spacy model is available..."
uv run python -m spacy download en_core_web_lg 

# Stop any existing elasticsearch containers and start compatible version
echo "Setting up Elasticsearch..."
docker stop elasticsearch 2>/dev/null || true
docker rm elasticsearch 2>/dev/null || true
docker run -d --name elasticsearch \
  -p 9200:9200 \
  -e "discovery.type=single-node" \
  -e "xpack.security.enabled=false" \
  elasticsearch:7.17.15

# Wait for Elasticsearch to start
echo "Waiting for Elasticsearch to start..."
sleep 10

# Set environment variable
export ELASTIC_PASSWORD=""

# Index the training data
echo "Indexing training data..."
uv run python index.py --dataset vishalbakshi/fake-train-data --messages_field messages --query_filter role:user --query_field content 

# Search and decontaminate
echo "Running search and decontamination..."
uv run python search.py --train_dataset_names vishalbakshi/fake-train-data --dataset vishalbakshi/simple-test-data --field content --decontaminate --output_dir ./results

echo "Decontamination complete! Check ./results for output files."