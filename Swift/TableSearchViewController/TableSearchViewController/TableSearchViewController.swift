//
//  ViewController.swift
//  TableSearchViewController
//
//  Created by Admin on 5/1/18.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import UIKit

class TableSearchViewController: UIViewController
{
    private var internalResultsArray : Array<Dictionary<String, Array<WrapperObj>>>?
    var delegate : TableSearchViewControllerDelegate?
    var resultsArray : Array<Dictionary<String, Array<Any>>>?
    {
        get
        {
            return self.resultsArray
        }
        
        set(newResultsArray)
        {
            if (newResultsArray == nil)
            {
                return
            }
            
            if (internalResultsArray == nil)
            {
                internalResultsArray = Array<Dictionary<String, Array<WrapperObj>>>.init()
            }
            
            for (sectionDict) in newResultsArray!
            {
                let sectionTitle = sectionDict.keys.first as! String
                let sectionRows = sectionDict.values.first
                
                var rowsArray = Array<Any>.init()
                for obj in sectionRows!
                {
                    let wrapperObj = WrapperObj.init(selected: false, kvcObject: obj)
                    rowsArray.append(wrapperObj)
                }
                
                let rowDict = [sectionTitle : rowsArray] as! Dictionary<String, Array<WrapperObj>>
                internalResultsArray?.append(rowDict)
            }
        }
    }

    required init?(coder aDecoder: NSCoder)
    {
       super.init(coder: aDecoder)
       self.delegate = nil
       self.resultsArray = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

