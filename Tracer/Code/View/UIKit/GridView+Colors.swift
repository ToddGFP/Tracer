//
//  GridView+Colors.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/12/24.
//

import UIKit

extension GridView {
    /// Color literals are used here to make it easy to envision the per-level color palettes
    func colorPairing(forLevel level: Int) -> (UIColor, UIColor) {
        let colors = [
            (#colorLiteral(red: 0.1254901961, green: 0.2980392157, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)),
            (#colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)),
            (#colorLiteral(red: 0.0, green: 0.2, blue: 0.4, alpha: 1), #colorLiteral(red: 1, green: 0.3411764706, blue: 0.1333333333, alpha: 1)),
            (#colorLiteral(red: 0.2745098039, green: 0.5098039216, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.5, green: 1, blue: 0, alpha: 1)),
            (#colorLiteral(red: 1, green: 0.3411764706, blue: 0.1333333333, alpha: 1), #colorLiteral(red: 0.0, green: 0.2, blue: 0.4, alpha: 1)),
            (#colorLiteral(red: 0.4823529412, green: 0.1215686275, blue: 0.6352941176, alpha: 1), #colorLiteral(red: 0.0, green: 1, blue: 1, alpha: 1)),
            (#colorLiteral(red: 0.9568627451, green: 0.6588235294, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 0.003921568627, green: 0.4, blue: 0.6, alpha: 1)),
            (#colorLiteral(red: 1, green: 1, blue: 0.4, alpha: 1), #colorLiteral(red: 0.5450980392, green: 0.0, blue: 0.5450980392, alpha: 1)),
            (#colorLiteral(red: 0.0, green: 0.2, blue: 0.4, alpha: 1), #colorLiteral(red: 0.7411764706, green: 0.6235294118, blue: 1, alpha: 1)),
            (#colorLiteral(red: 0.5, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1))
        ]
        // Grab the color from the array for the given level, repeating from the start whenever it reaches the end
        let (foreground, background) = colors[level > colors.count ? (level % colors.count) : level - 1]
        
        // If the number of runthroughs is even, flip the colors just to mix it up
        if level > colors.count {
            let runthroughs = Int(level - 1 / colors.count) + 1
            if runthroughs % 2 == 0 {
                //debug("-> runthroughs \(runthroughs) is even for level \(level)), so flipping", 0, .animation)
                return (background, foreground)
            }
        }
        //debug("-> no need to flip, runthroughs is \(runthroughs) for level \(level)", 0, .animation)
        return (foreground, background)
    }
    
    func foregroundColor(forLevel level: Int) -> UIColor {
        let (_, foreground) = colorPairing(forLevel: level)
        return foreground
    }
    
    func backgroundColor(forLevel level: Int) -> UIColor {
        let (background, _) = colorPairing(forLevel: level)
        return background
    }
    
    func updateColors(forLevel level: Int) {
        udpateForegroundColor(forLevel: level)
        updateBackgroundColor(forLevel: level)
    }
    
    func udpateForegroundColor(forLevel level: Int) {
        for tile in tiles {
            tile.hilightColor = foregroundColor(forLevel: level)
        }
    }
    
    func updateBackgroundColor(forLevel level: Int) {
        backgroundColor = backgroundColor(forLevel: level)
    }
}
