//
//  CustomObject.m
//  TestProject
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Nirav Bhatt. All rights reserved.
//

#import "CustomObject.h"

@implementation CustomObject

- (instancetype) initWithString:(NSString*)str andNumber:(NSNumber*)num
{
    if (self = [super init])
    {
        self.stringProperty = str;
        self.numberProperty = num;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.stringProperty, self.numberProperty];
}

@end
