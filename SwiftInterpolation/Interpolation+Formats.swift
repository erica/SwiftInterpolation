// Bool, Int8, Double, Float, Int32, Int, Int64, Int16, UInt8, UInt32, UInt, UInt64, UInt16
// Only works on NSNumbers
// Could easily extend NumberFormatter for presets

public extension String.StringInterpolation {
  mutating func appendInterpolation<Value: FloatingPoint>(_ number: Value, formatter: NumberFormatter) {
    if
      let value = number as? NSNumber,
      let string = formatter.string(from: value) {
      appendLiteral(string)
    } else {
      appendLiteral("Unformattable<\(number)>")
    }
  }
  
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

formatter.string(from: NSNumber(value: Double.pi))

"\(Double.pi, formatter: formatter)"
"\(5, formatter: formatter)"

if let value = Double.pi as? NSNumber {
  print(value)
}

