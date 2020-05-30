//
//  DimensionUtility.swift
//  PitchPerfect
//
//  Created by Nestor Diazgranados on 5/26/20.
//  Copyright © 2020 NesDupier. All rights reserved.
//

import Foundation

//Let's see if we can use this utility in SwiftUi
struct DimenUtils {
    //Sesign wasmade thingking on these dimensions 2nd Generation Phone.
    static let defaultWidth = 375
    static let defaultHeight = 677
    
    static let defaultPadding = 16
    static let buttonCoomonSize = 100
    
    static func percentageFrom (value: Int, screenWidthSize: Float) -> CFloat? {
        return  CFloat(value/defaultWidth * value)
    }
    
    static func percentageFrom (value: Int, screenHeightSize: Float) -> CFloat {
        return  CFloat(value/defaultHeight * value)
    }
    
    static func minValue (w: CFloat, h: CFloat) -> CFloat {
        return  CFloat(min(Float(w), Float(h)))
    }
}
