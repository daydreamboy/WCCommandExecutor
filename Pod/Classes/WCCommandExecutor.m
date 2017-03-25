//
//  WCCommandExecutor.m
//  WCCommandExecutor
//
//  Created by wesley chen on 2/24/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "WCCommandExecutor.h"

typedef NS_ENUM(NSUInteger, WCCommandType) {
    WCCommandTypeShellCmd,
    WCCommandTypeExecutable,
    WCCommandTypeScriptCmd,
};

@interface WCCommandExecutor ()
@property (nonatomic, copy, readwrite) NSString *cmd;
@property (nonatomic, assign) WCCommandType cmdType;
@property (nonatomic, copy, readwrite) NSString *scriptPath;

@property (nonatomic, strong) NSTask *task;
@property (nonatomic, strong) NSPipe *pipe;
@property (nonatomic, copy) void (^completion)(int status, NSString *output);
@property (nonatomic, copy) void (^consoleReadingHandler)(NSString *output);
@end

@implementation WCCommandExecutor

#pragma mark - Public Methods

+ (instancetype)executorWithCommand:(NSString *)cmd {
    return [[WCCommandExecutor alloc] initWithCmd:cmd cmdType:WCCommandTypeShellCmd scriptPath:nil];
}

+ (instancetype)executorWithExecutable:(NSString *)path {
    return [[WCCommandExecutor alloc] initWithCmd:path cmdType:WCCommandTypeExecutable scriptPath:nil];
}

+ (instancetype)executorWithScriptCommand:(NSString *)cmd scriptPath:(NSString *)scriptPath {
    return [[WCCommandExecutor alloc] initWithCmd:cmd cmdType:WCCommandTypeScriptCmd scriptPath:scriptPath];
}

- (void)startWithCompletion:(void (^)(int status, NSString *output))completion {
    [self startWithReadingHandler:nil async:YES completion:completion];
}

- (void)startWithReadingHandler:(void (^)(NSString *chunck))readingHandler completion:(void (^)(int status, NSString *output))completion {
    [self startWithReadingHandler:readingHandler async:YES completion:completion];
}

- (void)startWithSyncCompletion:(void (^)(int status, NSString *output))completion {
    [self startWithReadingHandler:nil async:NO completion:completion];
}

#pragma mark > Convenient Methods

+ (void)runCommand:(NSString *)cmd
         arguments:(NSArray<NSString *> *)arguments
        completion:(void (^)(int status, NSString *output))completion {
    WCCommandExecutor *exe = [[WCCommandExecutor alloc] initWithCmd:cmd cmdType:WCCommandTypeShellCmd scriptPath:nil];
    [exe runWithCommand:cmd arguments:arguments workingDirectory:nil async:YES readingHandler:nil completion:completion];
}


+ (void)runExecutable:(NSString *)path
            arguments:(NSArray<NSString *> *)arguments
           completion:(void (^)(int status, NSString *output))completion {
    WCCommandExecutor *exe = [[WCCommandExecutor alloc] initWithCmd:path cmdType:WCCommandTypeExecutable scriptPath:nil];
    [exe runWithExecutable:path arguments:arguments workingDirectory:nil async:YES readingHandler:nil completion:completion];
}

+ (void)runScriptCommand:(NSString *)cmd
              scriptPath:(NSString *)path
               arguments:(NSArray<NSString *> *)arguments
              completion:(void (^)(int status, NSString *output))completion {
    WCCommandExecutor *exe = [[WCCommandExecutor alloc] initWithCmd:path cmdType:WCCommandTypeScriptCmd scriptPath:nil];
    [exe runWithScriptCommand:cmd scriptPath:path arguments:arguments workingDirectory:nil async:YES readingHandler:nil completion:completion];
}

