//
//  ViewController.h
//  TestProject
//
//  Created by Admin on 10/16/16.
//  Copyright © 2016 Nirav Bhatt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (IBAction)loadNumbers:(id)sender;
- (IBAction)loadObjects:(id)sender;
- (IBAction)loadStrings:(id)sender;

@end

