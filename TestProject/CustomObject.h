//
//  CustomObject.h
//  TestProject
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Nirav Bhatt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomObject : NSObject

@property (nonatomic) NSString * stringProperty;
@property (nonatomic) NSNumber * numberProperty;

- (instancetype) initWithString:(NSString*)str andNumber:(NSNumber*)num;

@end
