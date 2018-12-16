/*
 
 Radix interpolation for Binary Integers
 
 */

public extension String.StringInterpolation {
  /// Represents a single numeric radix
  enum Radix: Int {
    /// a binary number (base 2)
    case binary = 2
    /// an octal number (base 8)
    case octal = 8
    /// a decimal number (base 10)
    case decimal = 10
    /// a hex number (base 16)
    case hex = 16
    
    /// Returns a radix's optional prefix
    var prefix: String {
      return [.binary: "0b", .octal: "0o", .hex: "0x"][self, default: ""]
    }
  }
  
  /// Return a string representation of the supplied value using a standard radix.
  ///
  /// For example,
  ///
  /// ```
  /// "\(42, radix: .hex)" // 2a
  /// "\(42, radix: .binary)" // 101010
  /// "\(42, radix: .octal)" // 52
  /// "\(0x2a, radix: .decimal)" // 42
  /// "\(5, radix: .binary, isBytewise: true)" // 00000101
  /// "\(5, radix: .octal, isBytewise: true)" // 0005
  /// "\(5, radix: .hex, isBytewise: true)" // 05
  /// "\(5, radix: .hex, prefix: true, isBytewise: true)" // 0x05
  /// ```
  ///
  /// - Parameters:
  ///   - value: A binary integer
  ///   - radix: A standard (decimal, binary, octal, or hex) radix
  ///   - prefix: Adds an optional prefix (`0b`, `0o`, or `0x`) corresponding to the output radix.
  ///   - bytewise: creates an entire byte in the output string (8 numbers for binary, 4 for octal, 2 for hex), left padding with zeroes.
  ///   - width: left pads with zeroes to the supplied width, unless the output string is already at least `width` in size.
  mutating func appendInterpolation<IntegerValue: BinaryInteger>(
    _ value: IntegerValue,
    radix: Radix,
    prefix: Bool = false,
    isBytewise bytewise: Bool = false,
    toWidth width: Int = 0
    ) {
    
    // Values are uppercased, producing `FF` instead of `ff`
    // String is now uppercased-radix-encoded-string
    var string = String(value, radix: radix.rawValue).uppercased()
    
    // Bytewise strings are padded to 2 for hex, 4 for oct, 8 for binary
    var width = width
    if bytewise {
      width = [Radix.binary: 8, .octal: 4, .hex: 2][radix, default: width]
    }
    
    // Strings are pre-padded with 0 to match target widths
    // String is now (0)* + uppercased-radix-encoded-string
    if string.count < width {
      string = String(repeating: "0", count: max(0, width - string.count)) + string
    }
    
    
    // Prefixes use lower case, sourced from `String.StringInterpolation.Radix`
    // String is now (optional-prefix) + uppercased-radix-encoded-string
    if prefix {
      string = radix.prefix + string
    }
    
    // Insert the interpolation
    appendLiteral(string)
  }
}

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
  
  public var radix: Radix = .decimal
  public var usesPrefix: Bool = false
  public var isBytewise: Bool = false
  public var width: Int = 0
  
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
  /// Interpolates a binary integer value using the supplied integer formatter
  ///
  /// - Parameters:
  ///   - value: an integer value
  ///   - formatter: a configured integer formatter
  mutating func appendInterpolation<IntegerValue: BinaryInteger>(
    _ value: IntegerValue, formatter formatter: IntegerFormatter) {
    appendLiteral(formatter.string(from: value))
  }
}
