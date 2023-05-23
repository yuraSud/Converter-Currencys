//
//  String+Extension.swift
//  CurrencyConverter
//
//  Created by YURA																			 on 23.05.2023.
//

import Foundation
extension String {
    
    public func noDigits() -> Bool {
        let regularExpression = "^([0-9]*)+([.]?)+([0-9]*)$"
        return NSPredicate(format: "SELF MATCHES %@", regularExpression).evaluate(with: self)
    }
}
