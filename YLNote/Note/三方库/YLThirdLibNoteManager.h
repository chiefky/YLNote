//
//  YLThirdLibNoteManager.h
//  YLNote
//
//  Created by tangh on 2021/1/21.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLThirdLibNoteManager : NSObject
+ (nonnull instancetype)sharedManager;
+ (NSDictionary *)allNotes;


@end

NS_ASSUME_NONNULL_END
