//
//  Common.h
//  JPush IM
//
//  Created by Apple on 14/12/29.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#ifndef JPush_IM_Common_h
#define JPush_IM_Common_h

#import <CocoaLumberjack/CocoaLumberjack.h>


#define TICK      NSDate *startTime = [NSDate date]
#define TOCK(action) DDLogDebug(@"%@ - TimeInSeconds - %f", action, -[startTime timeIntervalSinceNow])




/**
  DDLogError 错误：真的出错了，逻辑不正常
  DDLogWarn  警告：不是预期的情况，但也基本正常，不会导致逻辑问题
  DDLogInfo  信息：比较重要的信息，重要的方法入口
  DDLogDebug 调试：一般调试日志输出
  DDLogVerbose 过度：也用于调试，但输出时会过度，比如循环展示列表时输出其部分信息。
               默认 DEBUG 模式时也不输出 Verbose 日志，有需要临时修改下面的定义打开这个日志信息。
*/
#ifdef DEBUG
  static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
  static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif


#endif



