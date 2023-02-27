//
//  SymbolPicker.swift
//  SymbolPicker
//
//  Created by Cody Lewis on 2023-02-26.
//

import SwiftUI

public struct SymbolPicker: View {
    @Environment(\.dismiss) private var dismiss
    
    /// The variable used by the programmer to represent the symbol.
    @Binding var symbol: String
    /// The default symbol suggested to the user.
    @State var defaultSymbol: String = ""
    /// The collection of symbols being shown to the user to select from.
    @State var symbolGroup: SymbolGroup = DefaultSymbols
    
    public init(symbol: Binding<String>, defaultSymbol: String = "", symbolGroup: SymbolGroup = DefaultSymbols) {
        _symbol = symbol
        _defaultSymbol = State(initialValue: defaultSymbol)
        _symbolGroup = State(initialValue: symbolGroup)
    }
    
    /// The size of symbol tiles.
    private var tileSize: CGFloat {
#if os(watchOS)
        52
#elseif os(tvOS)
        96
#else
        64
#endif
    }
    /// The radius of rounded corners of symbol tiles.
    private var tileCornerRadius: CGFloat {
#if os(watchOS)
        4
#elseif os(tvOS)
        16
#else
        8
#endif
    }
    /// The amount of space between symbol tiles.
    private var gridSpacing: CGFloat {
#if os(watchOS)
        4
#elseif os(tvOS)
        24
#else
        8
#endif
    }
    /// The background colour of symbol tiles. Dynamically determined by the contained symbol.
    private func tileBackground(_ thisSymbol: String) -> Color {
        switch thisSymbol {
        case self.symbol: return .accentColor
        default:
            #if os(iOS)
            return .secondary.opacity(0.1)
            #else
            return .clear
            #endif
        }
    }
    /// The foreground (text) colour of symbol tiles. Dynamically determined by the contained symbol.
    private func tileForeground(_ thisSymbol: String) -> Color {
        switch thisSymbol {
        case self.symbol: return .white
        case self.defaultSymbol: return .accentColor
        default: return .primary
        }
    }
    
    /// The search text of the user in `.searchable` (or custom search fields).
    @State private var searchText = ""
    
    /// Dynamic collection of symbols shown to the user based on `searchText`.
    private var displayedSymbols: [String] {
        var symbols = symbolGroup.symbols
        if searchText != "" {
            symbols = symbols.filter({ $0.localizedCaseInsensitiveContains(searchText) })
        }
        return symbols
    }
    
    /// View and logic for symbol tiles.
    @ViewBuilder private func symbolTile(_ thisSymbol: String) -> some View {
        Button {
            self.symbol = thisSymbol
            dismiss()
        } label: {
            Image(systemName: thisSymbol)
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: tileSize, height: tileSize)
                .background(tileBackground(thisSymbol))
                .foregroundColor(tileForeground(thisSymbol))
                .cornerRadius(tileCornerRadius)
        }
        .buttonStyle(.plain)
    }
    
    /// Dynamically sized grid of symbol tiles within a scrollable container.
    @ViewBuilder private var tileGrid: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: tileSize), spacing: gridSpacing)], spacing: gridSpacing) {
                ForEach(displayedSymbols, id: \.self) { thisSymbol in
                    symbolTile(thisSymbol)
                }
            }
            .padding(.horizontal)
        }
    }
    
    /// View and logic for button when using default symbol.
    @ViewBuilder private var defaultButton: some View {
        if self.defaultSymbol != "" {
            Button("Default") {
                self.symbol = self.defaultSymbol
                dismiss()
            }
        }
    }
    
    /// View and logic for button when cancelling and closing the current view.
    @ViewBuilder private func cancelButton(icon: Bool = false) -> some View {
        Button(role: .cancel) { dismiss() } label: {
            if icon {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 16.0, height: 16.0)
            } else {
                Text("Cancel")
            }
        }
    }
    
    public var body: some View {
        #if os(macOS)
        VStack(spacing: 0) {
            HStack {
                TextField("Search", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 18.0))
                    .disableAutocorrection(true)
                defaultButton
                    .padding(.horizontal)
                    .tint(.accentColor)
                    .buttonStyle(.borderless)
                cancelButton(icon: true)
                    .buttonStyle(.borderless)
            }
            .padding()
            Divider()
            tileGrid
        }
        .frame(width: 720, height: 480)
        #else
        NavigationStack {
            tileGrid
                .navigationTitle(symbolGroup.name)
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        cancelButton()
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        defaultButton
                    }
                }
        }
        #endif
    }
}

struct SymbolPicker_Previews: PreviewProvider {
    @State static var symbol = "folder"
    
    static var previews: some View {
        SymbolPicker(symbol: $symbol, defaultSymbol: "trash")
    }
}
