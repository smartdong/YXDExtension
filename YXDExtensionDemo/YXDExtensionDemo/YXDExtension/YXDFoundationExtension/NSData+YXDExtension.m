//
//  NSData+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "NSData+YXDExtension.h"

@implementation NSData (YXDExtension)

- (id)objectFromJSONData {
    return [NSJSONSerialization JSONObjectWithData:self options:0 error:nil];
}

-(NSString *)hexString {
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer) {
        return nil;
    }
    
    NSUInteger dataLength  = [self length];
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    
    return hexString;
}

@end
