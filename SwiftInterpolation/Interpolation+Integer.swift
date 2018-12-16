/*
 
 Radix interpolation for Binary Integers
 
 */

import Foundation

/// A formatter that converts between binary integer values and their textual representations.
public class IntegerFormatter {
  /// Represents a single numeric radix
  public enum Radix: Int {
    /// a binary number (base 2)
    case binary = 2
    /// an octal number (base 8)
    case octal = 8
    /// a decimal number (base 10)
    case decimal = 10
    /// a hex number (base 16)
    case hex = 16
    
    /// Returns a radix's optional prefix
    public var prefix: String {
      return [.binary: "0b", .octal: "0o", .hex: "0x"][self, default: ""]
    }
  }
  
  /// A standard (decimal, binary, octal, or hex) radix
  public var radix: Radix = .decimal
  
  /// Adds an optional prefix (`0b`, `0o`, or `0x`) corresponding to the output radix.
  public var usesPrefix: Bool = false
  
  /// Creates an entire byte in the output string (8 numbers for binary, 4 for octal, 2 for hex), left padding with zeroes.
  public var isBytewise: Bool = false
  
  /// The minimum width of the output string, which is left padded with zeroes
  /// unless the output string is already at least `width` in size.
  public var width: Int = 0
  
  /// Initializes a new instance of an IntegerFormatter
  public init(radix: Radix = .decimal,
              usesPrefix: Bool = false,
              isBytewise: Bool = false,
              width: Int = 0) {
    (self.radix, self.usesPrefix, self.isBytewise, self.width) = (radix, usesPrefix, isBytewise, width)
  }
  
  static func format(radix: Radix = .decimal,
                     usesPrefix: Bool = false,
                     isBytewise: Bool = false,
                     width: Int = 0
    ) -> IntegerFormatter {
    return IntegerFormatter(radix: radix, usesPrefix: usesPrefix, isBytewise: isBytewise, width: width)
  }
  
  /// Returns a string representing the integer value using the
  /// formatter's current settings.
  ///
  /// - Parameter value: a binary integer
  /// - Returns: a formatted string
  func string<IntegerValue: BinaryInteger>(from value: IntegerValue) -> String {
    // Values are uppercased, producing `FF` instead of `ff`
    // String is now uppercased-radix-encoded-string
    var string = String(value, radix: radix.rawValue).uppercased()
    
    // Bytewise strings are padded to 2 for hex, 4 for oct, 8 for binary
    if isBytewise {
      width = [Radix.binary: 8, .octal: 4, .hex: 2][radix, default: width]
    }
    
    // Strings are pre-padded with 0 to match target widths
    // String is now (0)* + uppercased-radix-encoded-string
    if string.count < width {
      string = String(repeating: "0", count: max(0, width - string.count)) + string
    }
    
    
    // Prefixes use lower case, sourced from `String.StringInterpolation.Radix`
    // String is now (optional-prefix) + uppercased-radix-encoded-string
    if usesPrefix {
      string = radix.prefix + string
    }
    
    return string
  }
}

public extension String.StringInterpolation {
  /// Interpolates a binary integer value using the supplied integer formatter,
  /// for example:
  ///
  /// ```
  /// "\(15, .format(radix: .hex))" // F
  /// "\(15, .format(radix: .hex, isBytewise: true))" // 0F
  /// "\(15, .format(radix: .hex, usesPrefix: true, isBytewise: true))" // 0x0F
  /// ```
  ///
  /// - Parameters:
  ///   - value: an integer value
  ///   - formatter: a configured integer formatter
  mutating func appendInterpolation<IntegerValue: BinaryInteger>(
    _ value: IntegerValue, _ formatter: IntegerFormatter) {
    appendLiteral(formatter.string(from: value))
  }
}
