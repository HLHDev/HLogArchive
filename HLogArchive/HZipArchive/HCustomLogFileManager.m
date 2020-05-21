//
//  UCSCustomLogFileManager.m
//  UCS-IM-Personnal
//
//  Created by huangzh on 2019/1/22.
//  Copyright © 2019年 simba.pro. All rights reserved.
//

#import "HCustomLogFileManager.h"

@interface HCustomLogFileManager ()

@property (nonatomic, copy) NSString *fileName;

@end

@implementation HCustomLogFileManager

- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory
                             fileName:(NSString *)name
{
    self = [super initWithLogsDirectory:logsDirectory];
    if (self) {
        self.fileName = name;
    }
    return self;
}

#pragma mark - Override methods

- (NSString *)newLogFileName
{
    return [NSString stringWithFormat:@"%@", self.fileName];
}

- (BOOL)isLogFile:(NSString *)fileName
{
    return [fileName isEqualToString:self.fileName];
}

@end
