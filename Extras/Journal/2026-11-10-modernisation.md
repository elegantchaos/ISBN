# Modernisation

ISBN 1.0.2 was a set of `String` extensions from 2019: ISBN-10 and ISBN-13 check digits, `isISBN10`, `isISBN13` and ISBN-10 to ISBN-13 conversion, written against ASCII codes for Swift 5.1 with XCTest. Bookish needed more for scanning barcodes and matching imported books: input with separators, a lowercase `x`, ISBN-13 to ISBN-10 conversion, and comparison that treats the two forms of one ISBN as equal.

## Changes

- An `ISBN` value replaces the `String` extensions. It holds the ISBN-13 form and compares and hashes by it. `init?(_:)` accepts either form with spaces and hyphens, `init?(barcode:)` accepts only a book's EAN-13, and `isbn10` gives the ISBN-10 form where one exists. Both initialisers check the check digit and return nil for anything else, so text such as "FOUNDATION" is never taken for an ISBN.
- Only ASCII digits count, since `Character.wholeNumberValue` accepts other scripts' digits.
- The package uses Swift 6.2 tools and current platform minimums, keeps Linux support, and has no Foundation dependency. It is `Sendable`; there is no shared mutable state, so nothing else in Swift concurrency applies.
- Tests moved to Swift Testing, keeping the 1.0.2 test vectors, parameterised, and adding separators, lowercase `x`, `979`, the music prefix, letter-only text, equality and barcodes. The ISBN-13 to ISBN-10 vectors include a check character of `X`.
- The CI workflow was regenerated with ActionBuilderPlugin, added to the manifest only for the run. The generator still emits `on: [push, pull_request]`, so the trigger was edited by hand to push on `main` and pull requests, as in Commands.
- Added `AGENTS.md`, `.swift-format`, `.editorconfig`, a licence and a current README.

The `String` API is gone, without deprecated wrappers, and the platform minimums rise, so this is a major release: 2.0.0.
