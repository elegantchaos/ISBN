// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/03/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
@testable import ISBN

class ISBNTests: XCTestCase {
    let valid10 = ["0356502090","0316005401", "1597809802", "013603599X", "0345453743", "3200328584", "1416583785", "3200327316", "0349119287", "1605985228", "0684853159"]
    let converted = ["9780356502090", "9780316005401", "9781597809801", "9780136035992"]
    let valid13 = ["9781605985220", "9791090636071", "9780681403222", "9783200327313", "9780349139234", "9781597809825", "9780553283686", "9783200328587", "9780316005388", "9780446671279"]
    let invalid = ["", "AX123!@z?E", "1233200328587", "blah", "03565020901", "97803491392344", "9780605985220"]
    
    func testIsISBN10() {
        for v in valid10 {
            XCTAssertTrue(v.isISBN10)
        }
        
        for v in valid13 {
            XCTAssertFalse(v.isISBN10)
        }

        for v in invalid {
            XCTAssertFalse(v.isISBN10)
        }
    }
    
    func testIsISBN13() {
        for v in valid13 {
            XCTAssertTrue(v.isISBN13)
        }

        for v in valid10 {
            XCTAssertFalse(v.isISBN13)
        }

        for v in invalid {
            XCTAssertFalse(v.isISBN13)
        }
    }

    func testConversion() {
        for n in 0 ..< converted.count {
            let isbn10 = valid10[n]
            let expected = converted[n]
            XCTAssertEqual(isbn10.isbn10to13, expected)
        }
    }
}
