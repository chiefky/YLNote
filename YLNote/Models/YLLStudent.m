//
//  YLLStudent.m
//  YLNote
//
//  Created by tangh on 2021/1/12.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLLStudent.h"

@interface YLLStudent ()

@end

@implementation YLLStudent
@synthesize studentId = schoolId,name = ssName;
@dynamic studentTel;


- (void)setStudentId:(NSString *)studentId {
    if (![schoolId isEqualToString: studentId]) {
        schoolId = studentId;
    }
}

- (NSString *)studentId {
    return schoolId;
}

- (void)setName:(NSString *)name {
    if (![ssName isEqualToString:name]) {
        ssName = name;
    }
}
- (NSString *)name {
    return ssName;
}

- (NSString *)bonus {
    if (self.bomusBlock) {
       return self.bomusBlock(28, 0.96, 26000);
    }
    return @"";
}

@end
