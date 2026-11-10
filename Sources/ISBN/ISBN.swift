// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/11/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

/// An International Standard Book Number, held in its ISBN-13 form.
///
/// Create one from text with `init?(_:)`, which accepts an ISBN-10 or ISBN-13 written with or
/// without spaces and hyphens, or from a scanned barcode with `init?(barcode:)`. Both check the
/// check digit and return nil for anything that is not a valid ISBN, so callers can use them to
/// decide whether text is an ISBN at all.
///
/// Values compare and hash by their ISBN-13 form, so an ISBN-10 and the equivalent ISBN-13 are
/// equal however each was written. `isbn10` gives the ISBN-10 form where one exists.
public struct ISBN: Hashable, Sendable {
  /// The thirteen digits of the ISBN-13 form.
  public let isbn13: String

  /// Creates an ISBN from text holding an ISBN-10 or an ISBN-13.
  ///
  /// Spaces and hyphens are ignored, and an ISBN-10's check character may be `X` or `x`. An
  /// ISBN-13 must start with `978` or `979`, but not `9790`, which numbers printed music.
  /// Returns nil when the text is not a valid ISBN, including when its check digit is wrong.
  public init?(_ text: some StringProtocol) {
    let characters = text.filter { $0 != " " && $0 != "-" }
    switch characters.count {
    case 10:
      self.init(isbn10Characters: Array(characters))
    case 13:
      self.init(isbn13Characters: Array(characters))
    default:
      return nil
    }
  }

  /// Creates an ISBN from the payload of a scanned barcode.
  ///
  /// A book's barcode is an EAN-13 whose thirteen digits are its ISBN-13. Returns nil for any
  /// other payload, such as another product's EAN-13 or the five-digit price add-on printed
  /// beside a book's barcode.
  public init?(barcode: some StringProtocol) {
    self.init(isbn13Characters: Array(barcode))
  }

  /// The ten characters of the ISBN-10 form, or nil for an ISBN-13 starting with `979`, which
  /// has no ISBN-10 form.
  public var isbn10: String? {
    guard isbn13.hasPrefix("978") else { return nil }
    let body = Array(isbn13.compactMap(Self.digit).dropFirst(3).prefix(9))
    let check = Self.isbn10CheckValue(for: body)
    return body.map(String.init).joined() + (check == 10 ? "X" : String(check))
  }

  /// Creates an ISBN from the ten characters of an ISBN-10, checking its check character.
  private init?(isbn10Characters characters: [Character]) {
    guard characters.count == 10 else { return nil }
    let body = characters.prefix(9).compactMap(Self.digit)
    guard body.count == 9 else { return nil }
    let check = Self.isbn10CheckValue(for: body)
    let expected: Character = check == 10 ? "X" : Character(String(check))
    guard characters[9].uppercased() == String(expected) else { return nil }
    let twelve = [9, 7, 8] + body
    self.init(digits: twelve + [Self.isbn13CheckDigit(for: twelve)])
  }

  /// Creates an ISBN from the thirteen characters of an ISBN-13, checking its prefix and check
  /// digit.
  private init?(isbn13Characters characters: [Character]) {
    let digits = characters.compactMap(Self.digit)
    guard
      characters.count == 13,
      digits.count == 13,
      digits.starts(with: [9, 7, 8]) || (digits.starts(with: [9, 7, 9]) && digits[3] != 0),
      digits[12] == Self.isbn13CheckDigit(for: digits.prefix(12))
    else { return nil }
    self.init(digits: digits)
  }

  /// Creates an ISBN from thirteen digits already known to form a valid ISBN-13.
  private init(digits: [Int]) {
    isbn13 = digits.map(String.init).joined()
  }
}
