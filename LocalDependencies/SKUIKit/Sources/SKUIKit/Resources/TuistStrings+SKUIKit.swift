// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum SKUIKitStrings {
  
  public enum State {    
    public static let messageContextMenuTitle = SKUIKitStrings.tr(
      "MessageViewLocalization",
      "State.Message.ContextMenu.Title"
    )
    public static let messageCopyButtonTitle = SKUIKitStrings.tr(
      "MessageViewLocalization",
      "State.Message.CopyButton.Title"
    )
    public static let messageDeleteButtonTitle = SKUIKitStrings.tr(
      "MessageViewLocalization",
      "State.Message.DeleteButton.Title"
    )
    public static let messageRetryButtonTitle = SKUIKitStrings.tr(
      "MessageViewLocalization",
      "State.Message.RetryButton.Title"
    )
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension SKUIKitStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.module.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
// swiftlint:enable all
// swiftformat:enable all
