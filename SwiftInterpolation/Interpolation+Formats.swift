// Bool, Int8, Double, Float, Int32, Int, Int64, Int16, UInt8, UInt32, UInt, UInt64, UInt16
// Only works on NSNumbers
// Could easily extend NumberFormatter for presets

// This does not get called properly with, for example, Double.pi
//// Thanks Brent Royal-Gordan
//public extension String.StringInterpolation {
//  mutating func appendInterpolation<Value: _ObjectiveCBridgeable>(_ value: Value, formatter: NumberFormatter) where Value._ObjectiveCType == NSNumber {
//    if let string = formatter.string(from: NSNumber(nonretainedObject: value)) {
//      appendLiteral(string)
//    } else {
//      appendLiteral("Unformattable<\(value)>")
//    }
//  }
//}

public extension String.StringInterpolation {
  /// Interpolates a floating point value using a
  /// number formatter.
  mutating func appendInterpolation<Value: FloatingPoint>(_ number: Value, formatter: NumberFormatter) {
    if
      let value = number as? NSNumber,
      let string = formatter.string(from: value) {
      appendLiteral(string)
    } else {
      appendLiteral("Unformattable<\(number)>")
    }
  }
  
  /// Interpolates an integer value using a number formatter.
  mutating func appendInterpolation<Value: BinaryInteger>(_ number: Value, formatter: NumberFormatter) {
    if
      let value = number as? NSNumber,
      let string = formatter.string(from: value) {
      appendLiteral(string)
    } else {
      appendLiteral("Unformattable<\(number)>")
    }
  }
}

let formatter = NumberFormatter()
formatter.localizesFormat = true
formatter.roundingMode = .halfUp
//formatter.usesSignificantDigits = true
//formatter.maximumSignificantDigits = 8
//formatter.minimumSignificantDigits = 8
formatter.minimumFractionDigits = 1
formatter.maximumFractionDigits = 4
formatter.paddingPosition = .beforePrefix
formatter.paddingCharacter = "0"
formatter.minimumIntegerDigits = 5

// formatter.string(from: NSNumber(value: Double.pi))
"\(Double.pi, formatter: formatter)"
"\(5, formatter: formatter)"

//if let value = Double.pi as? NSNumber {
//  print(value)
//}
//
