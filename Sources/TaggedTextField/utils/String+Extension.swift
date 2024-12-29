//
//  String+Extension.swift
//  
//
//  Created by Nikita on 29.12.2024.
//

import Foundation

extension String {
    func indexOf(_ substring: String, from fromIndex: Int) -> Int {
        
        let firstSlice = fromIndex
        
        let searchStr = self[self.index(startIndex, offsetBy: fromIndex)...]
        
        if let index = searchStr.firstIndex(of: Character(substring)) {
            return firstSlice + searchStr.distance(from: searchStr.startIndex, to: index)
        }
        
        
        return -1
    }
}
