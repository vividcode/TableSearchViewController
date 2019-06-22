**TableSearchViewController:**

TableSearchViewController is a powerful UIViewController with easy to initialize interface. 

All you have to do is:

- Supply your rows inside a special Array of Dictionaries with <Section Name (String) : Rows Array (of String/Numbers/Dictionaries)>
- Supply cell and section formatting style
- Supply selection button criteria (in addition to select / delete flag)
- Supply Search flag (should search bar be visible on top)
- Supply blocks of record selection/deletion and cancel operation (these blocks will receive arrays containing selected / deleted objects)

All of the above can be accomplished in just few lines of code, like below:

1. Let's say you have 2 sections with each having following rows:

| First Section | Second Section |
|---------------|----------------|
| one           | two            |
| two           | four          |
| three         | six           |
|               | seven            |

To create UITableView with above objects (with possible search through rows, checkmark for rows), use the following code:

        let resultsArray = [["First": ["one","two","three"]], ["Second": ["two","four","six","seven"]]]

        let tableVC = TableSearchViewController.init(allowSelectionCheckMark: false, allowSearch: true, accessoryAction: ACCESSORY_ACTION.ACCESSORY_ACTION_CHECK, resultsArray: resultsArray)
        
        //Specify what happens when "Select" is pressed and TableSearchViewController is dismissed
        tableVC.selectionDoneBlock = { selectedObjects, bExtraFlag in
            //see what user checked on the presented table viewcontroller
            let str = "Selected: " + selectedObjects.description
            self.resultLabel.text? = str
            print("Selected:\(str)")
        }
        
        let tableNavVC  = UINavigationController.init(rootViewController: tableVC)
        
        self.navigationController?.present(tableNavVC, animated: true, completion: {
        })
        
Following code can be used to delete objects from presented table view, and get their reference back in deletionDoneBlock.

        let resultsArray = [["First": ["one","two","three"]], ["Second": ["two","four","six","seven"]]]
        
        let tableVC = TableSearchViewController.init(allowSelectionCheckMark: false, allowSearch: true, accessoryAction: ACCESSORY_ACTION.ACCESSORY_ACTION_DELETE, resultsArray: resultsArray)
        
        //Specify what happens when "Done" is pressed and TableSearchViewController is dismissed
        tableVC.selectionDoneBlock = { deletedObjects, bExtraFlag in
            
            let str = "All Deleted: " + (deletedObjects as Array<Any>).description
            self.resultLabel.text? = str
            print("Deleted:\(str)")
        }
        
        tableVC.deletionDoneBlock = { kvcObjectDeleted in
            let str = "Deleted Now: " + (kvcObjectDeleted as! String)
            self.resultLabel.text? = str
            print("Deleted:\(str)")
        }

        let tableNavVC  = UINavigationController.init(rootViewController: tableVC)
        
        self.navigationController?.present(tableNavVC, animated: true, completion: {
        })
        
There are lot of UI customizations possible using properties such as: 

- showGroupedView (show Windows explorer type tree structure)
- cellColorStyle (CELL_COLOR_STYLE_UNIFORM - all cells with same color, CELL_COLOR_STYLE_ALTERNATE_DOUBLE - 2 colors alternate, CELL_COLOR_STYLE_ALTERNATE_TRIPLE - 3 colors alternate)
- textLabelKeys (row titles from dictionary keys)
- subTitleKeys (row subtitles from dictionary keys)
- textLabelFormats (row title formats)
- subTitleFormats (row subtitle formats)

**A Note about tests:**
Test project is already part of the XCodeproj - hence no separate tests are included. The test results greatly depend on what user selects/deletes in the UI, so XCTest would make little sense. 
UI automation tests are beyond scope.