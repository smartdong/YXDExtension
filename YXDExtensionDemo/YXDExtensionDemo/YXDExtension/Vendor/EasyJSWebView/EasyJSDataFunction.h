//
//  EasyJSDataFunction.h
//  EasyJSWebViewSample
//
//  Created by Alex Lau on 21/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import "EasyJSWebView.h"

@interface EasyJSDataFunction : NSObject

@property (nonatomic, copy) NSString *funcID;
@property (nonatomic, strong) EasyJSWebView *webView;
@property (nonatomic, assign) BOOL removeAfterExecute;

- (id)initWithWebView:(EasyJSWebView *)_webView;

- (NSString *)execute;
- (NSString *)executeWithParam:(NSString *)param;
- (NSString *)executeWithParams:(NSArray *)params;

@end