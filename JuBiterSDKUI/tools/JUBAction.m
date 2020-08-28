//
//  JUBAction.m
//  JuBiterSDKUI
//
//  Created by zhangchuan on 2020/8/27.
//  Copyright © 2020 JuBiter. All rights reserved.
//

#import "JUBAction.h"

@interface JUBAction()

@property (nonatomic, assign) BOOL isDone;

@end

@implementation JUBAction

+ (JUBAction *)action {
    
    JUBAction *action = [[JUBAction alloc] init];
    
    action.isDone = NO;
    
    return action;
    
}

- (void)await {
    while (!self.isDone) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)doAction {
    self.isDone = YES;
}

@end
