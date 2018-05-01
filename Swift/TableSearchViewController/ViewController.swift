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
        
        tableVC.resultsArray = [["1": [1,3,4]], ["2": [1,3,6]]]
        
        self.navigationController?.present(tableVC, animated: true, completion: {
            print("presented")
        })
    }
    
    @IBAction func loadNumbers(_ sender: Any)
    {
    }
    
    @IBAction func loadObjects(_ sender: Any)
    {
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

    }
}
