import ProjectDescription

public struct Module {
  
  // Имя модуля
  let name: String
  
  /// Тип модуля
  let moduleType: AppModuleType
  
  /// Путь "Название папки модуля в проекте"
  let path: String
  
  /// Зависимости от других фраймворков
  /// `.target(name: "Common"), .target(name: "Haneke")]`
  let frameworkDependancies: [TargetDependency]
  
  /// Зависимость для песочницы
  /// `.target(name: "Detail")`
  let exampleDependencies: [TargetDependency]
  
  /// Список ресурсов
  /// `"Resources/**", "Sources/**/*.xib", "Sources/**/*.storyboard"`
  let frameworkResources: [String]
  
  /// Список ресурсов для песочницы
  /// `"Resources/**", "Sources/**/*.storyboard"`
  let exampleResources: [String]
  
  /// Ресурсы с тестовыми данными
  /// `"**/*.json"`
  let testResources: [String]
  
  /// Тип целей для приложения
  /// `.framework, .unitTests, .uiTests, .exampleApp`
  let targets: Set<FeatureTarget>
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - name: Имя модуля
  ///  - moduleType: Тип модуля
  ///  - path: Путь "Название папки модуля в проекте"
  ///  - frameworkDependancies: Зависимости от других фраймворков
  ///  - exampleDependencies: Зависимость для песочницы
  ///  - frameworkResources: Список ресурсов
  ///  - exampleResources: Список ресурсов для песочницы
  ///  - testResources: Ресурсы с тестовыми данными
  ///  - targets: Тип целей для приложения
  public init(name: String,
              moduleType: AppModuleType,
              path: String,
              frameworkDependancies: [TargetDependency],
              exampleDependencies: [TargetDependency],
              frameworkResources: [String],
              exampleResources: [String],
              testResources: [String],
              targets: Set<FeatureTarget> = Set([.framework, .unitTests, .exampleApp])) {
    self.name = name
    self.moduleType = moduleType
    self.path = path
    self.frameworkDependancies = frameworkDependancies
    self.exampleDependencies = exampleDependencies
    self.frameworkResources = frameworkResources
    self.exampleResources = exampleResources
    self.testResources = testResources
    self.targets = targets
  }
}
