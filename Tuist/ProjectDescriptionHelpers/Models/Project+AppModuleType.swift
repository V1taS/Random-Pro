import ProjectDescription

/// Тип модуля в приложении
public enum AppModuleType {
  
  /// Основа
  case core(String? = nil)
  
  /// Фичи
  case feature(String? = nil)
  
  /// Приложение
  case app(String? = nil)
  
  /// Путь для модуля "Название папки в проекте"
  func path() -> String {
    let appearance = Appearance()
    switch self {
    case let .core(path):
      if let path {
        return appearance.corePath + "/" + path
      } else {
        return appearance.corePath
      }
    case let .feature(path):
      if let path {
        return appearance.featuresPath + "/" + path
      } else {
        return appearance.featuresPath
      }
    case let .app(path):
      if let path {
        return appearance.appPath + "/" + path
      } else {
        return appearance.appPath
      }
    }
  }
}
