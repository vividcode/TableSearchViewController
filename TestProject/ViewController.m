//
//  ViewController.m
//  TestProject
//
//  Created by Admin on 10/16/16.
//  Copyright © 2016 Nirav Bhatt. All rights reserved.
//

#import "ViewController.h"
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
    
}

- (IBAction)loadObjects:(id)sender
{
    
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
        _valueLabel.text = [NSString stringWithFormat:@"%@", [selectedKVCObjects firstObject]];
    };
    
    UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

@end