+ (void)runScriptWithPath:(NSString *)path
                arguments:(NSArray<NSString *> *)arguments
               completion:(void (^)(int status, NSString *output))completion {
    
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        if (isDir) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"expected a file, but it's a directory" userInfo:nil];
        }
    }
    else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"path is not exist, %@", path] userInfo:nil];
    }
    
    NSString *cmd = nil;
    NSString *ext = [[path pathExtension] lowercaseString];
    NSString *scriptCmd = [self currentShell];
    
    NSData *startData = [@"#!" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *endData = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger numberOfBytes = 128;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [fileHandle readDataOfLength:numberOfBytes];
    if (data) {
        NSRange startRange = [data rangeOfData:startData options:NSDataSearchAnchored range:NSMakeRange(0, data.length)];
        NSRange endRange = [data rangeOfData:endData options:kNilOptions range:NSMakeRange(0, data.length)];
        
        if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
            NSData *subData = [data subdataWithRange:NSMakeRange(startRange.length, endRange.location - startRange.length)];
            cmd = [[NSString alloc] initWithData:subData encoding:NSUTF8StringEncoding];
            
            if ([cmd rangeOfString:@"/usr/bin/env" options:NSAnchoredSearch].location != NSNotFound) {
                
                NSMutableArray *parts = [[cmd componentsSeparatedByString:@" "] mutableCopy];
                [parts removeObject:@""];
                NSString *lastPart = [[parts lastObject] lowercaseString];
                if (lastPart.length) {
                    if ([lastPart isEqualToString:@"bash"]) {
                        // Note: it's bash but use currentShell
                        ext = @"sh";
                    }
                    else if ([lastPart isEqualToString:@"ruby"]) {
                        ext = @"rb";
                    }
                    else if ([lastPart isEqualToString:@"python"]) {
                        ext = @"py";
                    }
                }
                
                // go to decision by extension
                cmd = nil;
            }
        }
    }
    
    if (cmd.length) {
        WCCommandExecutor *exe = [[WCCommandExecutor alloc] initWithCmd:cmd cmdType:WCCommandTypeScriptCmd scriptPath:nil];
        [exe runWithScriptCommand:cmd scriptPath:path arguments:arguments workingDirectory:nil async:YES readingHandler:nil completion:completion];
    }
    else if (ext.length) {
        if ([ext isEqualToString:@"sh"]) {
            // use currentShell
        }
        else if ([ext isEqualToString:@"rb"]) {
            scriptCmd = @"/usr/bin/ruby";
        }
        else if ([ext isEqualToString:@"py"]) {
            scriptCmd = @"/usr/bin/python";
        }
        else {
            // use currentShell
        }
        
        WCCommandExecutor *exe = [[WCCommandExecutor alloc] initWithCmd:scriptCmd cmdType:WCCommandTypeScriptCmd scriptPath:nil];
        [exe runWithScriptCommand:scriptCmd scriptPath:path arguments:arguments workingDirectory:nil async:YES readingHandler:nil completion:completion];
    }
    else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"file must has an extenstion or its content is starting by #!" userInfo:nil];
    }
}

#pragma mark - Private Methods

- (void)dealloc {
    self.task = nil;
    self.pipe = nil;
}

#pragma mark > Designated Methods (init/run)

- (instancetype)initWithCmd:(NSString *)cmd
                    cmdType:(WCCommandType)type
                 scriptPath:(NSString *)scriptPath {
    self = [super init];
    if (self) {
        NSCAssert(cmd != nil, @"cmd must NOT be nil");
        
        self.cmd = cmd;
        self.cmdType = type;
        self.scriptPath = scriptPath;
        self.pipe = [NSPipe new];
        self.task = [NSTask new];
        
        // relate pipe to task
        self.task.standardOutput = self.pipe;
        self.task.standardError = self.pipe;
    }
    return self;
}

- (void)startWithReadingHandler:(void (^)(NSString *chunck))readingHandler async:(BOOL)isAsync completion:(void (^)(int status, NSString *output))completion {
    switch (self.cmdType) {
        case WCCommandTypeShellCmd:
            [self runWithCommand:self.cmd arguments:self.arguments workingDirectory:self.workingDirectory async:isAsync readingHandler:readingHandler completion:completion];
            break;
        case WCCommandTypeExecutable:
            [self runWithExecutable:self.cmd arguments:self.arguments workingDirectory:self.workingDirectory async:isAsync readingHandler:readingHandler completion:completion];
            break;
        case WCCommandTypeScriptCmd:
            [self runWithScriptCommand:self.cmd scriptPath:self.scriptPath arguments:self.arguments workingDirectory:self.workingDirectory async:isAsync readingHandler:readingHandler completion:completion];
            break;
    }
}

- (void)runWithLaunchPath:(NSString *)launchPath
                arguments:(NSArray<NSString *> *)arguments
         workingDirectory:(NSString *)workingDirectory
                    async:(BOOL)isAsync
           readingHandler:(void (^)(NSString *chunck))readingHandler
               completion:(void (^)(int status, NSString *output))completion {
    
    _task.launchPath = launchPath;
    if (arguments.count) {
        _task.arguments = arguments;
    }
    if (workingDirectory.length) {
        _task.currentDirectoryPath = workingDirectory;
    }
    
    if (isAsync) {
        if (readingHandler == nil) {
            // only completion
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [_task launch];
                [_task waitUntilExit];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData *data = [_pipe.fileHandleForReading readDataToEndOfFile];
                    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    int status = _task.terminationStatus;
                    !completion ?: completion(status, [output copy]);
                });
                
            });
        }
        else {
            // with chunck
            __block NSMutableString *outputM = [NSMutableString string];
            [_pipe.fileHandleForReading waitForDataInBackgroundAndNotify];
            
            // @see http://stackoverflow.com/questions/22362314/cocoa-wait-for-finish-executions
            [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:_pipe.fileHandleForReading queue:nil usingBlock:^(NSNotification *notification) {
                
                NSData *chunck = _pipe.fileHandleForReading.availableData;
                if (chunck.length == 0) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !completion ?: completion(_task.terminationStatus, [outputM copy]);
                    });
                }
                else {
                    NSString *part = [[NSString alloc] initWithData:chunck encoding:NSUTF8StringEncoding];
                    if (part.length) {
                        [outputM appendString:part];
                        
                        [_pipe.fileHandleForReading waitForDataInBackgroundAndNotify];
                        
                        readingHandler(part);
                    }
                    else {
                        // Note: NSData -> NSString error
                        dispatch_async(dispatch_get_main_queue(), ^{
                            !completion ?: completion(-1, [outputM copy]);
                        });
                    }
                }
            }];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [_task launch];
                [_task waitUntilExit];
            });
        }
    }
    else {
        [_task launch];
        [_task waitUntilExit];
        NSData *data = [_pipe.fileHandleForReading readDataToEndOfFile];
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        int status = _task.terminationStatus;
        !completion ?: completion(status, [output copy]);
    }
}

