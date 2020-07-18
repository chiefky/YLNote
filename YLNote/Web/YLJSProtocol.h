//
//  YLJSProtocol.h
//  TestDemo
//
//  Created by tangh on 2020/7/8.
//  Copyright © 2020 tangh. All rights reserved.
//
#import <JavaScriptCore/JavaScriptCore.h>
#ifndef YLJSProtocol_h
#define YLJSProtocol_h


@protocol YLJSProtocol <JSExport>

@property (nonatomic, copy) NSDictionary *data;

- (NSString *)whatYouName;

@end

#endif /* YLJSProtocol_h */
