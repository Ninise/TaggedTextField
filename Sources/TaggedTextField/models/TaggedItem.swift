//
//  TaggedItem.swift
//  
//
//  Created by Nikita on 29.12.2024.
//

import Foundation

// MARK: - Tagged Item Protocol
/// Protocol for items that can be tagged within the text field.
protocol TaggedItem: Identifiable {
    func displayName() -> String
    func taggedDisplayText() -> String
}
