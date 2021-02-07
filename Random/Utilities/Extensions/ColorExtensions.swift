//
//  ColorExtensions.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

extension Color {
    static func primaryBlue() -> Color {
        return Color(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
    }
    
    static func primaryGray() -> Color {
        return Color(#colorLiteral(red: 0.262745098, green: 0.2901960784, blue: 0.3960784314, alpha: 1))
    }
    
    static func primaryPale() -> Color {
        return Color(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1))
    }
    
    static func primaryError() -> Color {
        return Color(#colorLiteral(red: 1, green: 0.2784313725, blue: 0.2274509804, alpha: 1))
    }
    
    static func primaryInactive() -> Color {
        return Color(#colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1))
    }
    
    static func primaryDefault() -> Color {
        return Color(#colorLiteral(red: 0.5529411765, green: 0.568627451, blue: 0.6666666667, alpha: 1))
    }
    
    static func primaryGreen() -> Color {
        return Color(#colorLiteral(red: 0.1294117647, green: 0.6117647059, blue: 0.4196078431, alpha: 1))
    }
    
    static func primaryTertiary() -> Color {
        return Color(#colorLiteral(red: 0.1450980392, green: 0.8352941176, blue: 0.5607843137, alpha: 1))
    }
    
    static func primaryPink() -> Color {
        return Color(#colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1))
    }
    
    static func primarySky() -> Color {
        return Color(#colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
    }
}

extension UIColor {
    
    static func primaryBlue() -> UIColor {
        return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
    
    static func primaryGray() -> UIColor {
        return #colorLiteral(red: 0.262745098, green: 0.2901960784, blue: 0.3960784314, alpha: 1)
    }
    
    static func primaryPale() -> UIColor {
        return #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9725490196, alpha: 1)
    }
    
    static func primaryError() -> UIColor {
        return #colorLiteral(red: 1, green: 0.2784313725, blue: 0.2274509804, alpha: 1)
    }
    
    static func primaryInactive() -> UIColor {
        return #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
    }
    
    static func primaryDefault() -> UIColor {
        return #colorLiteral(red: 0.5529411765, green: 0.568627451, blue: 0.6666666667, alpha: 1)
    }
    
    static func primaryGreen() -> UIColor {
        return #colorLiteral(red: 0.1294117647, green: 0.6117647059, blue: 0.4196078431, alpha: 1)
    }
    
    static func primaryTertiary() -> UIColor {
        return #colorLiteral(red: 0.1450980392, green: 0.8352941176, blue: 0.5607843137, alpha: 1)
    }
    
    static func primaryPink() -> UIColor {
        return #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1)
    }
    
    static func primarySky() -> UIColor {
        return #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1)
    }
}
