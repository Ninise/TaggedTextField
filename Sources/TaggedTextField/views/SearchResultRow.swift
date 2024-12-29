//
//  SearchResultRow.swift
//
//
//  Created by Nikita on 29.12.2024.
//

import Foundation
import SwiftUI

// MARK: - Search Result Row
/// Represents a single row in the search results.
struct SearchResultRow<T: TaggedItem>: View {
    let item: T
    
    var body: some View {
        Text(item.displayName())
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .font(.headline)
    }
}
