import Foundation

public extension String.StringInterpolation {
  /// Interpolates a date using the supplied formatter
  mutating func appendInterpolation(_ value: Date, _ formatter: DateFormatter) {
    appendLiteral(formatter.string(from: value))
  }
}

public extension DateFormatter {
  /// Returns an initialized `DateFormatter` instance using the
  /// supplied date and time styles
  static func format(date: Style, time: Style) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    (formatter.dateStyle, formatter.timeStyle) = (date, time)
    return formatter
  }
}

