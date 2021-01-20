//
//  YLFileManager.m
//  YLNote
//
//  Created by tangh on 2021/1/11.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLFileManager.h"

@implementation YLFileManager
// 读取本地JSON文件
+ (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end
