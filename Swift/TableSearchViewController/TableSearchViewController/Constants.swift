//
//  Constants.swift
//  TableSearchViewController
//
//  Created by Nirav Bhatt on 02/05/2018.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import Foundation
import UIKit

enum ACCESSORY_ACTION : Int {
    case ACCESSORY_ACTION_CHECK = 0,
    ACCESSORY_ACTION_DELETE,
    ACCESSORY_ACTION_NAVIGATE
}

enum CellColorStyle : Int
{
    case CELL_COLOR_STYLE_UNIFORM = 1,
    CELL_COLOR_STYLE_ALTERNATE_DOUBLE,
    CELL_COLOR_STYLE_ALTERNATE_TRIPLE
}

enum SectionColorStyle : Int
{
    case SECTION_COLOR_STYLE_UNIFORM = 1
}

let headerID = "HeaderIdentifier"
let cellID = "CellIdentifier"

let SEARCHBAR_OFFSET = 20
let SEARCHBAR_TEXTOFFSET = 60
let NAVBAR_HEIGHT = 40
let DEFAULT_ROW_HEIGHT = 44
let SECTION_HEADER_CHECKBOX_OFFSET = 50
let SECTION_HEADER_LABEL_HEIGHT = 30
let CHECKBOX_HEIGHT = 30
let CHECKBOX_WIDTH = 30
let DEFAULT_SECTION_HEADER_HEIGHT = 50
let DEFAULT_SECTION_FOOTER_HEIGHT = 50
let TAG_SECTION_TITLE_LABEL = 999
let TAG_SECTION_HEADER_CHECKBOX = 1999

extension UIColor {
    enum ColorName : UInt32 {
        case GRAY = 0xb1b1b1ff
        case OFFWHITE = 0xf7f1eaff
        case LIGHTGRAY = 0xafb8b7ff
        case BROWN = 0xd4ac6aff
    }
    
    convenience init(named name: ColorName)
    {
        let rgbaValue = name.rawValue
        let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
        let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
        let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
        let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
