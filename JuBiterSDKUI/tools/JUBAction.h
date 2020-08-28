//
//  JUBAction.h
//  JuBiterSDKUI
//
//  Created by zhangchuan on 2020/8/27.
//  Copyright © 2020 JuBiter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUBAction : NSObject


/// <#Description#>
+ (JUBAction *)action;

- (void)await;

- (void)doAction;

@end

NS_ASSUME_NONNULL_END
