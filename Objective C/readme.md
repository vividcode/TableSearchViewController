**Usage:**

TableSearchViewController is a powerful UIViewController with easy to initialize interface. 

All you have to do is:

- Supply your rows inside a special NSArray of NSDictionaries with <Section Name (String) : Rows Array (NSObjects NSArray)>
- Supply cell and section formatting style
- Supply selection button criteria (in addition to select / delete flag)
- Supply Search flag
- Supply blocks of record selection/deletion and cancel operation

All of the above can be accomplished in just few lines of code, like below:

1. Let's say you have 2 sections with each having following rows:

| First Section | Second Section |
|---------------|----------------|
| one           | one            |
| two           | three          |
| three         | five           |
|               | six            |

To create UITableView with above objects with possible search through rows also, use the following code:

        NSArray * firstSectionArray = @[@"one", @"two", @"three"];
        NSArray * secondSectionArray = @[@"one", @"three", @"five",  @"six",];
    
        NSArray * resultsArray = @[@{@"First Section" : firstSectionArray}, @{@"Second Section" : secondSectionArray}];
    
        TableSearchViewController * tableSearchViewController = [[TableSearchViewController alloc] initWithCellColorStyle:CELL_COLOR_STYLE_ALTERNATE_DOUBLE andSectionColorStyle:SECTION_COLOR_STYLE_UNIFORM andAllowSelectionCheckMark:NO andAllowSelectAllCheckBox:YES andAllowSearch:YES andAccessoryAction:ACCESSORY_ACTION_CHECK andFooterText:@"" andResultsArray:resultsArray];
    
        tableSearchViewController.selectionDoneBlock = ^(NSArray* _Nullable  selectedKVCObjects, BOOL bExtraFlag)
        {
	        //see what user checked on the presented table viewcontroller
            NSLog(@"%@", selectedKVCObjects);
        };
    
        UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
        [self presentViewController:navCtrl animated:YES completion:nil];

Following code can be used to delete objects from presented table view, and get their reference back in deletionDoneBlock.

    	NSArray * firstSectionArray = @[@"one", @"two", @"two", @"three"];
    	NSArray * secondSectionArray = @[@"one", @"three", @"five",  @"six",];
    
    	NSArray * resultsArray = @[@{@"First Section" : firstSectionArray}, @{@"Second Section" : secondSectionArray}];
    
    	TableSearchViewController * tableSearchViewController = [[TableSearchViewController alloc] initWithCellColorStyle:CELL_COLOR_STYLE_ALTERNATE_DOUBLE andSectionColorStyle:SECTION_COLOR_STYLE_UNIFORM andAllowSelectionCheckMark:NO andAllowSelectAllCheckBox:YES andAllowSearch:YES andAccessoryAction:ACCESSORY_ACTION_DELETE andFooterText:@"" andResultsArray:resultsArray];
    
    	tableSearchViewController.selectionDoneBlock = ^(NSArray* _Nullable  deletedKVCObjects, BOOL bExtraFlag)
    	{
    		//get all deleted objects here
        	NSLog(@"%@", deletedKVCObjects);
        	_valueLabel.text = [NSString stringWithFormat:@"%@", [deletedKVCObjects componentsJoinedByString:@","]];
    	};
    
    	tableSearchViewController.accessoryActionDoneBlock = ^(NSArray* _Nullable  accessoryActionKVCObjects)
    	{
    		//get what was just deleted using row delete button
        	NSLog(@"%@", accessoryActionKVCObjects);
        	_valueLabel.text = [NSString stringWithFormat:@"Deleted: %@", [accessoryActionKVCObjects componentsJoinedByString:@","]];
    	};
    
    	UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
    	[self presentViewController:navCtrl animated:YES completion:nil];

For elaborate example of how various objects can be displayed inside TableSearchViewController, see example project. 

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
