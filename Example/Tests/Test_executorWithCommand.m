//
//  Test_executorWithCommand.m
//  WCCommandExecutor
//
//  Created by wesley chen on 17/3/23.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+Addition.h"
#import "WCCommandExecutor.h"


@interface Test_executorWithCommand : XCTestCase

@end

@implementation Test_executorWithCommand

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_startWithCompletion_ls {
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"ls"];
        exe.workingDirectory = @"/";
        
        [exe startWithCompletion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_startWithCompletion_ls_l_a_h {
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"ls"];
        exe.workingDirectory = @"/";
        exe.arguments = @[@"-l", @"-a", @"-h"];
        
        [exe startWithCompletion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_startWithCompletion_cat {
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"cat"];
        exe.workingDirectory = @"/etc";
        exe.arguments = @[@"passwd"];
        
        [exe startWithCompletion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_startWithCompletion_pwd {
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"pwd"];
        exe.workingDirectory = @"/etc";
        
        [exe startWithCompletion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_startWithCompletion_pwd_with_tilde_path {
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"pwd"];
        exe.workingDirectory = @"~";
        
        [exe startWithCompletion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_startWithSyncCompletion_ls_lah {
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"ls"];
        exe.workingDirectory = @"/";
        exe.arguments = @[@"-lah"];
        
        NSLog(@"Starting...");
        [exe startWithSyncCompletion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
        NSLog(@"Done");
    }];
}

- (void)test_startWithReadingHandler_cat_passwd {
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"cat"];
        exe.workingDirectory = @"/etc";
        exe.arguments = @[@"passwd"];
        
        static NSUInteger count = 0;
        [exe startWithReadingHandler:^(NSString *chunck) {
            NSLog(@"%@", chunck);
            NSLog(@"count: %lu", ++count);
        } completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
            
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_startWithReadingHandler_cat_hosts {
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"cat"];
        exe.workingDirectory = @"/etc";
        exe.arguments = @[@"hosts"];
        
        static NSUInteger count = 0;
        [exe startWithReadingHandler:^(NSString *chunck) {
            NSLog(@"%@", chunck);
            NSLog(@"count: %lu", ++count);
        } completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_startWithReadingHandler_cat_small_file {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"short" ofType:@"txt"];
    XCTAssertNotNil(path);
    
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"cat"];
        exe.arguments = @[path];
        
        static NSUInteger count = 0;
        [exe startWithReadingHandler:^(NSString *chunck) {
            NSLog(@"%@", chunck);
            NSLog(@"count: %lu", ++count);
        } completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_startWithReadingHandler_cat_large_file {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"long" ofType:@"txt"];
    XCTAssertNotNil(path);
    
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"cat"];
        exe.arguments = @[path];
        
        static NSUInteger count = 0;
        [exe startWithReadingHandler:^(NSString *chunck) {
            NSLog(@"%@", chunck);
            NSLog(@"count: %lu", ++count);
        } completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 0);
            }];
        }];
    }];
}

- (void)test_startWithReadingHandler_which_nonexist {
    [self runTestWithAsyncBlock:^{
        WCCommandExecutor *exe = [WCCommandExecutor executorWithCommand:@"which"];
        exe.arguments = @[@"nonexist"];
        
        static NSUInteger count = 0;
        [exe startWithReadingHandler:^(NSString *chunck) {
            NSLog(@"%@", chunck);
            NSLog(@"count: %lu", ++count);
        } completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
                
                XCTAssert(status == 1);
            }];
        }];
    }];
}

@end
