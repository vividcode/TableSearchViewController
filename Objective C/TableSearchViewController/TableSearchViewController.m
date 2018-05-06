//
//  TableSearchViewController.m
//  iphonegamezone
//
//  Created by Nirav Bhatt on 5/25/16.
//  Copyright © 2016 iphonegamezone.net. All rights reserved.
//  This view controller is business logic independent. All UI Components can be set using following properties:

/*
 titleMessage;
 tableView;
 checkBoxText;
 selectionDoneButtonTitle;
 dismissButtonTitle;
 searchBarPlaceHolderText;
 
 Data in the searchable table should be supplied by setting resultsArray property, which will be array of objects that comply to key value coding (any id objects).
 The text in the search bar is searched for the field specified by displaykey property.
 */


#define SEARCHBAR_OFFSET 20
#define SEARCHBAR_TEXTOFFSET 60
#define NAVBAR_HEIGHT 40
#define DEFAULT_ROW_HEIGHT 44

#define SECTION_HEADER_CHECKBOX_OFFSET 50
#define SECTION_HEADER_LABEL_HEIGHT 30
#define CHECKBOX_HEIGHT 30
#define CHECKBOX_WIDTH 30

#define DEFAULT_SECTION_HEADER_HEIGHT 50
#define DEFAULT_SECTION_FOOTER_HEIGHT 50

//#define TAG_OFFSET_SECTION_HEADER_CHECKED 1
//#define TAG_OFFSET_SECTION_HEADER_UNCHECKED 2
//#define TAG_SECTION_MULTIPLIER 1000
#define TAG_SECTION_TITLE_LABEL 999
#define TAG_SECTION_HEADER_CHECKBOX 1999

#import "TableSearchViewController.h"

@interface TableSearchViewController ()
{
    NSArray<NSDictionary<NSString *, NSArray<NSObject*>*> *> * _Nullable _searchArray;
    NSMutableArray* accessoryActionResultsArray;
    NSMutableArray* selectedResultsArray;
    bool footerCheckedStatus;
    UIView * checkBoxView;
    NSMutableArray *internalResultsArray;
    NSString * storedTitleValue;
}

@end

static NSString * headerID = @"HeaderIdentifier";
static NSString * cellID = @"CellIdentifier";

@implementation WrapperObject


@end

@implementation TableSearchViewController

#pragma mark-
#pragma mark getters
- (NSUInteger)sectionHeaderHeight
{
    if (_sectionHeaderHeight > 0)
        return _sectionHeaderHeight;
    return DEFAULT_SECTION_HEADER_HEIGHT;
}

- (NSUInteger)sectionFooterHeight
{
    if (_sectionFooterHeight > 0)
        return _sectionFooterHeight;
    return DEFAULT_SECTION_FOOTER_HEIGHT;
}

#pragma mark-
#pragma mark Init
-(instancetype) initWithCellColorStyle:(CELLCOLORSTYLE)cellColorStyle andSectionColorStyle:(SECTIONCOLORSTYLE) sectionColorStyle andAllowSelectionCheckMark:(BOOL)bAllowSelectionCheckMark andAllowSelectAllCheckBox:(BOOL)bAllowSelectAllCheckBox andAllowSearch:(BOOL)bAllowSearch andAccessoryAction:(ACCESSORY_ACTION)accessoryAction andFooterText:(NSString*)footerText andResultsArray:(NSArray*)resultsArray
{
    if (self == [self initWithNibName:@"TableSearchViewController" bundle:[NSBundle mainBundle]])
    {
        self.resultsArray = resultsArray;
        self.sectionColorStyle = sectionColorStyle;
        self.cellColorStyle = cellColorStyle;
        
        self.accessoryAction = accessoryAction;
        
        self.allowSelectionCheckMark = bAllowSelectionCheckMark;  //false will set check/uncheck images automatically.
        self.allowSelectAllCheckBox = bAllowSelectAllCheckBox;  //true will set "select All" images automatically.
        
        self.checkBoxText = footerText;
        
        self.allowSearch = bAllowSearch;
        
        [self commonInitDefaults];
    }
    
    return self;
}

-(void)commonInitDefaults
{
    self.selectionDoneButtonTitle = @"Select";
    self.dismissButtonTitle = @"Cancel";
    
    self.searchKeys = @[@"SELF"];
    
    self.textLabelKeys = @[@"SELF"];
    self.subTitleKeys = @[@"SELF"];
    self.textLableFormats = @[@"%@"];
    self.subTitleFormats = @[@"%@"];
}

#pragma mark-
#pragma mark setters
- (void)setAccessoryAction:(ACCESSORY_ACTION)accessoryAction
{
    _accessoryAction = accessoryAction;
    
    if (accessoryAction == ACCESSORY_ACTION_DELETE)
    {
        self.accessoryPromptMessageText = @"Are you sure you want to Delete:%@?";
        NSString * appDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        self.accessoryPromptMessageTitle = appDisplayName;
        self.accessoryPromptOKButtonTitle = @"OK";
        self.accessoryPromptCancelButtonTitle = @"Cancel";
    }
}

