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


@end


@interface YLFileManager (NSBundle)


/// 读取本地JSON文件并转Dictionary对象
/// @param name 文件名（格式: .json）
+ (id)jsonParseWithLocalFileName:(NSString *)name;

/// 读取本地文件并转Data对象
/// @param name 文件名
/// @param type 文件类型
+ (NSData *)dataWithLocalFileName:(NSString *)name type:(NSString *)type;

@end

@interface YLFileManager (Sandbox)

+ (NSString *)sandboxHomePath;

+ (NSString *)sandboxDoucumentPath;

+ (NSString *)sandboxLibraryPath;

+ (NSString *)sandboxCachePath;

+ (NSString *)sandboxTmpPath;

+ (NSDictionary *)dictionaryWithLocalFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
