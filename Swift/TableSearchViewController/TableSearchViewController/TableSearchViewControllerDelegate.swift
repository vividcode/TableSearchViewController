//
//  TableSearchViewDelegate.swift
//  TableSearchViewController
//
//  Created by Admin on 5/1/18.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import Foundation

protocol TableSearchViewControllerDelegate
{
    func rowShouldBeSelectedForKVCObject(kvcObject : Any) -> Bool
}
