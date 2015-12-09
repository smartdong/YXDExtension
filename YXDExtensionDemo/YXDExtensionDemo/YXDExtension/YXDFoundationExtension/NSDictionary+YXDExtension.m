//
//  NSDictionary+YXDExtension.m
//  YXDExtensionDemo
//
//  Created by zjdd on 15/12/5.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "NSDictionary+YXDExtension.h"

@implementation NSDictionary (YXDExtension)

- (NSString *)sortedKeyValueString {
    if (!self.count) {
        return nil;
    }
    
    NSArray *arrKeys = [self.allKeys copy];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    
    arrKeys = [arrKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSString *sortedString = @"";
    
    for (NSString *aKey in arrKeys) {
        sortedString = [sortedString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",aKey,[self objectForKey:aKey]]];
    }
    
    return [sortedString substringToIndex:[sortedString length] - 1];
}

@end
