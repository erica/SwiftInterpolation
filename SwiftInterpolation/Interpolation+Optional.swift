/*
 
 Optional interpolation reform
 
 */

extension String.StringInterpolation {
  /// Provides `Optional` string interpolation without forcing the
  /// use of `String(describing:)`.
  ///
  /// - Parameters:
  ///   - value: An optional value to interpolate for the `.some` case
  ///   - defaultValue: The string to present for the `.none`/`nil` case
  public mutating func appendInterpolation<Wrapped>(
    _ value: Wrapped?,
    default defaultValue: String
    ) {
    if let value = value {
      appendInterpolation(value)
    } else {
      appendLiteral(defaultValue)
    }
  }
}

extension String.StringInterpolation {
  /// Interpolates optional values using a supplied style.
  ///
  /// ```
  /// // "There's Optional(23) and nil"
  /// "There's \(value1, .format(style: .default)) and \(value2, .format(style: .default))"
  ///
  /// // "There's Optional(23) and Optional(nil)"
  /// "There's \(value1, .format(style: .descriptive)) and \(value2, .format(style: .descriptive))"
  ///
  /// // "There's 23 and nil"
  /// "There's \(value1, .format(style: .stripped)) and \(value2, .format(style: .stripped))"
  /// "There's \(value1, .format()) and \(value2, .format())"
  /// ```
  ///
  /// - Parameters:
  ///   - value: An optional value to interpolate for the `.some` case
  ///   - formatter: An `OptionalFormatter` instance
  public mutating func appendInterpolation<Wrapped>(_ value: Wrapped?, _ formatter: OptionalFormatter) {
    appendLiteral(formatter.string(from: value))
  }
}

public class OptionalFormatter {
  /// Optional Interpolation Styles
  public enum OptionalStyle {
    /// Includes the word `Optional` for both `some` and `none` cases
    case descriptive
    /// Strips the word `Optional` for both `some` and `none` cases
    case stripped
    /// Uses system interpolation, which includes the word `Optional` for
    /// `some` cases but not `none`.
    case `default`
  }
  
  ///  The style used to present the optional
  public var style: OptionalStyle = .stripped
  
  /// The fallback text for `.none` case
  public var defaultValue: String = "nil"
  
  public init(style: OptionalStyle = .stripped, `default`: String = "nil") {
    (self.style, self.defaultValue) = (style, `default`)
  }
  
  public static func format(style: OptionalStyle = .stripped, `default`: String = "nil") -> OptionalFormatter {
    return OptionalFormatter(style: style, default: `default`)
  }
  
  public func string<Wrapped>(from value: Wrapped?) -> String {
    switch style {
    /// Includes the word `Optional` for both `some` and `none` cases
    case .descriptive:
      if value == nil {
        return "Optional(\(defaultValue))"
      } else {
        return String(describing: value)
      }
    /// Strips the word `Optional` for both `some` and `none` cases
    case .stripped:
      if let value = value {
        return "\(value)"
      } else {
        return defaultValue
      }
      /// Uses system interpolation, which includes the word `Optional` for
    /// `some` cases but not `none`.
    default:
      if value != nil {
        return String(describing: value)
      } else {
        return defaultValue
      }
    }
  }
}
