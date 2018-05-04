//
//  ViewController.swift
//  TableSearchViewController
//
//  Created by Admin on 5/1/18.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loadStrings(_ sender: Any)
    {
        let tableVC = UIViewController.getViewControllerWithName(vcName: "TableSearchViewController") as! TableSearchViewController
        
        tableVC.resultsArray = [["First": ["one","two","three"]], ["Second": ["two","four","six","seven"]]]
        tableVC.allowSearch = true
        
        let tableNavVC  = UINavigationController.init(rootViewController: tableVC)
        
        self.navigationController?.present(tableNavVC, animated: true, completion: {
            print("presented")
        })
    }
    
    @IBAction func loadNumbers(_ sender: Any)
    {
        let tableVC = UIViewController.getViewControllerWithName(vcName: "TableSearchViewController") as! TableSearchViewController
        
        tableVC.resultsArray = [["First": [1,2,3]], ["Second": [2,5,6,7]]]
        tableVC.allowSearch = true
        
        let tableNavVC  = UINavigationController.init(rootViewController: tableVC)
        
        self.navigationController?.present(tableNavVC, animated: true, completion: {
            print("presented")
        })
    }
    
    @IBAction func loadDictionaries (_ sender: Any)
    {
        let tableVC = UIViewController.getViewControllerWithName(vcName: "TableSearchViewController") as! TableSearchViewController
       
        let dict1 = ["text": "Mytext1", "num" : 1] as [String : Any]
        let dict2 = ["text": "Mytext2", "num" : 2] as [String : Any]
        let dict3 = ["text": "Mytext3", "num" : 3] as [String : Any]
        let dict4 = ["text": "Mytext4", "num" : 4] as [String : Any]
        let dict5 = ["text": "Mytext6", "num" : 5] as [String : Any]
        let dict6 = ["text": "Mytext7", "num" : 6] as [String : Any]

        tableVC.textLabelKeys = ["text"]
        tableVC.subTitleKeys = ["num"]

        tableVC.resultsArray = [["First": [dict1, dict2, dict3]], ["Second": [dict3, dict4, dict5, dict6]]]

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
