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
            NSLog(@"%@", selectedKVCObjects);
        };
    
        UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
        [self presentViewController:navCtrl animated:YES completion:nil];

When you run the above code, a viewcontroller pops up (presented) and allows you to select objects of your choices, like below.

![alt text](https://github.com/vividcode/TableSearchViewController/blob/master/Resources/example1.png "Selectable Strings in table view")

Upon pressing Select, TableSearchViewController gets dismissed, and tableSearchViewController.selectionDoneBlock block executes, and selected objects (NSString) are supplied inside the block as part of NSArray.

Note that resultsArray dictinaries can also accept any NSObject derived objects, in which case you must supply specific property name to display in table rows.

- This property name must be supplied in the property textLabelKeys which is an array of properties to display inside UITableViewCell textLabel.
- Similarly, subTitleKeys array property holds properties to display inside UITableViewCell textLabel.
- Display formats can be supplied using textLableFormats and subTitleFormats Arrays.
- Searchable properties can be supplied using searchKeys Array property.
- If array of NSDictionary is supplied as part of NSArray, all the above property values must correspond to dictionary keys.

For elaborate example of how various objects can be displayed inside TableSearchViewController, see example project. 

This readme refers to Objective C. The swift counterpart is still evolving due to Key value coding not readily available for Swift objects.
