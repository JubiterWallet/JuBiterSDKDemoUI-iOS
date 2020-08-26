//
//  JUBInputAlert.h
//  JuBiterSDKDemo
//
//  Created by zhangchuan on 2020/6/30.
//  Copyright © 2020 JuBiter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^JUBInputCallBack)(NSString * _Nullable content);


@interface JUBInputAlert : NSObject

/// Pop up the input box
/// @param inputPinCallBack the block after clicking ok
+ (JUBInputAlert *)showInputPinAlert:(JUBInputCallBack)inputPinCallBack;

/// The title of the pop-up box
@property (nonatomic, copy) NSString *title;

/// The details below the title of the pop-up box
@property (nonatomic, copy) NSString *message;

/// The prompt copy of the input box
@property (nonatomic, copy) NSString *placeholder;

/// The length of the input in the input box
@property (nonatomic, assign) NSInteger limitLength;

@end

NS_ASSUME_NONNULL_END