-(void)setCellColorStyle:(CELLCOLORSTYLE)cellColorStyle
{
    UIColor * gray = [UIColor colorWithRed:177/255.0f green:177/255.0f blue:177/255.0f alpha:1.0];
    UIColor * offWhite = [UIColor colorWithRed:247/255.0f green:241/255.0f blue:234/255.0f alpha:1.0];
    UIColor * lightGray = [UIColor colorWithRed:175/255.0f green:184.0/255.0f blue:183.0/255.0f alpha:1.0];
    
    if (cellColorStyle == CELL_COLOR_STYLE_UNIFORM)
    {
        self.cellColorArray = [NSArray arrayWithObjects:offWhite, nil];
        self.cellTextColorArray = [NSArray arrayWithObjects:[UIColor darkTextColor], nil];
    }
    else if (cellColorStyle == CELL_COLOR_STYLE_ALTERNATE_DOUBLE)
    {
        self.cellColorArray = [NSArray arrayWithObjects:offWhite, lightGray, nil];
        self.cellTextColorArray = [NSArray arrayWithObjects:[UIColor darkTextColor], [UIColor whiteColor], nil];
    }
    else if (cellColorStyle == CELL_COLOR_STYLE_ALTERNATE_TRIPLE)
    {
        self.cellColorArray = [NSArray arrayWithObjects:gray, offWhite, lightGray, nil];
        self.cellTextColorArray = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor darkTextColor], [UIColor blackColor], nil];
    }
    _cellColorStyle = cellColorStyle;
}

- (void)setSectionColorStyle:(SECTIONCOLORSTYLE)sectionColorStyle
{
    UIColor * brown = [UIColor colorWithRed:212/255.0f green:172/255.0f blue:106/255.0f alpha:1.0];
    
    if (sectionColorStyle == SECTION_COLOR_STYLE_UNIFORM)
    {
        self.sectionColorArray = [NSArray arrayWithObjects:brown, nil];
    }
    _sectionColorStyle = sectionColorStyle;
}

- (void)setAllowSelectionCheckMark:(BOOL)allowSelectionCheckMark
{
    _allowSelectionCheckMark = allowSelectionCheckMark;
    _allowSelectionCheckImage = !allowSelectionCheckMark;
    
    [self updateAccessoryImagesArray:_allowSelectionCheckImage withAccessoryActionType:self.accessoryAction];
    
    [self updatedSelectedStatusForKVCObjects];
}

- (void)setAllowSelectionCheckImage:(BOOL)allowSelectionCheckImage
{
    _allowSelectionCheckImage = allowSelectionCheckImage;
    _allowSelectionCheckMark = !allowSelectionCheckImage;
    
    [self updateAccessoryImagesArray:_allowSelectionCheckImage withAccessoryActionType:self.accessoryAction];
    
    [self updatedSelectedStatusForKVCObjects];
}

-(void)updateAccessoryImagesArray : (BOOL) bAllowAccessoryImages withAccessoryActionType : (ACCESSORY_ACTION) accessoryAction
{
    if (bAllowAccessoryImages)
    {
        if (self.accessoryAction == ACCESSORY_ACTION_CHECK)
        {
            self.accessoryImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"uncheckbox"], [UIImage imageNamed:@"checkbox"], nil];
        }
        else if (self.accessoryAction == ACCESSORY_ACTION_DELETE)
        {
            self.accessoryImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"delete"], nil];
        }
        else
        {
            self.accessoryImages = nil;
        }
    }
    else
    {
        self.accessoryImages = nil;
    }
}

//Select all
- (void)setAllowSelectAllCheckBox:(BOOL)allowSelectAllCheckBox
{
    _allowSelectAllCheckBox = allowSelectAllCheckBox;
   
    if (self.accessoryAction == ACCESSORY_ACTION_CHECK)
    {
        if (self.selectAllImages == nil)
        {
            self.selectAllImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"uncheckbox"], [UIImage imageNamed:@"checkbox"], nil];
        }
    }
    else if (self.accessoryAction == ACCESSORY_ACTION_DELETE)
    {
        self.selectAllImages = nil; //no effect as of now, delete all isn't allowed.
    }
    
    [self updatedSelectedStatusForKVCObjects];
}

