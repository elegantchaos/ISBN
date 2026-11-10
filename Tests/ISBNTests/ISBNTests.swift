// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/03/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ISBN
import Testing

/// Tests for recognising, converting and comparing ISBNs.
struct ISBNTests {
  /// Valid ISBN-10s, with their ISBN-13 forms.
  static let tenDigit: [(isbn10: String, isbn13: String)] = [
    ("0356502090", "9780356502090"),
    ("0316005401", "9780316005401"),
    ("1597809802", "9781597809801"),
    ("013603599X", "9780136035992"),
    ("0345453743", "9780345453747"),
    ("3200328584", "9783200328587"),
    ("1416583785", "9781416583783"),
    ("3200327316", "9783200327313"),
    ("0349119287", "9780349119281"),
    ("1605985228", "9781605985220"),
    ("0684853159", "9780684853154"),
    ("031600538X", "9780316005388"),
  ]

  /// Valid ISBN-13s with a `978` prefix, with their ISBN-10 forms.
  static let thirteenDigit: [(isbn13: String, isbn10: String)] = [
    ("9781605985220", "1605985228"),
    ("9780681403222", "0681403225"),
    ("9783200327313", "3200327316"),
    ("9780349139234", "0349139237"),
    ("9781597809825", "1597809829"),
    ("9780553283686", "0553283685"),
    ("9780446671279", "0446671274"),
  ]

  /// Text that is not an ISBN: wrong lengths, wrong check digits, letters, the music prefix
  /// `9790`, and words with ten or thirteen letters.
  static let notISBNs = [
    "", "blah", "AX123!@z?E", "03565020901", "97803491392344", "9780605985220",
    "1233200328587", "0356502091", "9790000000001", "FOUNDATION", "BRAVENEWWORLD",
    "X356502090", "035650209Y", "0-356+502090",
  ]

  /// An ISBN-10 is recognised and holds its ISBN-13 form.
  @Test(arguments: tenDigit)
  func recognisesISBN10(isbn10: String, isbn13: String) throws {
    let isbn = try #require(ISBN(isbn10))
    #expect(isbn.isbn13 == isbn13)
    #expect(isbn.isbn10 == isbn10)
  }

  /// An ISBN-13 with a `978` prefix is recognised and has an ISBN-10 form.
  @Test(arguments: thirteenDigit)
  func recognisesISBN13(isbn13: String, isbn10: String) throws {
    let isbn = try #require(ISBN(isbn13))
    #expect(isbn.isbn13 == isbn13)
    #expect(isbn.isbn10 == isbn10)
  }

  /// An ISBN-13 with a `979` prefix has no ISBN-10 form.
  @Test func isbn979HasNoISBN10() throws {
    let isbn = try #require(ISBN("9791090636071"))
    #expect(isbn.isbn13 == "9791090636071")
    #expect(isbn.isbn10 == nil)
  }

  /// Text that is not an ISBN is not recognised.
  @Test(arguments: notISBNs)
  func rejectsNonISBNs(text: String) {
    #expect(ISBN(text) == nil)
  }

  /// Spaces, hyphens and a lowercase check character are accepted.
  @Test(arguments: ["0-345-45374-3", "0 345 45374 3", "978-0-345-45374-7", " 9780345453747 "])
  func ignoresSeparators(text: String) throws {
    let isbn = try #require(ISBN(text))
    #expect(isbn.isbn13 == "9780345453747")
  }

  /// A lowercase `x` check character is accepted.
  @Test func acceptsLowercaseX() throws {
    let isbn = try #require(ISBN("013603599x"))
    #expect(isbn.isbn10 == "013603599X")
  }

  /// The ISBN-10 and ISBN-13 forms of one ISBN are equal and hash alike.
  @Test(arguments: tenDigit)
  func formsAreEqual(isbn10: String, isbn13: String) throws {
    let ten = try #require(ISBN(isbn10))
    let thirteen = try #require(ISBN(isbn13))
    #expect(ten == thirteen)
    #expect(Set([ten, thirteen]).count == 1)
  }

  /// Different ISBNs are not equal.
  @Test func differentISBNsAreNotEqual() throws {
    let first = try #require(ISBN("0356502090"))
    let second = try #require(ISBN("0316005401"))
    #expect(first != second)
  }

  /// A book's EAN-13 barcode is its ISBN-13.
  @Test(arguments: ["9780345453747", "9791090636071"])
  func recognisesBookBarcodes(barcode: String) throws {
    let isbn = try #require(ISBN(barcode: barcode))
    #expect(isbn.isbn13 == barcode)
  }

  /// A barcode that is not a book's EAN-13 is not an ISBN: another product, an ISBN-10,
  /// separators, a price add-on or a wrong check digit.
  @Test(arguments: ["5012345678900", "0345453743", "978-0345453747", "51299", "9780345453748"])
  func rejectsOtherBarcodes(barcode: String) {
    #expect(ISBN(barcode: barcode) == nil)
  }

  /// An ISBN describes itself by its ISBN-13 form.
  @Test func descriptionIsISBN13() throws {
    let isbn = try #require(ISBN("0-345-45374-3"))
    #expect(isbn.description == "9780345453747")
  }
}
