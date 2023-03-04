import Foundation
import ProjectDescription

public let scriptSwiftLint: ProjectDescription.TargetScript =  .pre(
  script: """
if test -d "/opt/homebrew/bin/"; then
  PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH="$PATH:/opt/homebrew/bin"

if which swiftlint > /dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
""",
  name: "SwiftLintString",
  basedOnDependencyAnalysis: false
)
