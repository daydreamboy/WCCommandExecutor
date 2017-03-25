//
//  Test_runExecutable.m
//  WCCommandExecutor
//
//  Created by wesley chen on 2/25/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+Addition.h"
#import "WCCommandExecutor.h"

@interface Test_runExecutable : XCTestCase

@end

@implementation Test_runExecutable

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_run_executable_python_h {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runExecutable:@"/usr/bin/python" arguments:@[@"-h"] completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_executable_python {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runExecutable:@"/usr/bin/python" arguments:nil completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_executable_pwd {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runExecutable:@"/bin/pwd" arguments:nil completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_executable_ls_l_a {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runExecutable:@"/bin/ls" arguments:@[@"-l", @"-a"] completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_executable_echo {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runExecutable:@"/bin/echo" arguments:@[@"Hello", @"World!"] completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_executable_xed {
    [self runTestWithAsyncBlock:^{
        NSString *filePath = @"/etc/hosts";
        
        [WCCommandExecutor runExecutable:@"/usr/bin/xed" arguments:@[@"-l", @"5", filePath] completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

@end
