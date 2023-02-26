//
//  Symbols.swift
//  
//
//  Created by Cody Lewis on 2023-02-26.
//

import Foundation

/// Named collection of SF Symbols which can use displayed in the `SymbolPicker` view.
public struct SymbolGroup {
    var name: String
    var symbols: [String]
    
    /// Read a resource text file into an array of strings (split by new line in text file).
    /// Expects each line to contain the `systemName` for SF Symbols.
    private func fetchSymbols(_ filename: String) -> [String] {
        guard let path = Bundle.module.path(forResource: filename, ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            return []
        }
        return content
            .split(separator: "\n")
            .map({ String($0) })
    }
    
    /// Initilise `SymbolGroup` using an array of symbol names (in string form).
    /// Useful when trying to make a small custom set of symbols for a specific use case.
    public init(_ name: String = "Symbols", symbols: [String]) {
        self.name = name
        self.symbols = symbols
    }
    
    /// Initialise `SymbolGroup` using a `.txt` file in the `Resources` directory.
    /// Useful when making a large custom set of symbols which are used extensively.
    public init(_ name: String = "Symbols", filename: String) {
        self.name = name
        self.symbols = []
        self.symbols = self.fetchSymbols(filename)
    }
}

/// All symbols in the SF Symbols v4 catalogue.
public let DefaultSymbols = SymbolGroup(filename: "SFSymbols")
