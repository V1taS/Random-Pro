import ProjectDescription
import Foundation

var defaultYear: String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy"
  return dateFormatter.string(from: Date())
}

var defaultDate: String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "dd/MM/yyyy"
  return dateFormatter.string(from: Date())
}

private let organizationName = "SosinVitalii.com"
private let nameAttribute: Template.Attribute = .required("name")
private let authorAttribute: Template.Attribute = .required("author")
private let yearAttribute: Template.Attribute = .optional("year", default: defaultYear)
private let dateAttribute: Template.Attribute = .optional("date", default: defaultDate)
private let companyAttribute: Template.Attribute = .optional("company",
                                                     default: organizationName)

let template = Template(
  description: "Module template",
  attributes: [
    nameAttribute,
    authorAttribute,
    yearAttribute,
    dateAttribute,
    companyAttribute,
    .optional("platform", default: "ios")
  ],
  items: [
    .file(
      path: "\(nameAttribute)/Sources/\(nameAttribute)ViewController.swift",
      templatePath: "ViewController.stencil"
    ),
    .file(
      path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
      templatePath: "Tests.stencil"
    ),
    .file(
      path: "\(nameAttribute)/UITests/\(nameAttribute)UITests.swift",
      templatePath: "UITests.stencil"
    ),
    .directory(
      path: "\(nameAttribute)",
      sourcePath: "Resources"
    ),
    .directory(
      path: "\(nameAttribute)/Example",
      sourcePath: "Resources"
    ),
    .file(
      path: "\(nameAttribute)/Example/Resources/LaunchScreen.storyboard",
      templatePath: "LaunchScreen.stencil"
    ),
    .file(
      path: "\(nameAttribute)/Example/Sources/ExampleAppController.swift",
      templatePath: "ExampleAppController.stencil"
    ),
    .file(
      path: "\(nameAttribute)/Example/Sources/AppDelegate.swift",
      templatePath: "ExampleAppDelegate.stencil"
    )
  ]
)
