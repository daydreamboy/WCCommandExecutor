//
//  ViewController.m
//  MacAppTest
//
//  Created by wesley chen on 17/3/22.
//  Copyright © 2017年 daydreamboy. All rights reserved.
//

#import "ViewController.h"
#import "WCCommandExecutor.h"

#define FAUXPAS_CMD @"/usr/local/bin/fauxpas"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test_run_executable_fauxpas_help];
//    [self test_run_executable_fauxpas_check];
    [self test_run_command_find];
}

- (void)test_run_executable_fauxpas_help {
    NSLog(@"%@", [WCCommandExecutor currentEnvironment]);
    [WCCommandExecutor runExecutable:FAUXPAS_CMD arguments:nil completion:^(int status, NSString *output) {
        NSLog(@"status: %d", status);
        NSLog(@"output: %@", output);
    }];
}

// fauxpas -t ONEPassportSDK check /Users/wesley/Projects/didiProjects/DiDi-NextOne/one-workspace/ONEPassportSDK/Example/Pods/Pods.xcodeproj -o xcode

- (void)test_run_executable_fauxpas_check {
    static NSUInteger count = 0;
    
    NSString *target = @"ONEPassportSDK";
    NSString *xcodeproj = @"/Users/wesley/Projects/didiProjects/DiDi-NextOne/one-workspace/ONEPassportSDK/Example/Pods/Pods.xcodeproj";
    
    WCCommandExecutor *exe = [WCCommandExecutor executorWithExecutable:FAUXPAS_CMD];
    exe.arguments = @[@"-t", target, @"check", xcodeproj, @"-o", @"xcode"];
    [exe startWithReadingHandler:^(NSString *chunck) {
        NSLog(@"count: %ld", ++count);
        NSLog(@"%@\n", chunck);
    } completion:^(int status, NSString *output) {
        NSLog(@"completion:\n");
        NSLog(@"%@\n", output);
    }];
}

- (void)test_run_executable_fauxpas_check2 {
    
    NSString *target = @"ONEPassportSDK";
    NSString *xcodeproj = @"/Users/wesley/Projects/didiProjects/DiDi-NextOne/one-workspace/ONEPassportSDK/Example/Pods/Pods.xcodeproj";
    
    WCCommandExecutor *exe = [WCCommandExecutor executorWithExecutable:FAUXPAS_CMD];
    exe.arguments = @[@"-t", target, @"check", xcodeproj, @"-o", @"xcode"];
    
    [exe startWithCompletion:^(int status, NSString *output) {
        NSLog(@"completion:\n");
        NSLog(@"%@\n", output);
    }];
}

- (void)test_run_command_find {
    // Use "\\" instead of "\"
    [WCCommandExecutor runCommand:@"find" arguments:@[@"/Users/wesley/Projects/github\\ projects/WCCommandExecutor/Example"] completion:^(int status, NSString *output) {
        NSLog(@"status: %d", status);
        NSLog(@"output: %@", output);
    }];
}

@end
