//
//  UCSCustomLogFileManager.h
//  UCS-IM-Personnal
//
//  Created by huangzh on 2019/1/22.
//  Copyright © 2019年 simba.pro. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCustomLogFileManager : DDLogFileManagerDefault

- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory fileName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