#pragma mark > Dispatch Methods

- (void)runWithCommand:(NSString *)cmd
             arguments:(NSArray<NSString *> *)arguments
      workingDirectory:(NSString *)workingDirectory
                 async:(BOOL)isAsync
        readingHandler:(void (^)(NSString *chunck))readingHandler
            completion:(void (^)(int status, NSString *output))completion {
    
    NSMutableArray<NSString *> *argumentsM = [NSMutableArray arrayWithArray:@[@"-c"]];
    if (arguments) {
        NSString *command = [NSString stringWithFormat:@"%@ %@", cmd, [arguments componentsJoinedByString:@" "]];
        [argumentsM addObject:command];
    }
    else {
        [argumentsM addObject:cmd];
    }
    
    [self runWithLaunchPath:[self.class currentShell] arguments:argumentsM workingDirectory:workingDirectory async:isAsync readingHandler:readingHandler completion:completion];
}

- (void)runWithExecutable:(NSString *)path
                arguments:(NSArray<NSString *> *)arguments
         workingDirectory:(NSString *)workingDirectory
                    async:(BOOL)isAsync
           readingHandler:(void (^)(NSString *chunck))readingHandler
               completion:(void (^)(int status, NSString *output))completion {
    
    [self runWithLaunchPath:path arguments:arguments workingDirectory:workingDirectory async:isAsync readingHandler:readingHandler completion:completion];
}

- (void)runWithScriptCommand:(NSString *)cmd
                  scriptPath:(NSString *)path
                   arguments:(NSArray<NSString *> *)arguments
            workingDirectory:(NSString *)workingDirectory
                       async:(BOOL)isAsync
              readingHandler:(void (^)(NSString *chunck))readingHandler
                  completion:(void (^)(int status, NSString *output))completion {
    
    NSCAssert(cmd != nil, @"cmd must NOT be nil");
    NSCAssert(path != nil, @"path must NOT be nil");
    
    if ([cmd rangeOfString:@"ruby" options:NSBackwardsSearch | NSAnchoredSearch].location != NSNotFound) {
        NSMutableArray<NSString *> *argumentsM = [NSMutableArray arrayWithArray:@[@"LANG=zh_CN.UTF-8", cmd, path]];
        if (arguments) {
            [argumentsM addObjectsFromArray:arguments];
        }
        
        [self runWithLaunchPath:@"/usr/bin/env" arguments:argumentsM workingDirectory:workingDirectory async:isAsync readingHandler:readingHandler completion:completion];
    }
    else {
        NSMutableArray<NSString *> *argumentsM = [NSMutableArray arrayWithArray:@[path]];
        if (arguments) {
            [argumentsM addObjectsFromArray:arguments];
        }
        
        [self runWithLaunchPath:cmd arguments:argumentsM workingDirectory:workingDirectory async:isAsync readingHandler:readingHandler completion:completion];
    }
}

#pragma mark > Utility Methods (Debug, Test)

+ (NSString *)currentShell {
    static NSString *sShell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        char * shell = getenv("SHELL");
        sShell = (shell == NULL ? @"/bin/bash" : [NSString stringWithUTF8String:shell]);
    });
    return sShell;
}

+ (void)printEnvironmentWithCompletion:(void (^)(int status, NSString *output))completion {
    [self runCommand:@"env" arguments:nil completion:completion];
}

+ (NSString *)currentEnvironment {
    __block NSString *env = nil;
    WCCommandExecutor *exe = [[WCCommandExecutor alloc] initWithCmd:@"env" cmdType:WCCommandTypeShellCmd scriptPath:nil];
    [exe runWithCommand:@"env" arguments:nil workingDirectory:nil async:NO readingHandler:nil completion:^(int status, NSString *output) {
        env = [output copy];
    }];
    
    return env;
}

@end