//resultsArray => {"Section Title 1":[row1ManagedObj, row2ManagedObj},
//                {"Section Title 2":[row3ManagedObj, row4ManagedObj}
//internalResultsArray => {"Section Title 1":[{"checked":0,"kvcObject":row1ManagedObj}, {"checked":0,"kvcObject":row2ManagedObj}]},
//                        {"Section Title 2":[{"checked":0,"kvcObject":row3ManagedObj}, {"checked":0,"kvcObject":row4ManagedObj}]}
- (void)setResultsArray:(NSArray<NSDictionary<NSString *, NSArray<NSObject*>*> *>*)resultsArray
{
    if (!resultsArray || (resultsArray.count == 0))
    {
        NSLog(@"Error: Array argument not be empty.");
        return;
    }
    
    id firstObj = [resultsArray firstObject];
    if (![firstObj isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: Array argument must be dictionaries with key=sectionName, value=array of rows.");
        return;
    }
    
    if (!internalResultsArray)
    {
        internalResultsArray = [[NSMutableArray alloc] init];
    }
    
    for (NSDictionary* sectionDict in resultsArray)
    {
        NSString * sectionTitle = [[sectionDict allKeys] firstObject];
        NSArray * sectionRows = [[sectionDict allValues] firstObject];
        
        NSMutableArray * rowsArray = [[NSMutableArray alloc] init];
        for (id obj in sectionRows)
        {
            WrapperObject * wrapperObj = [[WrapperObject alloc] init];
            if (self.delegate && [self.delegate respondsToSelector:@selector(rowShouldbePreSelectedForKVCObject:)])
            {
                wrapperObj.selected = [self.delegate rowShouldbePreSelectedForKVCObject:obj];
            }
            else
            {
                wrapperObj.selected = NO;
            }
            wrapperObj.kvcObject = obj;
            [rowsArray addObject:wrapperObj];
        }
        
        [internalResultsArray addObject:@{sectionTitle : rowsArray}];
    }
}

-(void)setSeperatorColor:(UIColor *)seperatorColor
{
    if (seperatorColor == nil)
    {
        seperatorColor = [UIColor blackColor];
    }
    self.tableView.separatorColor = seperatorColor;
}

- (void) initialializeSelf
{
    if (self.textLabelSeperator.length == 0)
    {
        self.textLabelSeperator = @"";
    }
    
    if (self.subTitleSeperator.length == 0)
    {
        self.subTitleSeperator = @"";
    }
    
    if (!selectedResultsArray)
    {
        selectedResultsArray = [[NSMutableArray alloc] init];
    }
    
    if (self.cellColorStyle == CELL_COLOR_STYLE_NONE)
    {
        self.cellColorStyle = CELL_COLOR_STYLE_UNIFORM;
    }
    
    if (self.sectionColorStyle == SECTION_COLOR_STYLE_NONE)
    {
        self.sectionColorStyle = SECTION_COLOR_STYLE_UNIFORM;
    }
    
    
}

#pragma mark-
#pragma mark updagte Selected Status in model
- (void) updateSelectedArray : (WrapperObject*) wrapperObj
{
    if (!selectedResultsArray)
    {
        selectedResultsArray = [[NSMutableArray alloc] init];
    }
    
    NSUInteger idx = [selectedResultsArray indexOfObject:wrapperObj.kvcObject];
    if (wrapperObj.selected && (idx == NSNotFound))
    {
        [selectedResultsArray addObject:wrapperObj.kvcObject];
    }
    else if (!wrapperObj.selected && (idx != NSNotFound))
    {
        [selectedResultsArray removeObject:wrapperObj.kvcObject];
    }
}


- (void) updatedSelectedStatusForKVCObjects
{
    for (NSDictionary* sectionDict in internalResultsArray)
    {
        NSArray * sectionRows = [[sectionDict allValues] firstObject];
        for (WrapperObject * wrapperObj in sectionRows)
        {
            id kvcObj = wrapperObj.kvcObject;
        
            if (self.delegate && [self.delegate respondsToSelector:@selector(rowShouldbePreSelectedForKVCObject:)])
            {
                wrapperObj.selected = [self.delegate rowShouldbePreSelectedForKVCObject:kvcObj];
            }
            else
            {
                wrapperObj.selected = NO;
            }
        
            [self updateSelectedArray:wrapperObj];
        }
    }
}

#pragma mark view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBarButtons];
    
    [self initialializeSelf];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self navBarTitleSetup];
    [self updateBarButtonStatus];
    [self createTableView];
    [self createSearchBar];
    [self setSearchBarAppearance];
    [self reloadTableView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
} 

- (void)dealloc
{
    [internalResultsArray removeAllObjects];
    internalResultsArray = nil;
    
    _searchKeys = nil;
    _textLabelKeys = nil;
    _subTitleKeys = nil;
    _textLableFormats =nil;
    _subTitleFormats = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //if dismiss happens by tapping outside, make sure it saves the selections.
    [self doneTapped];
}

#pragma mark -
#pragma mark Bar Buttons
- (void) navBarTitleSetup
{
    if (self.title.length > 0)
    {
        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.navigationItem.title;
        [label sizeToFit];
        
        // emboss in the same way as the native title
        [label setShadowColor:[UIColor darkGrayColor]];
        [label setShadowOffset:CGSizeMake(0, -0.5)];
        self.navigationItem.titleView = label;
    }
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
    
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
        // Remove the recognizer first so it's view.window is valid.
        [self.view.window removeGestureRecognizer:sender];
        
        //if dismiss happens by tapping outside, make sure it saves the selections.
        [self doneTapped];
        }
    }
}

