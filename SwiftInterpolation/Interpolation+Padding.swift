/*
 
 Value interpolation with optional string padding
 
 */

import Foundation

public extension String.StringInterpolation {
  /// Interpolates using a custom string formatter, allowing the results to
  /// be padded as desired, for example:
  ///
  /// ```
  /// "\(23, .format(width: 5))" // "   23"
  /// "\(23, .format(alignment: .left, width: 5))" // "23   "
  ///
  /// - Parameters:
  ///   - value: a value to present
  ///   - formatter: a string formatter
  mutating func appendInterpolation<Value>(_ value:  Value, _ formatter: StringFormatter, width: Int = 0) {
    if width != 0 { formatter.width = width }
    appendLiteral(formatter.string(from: "\(value)"))
  }
}

/// A formatter that adjusts string layout.
public class StringFormatter {
  /// The direction from which a string floats when
  /// padded with repeated characters.
  public enum TextAlignment { case left, right, center }
  
  /// The direction that aligns the text
  public var alignment: TextAlignment = .right
  
  /// The character used to pad the text
  public var paddingCharacter: Character = " "
  
  /// The minimum width of the resulting string
  public var width: Int = 0
  
  public init(alignment: TextAlignment = .right,
              paddingCharacter: Character = " ",
              width: Int = 0
    ) {
    (self.alignment, self.paddingCharacter, self.width) = (alignment, paddingCharacter, width)
  }
  
  static func format(
    alignment: TextAlignment = .right,
    paddingCharacter: Character = " ",
    width: Int = 0
    ) -> StringFormatter {
    return StringFormatter(alignment: alignment, paddingCharacter: paddingCharacter, width: width)
  }
  
  func string(from string: StringLiteralType) -> StringLiteralType {
    
    // Determine core padding required
    guard width > string.count else { return string }
    let corePadCount = max(width - string.count, 0)
    
    func padding(_ count: Int) -> String {
      return String(repeating: paddingCharacter, count: count)
    }
    
    switch alignment {
    case .right:
      // Left pad "abc" to width 5 with " " -> "  abc"
      return padding(corePadCount) + string
    case .left:
      // Right pad "abc" to width 5 with " " -> "abc  "
      return string + padding(corePadCount)
    case .center:
      // Center pad "abc" to width 5 with " " -> " abc "
      let halfPad = corePadCount / 2
      return  padding(corePadCount - halfPad) + string + padding(halfPad)
    }
  }
}
