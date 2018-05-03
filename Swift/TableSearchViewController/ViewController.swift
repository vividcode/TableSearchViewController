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