- (void) createBarButtons
{
    if (self.selectionDoneButtonTitle.length > 0)
    {
        UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc] initWithTitle:self.selectionDoneButtonTitle
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(doneTapped)];
        self.navigationItem.rightBarButtonItem = doneBtn;
    }
    
    if (self.dismissButtonTitle.length > 0)
    {
        UIBarButtonItem * cancelBtn = [[UIBarButtonItem alloc] initWithTitle:self.dismissButtonTitle
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(cancelTapped)];
        self.navigationItem.leftBarButtonItem = cancelBtn;
    }
    
    if ((self.dismissButtonTitle.length == 0) && (self.selectionDoneButtonTitle.length == 0))
    {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
        
        [recognizer setNumberOfTapsRequired:1];
        recognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
        [self.view.window addGestureRecognizer:recognizer];
    }
}

- (void) updateBarButtonStatus
{
    UIBarButtonItem * selectionDoneButton = self.navigationItem.rightBarButtonItem;
    
    if (!selectionDoneButton)
        return;
    
    if (selectedResultsArray && selectedResultsArray.count > 0)
    {
        selectionDoneButton.enabled = YES;
    }
    else
    {
        selectionDoneButton.enabled = NO;
    }
}

#pragma mark - Navbar Actions
- (void) doneTapped
{
    if (self.selectionDoneBlock && selectedResultsArray)
    {
        self.selectionDoneBlock(selectedResultsArray, footerCheckedStatus);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) cancelTapped
{
    [selectedResultsArray removeAllObjects];
    if (self.cancelBlock)
    {
        self.cancelBlock(@"Nothing Selected.");
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Searchbar Actions
- (void) createSearchBar
{
    //search bar
    if (self.allowSearch)
    {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, NAVBAR_HEIGHT)];   //height for iOS 6 will be 0 if not set
        self.searchBar.delegate = self;
        self.tableView.tableHeaderView = self.searchBar;
    }
}

- (void) setSearchBarAppearance
{
    if (self.allowSearch)
    {
        self.searchBar.placeholder = self.searchBarPlaceHolderText;
        [self enumerateForTextFormat:self.searchBar];
    }
}

- (void) enumerateForTextFormat : (UIView *) argView
{
    for (UIView *subview in argView.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            UITextField *searchField = (UITextField *)subview;
            searchField.returnKeyType = UIReturnKeySearch;
            searchField.autocorrectionType = UITextAutocorrectionTypeNo;
            searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            break;
        }
        else
        {
            [self enumerateForTextFormat:subview];
        }
    }
}

- (NSMutableArray*) searchTextInTableRows : (NSString *) searchText
{
    NSMutableArray * searchMutableArray = [NSMutableArray array];
    NSMutableArray *predicates = nil;
    
    for (NSDictionary * sectionObj in internalResultsArray)
    {
        NSString * sectionTitle = [[sectionObj allKeys] firstObject];
        NSArray * sectionRows = [[sectionObj allValues] firstObject];
        
        NSPredicate * predicate = nil;
        WrapperObject * wrapperObj = [sectionRows firstObject];
        
        id kvcObject = wrapperObj.kvcObject;
        if ([kvcObject isKindOfClass:[NSString class]])
        {
            predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"kvcObject", searchText];
        }
        else if ([kvcObject isKindOfClass:[NSNumber class]])
        {
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *searchTextNumber = [f numberFromString:searchText];
            NSNumber * startRange = [NSNumber numberWithDouble:floor([searchTextNumber doubleValue])];
            NSNumber * endRange = @([startRange doubleValue] + 0.99);
            
            predicate = [NSPredicate predicateWithFormat:@"%K == %@ OR (%K >= %@ AND %K <= %@)",  @"kvcObject", searchTextNumber, @"kvcObject", startRange, @"kvcObject", endRange];
        }
        else if (self.searchKeys.count > 0)
        {
            predicates = [[NSMutableArray alloc] init];
            for (int idx = 0; idx < self.searchKeys.count; idx++)
            {
                NSString * searchKey = [self.searchKeys objectAtIndex:idx];
                predicate = [NSPredicate predicateWithFormat:@"%K.%K CONTAINS[cd] %@", @"kvcObject", searchKey, searchText];
                [predicates addObject:predicate];
            }
        }
        else
        {
            continue;
        }
        
        NSArray * filteredRowsArray = nil;
        
        if (predicates.count > 0)
        {
            NSCompoundPredicate * compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
            filteredRowsArray = [sectionRows filteredArrayUsingPredicate:compoundPredicate];
        }
        else
        {
            filteredRowsArray = [sectionRows filteredArrayUsingPredicate:predicate];
        }
        
        [searchMutableArray addObject:@{sectionTitle : filteredRowsArray}];
    }
    
    return searchMutableArray;
}

//internalResultsArray => {"Section Title 1":[{"checked":0,"kvcObject":row1ManagedObj}, {"checked":0,"kvcObject":row2ManagedObj}]},
//                        {"Section Title 2":[{"checked":0,"kvcObject":row3ManagedObj}, {"checked":0,"kvcObject":row4ManagedObj}]}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] != 0)
    {
        self.isSearching = YES;
        _searchArray = [self searchTextInTableRows:searchText];
    }
    else
    {
        self.isSearching = NO;
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self reloadTableView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self dismissKeyboard];
}

