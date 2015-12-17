//
//  NSDictionary+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "NSDictionary+YXDExtension.h"

@implementation NSDictionary (YXDExtension)

- (NSData *)jsonData {
    return [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
}

- (NSString *)jsonString {
    return [[NSString alloc] initWithData:[self jsonData] encoding:NSUTF8StringEncoding];
}

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
