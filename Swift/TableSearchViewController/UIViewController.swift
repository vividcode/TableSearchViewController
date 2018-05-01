//
//  UIViewController.swift
//  TableSearchViewController
//
//  Created by Admin on 5/1/18.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    class func getViewControllerWithName(vcName : String) -> UIViewController
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: vcName)
        
        return vc;
    }
}