#pragma mark-
#pragma mark Table View Creation
- (void) createTableView
{
    CGFloat fixedFooterHeight = NAVBAR_HEIGHT;
    CGRect tableViewFrame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - fixedFooterHeight - 44);
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    if (self.allowMultiSelect)
    {
        [self.tableView setAllowsMultipleSelection:YES];
    }
    
    if (!self.allowSelectionCheckMark && !self.allowSelectionCheckImage)
    {
        self.tableView.allowsSelection = YES;
    }
    
    if (!self.seperatorColor)
    {
        self.seperatorColor = [UIColor blackColor];
    }
    
    [self createFooterView];
}

- (void) createFooterView
{
    if (!self.checkBoxText || [self.checkBoxText isEqualToString:@""])
        return;
    
    if (!checkBoxView)
    {
        // Initialize your Footer
        CGFloat fixedFooterHeight = NAVBAR_HEIGHT;
        CGRect footerFrame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - fixedFooterHeight, CGRectGetWidth(self.view.bounds), fixedFooterHeight);
        float width = self.view.bounds.size.width;
        checkBoxView = [[UIView alloc] initWithFrame:footerFrame];
        
        UIButton * checkbox = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
        UIImage *checkedboxImg = [UIImage imageNamed:footerCheckedStatus ? @"checkbox": @"uncheckbox"];
        [checkbox setBackgroundImage:checkedboxImg forState:UIControlStateNormal];
        [checkbox addTarget:self action:@selector(checkFooterView:) forControlEvents:UIControlEventTouchUpInside];
        checkbox.backgroundColor = [UIColor clearColor];
        
        [checkBoxView addSubview:checkbox];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, width - 35, 30)];
        label.text = self.checkBoxText;
        label.backgroundColor = [UIColor clearColor];
        
        [checkBoxView addSubview:label];
        
        checkBoxView.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
        checkBoxView.backgroundColor = self.tableView.backgroundColor;
        [self.view addSubview:checkBoxView];
    }
}

- (void) reloadTableView
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rowHeight > 0)
        return self.rowHeight;
    return DEFAULT_ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.sectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    UILabel * sectionHeaderLabel = nil;
    UIButton * sectionHeaderCheckbox = nil;
    
    CGFloat labelHeight = SECTION_HEADER_LABEL_HEIGHT;
    CGFloat labelY = (self.sectionHeaderHeight - labelHeight) / 2;
    CGFloat checkBoxOffset = SECTION_HEADER_CHECKBOX_OFFSET;
    
    if (!headerView)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerID];
    
        if (self.allowSelectAllCheckBox)
        {
            sectionHeaderCheckbox = [[UIButton alloc] initWithFrame:CGRectMake(self.tableView.bounds.size.width - checkBoxOffset, labelY, CHECKBOX_WIDTH, CHECKBOX_HEIGHT)];
            sectionHeaderCheckbox.tag = TAG_SECTION_HEADER_CHECKBOX;
            [sectionHeaderCheckbox addTarget:self action:@selector(checkSectionHeaderCheckBox:) forControlEvents:UIControlEventTouchUpInside];
            sectionHeaderCheckbox.backgroundColor = [UIColor clearColor];
            [headerView.contentView addSubview:sectionHeaderCheckbox];
        }
    
        sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, labelY, self.tableView.bounds.size.width - checkBoxOffset, labelHeight)];
        sectionHeaderLabel.tag = TAG_SECTION_TITLE_LABEL;
        sectionHeaderLabel.backgroundColor = [UIColor clearColor];
    
        [headerView.contentView addSubview:sectionHeaderLabel];

        headerView.contentView.backgroundColor = [self.sectionColorArray objectAtIndex:(section%self.sectionColorStyle)];
    }
    else
    {
        sectionHeaderLabel = [headerView.contentView viewWithTag:TAG_SECTION_TITLE_LABEL];
        if (self.allowSelectAllCheckBox)
        {
            sectionHeaderCheckbox = [headerView.contentView viewWithTag:TAG_SECTION_HEADER_CHECKBOX];
        }
    }
    
    NSDictionary * sectionObj = nil;
    
    if (self.allowSearch && self.isSearching)
    {
        sectionObj = [_searchArray objectAtIndex:section];
    }
    else
    {
        sectionObj = [internalResultsArray objectAtIndex:section];
    }
    
    NSString* sectionTitle = [[sectionObj allKeys] firstObject];
    sectionHeaderLabel.text = sectionTitle;
    
    if (self.allowSelectAllCheckBox && (self.selectAllImages.count > 1))
    {
        BOOL bAllChecked = [self allCheckedInSection:section];
        UIImage *checkedboxImg = bAllChecked ? [self.selectAllImages lastObject] : [self.selectAllImages firstObject];
        [sectionHeaderCheckbox setBackgroundImage:checkedboxImg forState:UIControlStateNormal];
    }
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.allowSearch && self.isSearching)
    {
        return _searchArray.count;
    }
    return internalResultsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * sectionObj = nil;
    
    if (self.allowSearch && self.isSearching)
    {
        sectionObj = [_searchArray objectAtIndex:section];
    }
    else
    {
        sectionObj = [internalResultsArray objectAtIndex:section];
    }
    NSArray * sectionRows = [[sectionObj allValues] firstObject];
    return sectionRows.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        UITableViewCellStyle style;
        if (self.showGroupedView)
        {
            style = UITableViewCellStyleDefault;
        }
        else
        {
            style = UITableViewCellStyleSubtitle;
        }
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSArray * arrayToIndex = nil;
    NSDictionary * sectionObj = nil;
    if (self.allowSearch && self.isSearching)
    {
        sectionObj = [_searchArray objectAtIndex:indexPath.section];
    }
    else
    {
        sectionObj = [internalResultsArray objectAtIndex:indexPath.section];
    }
    
    arrayToIndex = [[sectionObj allValues] firstObject];
    
    WrapperObject* wrapperObj = [arrayToIndex objectAtIndex:indexPath.row];
    
    id kvcObject = wrapperObj.kvcObject;
    
    NSString * title = [self getFormattedStringFromDisplayKeys:kvcObject :self.textLabelKeys :self.textLableFormats :self.textLabelSeperator];
    NSString * subTitle = [self getFormattedStringFromDisplayKeys:kvcObject :self.subTitleKeys :self.subTitleFormats :self.subTitleSeperator];
    
    cell.textLabel.numberOfLines = 0;
    if (self.showGroupedView)
    {
        if ([self isTitleDisplayedInPreviousRow:arrayToIndex :indexPath.row :title])
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@\n     %@",@"", subTitle];
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@\n     %@",title, subTitle];
        }
    }
    else
    {
        cell.textLabel.text = title;
        cell.detailTextLabel.text = subTitle;
    }
    
    cell.backgroundColor = [self.cellColorArray objectAtIndex:(indexPath.row%(self.cellColorStyle))];
    cell.textLabel.textColor = [self.cellTextColorArray objectAtIndex:(indexPath.row%(self.cellColorStyle))];
    cell.detailTextLabel.textColor = [self.cellTextColorArray objectAtIndex:(indexPath.row%(self.cellColorStyle))];
    
    [self createAccessoryView:cell :wrapperObj.selected];
    
    return cell;
}

