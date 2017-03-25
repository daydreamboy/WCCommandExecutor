//
//  Test_runScript.m
//  WCCommandExecutor
//
//  Created by wesley chen on 3/14/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+Addition.h"
#import "WCCommandExecutor.h"

@interface Test_runScript : XCTestCase

@end

@implementation Test_runScript

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_run_ruby_script {
    [self runTestWithAsyncBlock:^{
        
        NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"get_all_targets" ofType:@".rb"];
        NSString *xcodeprojPath = [[[@(__FILE__) stringByDeletingLastPathComponent] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"MacAppTest.xcodeproj"];
        
        [WCCommandExecutor runScriptCommand:@"/usr/bin/ruby" scriptPath:scriptPath arguments:@[xcodeprojPath] completion:^(int status, NSString *output) {
            
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
            }];
        }];
    }];
}

- (void)test_run_shell_script {
    [self runTestWithAsyncBlock:^{
        
        NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"check_env" ofType:@".sh"];
        NSLog(@"%@", scriptPath);
        
        NSString *function = @"check_brew";
        
        [WCCommandExecutor runScriptCommand:@"/bin/bash" scriptPath:scriptPath arguments:@[function] completion:^(int status, NSString *output) {
            
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
            }];
        }];
    }];
}

- (void)test_run_script_of_shell {
    [self runTestWithAsyncBlock:^{
        
        NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"check_env" ofType:@".sh"];
        NSLog(@"%@", scriptPath);
        
        NSString *function = @"check_xcodeproj";
        
        [WCCommandExecutor runScriptWithPath:scriptPath arguments:@[function] completion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
            }];
        }];
    }];
}

- (void)test_run_script_of_ruby {
    [self runTestWithAsyncBlock:^{
        
        NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"get_all_targets" ofType:@".rb"];
        NSString *xcodeprojPath = [[[@(__FILE__) stringByDeletingLastPathComponent] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"MacAppTest.xcodeproj"];
        
        [WCCommandExecutor runScriptWithPath:scriptPath arguments:@[xcodeprojPath] completion:^(int status, NSString *output) {
            
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
            }];
        }];
    }];
}

- (void)test_run_script_of_python {
    [self runTestWithAsyncBlock:^{
        
        NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"hello_python" ofType:@"py"];
        
        [WCCommandExecutor runScriptWithPath:scriptPath arguments:nil completion:^(int status, NSString *output) {
            
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"status: %d", status);
                NSLog(@"output: %@", output);
            }];
        }];
    }];
}

@end
