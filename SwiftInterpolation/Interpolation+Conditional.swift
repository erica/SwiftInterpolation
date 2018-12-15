import Foundation

// Conditional interpolation, which is included only on
// success conditions and otherwise omitted.
//
// Old
//
//    "Cheese Sandwich\(sandwich.isStarred ? " (*)" : "")"
//
// New
//
//    "Cheese Sandwich\(if: sandwich.isStarred, " (*)")"
//
//
// Thanks, Nate Cook

extension String.StringInterpolation {
  /// Provides Boolean-guided interpolation that succeeds
  /// only when the `condition` evaluates to true
  ///
  /// For example,
  ///
  /// ```
  /// "Premiere Cheese Sandwich\(if: sandwich.IsStarred, " (*)")"
  /// ```
  ///
  /// - parameters:
  ///   - condition: a Boolean predicate that evaluates to true or false
  ///   - literal: a `String` literal to include on conditional success
  mutating func appendInterpolation(if condition: @autoclosure () -> Bool, _ literal: StringLiteralType) {
    guard condition() else { return }
    appendLiteral(literal)
  }
}