- (BOOL) isTitleDisplayedInPreviousRow : (NSArray*)rowsArray :(NSUInteger) index :(NSString*)title
{
    while (index--)
    {
        WrapperObject* wrapperObj = [rowsArray objectAtIndex:index];
        
        id kvcObject = wrapperObj.kvcObject;
        
        NSString * previousTitle = [self getFormattedStringFromDisplayKeys:kvcObject :self.textLabelKeys :self.textLableFormats :self.textLabelSeperator];
        
        if ([previousTitle isEqualToString:title])
            return YES;
    }
    return NO;
}

#pragma mark - Table view delegate
- (void)accessoryButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self dismissKeyboard];
    
    NSMutableArray * arrayToIndex = nil;
    NSDictionary * sectionObj = nil;
    if (self.allowSearch && self.isSearching)
    {
        sectionObj = [_searchArray objectAtIndex:indexPath.section];
    }
    else
    {
        sectionObj = [internalResultsArray objectAtIndex:indexPath.section];
    }
    
    arrayToIndex = [[sectionObj allValues] firstObject];
    WrapperObject* wrapperObj = [arrayToIndex objectAtIndex:indexPath.row];
    id kvcObject = wrapperObj.kvcObject;
    
    if (self.accessoryAction == ACCESSORY_ACTION_DELETE)
    {
        UIAlertController * alertCtrl = [UIAlertController alertControllerWithTitle:self.accessoryPromptMessageTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        NSString * displayValueToDelete = [self getFormattedStringFromDisplayKeys:kvcObject :self.textLabelKeys :self.textLableFormats :@""];
        alertCtrl.message = [NSString stringWithFormat:self.accessoryPromptMessageText, displayValueToDelete];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:self.accessoryPromptOKButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
        {
           if (!accessoryActionResultsArray)
           {
                accessoryActionResultsArray = [[NSMutableArray alloc] init];
           }
       
           if (self.allowSearch && self.isSearching)
           {
               //first, let us remove the object from internal array
               NSDictionary * sectionObjInMainResults = nil;
               
               sectionObjInMainResults = [internalResultsArray objectAtIndex:indexPath.section];
               
               NSMutableArray * rowsArray = [[sectionObjInMainResults allValues] firstObject];
               
               NSUInteger rowIndexInMainResults = [rowsArray indexOfObject:wrapperObj];
               
               WrapperObject* rowWrapperObj = [rowsArray objectAtIndex:rowIndexInMainResults];
               
               id kvcObject = wrapperObj.kvcObject;
               
               [selectedResultsArray removeObject:kvcObject];
               [accessoryActionResultsArray addObject:kvcObject];
           
               if ([rowsArray indexOfObject:rowWrapperObj] != NSNotFound)
               {
                    [rowsArray removeObject:rowWrapperObj];
               }
               //refresh search array and reload rows
               _searchArray = [self searchTextInTableRows:self.searchBar.text];
           }
           else
           {
               id kvcObject = wrapperObj.kvcObject;
               
               [selectedResultsArray removeObject:kvcObject];
               [accessoryActionResultsArray addObject:kvcObject];
               
               // arrayToIndex already points to rowsArray, contained inside internalResultsArray
               [arrayToIndex removeObject:wrapperObj];
           }
           [self.tableView reloadData];
           
           //display refresh done. Background work must be done by caller
           if (accessoryActionResultsArray.count > 0 && self.accessoryActionDoneBlock)
           {
               self.accessoryActionDoneBlock(accessoryActionResultsArray);
           }
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:self.accessoryPromptCancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
        {
        
        }];
        [alertCtrl addAction:okAction];
        [alertCtrl addAction:cancelAction];
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }
    else if (self.accessoryAction == ACCESSORY_ACTION_NAVIGATE)
    {
        //ADD CODE HERE.
    }
    else if (self.accessoryAction == ACCESSORY_ACTION_CHECK)
    {
        //1 - Update model - selected array
        BOOL bToCheck = !wrapperObj.selected;
        wrapperObj.selected = bToCheck;
    
        NSUInteger idx = [selectedResultsArray indexOfObject:kvcObject];

        if ((idx == NSNotFound) && bToCheck)
        {
            //add if it does not exist, and checking
            [selectedResultsArray addObject:kvcObject];
        }
        else if ((idx != NSNotFound) && !bToCheck)
        {
            //remove if it exists and unchecking
            [selectedResultsArray removeObject:kvcObject];
        }
        
    
        //2 - Update UI - Cell accessory button image
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryView && [cell.accessoryView isKindOfClass:[UIButton class]])
        {
            UIButton * accessoryButton = (UIButton*) cell.accessoryView;
            UIImage * image = (bToCheck)?[self.accessoryImages lastObject] : [self.accessoryImages firstObject];
            [accessoryButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    
        //3 - Reload Table Data from data source, and update bar buttons
        [self.tableView reloadData];
        [self updateBarButtonStatus];
    }
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissKeyboard];
    
    NSArray * arrayToIndex = nil;
    NSDictionary * sectionObj = nil;
    if (self.allowSearch && self.isSearching)
    {
        sectionObj = [_searchArray objectAtIndex:indexPath.section];
    }
    else
    {
        sectionObj = [internalResultsArray objectAtIndex:indexPath.section];
    }
    
    //1 - Update Checked Status
    arrayToIndex = [[sectionObj allValues] firstObject];
    
    WrapperObject* wrapperObj = [arrayToIndex objectAtIndex:indexPath.row];
    BOOL bToCheck = !wrapperObj.selected;
    wrapperObj.selected = bToCheck;
    
    
    //2 - Add to selected Array
    id kvcObject = wrapperObj.kvcObject;
    
    NSUInteger idx = [selectedResultsArray indexOfObject:kvcObject];
    
    if ((idx == NSNotFound) && bToCheck)
    {
        //add if it does not exist, and checking
        [selectedResultsArray addObject:kvcObject];
    }
    else if ((idx != NSNotFound) && !bToCheck)
    {
        //remove if it exists and unchecking
        [selectedResultsArray removeObject:kvcObject];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    //3 - Reload Table Data from data source, and update bar buttons
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self createAccessoryView:cell :wrapperObj.selected];
    
    [self updateBarButtonStatus];
}

