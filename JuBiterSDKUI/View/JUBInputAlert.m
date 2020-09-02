//
//  JUBInputAlert.m
//  JuBiterSDKDemo
//
//  Created by zhangchuan on 2020/8/26.
//  Copyright © 2020 JuBiter. All rights reserved.
//

#define inputPinTextFieldTag 100
#define oldPinTextFieldTag 200
#define n1wPinTextFieldTag 300

#import "JUBInputAlert.h"
#import "Tools.h"


@interface JUBInputAlert()<UITextFieldDelegate>
@property (nonatomic, weak) UIAlertAction *okAction;
@property (nonatomic, weak) UITextField *inputPinTextField;
@property (nonatomic, weak) UIAlertController *alertController;
@end


@implementation JUBInputAlert


#pragma mark - 输入pin码
+ (JUBInputAlert *)showInputPinAlert:(JUBInputCallBack)inputResultCallBack {
    
    __block JUBInputAlert *alertView;
    
    [Tools doUIActionInMainThread:^{
        
        alertView = [[JUBInputAlert alloc] init];
        
        [alertView showInputPinAlert:inputResultCallBack];
        
    }];
        
    return alertView;
    
}

- (void)showInputPinAlert:(JUBInputCallBack)inputResultCallBack {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    self.alertController = alertController;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            inputResultCallBack(NULL);
        });
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        // Solve the problem that the log cannot be updated in time because the operation is stuck in the main thread
//        inputResultCallBack(self.inputPinTextField.text);
        NSString *inputPin = self.inputPinTextField.text;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            inputResultCallBack(inputPin);
        });
    }];
    
//    self.okAction = okAction;
    
//    okAction.enabled = NO;
    
    [alertController addAction:okAction];
    
    [alertController addAction:cancelAction];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"";
        
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        [textField addTarget:self
                      action:@selector(changedInputPinTextField:)
            forControlEvents:UIControlEventEditingChanged];
        
        self.inputPinTextField = textField;
        
        self.inputPinTextField.delegate = self;
    }];
    
    [[Tools getCurrentVC] presentViewController:alertController
                                      animated:YES
                                    completion:nil];
}

#pragma mark - textField代理
- (void)changedInputPinTextField:(UITextField *)textField {
    
    if (self.limitLength > 0 && textField.text.length > self.limitLength) {
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
    }
        
//    if (textField.text.length > 0) {
//        self.okAction.enabled = YES;
//    }
//    else {
//        self.okAction.enabled = NO;
//    }
}

#pragma mark - getter和setter
- (void)setTitle:(NSString *)title {
    
    _title = [title copy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alertController.title = [title copy];
    });
    
}

- (void)setMessage:(NSString *)message {
    
    _message = [message copy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alertController.message = [message copy];
    });
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = placeholder;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.inputPinTextField.placeholder = placeholder;
    });
    
}

@end
