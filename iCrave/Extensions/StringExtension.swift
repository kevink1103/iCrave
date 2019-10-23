//
//  StringExtension.swift
//  iCrave
//
//  Created by Kevin Kim on 21/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

extension String {
    subscript (i: Int) -> Character {
      return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
      let start = index(startIndex, offsetBy: bounds.lowerBound)
      let end = index(startIndex, offsetBy: bounds.upperBound)
      return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
      let start = index(startIndex, offsetBy: bounds.lowerBound)
      let end = index(startIndex, offsetBy: bounds.upperBound)
      return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
      let start = index(startIndex, offsetBy: bounds.lowerBound)
      let end = index(endIndex, offsetBy: -1)
      return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
      let end = index(startIndex, offsetBy: bounds.upperBound)
      return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
      let end = index(startIndex, offsetBy: bounds.upperBound)
      return self[startIndex ..< end]
    }
    
    // My Own Extension Function
    func isEmpty() -> Bool {
        return self.count == 0
    }

    func isNumeric() -> Bool {
        var result: Bool = true
        var string: String = self
        if string[0] == "-" && string.count >= 2 {
            string = String(string[1...])
        }
        string.forEach({ (char: Character) in
            if !char.isNumber {
                result = false
                return
            }
        })
        return result
    }
    
    func search(_ char: Character) -> Int {
        if let index = self.firstIndex(of: char) {
            return self.distance(from: self.startIndex, to: index)
        }
        return 0
    }
    
    func dropLastSpace() -> String {
        if self.count-1 > 0 && self[self.count-1] == " " {
            return String(self.dropLast())
        }
        return self
    }
    
    func getUIColor() -> UIColor {
        switch (self) {
        case "red":
            return .systemRed
        case "orange":
            return .systemOrange
        case "yellow":
            return .systemYellow
        case "green":
            return .systemGreen
        case "blue":
            return .systemBlue
        case "purple":
            return .systemPurple
        case "pink":
            return .systemPink
        case "teal":
            return .systemTeal
        case "indigo":
            return .systemIndigo
        case "gray":
            return .systemGray
        case "black":
            return .black
        case "white":
            return .white
        default:
            return .white
        }
    }
}

extension Substring {
  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }
  subscript (bounds: CountableRange<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[start ..< end]
  }
  subscript (bounds: CountableClosedRange<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[start ... end]
  }
  subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(endIndex, offsetBy: -1)
    return self[start ... end]
  }
  subscript (bounds: PartialRangeThrough<Int>) -> Substring {
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[startIndex ... end]
  }
  subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return self[startIndex ..< end]
  }
}
