//
//  ViewController.swift
//  TableSearchViewController
//
//  Created by Admin on 5/1/18.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import UIKit

class TableSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    private var internalResultsArray : Array<Dictionary<String, Array<WrapperObj>>>?
    var delegate : TableSearchViewControllerDelegate?
    
    var textLabelFormats : Array<String>
    var textLableKeys : Array<String>
    var textLabelSeparator : String
    
    private var searchArray : Array<Dictionary<String, Array<WrapperObj>>>?
    
    private var isSearching : Bool
    
    var allowSearch : Bool
    
    var cellColorStyle : CellColorStyle?
    {
        get
        {
            return self.cellColorStyle
        }
        set(newVal)
        {
            self.cellColorStyle = newVal
        }
    }
    
    var cellColorArray : Array<UIColor>?
    {
        get
        {
            return self.cellColorArray
        }
        set(newVal)
        {
            if (newVal != nil)
            {
                self.cellColorArray = newVal
                return
            }
            
            if (self.cellColorStyle == CellColorStyle.CELL_COLOR_STYLE_UNIFORM)
            {
                self.cellColorArray = [UIColor.init(named: UIColor.ColorName.OFFWHITE)]
            }
            else if (self.cellColorStyle == CellColorStyle.CELL_COLOR_STYLE_ALTERNATE_DOUBLE)
            {
                self.cellColorArray = [UIColor.init(named: UIColor.ColorName.OFFWHITE),
                                       UIColor.init(named: UIColor.ColorName.LIGHTGRAY)]
            }
            else if (self.cellColorStyle == CellColorStyle.CELL_COLOR_STYLE_ALTERNATE_TRIPLE)
            {
                self.cellColorArray = [UIColor.init(named: UIColor.ColorName.GRAY),
                                       UIColor.init(named: UIColor.ColorName.OFFWHITE),
                                       UIColor.init(named: UIColor.ColorName.LIGHTGRAY)]
            }
        }
    }
    
    
    var sectionColorStyle : SectionColorStyle
    {
        get
        {
            return self.sectionColorStyle
        }
        set(newVal)
        {
            self.sectionColorStyle = newVal
        }
    }
    
    var sectionColorArray : Array<(UIColor)>?
    {
        get
        {
            return self.sectionColorArray
        }
        set(newVal)
        {
            if (newVal != nil)
            {
                self.sectionColorArray = newVal
                return
            }
            
            self.sectionColorArray = [UIColor.init(named: UIColor.ColorName.BROWN)]
        }
    }
    
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

    var allowSelectionCheckMark : Bool
    {
        get
        {
            return self.allowSelectionCheckMark
        }
        set(newVal)
        {
            self.allowSelectionCheckMark = newVal
            self.allowSelectionImages = !newVal
        }
    }
    
    var allowSelectionImages : Bool
    {
        get
        {
            return self.allowSelectionImages
        }
        set(newVal)
        {
            self.allowSelectionImages = newVal
            self.allowSelectionCheckMark = !newVal
            
            if (newVal == true)
            {
                self.accessoryImageNames = ["checkbox", "uncheckbox"]
            }
            else
            {
                self.accessoryImageNames = nil
            }
        }
    }
    
    var accessoryImageNames : Array<String>?
    {
        get
        {
            return self.accessoryImageNames
        }
        
        set(newVal)
        {
            if (newVal != nil)
            {
                var temp = Array<UIImage>.init()
                
                for s in newVal!
                {
                    temp.append(UIImage.init(named: s)!)
                }
                
                self.accessoryImages = temp
            }
        }
    }
    
    var accessoryImages : Array<UIImage>?
    {
        get
        {
            return self.accessoryImages
        }
        
        set (newVal)
        {
            if (newVal != nil)
            {
                self.accessoryImages = newVal
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
       self.textLableKeys = []
       self.textLabelFormats = []
       self.textLabelSeparator = ""
       self.isSearching = false
       self.allowSearch = true
       
       super.init(coder: aDecoder)
       
       self.delegate = nil
       self.resultsArray = nil
       self.cellColorStyle = CellColorStyle.CELL_COLOR_STYLE_UNIFORM
       self.sectionColorStyle = SectionColorStyle.SECTION_COLOR_STYLE_UNIFORM
       self.cellColorArray = nil
       self.sectionColorArray = nil
       self.allowSelectionImages = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.allowSearch && self.isSearching)
        {
            return self.searchArray!.count;
        }
        return internalResultsArray!.count;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var sectionObj : Dictionary<String, Array<WrapperObj>>
        
        if (self.allowSearch && self.isSearching)
        {
            sectionObj = self.searchArray![section]
        }
        else
        {
            sectionObj = self.internalResultsArray![section]
        }
        
        let sectionRows = sectionObj.values.first
        
        return (sectionRows?.count)!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        // prevent the cell from inheriting the tableView's margin settings
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        // explicitly setting cell's layout margins
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        
        
        
        return cell!
    }

    
    func isTitleDisplayedOnPreviousRow (rowsArray : Array<Any>, index : Int, title : String) -> Bool
    {
        var idx = index
        while (idx > 0)
        {
            let wrapperObj = rowsArray[idx] as! WrapperObj
            let kvcObject = wrapperObj.kvcObject
            let previousTitle = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.textLabelFormats, formatArray:self.textLabelFormats, separator: self.textLabelSeparator)
            
            if (previousTitle == title)
            {
                return true
            }
            
            idx = idx - 1
        }
        
        return false
    }
    
    func getFormattedStringFromDisplayKeys (kvcObject : Any, displayKeyArray : Array<String>, formatArray: Array<String>, separator : String) -> String
    {
        return ""
    }
}

