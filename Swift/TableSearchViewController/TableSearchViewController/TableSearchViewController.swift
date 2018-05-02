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
    var textLabelKeys : Array<String>
    var subTitleFormats : Array<String>
    var subTitleKeys : Array<String>
    var textLabelSeparator : String
    var subTitleSeparator : String
    var showGroupedView : Bool
    
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
       self.textLabelKeys = []
       self.textLabelFormats = []
       self.textLabelSeparator = ""
       self.isSearching = false
       self.allowSearch = true
       self.showGroupedView = false
       self.subTitleKeys = []
       self.subTitleFormats = []
       self.subTitleSeparator = ""
       
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
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        
        if (cell == nil)
        {
            var style : UITableViewCellStyle
            if (self.showGroupedView)
            {
                style = UITableViewCellStyle.default
            }
            else
            {
                style = UITableViewCellStyle.subtitle
            }
            
            cell = UITableViewCell.init(style: style, reuseIdentifier: cellID)
        }
        
        let biggerArrayToIndex = (self.allowSearch && self.isSearching) ? self.searchArray : self.internalResultsArray
        let sectionObj = biggerArrayToIndex![indexPath.section] as! Dictionary<String, Array<WrapperObj>>
        let rowArray = sectionObj.values.first
        
        let wrapperObj = rowArray![indexPath.row] as! WrapperObj
        let kvcObject = wrapperObj.kvcObject
        
        let title = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.textLabelKeys, formatArray: self.textLabelFormats, separator: self.textLabelSeparator)
        let subTitle = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.subTitleKeys, formatArray: self.subTitleFormats, separator: self.subTitleSeparator)
        
        if (self.showGroupedView)
        {
            if (self.isTitleDisplayedOnPreviousRow(rowsArray: rowArray!, index: indexPath.row, title: title))
            {
                cell?.textLabel?.text = String(format:"%@\n     %@", "", subTitle)
            }
            else
            {
                cell?.textLabel?.text = String(format:"%@\n     %@", title, subTitle)
            }
        }
        else
        {
            cell?.textLabel?.text = title
            let subTitle = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.subTitleKeys, formatArray: self.subTitleFormats, separator: self.subTitleSeparator)
            cell?.detailTextLabel?.text = subTitle
        }
        
        cell?.backgroundColor = self.cellColorArray?[indexPath.row % (self.cellColorStyle?.rawValue)!]
        cell?.textLabel?.textColor = self.cellColorArray?[indexPath.row % (self.cellColorStyle?.rawValue)!]
        cell?.detailTextLabel?.textColor = self.cellColorArray?[indexPath.row % (self.cellColorStyle?.rawValue)!]

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
        if (kvcObject is String)
        {
            let format = formatArray.first
            if (format != nil)
            {
                let valueToFormat = kvcObject as! String
                let formattedValue = String(format:format!, valueToFormat)
                return formattedValue
            }
            
            return kvcObject as! String
        }
        
        if (kvcObject is NSNumber)
        {
            let format = formatArray.first
            if (format != nil)
            {
                let valueToFormat = kvcObject as! String
                let formattedValue = String(format:format!, valueToFormat)
                return formattedValue
            }
            
            return String(format:"%@", kvcObject as! CVarArg)
        }
        
        var retString = "" as! String
        
        for (idx, element) in displayKeyArray.enumerated()
        {
            let key = displayKeyArray[idx] as! String
            let format = formatArray[idx] as! String
            var valueToAppend = self.getValueFromKVCObject(kvcObject: kvcObject as! AnyObject, key: key) as! String
            
            if (format != nil)
            {
                valueToAppend = String(format:format, valueToAppend)
            }
            
            retString.append(valueToAppend)
            
            if ((idx != displayKeyArray.count - 1) && (!separator.isEmpty))
            {
                retString.append(separator)
            }
        }
        
        return retString
    }
    
    func getValueFromKVCObject(kvcObject : AnyObject, key : String) -> String
    {
        if (kvcObject.responds(to: #selector(value(forKey:))))
        {
            return kvcObject.value(forKey: key) as! String
        }
        
        if (kvcObject is Dictionary<String, AnyObject>)
        {
            return (kvcObject as! Dictionary)[key]!
        }

        return ""
    }
}

