//
//  NSDictionary+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "NSDictionary+YXDExtension.h"
#import "NSString+YXDExtension.h"

@implementation NSDictionary (YXDExtension)

- (NSUInteger)length {
    return self.count;
}

- (NSData *)JSONData {
    return [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
}

- (NSString *)JSONString {
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)JSONString {
    return [JSONString objectFromJSONString];
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
    
    return [sortedString substringToIndex:(sortedString.length - 1)];
}

@end
