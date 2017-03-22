//
//  XCTestCase+Addition.h
//  XCTestCase+Addition
//
//  Created by wesley chen on 15/11/3.
//  Copyright © 2015年 daydreamboy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (Addition)

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

- (void)runTestWithAsyncBlock:(void (^)(void))block;
- (void)asyncBlockCompletedWithBlock:(void (^)(void))block;

@end
