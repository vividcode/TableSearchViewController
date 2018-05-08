//
//  ViewController.swift
//  TableSearchViewController
//
//  Created by Admin on 5/1/18.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import UIKit

typealias SelectionDoneClosure = (Array<Any>, Bool) -> Void
typealias DismissClosure = (String) -> Void

class TableSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var tableView: UITableView!
    private var internalResultsArray : Array<Dictionary<String, Array<WrapperObj>>>?
    var delegate : TableSearchViewControllerDelegate?
    var searchBar : UISearchBar?
    var searchBarPlaceHolderText : String?
    
    var searchKeys : Array<String>?
    
    var textLabelFormats : Array<String>?
    var textLabelKeys : Array<String>?
    {
        didSet
        {
            for _ in self.textLabelKeys!
            {
                self.textLabelFormats?.append("%@")
            }
        }
    }
    var subTitleFormats : Array<String>?
  
    var subTitleKeys : Array<String>?
    {
        didSet
        {
            for _ in self.subTitleKeys!
            {
                self.subTitleFormats?.append("")
            }
        }
    }
    var textLabelSeparator : String?
    var subTitleSeparator : String?
    var showGroupedView : Bool?
    var extraFlagSelected : Bool?
    
    var selectionDoneBlock: SelectionDoneClosure?
    var dismissBlock : DismissClosure?

    var screenTitle : String?
    var selectionDoneButtonTitle : String?
    var dismissButtonTitle : String?
    
    private var searchArray : Array<Dictionary<String, Array<WrapperObj>>>?
    
    private var isSearching : Bool?
    private var selectedObjects : Array<Any>?
    
    var allowSearch : Bool?
    
    // MARK: Computed Properties
    var cellColorStyle : CellColorStyle?
    {
        didSet
        {
            if (cellColorStyle == CellColorStyle.CELL_COLOR_STYLE_UNIFORM)
            {
                self.cellColorArray = [UIColor.init(named: UIColor.ColorName.OFFWHITE)]
            }
            else if (cellColorStyle == CellColorStyle.CELL_COLOR_STYLE_ALTERNATE_DOUBLE)
            {
                self.cellColorArray = [UIColor.init(named: UIColor.ColorName.OFFWHITE),
                                       UIColor.init(named: UIColor.ColorName.LIGHTGRAY)]
            }
            else if (cellColorStyle == CellColorStyle.CELL_COLOR_STYLE_ALTERNATE_TRIPLE)
            {
                self.cellColorArray = [UIColor.init(named: UIColor.ColorName.GRAY),
                                       UIColor.init(named: UIColor.ColorName.OFFWHITE),
                                       UIColor.init(named: UIColor.ColorName.LIGHTGRAY)]
            }
        }
    }
    
    var cellColorArray : Array<UIColor>?
    
    var sectionColorStyle : SectionColorStyle?
    {
        didSet
        {
            if (sectionColorStyle == SectionColorStyle.SECTION_COLOR_STYLE_UNIFORM)
            {
                self.sectionColorArray = [UIColor.init(named: UIColor.ColorName.OFFWHITE)]
            }
        }
    }
    
    var sectionColorArray : Array<(UIColor)>?
    
    
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

    var allowSelectionCheckMark : Bool?
    {
        didSet(newVal)
        {
            self.allowSelectionImages = !newVal!
        }
    }
    
    var allowSelectionImages : Bool?
    {
        didSet(newVal)
        {
            self.allowSelectionCheckMark = !newVal!
            
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
        didSet(newVal)
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
    var accessoryAction : ACCESSORY_ACTION?
    {
        didSet(newVal)
        {
            if (newVal == ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK)
            {
                self.accessoryImageNames = ["checkbox", "uncheckbox"]
            }
            else if (newVal == ACCESSORY_ACTION.ACCESSORY_ACTION_DELETE)
            {
                self.accessoryImageNames = ["delete"]
            }
        }
    }
    

    // MARK: Inits
    required init?(coder aDecoder: NSCoder)
    {
       super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(cellColorStyle : CellColorStyle, sectionColorStyle:SectionColorStyle, allowSelectionCheckMark: Bool, allowSelectAllImage : Bool, allowSearch: Bool, accessoryAction:ACCESSORY_ACTION, footerText: String, resultsArray : Array<Dictionary<String, Array<Any>>>)
    {
        self.init(nibName: "TableSearchViewController", bundle: Bundle.main)
        
        self.resultsArray = resultsArray
        
        self.textLabelKeys = []
        self.textLabelFormats = []
        self.textLabelSeparator = ""
        self.isSearching = false
        self.allowSearch = allowSearch
        self.showGroupedView = false
        self.subTitleKeys = []
        self.subTitleFormats = []
        self.subTitleSeparator = ""

        self.accessoryAction = accessoryAction
        self.allowSelectionImages = !allowSelectionCheckMark
        
        self.selectedObjects = []
        self.extraFlagSelected = false
        
        self.screenTitle = ""
        self.selectionDoneButtonTitle = "Select"
        self.dismissButtonTitle = "Cancel"
 
        self.allowSelectionCheckMark = allowSelectionCheckMark
        
        self.delegate = nil

        self.cellColorStyle = cellColorStyle
        self.sectionColorStyle = sectionColorStyle
    }
    
    // MARK view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.createSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: NAV BAR
    func configureNavBar()
    {
        if (!self.selectionDoneButtonTitle!.isEmpty)
        {
            let doneButton = UIBarButtonItem.init(title: self.selectionDoneButtonTitle, style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneTapped))
            self.navigationItem.rightBarButtonItem = doneButton
        }
        
        if (!self.dismissButtonTitle!.isEmpty)
        {
            let dismissButton = UIBarButtonItem.init(title: self.dismissButtonTitle, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelTapped))
            self.navigationItem.leftBarButtonItem = dismissButton
        }
    }
    
    @objc func doneTapped(sender : AnyObject)
    {
        self.navigationController?.dismiss(animated: true, completion: {
            self.selectionDoneBlock?(self.selectedObjects!, self.extraFlagSelected!)
        })
    }
    
    @objc func cancelTapped(sender : AnyObject)
    {
        self.navigationController?.dismiss(animated: true, completion: {
            self.dismissBlock?("Dismissed TableSearchViewController: ")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Search Bar
    func createSearchBar()
    {
        if (self.allowSearch!)
        {
            self.searchBar = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: NAVBAR_HEIGHT))
            self.searchBar?.delegate = self
            
            var subViews = self.searchBar?.subviews
            for subView in subViews!
            {
                if (subView is UITextField)
                {
                    let searchField = subView as! UITextField
                    searchField.returnKeyType = UIReturnKeyType.search
                    searchField.autocorrectionType = UITextAutocorrectionType.no
                    searchField.autocapitalizationType = UITextAutocapitalizationType.none
                    break
                }
                else
                {
                    subViews = subView.subviews
                }
            }
            
            self.searchBar?.placeholder = self.searchBarPlaceHolderText
            self.tableView.tableHeaderView = self.searchBar
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.isSearching = !searchText.isEmpty
        
        if (self.isSearching!)
        {
            self.searchArray = self.searchTextInTableRows(searchText: searchText)
        }
        
        self.tableView.reloadData()
    }
    
    func searchTextInTableRows (searchText : String) -> Array<Dictionary<String, Array<WrapperObj>>>
    {
        var searchResultArray = Array<Dictionary<String, Array<WrapperObj>>>()
        
        for sectionObj in self.internalResultsArray!
        {
            let sectionTitle = sectionObj.keys.first
            let sectionRows = sectionObj.values.first
            
            let wrapperObj = sectionRows?.first
            let kvcObject = wrapperObj?.kvcObject
            
            var filteredRowsArray : Array<WrapperObj>?
            if (kvcObject is String)
            {
                filteredRowsArray = sectionRows?.filter
                {
                    let wrapperObjectSample = $0 as? WrapperObj
                    let kvcString = wrapperObjectSample?.kvcObject as! String
                    return kvcString.contains(searchText)
                }
            }
            else if (kvcObject is NSNumber)
            {
                let nf = NumberFormatter.init()
                nf.numberStyle = .decimal
                let searchTextNumber = nf.number(from: searchText)
                let startRange = NSNumber.init(value: floor((searchTextNumber?.doubleValue)!))
                let endRange =  NSNumber.init(value: startRange.doubleValue + 0.99)

                filteredRowsArray = sectionRows?.filter
                {
                    let wrapperObjectSample = $0 as? WrapperObj
                    let kvcNumber = wrapperObjectSample?.kvcObject as? NSNumber
                
                    return (((kvcNumber?.doubleValue)! == searchTextNumber?.doubleValue) ||
                    ((kvcNumber?.doubleValue)! >= startRange.doubleValue) &&
                    ((kvcNumber?.doubleValue)! <= endRange.doubleValue))
                }
            }
            else if (kvcObject is Dictionary<String, Any>)
            {
                filteredRowsArray = sectionRows?.filter
                {
                    let wrapperObjectSample = $0 as? WrapperObj
                    let kvcDict = wrapperObjectSample?.kvcObject as? Dictionary<String, Any>
                    
                    var bContainsKey = false
                    
                    for searchKey in self.searchKeys!
                    {
                        if (kvcDict![searchKey] as! String).contains(searchText)
                        {
                            bContainsKey = true
                            break
                        }
                    }
                    
                    return bContainsKey
                }
            }

            searchResultArray.append([sectionTitle!:filteredRowsArray!])
        }
        
        return searchResultArray
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.text = ""
        self.view.endEditing(true)
    }
    
    // MARK: Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.allowSearch! && self.isSearching!)
        {
            return self.searchArray!.count;
        }
        return internalResultsArray!.count;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var sectionObj : Dictionary<String, Array<WrapperObj>>
        
        if (self.allowSearch! && self.isSearching!)
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
            if (self.showGroupedView)!
            {
                style = UITableViewCellStyle.default
            }
            else
            {
                style = UITableViewCellStyle.subtitle
            }
            
            cell = UITableViewCell.init(style: style, reuseIdentifier: cellID)
        }
        
        let biggerArrayToIndex = (self.allowSearch! && self.isSearching!) ? self.searchArray : self.internalResultsArray
        let sectionObj = biggerArrayToIndex![indexPath.section] as! Dictionary<String, Array<WrapperObj>>
        let rowArray = sectionObj.values.first
        
        let wrapperObj = rowArray![indexPath.row] as! WrapperObj
        let kvcObject = wrapperObj.kvcObject
        
        let title = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.textLabelKeys!, formatArray: self.textLabelFormats!, separator: self.textLabelSeparator!)
        let subTitle = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.subTitleKeys!, formatArray: self.subTitleFormats!, separator: self.subTitleSeparator!)
        
        if (self.showGroupedView)!
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
            let subTitle = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.subTitleKeys!, formatArray: self.subTitleFormats!, separator: self.subTitleSeparator!)
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
            let previousTitle = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.textLabelFormats!, formatArray:self.textLabelFormats!, separator: self.textLabelSeparator!)
            
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
            if ((formatArray ?? []).isEmpty == false)
            {
                let format = formatArray.first
                let valueToFormat = kvcObject as! String
                let formattedValue = String(format:(format)!, valueToFormat)
                return formattedValue
            }
            
            return kvcObject as! String
        }
        
        if (kvcObject is NSNumber)
        {
            if ((formatArray ?? []).isEmpty == false)
            {
                let format = formatArray.first
                let valueToFormat = kvcObject as! String
                let formattedValue = String(format:format!, valueToFormat)
                return formattedValue
            }
            
            return String(NSString.init(format: "%@", kvcObject as! NSNumber))
        }
        
        if ((kvcObject is NSDictionary) || (kvcObject is Dictionary<String, AnyObject>))
        {
            var retString = ""
            
            for (idx, _) in displayKeyArray.enumerated()
            {
                let key = displayKeyArray[idx]
                let format = formatArray[idx]
                var valueToAppend = self.getValueFromKVCObject(kvcObject: kvcObject as AnyObject, key: key)
                
                if (!format.isEmpty)
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
        
        return ""
    }
    
    func getValueFromKVCObject(kvcObject : AnyObject, key : String) -> String
    {
        if (kvcObject is Dictionary<String, AnyObject>)
        {
            let obj = (kvcObject as! Dictionary<String, AnyObject>)[key] as! NSObject
            
            return obj.description
        }
        else if (kvcObject is NSDictionary)
        {
            let obj = (kvcObject as! NSDictionary) .object(forKey: key) as! NSObject
            return obj.description
        }

        return ""
    }
}

