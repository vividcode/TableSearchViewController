//
//  ViewController.m
//  TestProject
//
//  Created by Admin on 10/16/16.
//  Copyright © 2016 Nirav Bhatt. All rights reserved.
//

#import "ViewController.h"
#import "CustomObject.h"
#import "TableSearchViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)loadNumbers:(id)sender
{
    TableSearchViewController * tableSearchViewController = [[TableSearchViewController alloc] initWithNibName:@"TableSearchViewController" bundle:[NSBundle mainBundle]];
    
    NSArray * firstSectionArray = @[@(1), @(2), @(3)];
    NSArray * secondSectionArray = @[@(2), @(5), @(6)];
    
    tableSearchViewController.resultsArray = @[@{@"First Section" : firstSectionArray}, @{@"Second Section" : secondSectionArray}];
    
    tableSearchViewController.tableViewStyle = UITableViewStyleGrouped;
    tableSearchViewController.allowSearch = YES;
    tableSearchViewController.selectionDoneButtonTitle = @"Select";
    tableSearchViewController.dismissButtonTitle = @"Cancel";
    
    tableSearchViewController.accessoryAction = ACCESSORY_ACTION_CHECK;
    tableSearchViewController.allowSelectionCheckImage = YES;
    tableSearchViewController.allowSelectAllCheckBox = YES;
    tableSearchViewController.checkBoxText = @"This is extra footer checkbox.";
    
    tableSearchViewController.cellColorStyle = CELL_COLOR_STYLE_ALTERNATE_DOUBLE;
    
    tableSearchViewController.selectionDoneBlock = ^(NSArray* _Nullable  selectedKVCObjects, BOOL bExtraFlag)
    {
        NSLog(@"%@", selectedKVCObjects);
        _valueLabel.text = [NSString stringWithFormat:@"%@", [selectedKVCObjects componentsJoinedByString:@","]];
    };
    
    UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

- (IBAction)loadObjects:(id)sender
{
    TableSearchViewController * tableSearchViewController = [[TableSearchViewController alloc] initWithNibName:@"TableSearchViewController" bundle:[NSBundle mainBundle]];
    
    CustomObject * firstObj = [[CustomObject alloc] initWithString:@"First" andNumber:@(1)];
    CustomObject * secondObj = [[CustomObject alloc] initWithString:@"Second" andNumber:@(2)];
    CustomObject * thirdObj = [[CustomObject alloc] initWithString:@"Third" andNumber:@(3)];
    
    CustomObject * forthObj = [[CustomObject alloc] initWithString:@"Four" andNumber:@(4)];
    CustomObject * fifthObj = [[CustomObject alloc] initWithString:@"Five" andNumber:@(5)];
    
    
    NSArray * firstSectionArray = @[firstObj, secondObj, thirdObj];
    NSArray * secondSectionArray = @[forthObj, fifthObj, firstObj];
    
    tableSearchViewController.resultsArray = @[@{@"First Section" : firstSectionArray}, @{@"Second Section" : secondSectionArray}];
    
    tableSearchViewController.tableViewStyle = UITableViewStyleGrouped;
    tableSearchViewController.allowSearch = YES;
    
    
    tableSearchViewController.searchKeys = @[@"stringProperty"];
    tableSearchViewController.textLabelKeys = @[@"stringProperty"];
    tableSearchViewController.subTitleKeys = @[@"numberProperty"];
    tableSearchViewController.textLableFormats = @[@"%@"];
    tableSearchViewController.subTitleFormats = @[@"%@"];
    
    tableSearchViewController.selectionDoneButtonTitle = @"Select";
    tableSearchViewController.dismissButtonTitle = @"Cancel";
    
    tableSearchViewController.accessoryAction = ACCESSORY_ACTION_CHECK;
    tableSearchViewController.allowSelectionCheckImage = YES;
    tableSearchViewController.allowSelectAllCheckBox = YES;
    
    tableSearchViewController.cellColorStyle = CELL_COLOR_STYLE_ALTERNATE_DOUBLE;
    
    tableSearchViewController.selectionDoneBlock = ^(NSArray* _Nullable  selectedKVCObjects, BOOL bExtraFlag)
    {
        NSLog(@"%@", selectedKVCObjects);
        _valueLabel.text = [NSString stringWithFormat:@"%@", [selectedKVCObjects componentsJoinedByString:@","]];
    };
    
    UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

- (IBAction)loadStrings:(id)sender
{
    TableSearchViewController * tableSearchViewController = [[TableSearchViewController alloc] initWithNibName:@"TableSearchViewController" bundle:[NSBundle mainBundle]];

    
    NSArray * firstSectionArray = @[@"one", @"two", @"three"];
    NSArray * secondSectionArray = @[@"one", @"three", @"five",  @"six",];
    
    tableSearchViewController.resultsArray = @[@{@"First Section" : firstSectionArray}, @{@"Second Section" : secondSectionArray}];
    
    tableSearchViewController.tableViewStyle = UITableViewStyleGrouped;
    tableSearchViewController.allowSearch = YES;
    tableSearchViewController.selectionDoneButtonTitle = @"Select";
    tableSearchViewController.dismissButtonTitle = @"Cancel";
    
    tableSearchViewController.accessoryAction = ACCESSORY_ACTION_CHECK;
    tableSearchViewController.allowSelectionCheckImage = YES;
    tableSearchViewController.allowSelectAllCheckBox = YES;
    tableSearchViewController.checkBoxText = @"This is extra footer checkbox.";
    
    tableSearchViewController.cellColorStyle = CELL_COLOR_STYLE_ALTERNATE_DOUBLE;
    
    tableSearchViewController.selectionDoneBlock = ^(NSArray* _Nullable  selectedKVCObjects, BOOL bExtraFlag)
    {
        NSLog(@"%@", selectedKVCObjects);
        _valueLabel.text = [NSString stringWithFormat:@"%@", [selectedKVCObjects componentsJoinedByString:@","]];
    };
    
    UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

@end
