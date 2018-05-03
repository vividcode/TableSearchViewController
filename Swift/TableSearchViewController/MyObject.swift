//
//  MyObject.swift
//  TableSearchViewController
//
//  Created by Nirav Bhatt on 03/05/2018.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import Foundation

class MyObject : NSObject
{
    var text : NSString = ""
    var num : Int = 0
    
    init(text : String, num : Int)
    {
        self.text = NSString.init(string: text)
        self.num = num
    }
    
    override var description: String
    {
        let textProp = self.value(forKey: "MyObject.text") as! String
        return textProp
    }
}
