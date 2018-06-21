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
    NSArray * firstSectionArray = @[@(1.23), @(2.45), @(3.0)];
    NSArray * secondSectionArray = @[@(2), @(5), @(6)];
    
    NSArray * resultsArray = @[@{@"First Section" : firstSectionArray}, @{@"Second Section" : secondSectionArray}];
    
    TableSearchViewController * tableSearchViewController = [[TableSearchViewController alloc] initWithCellColorStyle:CELL_COLOR_STYLE_ALTERNATE_DOUBLE andSectionColorStyle:SECTION_COLOR_STYLE_UNIFORM andAllowSelectionCheckMark:NO andAllowSelectAllCheckBox:YES andAllowSearch:NO andAccessoryAction:ACCESSORY_ACTION_CHECK andFooterText:@"This is extra footer checkbox" andResultsArray:resultsArray];
    
    tableSearchViewController.textLableFormats = @[@"My numbers: %.4f"];
    tableSearchViewController.preventSubTitle = YES;
    
    tableSearchViewController.selectionDoneBlock = ^(NSArray* _Nullable  selectedKVCObjects, BOOL bExtraFlag)
    {
        NSLog(@"%@", selectedKVCObjects);
        _valueLabel.text = [NSString stringWithFormat:@"Selected: %@", [selectedKVCObjects componentsJoinedByString:@","]];
    };
    
    UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

- (IBAction)loadObjects:(id)sender
{
    CustomObject * firstObj = [[CustomObject alloc] initWithString:@"First" andNumber:@(1)];
    CustomObject * secondObj = [[CustomObject alloc] initWithString:@"Second" andNumber:@(2.555)];
    CustomObject * thirdObj = [[CustomObject alloc] initWithString:@"Third" andNumber:@(3.999)];
    
    CustomObject * forthObj = [[CustomObject alloc] initWithString:@"Four" andNumber:@(4.111)];
    CustomObject * fifthObj = [[CustomObject alloc] initWithString:@"Five" andNumber:@(5.345)];
    
    NSArray * firstSectionArray = @[firstObj, secondObj, thirdObj];
    NSArray * secondSectionArray = @[forthObj, fifthObj, firstObj];
    
    NSArray * resultsArray = @[@{@"First Section" : firstSectionArray}, @{@"Second Section" : secondSectionArray}];
    
    TableSearchViewController * tableSearchViewController = [[TableSearchViewController alloc] initWithCellColorStyle:CELL_COLOR_STYLE_ALTERNATE_DOUBLE andSectionColorStyle:SECTION_COLOR_STYLE_UNIFORM andAllowSelectionCheckMark:NO andAllowSelectAllCheckBox:YES andAllowSearch:YES andAccessoryAction:ACCESSORY_ACTION_CHECK andFooterText:@"" andResultsArray:resultsArray];
    
    //Must define below properties for seachability
    tableSearchViewController.searchKeys = @[@"stringProperty"];
    tableSearchViewController.textLabelKeys = @[@"stringProperty"];
    tableSearchViewController.subTitleKeys = @[@"numberProperty"];
    tableSearchViewController.textLableFormats = @[@"String Property is: %@"];
    tableSearchViewController.subTitleFormats = @[@"Number Property is: %.4f"];
    
    tableSearchViewController.selectionDoneBlock = ^(NSArray* _Nullable  selectedKVCObjects, BOOL bExtraFlag)
    {
        NSLog(@"%@", selectedKVCObjects);
        _valueLabel.text = [NSString stringWithFormat:@"Selected: %@", [selectedKVCObjects componentsJoinedByString:@","]];
    };
    
    UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

- (IBAction)loadStrings:(id)sender
{
    NSArray * firstSectionArray = @[@"one", @"two", @"three"];
    NSArray * secondSectionArray = @[@"one", @"three", @"five",  @"six",];
    
    NSArray * resultsArray = @[@{@"First Section" : firstSectionArray}, @{@"Second Section" : secondSectionArray}];
    
    TableSearchViewController * tableSearchViewController = [[TableSearchViewController alloc] initWithCellColorStyle:CELL_COLOR_STYLE_ALTERNATE_DOUBLE andSectionColorStyle:SECTION_COLOR_STYLE_UNIFORM andAllowSelectionCheckMark:NO andAllowSelectAllCheckBox:YES andAllowSearch:YES andAccessoryAction:ACCESSORY_ACTION_CHECK andFooterText:@"" andResultsArray:resultsArray];
    
    tableSearchViewController.checkBoxText = @"This is the footer checkbox.";
    tableSearchViewController.selectionDoneBlock = ^(NSArray* _Nullable  selectedKVCObjects, BOOL bExtraFlag)
    {
        NSLog(@"%@", selectedKVCObjects);
        _valueLabel.text = [NSString stringWithFormat:@"Selected: %@", [selectedKVCObjects componentsJoinedByString:@","]];
    };
    
    UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

- (IBAction)loadStringsWithDelete:(id)sender
{
    NSArray * firstSectionArray = @[@"one", @"two", @"two", @"three"];
    NSArray * secondSectionArray = @[@"one", @"three", @"five",  @"six",];
    
    NSArray * resultsArray = @[@{@"First Section" : firstSectionArray}, @{@"Second Section" : secondSectionArray}];
    
    TableSearchViewController * tableSearchViewController = [[TableSearchViewController alloc] initWithCellColorStyle:CELL_COLOR_STYLE_ALTERNATE_DOUBLE andSectionColorStyle:SECTION_COLOR_STYLE_UNIFORM andAllowSelectionCheckMark:NO andAllowSelectAllCheckBox:YES andAllowSearch:YES andAccessoryAction:ACCESSORY_ACTION_DELETE andFooterText:@"" andResultsArray:resultsArray];
    
    tableSearchViewController.selectionDoneBlock = ^(NSArray* _Nullable  deletedKVCObjects, BOOL bExtraFlag)
    {
        NSLog(@"%@", deletedKVCObjects);
        _valueLabel.text = [NSString stringWithFormat:@"%@", [deletedKVCObjects componentsJoinedByString:@","]];
    };
    
    tableSearchViewController.accessoryActionDoneBlock = ^(NSArray* _Nullable  accessoryActionKVCObjects)
    {
        NSLog(@"%@", accessoryActionKVCObjects);
        _valueLabel.text = [NSString stringWithFormat:@"Deleted: %@", [accessoryActionKVCObjects componentsJoinedByString:@","]];
    };
    
    UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tableSearchViewController];
    [self presentViewController:navCtrl animated:YES completion:nil];
}


@end