#pragma mark - Other Actions
- (void) createAccessoryView : (UITableViewCell *) cell :(BOOL)wrapperObjSelected
{
    if (self.allowSelectionCheckMark)
    {
        //iOS default checkmark, nothing else to be done.
        cell.accessoryType = (wrapperObjSelected) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else
    {
        UIImage * image;
        cell.accessoryType = UITableViewCellAccessoryNone;
    
        if (self.allowSelectionCheckImage)
        {
            image =  (wrapperObjSelected) ? [self.accessoryImages lastObject] : [self.accessoryImages firstObject];
        }
        else
        {
            //other image
            image = [self.accessoryImages firstObject];
        }
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, CHECKBOX_WIDTH, CHECKBOX_HEIGHT);
        button.frame = frame;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(accessoryButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        cell.accessoryView = button;
    }
}

- (NSString *)getFormattedStringFromDisplayKeys : (id) kvcObject : (NSArray*)displayKeyArray :(NSArray*)formatArray :(NSString*) seperator
{
    if ([kvcObject isKindOfClass:[NSString class]])
    {
        NSString * format = [formatArray objectAtIndex:0];
        if (format)
        {
            NSString * valueToFormat = (NSString *)kvcObject;
            NSString * formattedValue = [NSString stringWithFormat:format, valueToFormat];
            if (formattedValue.length > 0) return formattedValue;
        }
        return (NSString*)kvcObject;
    }
    
    if ([kvcObject isKindOfClass:[NSNumber class]])
    {
        NSString * format = [formatArray objectAtIndex:0];
        if (format)
        {
            double valueToFormat = [((NSNumber*)kvcObject) doubleValue];
            NSString * formattedValue = [NSString stringWithFormat:format, valueToFormat];
            if (formattedValue.length > 0) return formattedValue;
        }
        return [NSString stringWithFormat:@"%@", kvcObject];
    }
    
    NSMutableString * retString = [[NSMutableString alloc] init];
    
    for (int idx = 0; idx < displayKeyArray.count; idx++)
    {
        NSString * key = [displayKeyArray objectAtIndex:idx];
        NSString * format = [formatArray objectAtIndex:idx];
        id value = [self getValueFromKVCObject:kvcObject :key];
        
        NSString * valueToAppend = nil;
        
        if (format && value)
        {
            if ([value isKindOfClass:[NSNumber class]])
            {
                double d = [((NSNumber*)value) doubleValue];
                valueToAppend = [NSString stringWithFormat:format, d];
            }
            else
            {
                valueToAppend = [NSString stringWithFormat:format, value];
            }
        }
        
        [retString appendString:valueToAppend];
        if ((idx != displayKeyArray.count - 1) && (seperator.length > 0))
            [retString appendString:seperator];
    }
    
    return retString;
}

- (id)getValueFromKVCObject : (id) kvcObject :(NSString*) key
{
    if ([kvcObject respondsToSelector:@selector(objectForKey:)])
    {
        return [kvcObject objectForKey:key];
    }
    else if ([kvcObject respondsToSelector:NSSelectorFromString(key)])
    {
        return [kvcObject valueForKey:key];
    }
    return @"";
}

- (BOOL) allCheckedInSection : (NSUInteger) section
{
    NSArray * rowArray = nil;
    NSDictionary * sectionObj = nil;
    if (self.allowSearch && self.isSearching)
    {
        sectionObj = [_searchArray objectAtIndex:section];
    }
    else
    {
        sectionObj = [internalResultsArray objectAtIndex:section];
    }
    
    rowArray = [[sectionObj allValues] firstObject];
    
    if ((rowArray == nil) || (rowArray.count == 0))
        return false;
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"selected==%d", YES];
    
    BOOL bAllChecked = [rowArray filteredArrayUsingPredicate:predicate].count == rowArray.count;
    
    return bAllChecked;
}

