//
//  Double.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 17.10.2022.
//

import Foundation

extension Double {
    private var currencyFormatter:  NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    func toCurrency() -> String  {
        return currencyFormatter.string(for: self) ?? ""
    }
    
}
