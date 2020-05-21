//
//  UCSLogFileHelper.m
//  UCS
//
//  Created by hanmc on 2018/3/9.
//  Copyright © 2018年 All rights reserved.
//

#import "HLogFileHelper.h"
#import "HZipArchive.h"
#import "HCustomLogFileManager.h"

@interface HLogFileHelper()

@end;

@implementation HLogFileHelper
+ (void)startLoggingWithDebug{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

+ (void)startLogging{
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentDirectory stringByAppendingPathComponent:@"log"];
    
    NSLog(@"logpath: %@\n",logPath);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH.mm.ss"];
    NSDate *curDate = [NSDate date];
    NSString *locationString=[formatter stringFromDate:curDate];

    NSString *fileName = [NSString stringWithFormat:@"ios_%@.log", locationString];
//    NSString *logFilePath = [logPath stringByAppendingPathComponent:fileName];
    
    HCustomLogFileManager *logFileManager = [[HCustomLogFileManager alloc] initWithLogsDirectory:logPath fileName:fileName];
    DDFileLogger * fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    //    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.maximumFileSize = 1024 * 1024 * 10; // 10M
    [DDLog addLogger:fileLogger];

    
    /// 删除日期超过2天的日志
    NSDate *twoDaysAgoDate = [NSDate dateWithTimeInterval:-48*60*60 sinceDate:curDate]; //两天前
    NSFileManager *fileManager = [NSFileManager defaultManager];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *subPaths = [fileManager subpathsAtPath:logPath];// 关键是subpathsAtPath方法
        for(NSString *subPath in subPaths){
            NSString *fullPath = [logPath stringByAppendingPathComponent:subPath];
            BOOL isDir = NO;
            if(![fileManager fileExistsAtPath:fullPath isDirectory:&isDir]){
                continue;
            }
            if (isDir) {
                continue;
            }
            NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            id motifyDate = [fileInfo objectForKey:NSFileModificationDate];//获取前一个文件修改时间
            if ([motifyDate compare:twoDaysAgoDate] == NSOrderedAscending) {
                [fileManager removeItemAtPath:fullPath error:nil];
            }
        }
    });
}

+ (void)zipLogFiles:(void(^)(NSString *fileName, NSString *filePath))block{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *logPath = [documentDirectory stringByAppendingPathComponent:@"log"];
        NSString *backPath = [documentDirectory stringByAppendingPathComponent:@"log_back"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH.mm.ss"];
        NSString *locationString=[formatter stringFromDate: [NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"log_%@.zip", locationString];
        NSString *zipPath = [documentDirectory stringByAppendingPathComponent:fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *erro = nil;
        [fileManager removeItemAtPath:backPath error:&erro];
        BOOL b = [fileManager copyItemAtPath:logPath toPath:backPath error:&erro];
        if (b) {
            HZipArchive * zipArchive = [[HZipArchive alloc] init];
            [zipArchive CreateZipFile2:zipPath];
            NSArray *subPaths = [fileManager subpathsAtPath:backPath];// 关键是subpathsAtPath方法
            for(NSString *subPath in subPaths){
                NSString *fullPath = [logPath stringByAppendingPathComponent:subPath];
                BOOL isDir = NO;
                if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir){
                    [zipArchive addFileToZip:fullPath newname:subPath];
                }
            }
            [zipArchive CloseZipFile2];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(fileName, zipPath);
            });
            [fileManager removeItemAtPath:backPath error:&erro];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil, nil);
            });
        }
        
    });
}

+ (void)zipLogFilesToLibray:(void(^)(NSString *fileName, NSString *filePath))block{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *logPath = [documentDirectory stringByAppendingPathComponent:@"log"];
        NSString *backPath = [documentDirectory stringByAppendingPathComponent:@"log_back"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH.mm.ss"];
        NSString *locationString=[formatter stringFromDate: [NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"log_%@.zip", locationString];
        
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        NSString *zipPath = [libraryPath stringByAppendingPathComponent:fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *erro = nil;
        [fileManager removeItemAtPath:backPath error:&erro];
        BOOL b = [fileManager copyItemAtPath:logPath toPath:backPath error:&erro];
        if (b) {
            HZipArchive * zipArchive = [[HZipArchive alloc] init];
            [zipArchive CreateZipFile2:zipPath];
            NSArray *subPaths = [fileManager subpathsAtPath:backPath];// 关键是subpathsAtPath方法
            for(NSString *subPath in subPaths){
                NSString *fullPath = [logPath stringByAppendingPathComponent:subPath];
                BOOL isDir = NO;
                if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir){
                    [zipArchive addFileToZip:fullPath newname:subPath];
                }
            }
            [zipArchive CloseZipFile2];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(fileName, zipPath);
            });
            [fileManager removeItemAtPath:backPath error:&erro];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil, nil);
            });
        }
        
    });
}

@end
