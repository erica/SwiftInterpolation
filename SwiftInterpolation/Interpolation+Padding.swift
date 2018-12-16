import Foundation

/// A formatter that adjusts string layout.
public class StringFormatter {
  /// The direction from which a string floats when
  /// padded with repeated characters.
  public enum TextAlignment { case left, right, center }
  
  public var alignment: TextAlignment = .right
  public var paddingCharacter: Character = " "
  public var width: Int = 0
  
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

public extension String.StringInterpolation {
  /// Interpolates using a custom string formatter, allowing the results to
  /// be padded as desired, for example:
  ///
  /// `"\(23, formatter: formatter, width: 15)"`
  ///
  /// - Parameters:
  ///   - value: a value to present
  ///   - formatter: a string formatter
  mutating func appendInterpolation<Value>(_ value:  Value, formatter: StringFormatter, width: Int = 0) {
    if width != 0 { formatter.width = width }
    appendLiteral(formatter.string(from: "\(value)"))
  }
}

public extension String.StringInterpolation {
  /// The direction from which a string floats when
  /// padded with repeated characters.
  enum TextAlignment { case left, right, center }
  
  /// Returns a new string repeatedly padded with a character on
  /// either or both sides of the source string.
  ///
  /// - Returns: A padded string
  ///
  /// - Parameters:
  ///   - string: a string literal to pad
  ///   - alignment: the direction where the padding pushes the string
  ///   - character: the character to pad with (defaults to `" "`)
  ///   - targetWidth: the minimum string width result
  private func pad(
    string: StringLiteralType,
    alignment: TextAlignment,
    with character: Character = " ",
    toWidth targetWidth: Int = 0
    ) -> StringLiteralType {
    
    var width = targetWidth
    
    // Default the padding to one pad on each side
    if targetWidth == 0 {
      switch alignment {
      case .left, .right: width = string.count + 1
      case .center: width = string.count + 2
      }
    }
    
    // Determine core padding required
    guard width > string.count else { return string }
    let corePadCount = max(width - string.count, 0)
    
    func padding(_ count: Int) -> String {
      return String(repeating: character, count: count)
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
  
  /// Interpolates character-padded version of a string literal
  ///
  /// ```
  /// "\("hi", width: 5)" // "   hi"
  /// "\("hi", width: 5, withPad: ".")" // "...hi"
  /// "\("hi", width: 5, align: .center)" // "  hi "
  /// "\("hi", width: 5, align: .right, withPad: ".")" // "hi..."
  /// ```
  ///
  /// - Parameters:
  ///   - value: a value to interpolate
  ///   - width: the minimum width for the interpolated value to occupy
  ///   - alignment: the alignment of the value
  ///   - padding: the padding character (defaults to `" "`)
  mutating func appendInterpolation<Value>(
    _ value:  Value,
    width: Int,
    align alignment: String.StringInterpolation.TextAlignment = .right,
    withPad padding: Character = " "
    ) {
    appendLiteral(pad(string: "\(value)", alignment: alignment, with: padding, toWidth: width))
  }
}
