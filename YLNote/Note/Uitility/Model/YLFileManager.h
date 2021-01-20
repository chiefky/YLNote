//
//  YLFileManager.h
//  YLNote
//
//  Created by tangh on 2021/1/11.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLFileManager : NSObject

+ (NSDictionary *)readLocalFileWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
