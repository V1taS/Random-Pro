import json
import re

with open("versions.json", "r") as f:
    versions = json.load(f)

marketing_version = versions["marketing_version"]
current_project_version = versions["current_project_version"]

with open("Tuist/ProjectDescriptionHelpers/Project+Appearance.swift", "r") as f:
    content = f.read()

content = re.sub(r'public let marketingVersion = ".*"', f'public let marketingVersion = "{marketing_version}"', content)
content = re.sub(r'public let currentProjectVersion = ".*"', f'public let currentProjectVersion = "{current_project_version}"', content)

with open("Tuist/ProjectDescriptionHelpers/Project+Appearance.swift", "w") as f:
    f.write(content)