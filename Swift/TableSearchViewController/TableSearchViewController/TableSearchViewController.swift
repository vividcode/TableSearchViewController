//
//  ViewController.swift
//  TableSearchViewController
//
//  Created by Admin on 5/1/18.
//  Copyright © 2018 iPhoneGameZone. All rights reserved.
//

import UIKit

typealias SelectionDoneClosure = (Array<Any>) -> Void
typealias DismissClosure = (String) -> Void
typealias DeletionDoneClosure = (Any) -> Void

class TableSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var tableView: UITableView!

    var delegate : TableSearchViewControllerDelegate?
    var searchBar : UISearchBar?
    var searchBarPlaceHolderText : String?
    
    var searchKeys : Array<String>?
    
    var textLabelFormats : Array<String>
    var textLabelKeys : Array<String>
    {
        didSet
        {
            for _ in self.textLabelKeys
            {
                self.textLabelFormats.append("%@")
            }
        }
    }
    var subTitleFormats : Array<String>
    var subTitleKeys : Array<String>
    {
        didSet
        {
            for _ in self.subTitleKeys
            {
                self.subTitleFormats.append("")
            }
        }
    }
    var textLabelSeparator : String = "-"
    var subTitleSeparator : String = "_"
    var showGroupedView : Bool
    
    var sectionHeaderHeight : CGFloat?
    
    var selectionDoneBlock: SelectionDoneClosure?
    var deletionDoneBlock : DeletionDoneClosure?
    
    var dismissBlock : DismissClosure?

    var screenTitle : String?
    var selectionDoneButtonTitle : String = "Select"
    var dismissButtonTitle : String = "Cancel"
    
    private var internalResultsArray : Array<Dictionary<String, Array<WrapperObj>>> = []
    private var searchArray : Array<Dictionary<String, Array<WrapperObj>>> = []
    
    private var isSearching : Bool
    private var selectedObjects : Array<AnyObject> = []
    
    private var accessoryActionResultsArray : Array<AnyObject> = []
    
    var allowSearch : Bool
    var allowSelectAll : Bool
    
    // MARK: Computed Properties
    var cellColorStyle : CellColorStyle = .CELL_COLOR_STYLE_UNIFORM
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
                self.sectionColorArray = [UIColor.init(named: UIColor.ColorName.LIGHTGRAY)]
            }
        }
    }
    
    var sectionColorArray : Array<(UIColor)>?
    
    var resultsArray : Array<Dictionary<String, Array<Any>>>?
    {
        get
        {
            return ((self.allowSearch && self.isSearching) ? searchArray : internalResultsArray)
        }
        
        set(newResultsArray)
        {
            if (newResultsArray == nil)
            {
                return
            }
            
            for (sectionDict) in newResultsArray!
            {
                let sectionTitle = sectionDict.keys.first
                let sectionRows = sectionDict.values.first
                
                var rowsArray = Array<Any>.init()
                for obj in sectionRows!
                {
                    let wrapperObj = WrapperObj.init(selected: false, kvcObj: obj as AnyObject)
                    rowsArray.append(wrapperObj)
                }
                
                let rowDict = [sectionTitle : rowsArray] as! Dictionary<String, Array<WrapperObj>>
                internalResultsArray.append(rowDict)
            }
        }
    }

    var allowSelectionCheckMark : Bool = true
    {
        didSet(oldAllowSelectionCheckMark)
        {
            self.allowSelectionImages = !self.allowSelectionCheckMark
        }
    }
    
    var allowSelectionImages : Bool = false
    {
        willSet(newAllowSelectionImages)
        {
            if (newAllowSelectionImages == true)
            {
                if (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK)
                {
                    self.accessoryImageNames = ["checkbox", "uncheckbox"]
                    self.allowSelectAll = true
                }
                else
                {
                    self.accessoryImageNames = ["delete"]
                }
            }
            else
            {
                self.allowSelectAll = true
                self.accessoryImageNames = nil
            }
        }
    }
    
    var accessoryImageNames : Array<String>?
    {
        willSet(newAccessoryImageNames)
        {
            if (newAccessoryImageNames != nil)
            {
                var temp = Array<UIImage>.init()
                
                for s in newAccessoryImageNames!
                {
                    temp.append(UIImage.init(named: s)!)
                }
                
                self.accessoryImages = temp
            }
        }
    }
    
    private var accessoryPromptTitle : String = ""
    
    var accessoryPromptMessage : String = ""
    var accessoryPromptOKButtonTitle : String?
    var accessoryPromptCancelButtonTitle : String?
    
    var accessoryImages : Array<UIImage>?
    var accessoryAction : ACCESSORY_ACTION?
    {
        willSet(newVal)
        {
            self.selectedObjects = []
            if (newVal == ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK)
            {
                self.selectionDoneButtonTitle = "Select"
                self.accessoryImageNames = ["checkbox", "uncheckbox"]
            }
            else if (newVal == ACCESSORY_ACTION.ACCESSORY_ACTION_DELETE)
            {
                self.selectionDoneButtonTitle = "Done"
                
                self.accessoryActionResultsArray = []
                self.accessoryImageNames = ["delete"]
                
                if let title = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String
                {
                    self.accessoryPromptTitle = title
                }
                else
                {
                    self.accessoryPromptTitle = "Delete"
                }
                
                self.accessoryPromptMessage = "Are you sure you want to Delete:%@?"
                self.accessoryPromptOKButtonTitle = "OK"
                self.accessoryPromptCancelButtonTitle = "Cancel"
            }
        }
    }
    

    // MARK: Inits
    required init?(coder aDecoder: NSCoder)
    {
        self.allowSearch = true
        self.isSearching = false
        self.allowSelectAll = true
        self.showGroupedView = false
        self.textLabelKeys = []
        self.textLabelFormats = []
        self.subTitleKeys = []
        self.subTitleFormats = []
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        self.allowSearch = true
        self.isSearching = false
        self.allowSelectAll = true
        self.showGroupedView = false
        self.textLabelKeys = []
        self.textLabelFormats = []
        self.subTitleKeys = []
        self.subTitleFormats = []
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(cellColorStyle : CellColorStyle = .CELL_COLOR_STYLE_UNIFORM, sectionColorStyle:SectionColorStyle = .SECTION_COLOR_STYLE_UNIFORM, allowSelectionCheckMark: Bool,  allowSearch: Bool, accessoryAction:ACCESSORY_ACTION,  resultsArray : Array<Dictionary<String, Array<Any>>>, showGroupedView:Bool = false)
    {
        self.init(nibName: "TableSearchViewController", bundle: Bundle.main)
        
        self.resultsArray = resultsArray
        
        self.textLabelKeys = []
        self.textLabelFormats = []

        self.isSearching = false
        self.allowSearch = allowSearch
        self.showGroupedView = showGroupedView
        self.subTitleKeys = []
        self.subTitleFormats = []
        
        // Deferred
        defer {
           self.accessoryAction = accessoryAction
           self.allowSelectionCheckMark = allowSelectionCheckMark
            self.cellColorStyle = cellColorStyle
            self.sectionColorStyle = sectionColorStyle
        }
        
        self.screenTitle = ""
        self.selectionDoneButtonTitle = "Select"
        self.dismissButtonTitle = "Cancel"
        self.sectionHeaderHeight = CGFloat(SECTION_HEADER_HEIGHT)
        
        self.delegate = nil
    }
    
    // MARK view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.createSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.updateBarButtonStatus()
        self.tableView.reloadData()
    }
    
    // MARK: NAV BAR
    func configureNavBar()
    {
        if (!self.selectionDoneButtonTitle.isEmpty)
        {
            let doneButton = UIBarButtonItem.init(title: self.selectionDoneButtonTitle, style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneTapped))
            self.navigationItem.rightBarButtonItem = doneButton
        }
        
        if (!self.dismissButtonTitle.isEmpty)
        {
            let dismissButton = UIBarButtonItem.init(title: self.dismissButtonTitle, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelTapped))
            self.navigationItem.leftBarButtonItem = dismissButton
        }
    }
    
    func updateBarButtonStatus()
    {
        if (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK)
        {
            let selectionDoneButton = self.navigationItem.rightBarButtonItem
            selectionDoneButton?.isEnabled = !(self.selectedObjects.isEmpty)
        }
    }
    
    @objc func doneTapped(sender : AnyObject)
    {
        var arrayToReturn : Array<Any>
        
        if (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK)
        {
            arrayToReturn = self.selectedObjects
        }
        else if (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_DELETE)
        {
            arrayToReturn = self.accessoryActionResultsArray
        }
        else
        {
            arrayToReturn = []
        }
        
        self.navigationController?.dismiss(animated: true, completion:
        {
            self.selectionDoneBlock?(arrayToReturn)
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
        if (self.allowSearch)
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
        
        if (self.isSearching)
        {
            self.searchArray = self.searchTextInTableRows(searchText: searchText)
        }
        
        self.tableView.reloadData()
    }
    
    func searchTextInTableRows (searchText : String) -> Array<Dictionary<String, Array<WrapperObj>>>
    {
        var searchResultArray = Array<Dictionary<String, Array<WrapperObj>>>()
        
        for sectionObj in self.internalResultsArray
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
                    let wrapperObjectSample = $0
                    let kvcString = wrapperObjectSample.kvcObject as! String
                    return kvcString.uppercased().contains(searchText.uppercased())
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
                    let wrapperObjectSample = $0
                    let kvcNumber = wrapperObjectSample.kvcObject as? NSNumber
                
                    return (((kvcNumber?.doubleValue)! == searchTextNumber?.doubleValue) ||
                    ((kvcNumber?.doubleValue)! >= startRange.doubleValue) &&
                    ((kvcNumber?.doubleValue)! <= endRange.doubleValue))
                }
            }
            else if (kvcObject is Dictionary<String, Any>)
            {
                filteredRowsArray = sectionRows?.filter
                {
                    let wrapperObjectSample = $0
                    let kvcDict = wrapperObjectSample.kvcObject as? Dictionary<String, Any>
                    
                    var bContainsKey = false
                    
                    for searchKey in self.searchKeys!
                    {
                        let kvcValue = kvcDict![searchKey] as! String
                    
                        if (kvcValue.lowercased().contains(searchText.lowercased()))
                        {
                            bContainsKey = true
                            break
                        }
                    }
                    
                    return bContainsKey
                }
            }

            if ((filteredRowsArray != nil) && !(filteredRowsArray?.isEmpty)!)
            {
                searchResultArray.append([sectionTitle!:filteredRowsArray!])
            }
        }
        
        return searchResultArray
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.text = ""
        self.view.endEditing(true)
    }
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionHeaderHeight!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        var sectionHeaderLabel : UILabel?
        var sectionHeaderCheckbox : UIButton?
        
        let sectionObj = self.getSectionObjFromSection(section: section)
        let sectionTitle = sectionObj.keys.first
        
        let bAllSelected = self.allCheckedWithSectionObj(sectionObj: sectionObj)
        
        let idx = (bAllSelected == true) ? 0 : 1
        if let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID)
        {
            if ((self.allowSelectAll == true) && (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK))
            {
                let sectionHeaderCheckbox = headerView.viewWithTag(TAG_SECTION_HEADER_CHECKBOX) as! UIButton
                sectionHeaderCheckbox.setBackgroundImage(self.accessoryImages?[idx], for: UIControlState.normal)
            }
            
            let sectionHeaderLabel = headerView.viewWithTag(TAG_SECTION_TITLE_LABEL) as! UILabel
            
            sectionHeaderLabel.text = sectionTitle

            return headerView
        }
        
        let headerView = UITableViewHeaderFooterView.init(reuseIdentifier: headerID)
        
        let labelY = (self.sectionHeaderHeight! - CGFloat(SECTION_HEADER_LABEL_HEIGHT)) / 2
        
        sectionHeaderLabel = UILabel.init(frame: CGRect.init(x: 5, y: labelY, width: tableView.bounds.size.width - CGFloat(SECTION_HEADER_CHECKBOX_OFFSET), height: CGFloat(SECTION_HEADER_LABEL_HEIGHT)))
        sectionHeaderLabel?.tag = TAG_SECTION_TITLE_LABEL
        sectionHeaderLabel?.backgroundColor = UIColor.clear
        sectionHeaderLabel?.textColor = UIColor.darkText
        headerView.contentView.backgroundColor = self.sectionColorArray?.first
        
        sectionHeaderLabel?.text = sectionTitle
        
        headerView.contentView.addSubview(sectionHeaderLabel!)
        
        if ((self.allowSelectAll == true) && (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK))
        {
            sectionHeaderCheckbox = UIButton.init(frame: CGRect.init(x: tableView.bounds.size.width - CGFloat(SECTION_HEADER_CHECKBOX_OFFSET), y: 5, width: CGFloat(CHECKBOX_WIDTH), height: CGFloat(CHECKBOX_HEIGHT)))
                sectionHeaderCheckbox?.tag = TAG_SECTION_HEADER_CHECKBOX
            sectionHeaderCheckbox?.setBackgroundImage(self.accessoryImages?[idx], for: UIControlState.normal)
            sectionHeaderCheckbox?.addTarget(self,  action: #selector(self.selectAllTapped(sender:event:)), for: UIControlEvents.touchUpInside)
            
            headerView.contentView.addSubview(sectionHeaderCheckbox!)
        }
       
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.allowSearch && self.isSearching)
        {
            return self.searchArray.count;
        }
        return internalResultsArray.count;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var sectionObj : Dictionary<String, Array<WrapperObj>>
        
        if (self.allowSearch && self.isSearching)
        {
            sectionObj = self.searchArray[section]
        }
        else
        {
            sectionObj = self.internalResultsArray[section]
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
        let sectionObj = biggerArrayToIndex[indexPath.section]
        let rowArray = sectionObj.values.first
        
        let wrapperObj = rowArray![indexPath.row]
        let kvcObject = wrapperObj.kvcObject
        
        let title = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.textLabelKeys, formatArray: self.textLabelFormats, separator: self.textLabelSeparator)
        let subTitle = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.subTitleKeys, formatArray: self.subTitleFormats, separator: self.subTitleSeparator)
       
        if (self.showGroupedView)
        {
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.lineBreakMode = .byWordWrapping
            
            if (self.isTitleDisplayedOnPreviousRow(rowsArray: rowArray!, index: indexPath.row, title: title))
            {
                cell?.textLabel?.text = String(format:"%@\n↳%@", "", subTitle)
            }
            else
            {
                cell?.textLabel?.text = String(format:"%@\n↳%@", title, subTitle)
            }
        }
        else
        {
            cell?.textLabel?.text = title
            cell?.detailTextLabel?.text = subTitle
        }
        
        cell?.backgroundColor = self.cellColorArray?[indexPath.row % (self.cellColorStyle.rawValue)]
        cell?.textLabel?.textColor = UIColor.darkText
        cell?.detailTextLabel?.textColor = UIColor.darkText
        
        self.createAccessoryView(cell: cell!, wrapperObjSelected: wrapperObj.selected)

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //1 - Update Model, and decide about check / uncheck
        let bToCheck = self.updateModelForSelection(indexPath: indexPath)
        
        //2 - Update UI - Cell accessory button image
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if (self.allowSelectionCheckMark == true)
        {
            cell?.accessoryType = (bToCheck == true) ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
        }
        else
        {
            let image = (bToCheck == true) ? self.accessoryImages![0] : self.accessoryImages![1]
            let button = cell!.accessoryView as! UIButton
            button.setBackgroundImage(image, for: UIControlState.normal)
        }
        
        //3 - Reload Table Data from data source, and update bar buttons
        self.tableView.reloadData()
        self.updateBarButtonStatus()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
       if (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_DELETE)
       {
            let wrapperObj = self.getWrapperObjectFromIndexPath(indexPath: indexPath)
            let kvcObject = wrapperObj.kvcObject
        
            let alertController = UIAlertController.init(title: self.accessoryPromptTitle, message: "", preferredStyle: UIAlertControllerStyle.alert)
        
            let displayValueToDelete = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.textLabelKeys, formatArray: self.textLabelFormats, separator: "")
        
            alertController.message = String.init(format: self.accessoryPromptMessage, displayValueToDelete)
        
            let okAction = UIAlertAction.init(title: self.accessoryPromptOKButtonTitle!, style: UIAlertActionStyle.default) { (action) in
                
                let kvcObjectDeleted = self.updateModelForDeletion(indexPath: indexPath)
                self.tableView.reloadData()
                
                self.deletionDoneBlock?(kvcObjectDeleted)
            }
        
            let cancelAction = UIAlertAction.init(title: self.accessoryPromptCancelButtonTitle!, style: UIAlertActionStyle.cancel) { (action) in
                
            }
        
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        
       }
       else if (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK)
       {
            //1 - Update Model, and decide about check / uncheck
            let bToCheck = self.updateModelForSelection(indexPath: indexPath)
        
            //2 - Update UI - Cell accessory button image
            let cell = self.tableView.cellForRow(at: indexPath)
        
            if (self.allowSelectionCheckMark == true)
            {
                cell?.accessoryType = (bToCheck == true) ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            }
            else
            {
                let image = (bToCheck == true) ? self.accessoryImages![0] : self.accessoryImages![1]
                let button = cell!.accessoryView as! UIButton
                button.setBackgroundImage(image, for: UIControlState.normal)
            }
        
            //3 - Reload Table Data from data source, and update bar buttons
            self.tableView.reloadData()
            self.updateBarButtonStatus()
        }
    }

    
    //MARK: Accessory View
    func createAccessoryView (cell : UITableViewCell, wrapperObjSelected : Bool)
    {
        var image : UIImage
        
        if (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK)
        {
            if (self.allowSelectionCheckMark == true)
            {
                cell.accessoryType = (wrapperObjSelected == true) ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
                return
            }
            else
            {
                image = (wrapperObjSelected == true) ? self.accessoryImages![0] : self.accessoryImages![1]
            }
        }
        else if (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_DELETE)
        {
            image = self.accessoryImages![0]
        }
        else
        {
            image = UIImage.init()
        }
        
        if (cell.accessoryView == nil)
        {
            let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: CHECKBOX_WIDTH, height: CHECKBOX_HEIGHT))
            button.setBackgroundImage(image, for: UIControlState.normal)
            button.addTarget(self,  action: #selector(self.accessoryTapped(sender:event:)), for: UIControlEvents.touchUpInside)
            cell.accessoryView = button
        }
        else
        {
            let button = cell.accessoryView as! UIButton
            button.setBackgroundImage(image, for: UIControlState.normal)
        }
    }
    
    @objc func selectAllTapped (sender:UIButton, event : UIEvent)
    {
        let touch = event.allTouches?.first
        let touchPoint = touch?.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: touchPoint!)
        
        if (indexPath != nil)
        {
            let sectionObj = self.getSectionObjFromSection(section: (indexPath?.section)!)
            
            let bToCheck = !(self.allCheckedWithSectionObj(sectionObj: sectionObj))
            
            let rowsArray = sectionObj.values.first
            
            for wrapperObj in rowsArray!
            {
                wrapperObj.selected = bToCheck
                let kvcObject = wrapperObj.kvcObject
                
                if let idx = selectedObjects.index(where: {
                    ($0 === kvcObject)
                })
                {
                    if (bToCheck == false)
                    {
                        selectedObjects.remove(at: idx)
                    }
                }
                else
                {
                    if (bToCheck == true)
                    {
                        selectedObjects.append(kvcObject)
                    }
                }
            }
            
            self.tableView.reloadData()
            self.updateBarButtonStatus()
        }
    }
    
    @objc func accessoryTapped (sender:UIButton, event : UIEvent)
    {
        let touch = event.allTouches?.first
        let touchPoint = touch?.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: touchPoint!)
        
        if (indexPath != nil)
        {
            self.tableView.delegate?.tableView!(self.tableView, accessoryButtonTappedForRowWith: indexPath!)
        }
    }
    
    //MARK: Helpers
    func updateModelForDeletion (indexPath: IndexPath) -> Any
    {
        var kvcObjectDeleted : AnyObject!
        let wrapperObj = self.getWrapperObjectFromIndexPath(indexPath: indexPath)
        var rowArray = self.getArrayToIndexFromIndexPath(indexPath: indexPath, bIgnoreSearchCondition: false)
        
        if (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_DELETE)
        {
            if let idx = rowArray.index(where: {
                ($0 === wrapperObj)
            })
            {
                let kvcObject = wrapperObj.kvcObject
                self.accessoryActionResultsArray.append(kvcObject)
   
                if (self.allowSearch && self.isSearching)
                {
                    var searchSectionObj = self.searchArray[indexPath.section]
                    var key = searchSectionObj.keys.first
                    rowArray.remove(at: idx)
                    searchSectionObj[key!] = rowArray
                    self.searchArray[indexPath.section] = searchSectionObj
                    
                    var internalSectionDict : Dictionary<String, Array<WrapperObj>> = ["" : []]
                    
                    if let sectionIdx = self.internalResultsArray.index(where: {
                        
                        (eachSectionObj) -> Bool in
                        
                        var bRetVal = false

                        if let rowIdx = (eachSectionObj.values.first?.index(where: {
                            (wrapperObj === $0)
                        }))
                        {
                            var internalRowArray = eachSectionObj.values.first
                            key = eachSectionObj.keys.first
                            kvcObjectDeleted = (internalRowArray?.remove(at: rowIdx).kvcObject)!
                            
                            internalSectionDict = eachSectionObj
                            internalSectionDict[key!] = internalRowArray
                            
                            bRetVal = true
                        }
                        return bRetVal
                    })
                    {
                        self.internalResultsArray[sectionIdx] = internalSectionDict
                    }
                }
                else
                {
                    var sectionObj = self.internalResultsArray[indexPath.section]
                    let key = sectionObj.keys.first
                    kvcObjectDeleted = rowArray.remove(at: idx).kvcObject
                    sectionObj[key!] = rowArray
                    self.internalResultsArray[indexPath.section] = sectionObj
                }
            }
        }
        
        return kvcObjectDeleted as Any
    }
    
    func updateModelForSelection (indexPath: IndexPath) -> Bool
    {
        let wrapperObj = self.getWrapperObjectFromIndexPath(indexPath: indexPath)
        let kvcObject = wrapperObj.kvcObject
        
        var bToCheck = false
        if (self.accessoryAction == ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK)
        {
            //1 - Update model - selected array
            bToCheck = !wrapperObj.selected;
            wrapperObj.selected = bToCheck;
            
            if let idx = selectedObjects.index(where: {
                ($0 === kvcObject)
            })
            {
                if (bToCheck == false)
                {
                    selectedObjects.remove(at: idx)
                }
            }
            else
            {
                if (bToCheck == true)
                {
                    selectedObjects.append(kvcObject)
                }
            }
        }
        
        return bToCheck
    }
    
    func getArrayToIndexFromIndexPath (indexPath : IndexPath, bIgnoreSearchCondition: Bool) -> Array<WrapperObj>
    {
        var sectionObj : Dictionary<String, Array<WrapperObj>>
        
        if (self.allowSearch && self.isSearching)
        {
            if (bIgnoreSearchCondition)
            {
                sectionObj  = self.internalResultsArray[indexPath.section]
            }
            else
            {
                sectionObj = self.searchArray[indexPath.section]
            }
        }
        else
        {
            sectionObj = self.internalResultsArray[indexPath.section]
        }
        
        let arrayToIndex = sectionObj.values.first
        
        return arrayToIndex!
    }
    
    func allCheckedWithSectionObj (sectionObj : Dictionary<String, Array<WrapperObj>>) -> Bool
    {
        let arrayToIndex = sectionObj.values.first
        
       let notCheckedCount = arrayToIndex?.filter({ (wrapperObj) -> Bool in
            return (wrapperObj.selected == false)
        }).count
        
        return (notCheckedCount == 0)
    }
    
    func getSectionObjFromSection (section : Int) -> Dictionary<String, Array<WrapperObj>>
    {
        var sectionObj : Dictionary<String, Array<WrapperObj>>
        
        if (self.allowSearch && self.isSearching)
        {
            sectionObj = self.searchArray[section]
        }
        else
        {
            sectionObj = self.internalResultsArray[section]
        }
        
        return sectionObj
    }
    
    func getWrapperObjectFromIndexPath (indexPath : IndexPath) -> WrapperObj
    {
        let sectionObj = self.getSectionObjFromSection(section: indexPath.section)
        
        var arrayToIndex = sectionObj.values.first
        let wrapperObj = arrayToIndex![indexPath.row]
        
        return wrapperObj
    }
    
    func isTitleDisplayedOnPreviousRow (rowsArray : Array<Any>, index : Int, title : String) -> Bool
    {
        var idx = index - 1
        while (idx > 0)
        {
            let wrapperObj = rowsArray[idx] as! WrapperObj
            let kvcObject = wrapperObj.kvcObject
            let previousTitle = self.getFormattedStringFromDisplayKeys(kvcObject: kvcObject, displayKeyArray: self.textLabelKeys, formatArray:self.textLabelFormats, separator: self.textLabelSeparator)
            
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
            if (formatArray.isEmpty == false)
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
            if (formatArray.isEmpty == false)
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
            if let obj = (kvcObject as! Dictionary<String, AnyObject>)[key] as? NSObject
            {
                return obj.description
            }
        }
        else if (kvcObject is NSDictionary)
        {
            if let obj = (kvcObject as! NSDictionary) .object(forKey: key) as? NSObject
            {
                return obj.description
            }
        }

        return ""
    }
}

