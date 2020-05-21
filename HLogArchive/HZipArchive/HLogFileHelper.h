//
//  UCSLogFileHelper.h
//  UCS
//
//  Created by hanmc on 2018/3/9.
//  Copyright © 2018年 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLogFileHelper : NSObject
+ (void)startLogging;
+ (void)startLoggingWithDebug;
+ (void)zipLogFiles:(void(^)(NSString *fileName, NSString *filePath))block;
+ (void)zipLogFilesToLibray:(void(^)(NSString *fileName, NSString *filePath))block;
@end
