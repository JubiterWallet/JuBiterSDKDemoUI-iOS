//
//  JUBInputAlert.m
//  JuBiterSDKDemo
//
//  Created by zhangchuan on 2020/6/30.
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
@property (nonatomic, weak) UITextField *oldPinTextField;
@property (nonatomic, weak) UITextField *n1wPinTextField;
@end


@implementation JUBInputAlert


#pragma mark - 输入pin码
+ (JUBInputAlert *)showInputPinAlert:(JUBInputCallBack)inputPinCallBack {
    
    __block JUBInputAlert *alertView;
    
    [Tools doUIActionInMainThread:^{
        
        alertView = [[JUBInputAlert alloc] init];
        
        [alertView showInputPinAlert:inputPinCallBack];
        
    }];
        
    return alertView;
    
}

- (void)showInputPinAlert:(JUBInputCallBack)inputPinCallBack {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please enter PIN" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
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

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"Please enter PIN";
        
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



@end
