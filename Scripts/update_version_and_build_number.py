import os
import json

VERSIONS_FILE = "versions.json"

def update_versions():
    if os.path.exists(VERSIONS_FILE):
        with open(VERSIONS_FILE, "r") as f:
            versions = json.load(f)
    else:
        versions = {"marketing_version": "777.5", "current_project_version": "160"}

    # Увеличиваем значение marketing_version
    major, minor = map(int, versions["marketing_version"].split("."))
    minor += 1
    versions["marketing_version"] = f"{major}.{minor}"

    # Увеличиваем значение current_project_version
    versions["current_project_version"] = str(int(versions["current_project_version"]) + 1)

    with open(VERSIONS_FILE, "w") as f:
        json.dump(versions, f)

    return versions["marketing_version"], versions["current_project_version"]

if __name__ == "__main__":
    marketing_version, current_project_version = update_versions()
    print(f"Updated versions: Marketing version: {marketing_version}, Current project version: {current_project_version}")
