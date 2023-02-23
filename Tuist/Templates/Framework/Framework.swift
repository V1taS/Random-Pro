import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Framework template",
    attributes: [
        nameAttribute,
        .optional("platform", default: "ios")
    ],
    items: [
        .file(path: "\(nameAttribute)/Sources/\(nameAttribute).swift", templatePath: "Framework.stencil"),
        
        // Placeholder UnitTest
        .file(path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift", templatePath: "UnitTests.stencil")
    ]
)