- (void) checkSectionHeaderCheckBox : (id) sender
{
    UIButton * checkBox = (UIButton*) sender;
    
    CGPoint center= checkBox.center;
    CGPoint rootViewPoint = [checkBox.superview convertPoint:center toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    
    NSInteger section = indexPath.section;
    
    section = MAX(section, 0);
    
    BOOL bToCheck = ![self allCheckedInSection:section];
    
    UIImage *checkedboxImg = [UIImage imageNamed:bToCheck ? @"checkbox": @"uncheckbox"];
    [checkBox setBackgroundImage:checkedboxImg forState:UIControlStateNormal];
    
    [self selectAllCheckBoxInSection:section :bToCheck];
}

- (void) selectAllCheckBoxInSection : (NSUInteger) section :(BOOL)bToCheck
{
    NSArray * rowArray = nil;
    NSDictionary * sectionObj = nil;
    if (self.allowSearch && self.isSearching)
    {
        sectionObj = [_searchArray objectAtIndex:section];
    }
    else
    {
        sectionObj = [internalResultsArray objectAtIndex:section];
    }
    
    rowArray = [[sectionObj allValues] firstObject];
    
    for (WrapperObject * wrapperObj in rowArray)
    {
        wrapperObj.selected = bToCheck;
        
        id kvcObject = wrapperObj.kvcObject;
        
        NSUInteger idx = [selectedResultsArray indexOfObject:kvcObject];
        if ((idx == NSNotFound) && bToCheck)
        {
            //add if it does not exist, and checking
            [selectedResultsArray addObject:kvcObject];
        }
        else if ((idx != NSNotFound) && !bToCheck)
        {
            //remove if it exists and unchecking
            [selectedResultsArray removeObject:kvcObject];
        }
    }
    
    [self.tableView reloadData];
    [self updateBarButtonStatus];
}

- (void) checkFooterView : (id) sender
{
    UIButton * checkBox = (UIButton*) sender;
    footerCheckedStatus = !footerCheckedStatus;
    UIImage *checkedboxImg = [UIImage imageNamed:footerCheckedStatus ? @"checkbox": @"uncheckbox"];
    [checkBox setBackgroundImage:checkedboxImg forState:UIControlStateNormal];
}

- (void) dismissKeyboard
{
    if (self.allowSearch && [self.searchBar isFirstResponder])
    {
        BOOL resigned = [self.searchBar resignFirstResponder];
        if (!resigned)
        {
            [self.searchBar endEditing:YES];
        }
    }
}

@end
