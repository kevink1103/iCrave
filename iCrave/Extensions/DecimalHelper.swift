//
//  DecimalHelper.swift
//  iCrave
//
//  Created by Kevin Kim on 15/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import Foundation

func stringToDecimal(_ string: String) -> Decimal? {
    return Decimal(string: string)
}

func decimalToString(_ decimal: NSDecimalNumber) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    if let decimalString = numberFormatter.string(from: decimal) {
        return decimalString
    }
    else {
        return ""
    }
}

func decimalToString(_ decimal: Decimal) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    if let decimalString = numberFormatter.string(from: decimal as NSDecimalNumber) {
        return decimalString
    }
    else {
        return ""
    }
}
