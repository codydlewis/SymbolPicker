import XCTest
@testable import SymbolPicker

final class SymbolPickerTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(SymbolPicker().text, "Hello, World!")
    }
}

final class SymbolsTests: XCTestCase {
    func testDefault() throws {
        // Ensure that the DefaultSymbols name attribute is default value
        XCTAssertEqual(DefaultSymbols.name, "Symbols")
        // Ensure that the DefaultSymbols object contains 4014 symbols in the `symbols` attribute
        XCTAssertEqual(DefaultSymbols.symbols.count, 4014)
    }
}
