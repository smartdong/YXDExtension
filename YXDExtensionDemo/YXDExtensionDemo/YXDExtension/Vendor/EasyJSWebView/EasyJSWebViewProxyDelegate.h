//
//  EasyJSWebViewDelegate.h
//  EasyJS
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasyJSWebViewProxyDelegate : NSObject<UIWebViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *javascriptInterfaces;
@property (nonatomic, strong) id<UIWebViewDelegate> realDelegate;

- (void)addJavascriptInterfaces:(NSObject *)interface WithName:(NSString *)name;

@end
