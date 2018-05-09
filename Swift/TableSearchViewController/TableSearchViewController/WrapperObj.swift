//
//  WrapperObj.swift
//  TableSearchViewController
//
//  Created by Admin on 5/1/18.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import Foundation

class WrapperObj
{
    var selected : Bool
    var kvcObject : AnyObject
    
    init(selected : Bool, kvcObj : AnyObject) {
        self.selected = selected
        self.kvcObject = kvcObj
        
    }
}
