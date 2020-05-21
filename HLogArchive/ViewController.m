//
//  ViewController.m
//  HLogArchive
//
//  Created by H&L on 2020/5/21.
//  Copyright © 2020 H&L. All rights reserved.
//

#import "ViewController.h"
#import "HZipArchive/LogConstants.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 * 1.info.plist里添加Application supports iTunes file sharing设置为YES
 * 2.手机接入电脑，打开ituns-文件共享-找到对应的APP，点击app，会出来log文件，点击保存至相应位置，就可以查看打印相关日志
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DDLogInfo(@"输入想要的日志");
}


@end
