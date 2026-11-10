// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/11/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

extension ISBN {
  /// The value of an ASCII digit character, or nil for any other character.
  ///
  /// Only `0` to `9` count: ISBNs are written in ASCII digits, and other scripts' digits would
  /// otherwise be accepted as numbers.
  static func digit(_ character: Character) -> Int? {
    guard let ascii = character.asciiValue, (48...57).contains(ascii) else { return nil }
    return Int(ascii - 48)
  }

  /// The check digit completing the first twelve digits of an ISBN-13.
  ///
  /// Digits are weighted alternately by 1 and 3; the check digit brings the weighted sum to a
  /// multiple of 10.
  static func isbn13CheckDigit(for digits: some Collection<Int>) -> Int {
    var sum = 0
    for (index, digit) in digits.enumerated() {
      sum += index.isMultiple(of: 2) ? digit : digit * 3
    }
    return (10 - sum % 10) % 10
  }

  /// The check value completing the first nine digits of an ISBN-10, from 0 to 10, where 10 is
  /// written as `X`.
  ///
  /// Digits are weighted from 10 down to 2; the check value brings the weighted sum to a
  /// multiple of 11.
  static func isbn10CheckValue(for digits: some Collection<Int>) -> Int {
    var sum = 0
    for (index, digit) in digits.enumerated() {
      sum += (10 - index) * digit
    }
    return (11 - sum % 11) % 11
  }
}
