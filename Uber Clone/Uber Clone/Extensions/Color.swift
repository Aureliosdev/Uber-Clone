//
//  Color.swift
//  Uber Clone
//
//  Created by Aurelio Le Clarke on 17.10.2022.
//


import SwiftUI

extension Color {
    
    static let theme  = ColorTheme()
}


struct ColorTheme {
    let backgroundColor = Color("BackgroundColor")
    
    let secondaryBackground = Color("SecondaryBackground")
    let  primaryTextColor = Color("PrimaryTextColor")
}
