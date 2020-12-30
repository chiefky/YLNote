//
//  YLUser.h
//  YLNote
//
//  Created by tangh on 2020/7/31.
//  Copyright © 2020 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    GenderMale,
    GenderFemale
} Gender;

NS_ASSUME_NONNULL_BEGIN

@interface YLUser : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
@property (assign, nonatomic) unsigned int age;
@property (copy, nonatomic) NSString *height;
@property (strong, nonatomic) NSNumber *money;
@property (assign, nonatomic) Gender sex;
@property (assign, nonatomic, getter=isGay) BOOL gay;

@end

NS_ASSUME_NONNULL_END
