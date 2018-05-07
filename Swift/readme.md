**Caveat:**
Swift TableSearchViewController is freshly under porting effort and many APIs do not work same as Objective C counterpart. This is constantly under updates and should be fully functional very soon.

**TableSearchViewController:**

TableSearchViewController is a powerful UIViewController with easy to initialize interface. 

All you have to do is:

- Supply your rows inside a special NSArray of NSDictionaries with <Section Name (String) : Rows Array (String/NSNumbers/NSDictionaries NSArray)>
- Supply cell and section formatting style
- Supply selection button criteria (in addition to select / delete flag)
- Supply Search flag
- Supply blocks of record selection/deletion and cancel operation

All of the above can be accomplished in just few lines of code, like below:

1. Let's say you have 2 sections with each having following rows:

| First Section | Second Section |
|---------------|----------------|
| one           | two            |
| two           | four          |
| three         | six           |
|               | seven            |

To create UITableView with above objects with possible search through rows also, use the following code:

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
