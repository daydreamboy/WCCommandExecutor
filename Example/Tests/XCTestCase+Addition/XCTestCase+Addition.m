//
//  XCTestCase+Addition.m
//  XCTestCase+Addition
//
//  Created by wesley chen on 15/11/3.
//  Copyright © 2015年 daydreamboy. All rights reserved.
//

#import "XCTestCase+Addition.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@implementation XCTestCase (Addition)

@dynamic semaphore;

#pragma mark - Setter & Getter

static const char * const SemaphoreObjectTagKey = "SemaphoreObjectTagKey";

/**
 *  @sa https://github.com/xslim/TKSenTestAsync/blob/master/SenTest%2BAsync.m
 */
- (void)setSemaphore:(dispatch_semaphore_t)semaphore {
    objc_setAssociatedObject(self, SemaphoreObjectTagKey, semaphore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_semaphore_t)semaphore {
    return objc_getAssociatedObject(self, SemaphoreObjectTagKey);
}

/**
 *  Run an asynchronous block
 *
 *  @param block the callback block
 *  @sa https://github.com/AFNetworking/AFNetworking/issues/466
 */
- (void)runTestWithAsyncBlock:(void (^)(void))block {
    self.semaphore = dispatch_semaphore_create(0);
    
    if (block) {
        block();
        
        while (dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_NOW)) {
            //NSLog(@"[Debug]: %@", [NSDate date]);
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        }
    }
}

/**
 *  Call this method in callback
 *
 *  @param block the business code in the callback block
 *  @sa https://github.com/AFNetworking/AFNetworking/issues/466
 */
- (void)asyncBlockCompletedWithBlock:(void (^)(void))block {
    if (block) {
//        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{
            block();
//        });
    }
    
//    dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{
        dispatch_semaphore_signal(self.semaphore);
//    });
}


@end
