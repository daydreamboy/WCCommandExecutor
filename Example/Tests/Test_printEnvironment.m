//
//  Test_printEnvironment.m
//  WCCommandExecutor
//
//  Created by wesley chen on 3/14/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+Addition.h"
#import "WCCommandExecutor.h"

@interface Test_printEnvironment : XCTestCase

@end

@implementation Test_printEnvironment

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_printEnvironmentWithCompletion {
    [self runTestWithAsyncBlock:^{
        [WCCommandExecutor printEnvironmentWithCompletion:^(int status, NSString *output) {
            [self asyncBlockCompletedWithBlock:^{
                NSLog(@"%@", output);
            }];
        }];
    }];
}

- (void)test_currentEnvironment {
    NSLog(@"%@", [WCCommandExecutor currentEnvironment]);
}

@end
