//
//  WCCommandExecutor.h
//  WCCommandExecutor
//
//  Created by wesley chen on 2/24/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCCommandExecutor : NSObject

@property (nonatomic, copy, readonly) NSString *cmd;
@property (nonatomic, strong) NSArray<NSString *> *arguments;
@property (nonatomic, copy) NSString *workingDirectory; /**< the working directory. If nil, the working directory is current directory that places this executable */
@property (nonatomic, copy, readonly) NSString *scriptPath;

+ (instancetype)executorWithCommand:(NSString *)cmd;
+ (instancetype)executorWithExecutable:(NSString *)path;
+ (instancetype)executorWithScriptCommand:(NSString *)cmd scriptPath:(NSString *)scriptPath;

#pragma mark > Async Start
- (void)startWithCompletion:(void (^)(int status, NSString *output))completion;
- (void)startWithReadingHandler:(void (^)(NSString *chunck))readingHandler completion:(void (^)(int status, NSString *output))completion;

#pragma mark > Sync Start
- (void)startWithSyncCompletion:(void (^)(int status, NSString *output))completion;

#pragma mark - Convenient Methods

/**
 Run a command, e.g. `ls -l`, `pwd`

 @param cmd         the command string, e.g. @"ls"
 @param arguments   the array of arguments, e.g. @[@"-l"]
 @param completion  the callback when running is finished
 */
+ (void)runCommand:(NSString *)cmd
         arguments:(NSArray<NSString *> *)arguments
        completion:(void (^)(int status, NSString *output))completion;


/**
 Run an executable file, e.g. `/usr/bin/python`

 @param path        the path of executable
 @param arguments   the array of arguments
 @param completion  the callback when running is finished
 */
+ (void)runExecutable:(NSString *)path
            arguments:(NSArray<NSString *> *)arguments
           completion:(void (^)(int status, NSString *output))completion;


/**
 Run a script file, e.g. `/usr/bin/ruby <script file> <arguments>`

 @param cmd         the path of script executor
 @param path        the path of script
 @param arguments   the arguments of script
 @param completion  the callback when running is finished
 */
+ (void)runScriptCommand:(NSString *)cmd
              scriptPath:(NSString *)path
               arguments:(NSArray<NSString *> *)arguments
              completion:(void (^)(int status, NSString *output))completion;


/**
 Run a script file, e.g. `<script file> <arguments>`

 @param path        the path of script
 @param arguments   the arguments of script
 @param completion  the callback when running is finished
 
 @note the script should have an extension or its content started by #!
 */
+ (void)runScriptWithPath:(NSString *)path
                arguments:(NSArray<NSString *> *)arguments
               completion:(void (^)(int status, NSString *output))completion;

#pragma mark > Utility Methods (Debug, Test)
/**
 Get the path of current shell, e.g. @"/bin/zsh"
 
 @return the path of current shell
 */
+ (NSString *)currentShell;

+ (void)printEnvironmentWithCompletion:(void (^)(int status, NSString *output))completion;
+ (NSString *)currentEnvironment;

#pragma mark - Forbidden Methods

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
