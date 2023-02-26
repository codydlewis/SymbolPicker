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
    
    func testCustomFromList() throws {
        // create SymbolGroup instance using `symbols` init
        let sut = SymbolGroup("Custom1", symbols: ["trash", "folder", "tray", "clipboard", "list"])
        // test name attribute
        XCTAssertEqual(sut.name, "Custom1")
        // test symbols attribute
        XCTAssertEqual(sut.symbols.count, 5)
    }
    
    func testCustomFromFile() throws {
        // create SymbolGroup instance using 'filename' init
        let sut = SymbolGroup(filename: "DoesNotExist")
        // test that SUT has no symbols within that attribute
        XCTAssertEqual(sut.symbols.count, 0)
    }
}
