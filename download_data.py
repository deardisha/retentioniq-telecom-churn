from pathlib import Path
import shutil

import kagglehub


DATASET_HANDLE = "abdullah0a/telecom-customer-churn-insights-for-analysis"
RAW_DATA_DIR = Path("data/raw")


def main() -> None:
    """Download the Kaggle dataset and copy its files into data/raw."""

    RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)

    print("Downloading dataset...")

    downloaded_path = Path(
        kagglehub.dataset_download(DATASET_HANDLE)
    )

    print(f"Dataset downloaded to: {downloaded_path}")
    print("\nFiles found:")

    files_found = []

    for source_file in downloaded_path.rglob("*"):
        if source_file.is_file():
            files_found.append(source_file)
            print(f"- {source_file.name}")

            destination = RAW_DATA_DIR / source_file.name

            if source_file.resolve() != destination.resolve():
                shutil.copy2(source_file, destination)

    if not files_found:
        raise FileNotFoundError(
            "The dataset downloaded, but no files were found."
        )

    print("\nFiles copied into data/raw:")

    for file_path in RAW_DATA_DIR.iterdir():
        if file_path.is_file():
            print(f"- {file_path}")


if __name__ == "__main__":
    main()