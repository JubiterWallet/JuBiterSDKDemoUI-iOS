//
//  JUBPinAlertView.m
//  JuBiterSDKDemo
//
//  Created by zhangchuan on 2020/6/30.
//  Copyright © 2020 JuBiter. All rights reserved.
//

#define inputPinTextFieldTag 100
#define oldPinTextFieldTag 200
#define n1wPinTextFieldTag 300

#import "JUBPinAlertView.h"
#import "Tools.h"


@interface JUBPinAlertView()<UITextFieldDelegate>
@property (nonatomic, weak) UIAlertAction *okAction;
@property (nonatomic, weak) UITextField *inputPinTextField;
@property (nonatomic, weak) UITextField *oldPinTextField;
@property (nonatomic, weak) UITextField *n1wPinTextField;
@end


@implementation JUBPinAlertView


#pragma mark - 输入pin码
+ (JUBPinAlertView *)showInputPinAlert:(JUBInputPinCallBack)inputPinCallBack {
    
    __block JUBPinAlertView *pinAlertView;
    
    [Tools doUIActionInMainThread:^{
        
        pinAlertView = [[JUBPinAlertView alloc] init];
        
        [pinAlertView showInputPinAlert:inputPinCallBack fingerprintsCallBack:nil];
    }];
    
    return pinAlertView;
    
}


+ (JUBPinAlertView *)showInputPinAlert:(JUBInputPinCallBack)inputPinCallBack
     fingerprintsCallBack:(JUBFingerprintsCallBack)fingerprintsCallBack {
    
    __block JUBPinAlertView *pinAlertView;
    
    [Tools doUIActionInMainThread:^{
        
        pinAlertView = [[JUBPinAlertView alloc] init];
        
        [pinAlertView showInputPinAlert:inputPinCallBack fingerprintsCallBack:fingerprintsCallBack];
    }];
    
    return pinAlertView;
    
}


- (void)showInputPinAlert:(JUBInputPinCallBack)inputPinCallBack
     fingerprintsCallBack:(JUBFingerprintsCallBack)fingerprintsCallBack {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please enter PIN"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            inputPinCallBack(NULL);
        });
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        // Solve the problem that the log cannot be updated in time because the operation is stuck in the main thread
//        inputPinCallBack(self.inputPinTextField.text);
        NSString *inputPin = self.inputPinTextField.text;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            inputPinCallBack(inputPin);
        });
    }];
    
    self.okAction = okAction;
    
    okAction.enabled = NO;
    
    [alertController addAction:okAction];
    
    [alertController addAction:cancelAction];
    
    if (fingerprintsCallBack) {
        
        UIAlertAction *fingerprintsAction = [UIAlertAction actionWithTitle:@"Switch to fingerprint"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                fingerprintsCallBack();
                
            });
            
        }];
        
        [alertController addAction:fingerprintsAction];
    }
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"Please enter PIN";
        
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        [textField addTarget:self
                      action:@selector(changedInputPinTextField:)
            forControlEvents:UIControlEventEditingChanged];
        
        self.inputPinTextField = textField;
        
        self.inputPinTextField.delegate = self;
    }];
    
    //延迟执行，等待键盘类型被设置
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[self getCurrentVC] presentViewController:alertController
          animated:YES
        completion:nil];
        
    });
    
}


#pragma mark - 修改pin码
+ (JUBPinAlertView *)showChangePinAlert:(JUBChangePinCallBack)changePinCallBack {
    
    __block JUBPinAlertView *pinAlertView;
    
    [Tools doUIActionInMainThread:^{
        
        pinAlertView = [[JUBPinAlertView alloc] init];
        
        [pinAlertView showChangePinAlert:changePinCallBack];
    }];
    
    return pinAlertView;
    
}


- (void)showChangePinAlert:(JUBChangePinCallBack)changePinCallBack {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Modify PIN"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *oldPin = self.oldPinTextField.text;
        
        NSString *newPin = self.n1wPinTextField.text;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            changePinCallBack(oldPin, newPin);
        });
        
    }];
    
    self.okAction = okAction;
    
    [alertController addAction:okAction];
    
    [alertController addAction:cancelAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"Please enter old PIN";
        
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        [textField addTarget:self
                      action:@selector(changedOldPinTextField:)
            forControlEvents:UIControlEventEditingChanged];
        
        self.oldPinTextField = textField;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"Please enter new PIN";
        
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        [textField addTarget:self
                      action:@selector(changedN1wPinTextField:)
            forControlEvents:UIControlEventEditingChanged];
        
        self.n1wPinTextField = textField;
    }];
    
    //延迟执行，等待键盘类型被设置
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[self getCurrentVC] presentViewController:alertController
          animated:YES
        completion:nil];
        
    });
    
}


#pragma mark - textField代理
- (void)changedInputPinTextField:(UITextField *)textField {
    
    NSLog(@"textField12 = %@", textField.text);
    
    if (textField.text.length > 0) {
        self.okAction.enabled = YES;
    }
    else {
        self.okAction.enabled = NO;
    }
}


- (void)changedOldPinTextField:(UITextField *)textField {
    
    if (self.n1wPinTextField.text.length > 0
//        &&         textField.text.length > 0
        ) {
        self.okAction.enabled = YES;
    }
    else {
        self.okAction.enabled = NO;
    }
}


- (void)changedN1wPinTextField:(UITextField *)textField {

    if (textField.text.length > 0
//        && self.oldPinTextField.text.length > 0
        ) {
        self.okAction.enabled = YES;
    }
    else {
        self.okAction.enabled = NO;
    }
}

#pragma mark - getter setter
- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    
    _secureTextEntry = secureTextEntry;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.inputPinTextField.secureTextEntry = secureTextEntry;
        
        self.oldPinTextField.secureTextEntry = secureTextEntry;
        
        self.n1wPinTextField.secureTextEntry = secureTextEntry;
        
    });
        
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    
    _keyboardType = keyboardType;
        
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.inputPinTextField.keyboardType = keyboardType;
        
        self.oldPinTextField.keyboardType = keyboardType;
        
        self.n1wPinTextField.keyboardType = keyboardType;
        
    });
    
}

#pragma mark - 获取当前控制器
- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    // 放在报警告代码的前面,其中`XXXXX`代表的就是第二部步查找的警告类型
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        // 放在报警告代码的后面
    #pragma clang diagnostic push
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *temp in windows) {
            if (temp.windowLevel == UIWindowLevelNormal) {
                window = temp;
                break;
            }
        }
    }
    
    //取当前展示的控制器
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    
    //如果为UITabBarController：取选中控制器
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    
    //如果为UINavigationController：取可视控制器
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    
    return result;
}

@end
