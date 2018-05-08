//
//  ViewController.swift
//  TableSearchViewController
//
//  Created by Admin on 5/1/18.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loadStrings(_ sender: Any)
    {
        let resultsArray = [["First": ["one","two","three"]], ["Second": ["two","four","six","seven"]]]

        let tableVC = TableSearchViewController.init(cellColorStyle: CellColorStyle.CELL_COLOR_STYLE_UNIFORM, sectionColorStyle: SectionColorStyle.SECTION_COLOR_STYLE_UNIFORM, allowSelectionCheckMark: false, allowSelectAllImage: true, allowSearch: true, accessoryAction: ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK, footerText: "This is extra footer", resultsArray: resultsArray)
        
        tableVC.selectionDoneBlock = { selectedObjects, bExtraFlag in
            
            let str = "Selected: " + selectedObjects.description
            self.resultLabel.text? = str
            print("Selected:\(str)")
        }
        
        let tableNavVC  = UINavigationController.init(rootViewController: tableVC)
        
        self.navigationController?.present(tableNavVC, animated: true, completion: {
            print("presented")
        })
    }
    
    @IBAction func loadNumbers(_ sender: Any)
    {
        let resultsArray = [["First": [1,2,3]], ["Second": [2,5,6,7]]]
        
        let tableVC = TableSearchViewController.init(cellColorStyle: CellColorStyle.CELL_COLOR_STYLE_UNIFORM, sectionColorStyle: SectionColorStyle.SECTION_COLOR_STYLE_UNIFORM, allowSelectionCheckMark: false, allowSelectAllImage: true, allowSearch: true, accessoryAction: ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK, footerText: "This is extra footer", resultsArray: resultsArray)
        
        
        tableVC.selectionDoneBlock = { selectedObjects, bExtraFlag in
            
            let str = "Selected: " + selectedObjects.description
            self.resultLabel.text? = str
            print("Selected:\(str)")
        }
        
        let tableNavVC  = UINavigationController.init(rootViewController: tableVC)
        
        self.navigationController?.present(tableNavVC, animated: true, completion: {
            print("presented")
        })
    }
    
    @IBAction func loadDictionaries (_ sender: Any)
    {
        let dict1 = ["text": "Totaldrunk", "num" : 1] as [String : AnyObject]
        let dict2 = ["text": "Lovelystrings", "num" : 2] as [String : AnyObject]
        let dict3 = ["text": "Flyingsaucer", "num" : 3] as [String : AnyObject]
        let dict4 = ["text": "Lovelyapple", "num" : 4] as [String : AnyObject]
        let dict5 = ["text": "Flyingberries", "num" : 5] as [String : AnyObject]
        let dict6 = ["text": "Kiterunner", "num" : 6] as [String : AnyObject]

        
        let resultsArray = [["First": [dict1, dict2, dict3]], ["Second": [dict3, dict4, dict5, dict6]]]
        
        let tableVC = TableSearchViewController.init(cellColorStyle: CellColorStyle.CELL_COLOR_STYLE_UNIFORM, sectionColorStyle: SectionColorStyle.SECTION_COLOR_STYLE_UNIFORM, allowSelectionCheckMark: false, allowSelectAllImage: true, allowSearch: true, accessoryAction: ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK, footerText: "This is extra footer", resultsArray: resultsArray)
        
        tableVC.searchKeys = ["text"]
        tableVC.textLabelKeys = ["text"]
        tableVC.subTitleKeys = ["num"]
        
        tableVC.selectionDoneBlock = { selectedObjects, bExtraFlag in
            let str = "Selected: " + selectedObjects.description
            self.resultLabel.text? = str
            print("Selected:\(str)")
        }

        let tableNavVC  = UINavigationController.init(rootViewController: tableVC)

        self.navigationController?.present(tableNavVC, animated: true, completion: {
            print("presented")
        })
    }
    
    @IBAction func loadObjects(_ sender: Any)
    {
        //TODO: KVC is not available for Swift yet.
        
//        let tableVC = UIViewController.getViewControllerWithName(vcName: "TableSearchViewController") as! TableSearchViewController
//        let obj1 = MyObject(text: "one", num: 1)
//        let obj2 = MyObject(text: "two", num: 2)
//        let obj3 = MyObject(text: "three", num: 3)
//
//        print(obj1)
//        print(obj2.description)
//        print(obj3.description)
//
//        let obj4 = MyObject(text: "four", num: 4)
//        let obj5 = MyObject(text: "five", num: 5)
//        let obj6 = MyObject(text: "six", num: 6)
//
//        tableVC.textLabelKeys = ["text"]
//        tableVC.subTitleKeys = ["num"]
//
//        tableVC.resultsArray = [["First": [obj1, obj2, obj3]], ["Second": [obj3, obj4, obj5, obj6]]]
//
//        let tableNavVC  = UINavigationController.init(rootViewController: tableVC)
//
//        self.navigationController?.present(tableNavVC, animated: true, completion: {
//            print("presented")
//        })
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

    }
}
