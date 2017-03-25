//
//  Tests.m
//  Tests
//
//  Created by wesley chen on 2/24/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+Addition.h"
#import "WCCommandExecutor.h"

@interface Test_runCommand : XCTestCase

@end

@implementation Test_runCommand

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_currentShell {
    NSString *str = [WCCommandExecutor currentShell];
    NSLog(@"shell: %@", str);
}

- (void)test_run_command_python_h {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runCommand:@"python" arguments:@[@"-h"] completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_command_pwd {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runCommand:@"pwd" arguments:nil completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_command_ls {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runCommand:@"ls" arguments:nil completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_command_ls_l {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runCommand:@"ls" arguments:@[@"-l"] completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_command_ls_l_h {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runCommand:@"ls" arguments:@[@"-l", @"-h"] completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_command_echo {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runCommand:@"echo" arguments:@[@"Hello", @"World!"] completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_run_command_env {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor runCommand:@"env" arguments:nil completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

@end
