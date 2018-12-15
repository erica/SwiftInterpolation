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
  
  /// Interpolates optional values using a supplied style.
  ///
  /// ```
  /// // "There's Optional(23) and nil"
  /// "There's \(value1, optStyle: .default) and \(value2, optStyle: .default)"
  ///
  /// // "There's Optional(23) and Optional(nil)"
  /// "There's \(value1, optStyle: .descriptive) and \(value2, optStyle: .descriptive)"
  ///
  /// // "There's 23 and nil"
  /// "There's \(value1, optStyle: .stripped) and \(value2, optStyle: .stripped)"
  /// ```
  ///
  /// - Parameters:
  ///   - value: An optional value to interpolate for the `.some` case
  ///   - optStyle: The style used to present the optional (`String.StringInterpolation.OptionalStyle`)
  ///   - default: The fallback presentation for `.none` case
  public mutating func appendInterpolation<Wrapped>(
    _ value: Wrapped?,
    optStyle style: String.StringInterpolation.OptionalStyle,
    default defaultValue: String = "nil"
    ) {
    switch style {
    /// Includes the word `Optional` for both `some` and `none` cases
    case .descriptive:
      if value == nil {
        appendLiteral("Optional(\(defaultValue))")
      } else {
        appendLiteral(String(describing: value))
      }
    /// Strips the word `Optional` for both `some` and `none` cases
    case .stripped:
      if let value = value {
        appendInterpolation(value)
      } else {
        appendLiteral("\(defaultValue)")
      }
      /// Uses system interpolation, which includes the word `Optional` for
    /// `some` cases but not `none`.
    default:
      appendLiteral(String(describing: value))
    }
  }
  
  /// Interpolates an optional using "stripped" interpolation, omitting
  /// the word "Optional" from both `.some` and `.none` cases
  ///
  /// ```
  /// // "There's 23 and nil"
  /// "There's \(describing: value1) and \(describing: value2)"
  /// ```
  public mutating func appendInterpolation<Wrapped>(describing value: Wrapped?) {
    appendInterpolation(value, optStyle: .stripped)
  }
}
