//
//  SearchResultsView.swift
//  
//
//  Created by Nikita on 29.12.2024.
//

import Foundation
import SwiftUI

// MARK: - Search Results View
/// Displays the search results in a popover.
struct SearchResultsView<T: TaggedItem>: View {
    let results: [T]
    let noResultsMessage: String
    let onSelect: (T) -> Void
    
    var body: some View {
        VStack (alignment: .leading) {
            if results.isEmpty {
                Text(noResultsMessage)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(results) { item in
                            SearchResultRow(item: item)
                                .onTapGesture {
                                    onSelect(item)
                                }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
    }
}
