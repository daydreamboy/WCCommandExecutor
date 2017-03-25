//
//  ViewController.m
//  MacAppTest
//
//  Created by wesley chen on 17/3/22.
//  Copyright © 2017年 daydreamboy. All rights reserved.
//

#import "ViewController.h"
#import "WCCommandExecutor.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test_run_executable_fauxpas_help];
}

- (void)test_run_executable_fauxpas_help {
    NSLog(@"%@", [WCCommandExecutor currentEnvironment]);
    [WCCommandExecutor runExecutable:@"/usr/local/bin/fauxpas" arguments:nil completion:^(int status, NSString *output) {
        NSLog(@"status: %d", status);
        NSLog(@"output: %@", output);
    }];
}


@end
