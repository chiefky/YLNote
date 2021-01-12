//
//  YLLStudent.h
//  YLNote
//
//  Created by tangh on 2021/1/12.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLPerson.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *_Nullable(^SummationBonus)(NSUInteger attendanceDays,double performance,double salary);

@interface YLLStudent : YLPerson

@property (nonatomic, copy) NSString *studentId;
@property (nonatomic, copy) NSString *studentTel;
@property (nonatomic, copy) NSString *bonus;

@property (nonatomic, copy) SummationBonus bomusBlock;


@end

NS_ASSUME_NONNULL_END
