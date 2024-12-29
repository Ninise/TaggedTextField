//
//  TagParser.swift
//  
//
//  Created by Nikita on 29.12.2024.
//

import Foundation

// MARK: - Tag Parser
/// Parses text to identify tagged text and trigger search functionality.
struct TagParser {
    static func extractTaggedText(
        start: Int, text: String, trigger: Character, onShowSearchPopover: (Bool) -> Void, onLastExtText: (String) -> Void, performSearch: (Character, String) -> Void
    ) {
        if (start > 0 && !text.isEmpty && start < text.count) {
            let currentCursor = text.index(text.startIndex, offsetBy: start)
            
            var textToSearch = text[text.startIndex...currentCursor]
            
            if textToSearch.isEmpty {
                return
            }
            
            var lastTokenIndex = -1
            var lastIndexOfSpace = -1
            var nextIndexOfSpace = -1
            
            if let index1 = textToSearch.lastIndex(of: trigger) {
                lastTokenIndex = textToSearch.distance(from: textToSearch.startIndex, to: index1)
            }
            
            if let index2 = textToSearch.lastIndex(of: " ") {
                lastIndexOfSpace = textToSearch.distance(from: textToSearch.startIndex, to: index2)
            }
            
            nextIndexOfSpace = String(textToSearch).indexOf(" ", from: start)
            
            if (lastIndexOfSpace > 0 && lastTokenIndex < lastIndexOfSpace) {
                
                if (lastIndexOfSpace >= text.count - 1) {
                    onShowSearchPopover(false)
                    return
                }
                
                let afterStringIndex = text.index(text.startIndex, offsetBy: lastIndexOfSpace)
                
                let afterString = String(text[afterStringIndex...])
                if (afterString.starts(with: " ")) {
                    onShowSearchPopover(false)
                    return
                }
            }
            
            if (lastTokenIndex < 0) {
                if (textToSearch.count >= 1 && textToSearch.starts(with: "\(trigger)")) {
                    lastTokenIndex = 1;
                } else {
                    onShowSearchPopover(false)
                    return
                }
                
            }
            
            var tokenEnd = lastIndexOfSpace;
            if (lastIndexOfSpace <= lastTokenIndex) {
                tokenEnd = textToSearch.count
                if (nextIndexOfSpace != -1 && nextIndexOfSpace < tokenEnd) {
                    tokenEnd = nextIndexOfSpace
                }
            }
            if (lastTokenIndex >= 0) {
                let lti = text.index(text.startIndex, offsetBy: lastTokenIndex)
                let te = text.index(text.startIndex, offsetBy: tokenEnd - 1)
                
                textToSearch = text[lti...te]
                
                if let txt = extractText(from: String(textToSearch).trimmingCharacters(in: .whitespaces), trigger: "\(trigger)") {
                    onLastExtText(txt)
                    onShowSearchPopover(true)
                    performSearch(trigger, txt)
                }
            }
        }
    }
    
    static func extractText(from text: String, trigger: String) -> String? {
        let pattern = "\(trigger)(\\w+)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
        
        if let match = regex?.firstMatch(in: text, options: [], range: range) {
            let txtRange = match.range(at: 1)
            if let swiftRange = Range(txtRange, in: text) {
                return String(text[swiftRange])
            }
        }
        
        return nil
    }
}
