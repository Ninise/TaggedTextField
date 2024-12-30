//
//  TagConfiguration.swift
//
//
//  Created by Nikita on 29.12.2024.
//

import Foundation
import SwiftUI

// MARK: - Tag Configuration
/// Configuration for tag behavior, including the trigger character, placeholders, and styling.
public struct TagConfiguration {
    public init(trigger: Character, searchPlaceholder: String, noResultsMessage: String, itemBackgroundColor: Color, triggerColor: Color) {
        self.trigger = trigger
        self.searchPlaceholder = searchPlaceholder
        self.noResultsMessage = noResultsMessage
        self.itemBackgroundColor = itemBackgroundColor
        self.triggerColor = triggerColor
    }
    
    let trigger: Character // e.g., "@" for mentions, "#" for hashtags
    let searchPlaceholder: String
    let noResultsMessage: String
    let itemBackgroundColor: Color
    let triggerColor: Color
}
