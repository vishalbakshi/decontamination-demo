# decontamination-demo
Demo of Allen AI's Dataset decontamination on a simple pair of fake data datasets

This is a hacky "just get it to work" demo. 

## Datasets Used

- https://huggingface.co/datasets/vishalbakshi/fake-train-data
- https://huggingface.co/datasets/vishalbakshi/simple-test-data

I had to "flatten" the test dataset to make the script work but that's likely because I don't understand the flags enough to make it work otherwise.

## Installation + Running the Script

1. Install [Docker Desktop](https://docs.docker.com/desktop/) (or Docker Engine, you need the `docker` command available on your machine).
2. Run:

```
chmod +x run.sh
./run.sh
```

This will create an environment, install deps, download the spaCy model used, index the training dataset and then search/decontaminate it with the test dataset.

## Outputs

In a `results` directory you should see two files and a folder:

- contamination_results.tsv (the percentage of contamination)
- vishalbakshi_fake-train-data_decontaminated
  - train.parquet (the decontaminated dataset)
- vishalbakshi_fake-train-data_text_simple-test-data.jsonl (the contaminated dataset items)

