//
//  JUBCustomInputAlert.m
//  JuBiterSDKDemo
//
//  Created by 张川 on 2020/5/12.
//  Copyright © 2020 JuBiter. All rights reserved.
//

#import "JUBCustomInputAlert.h"
#import "FTConstant.h"
#import "Tools.h"

@interface JUBCustomInputAlert()<UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, copy) JUBInputCallBackBlock inputCallBackBlock;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UILabel *errorMessageLabel;

@property (nonatomic, weak) UIButton *leftButton;

@property (nonatomic, weak) UIButton *rightButton;


@end

@implementation JUBCustomInputAlert

+ (JUBCustomInputAlert *)showCallBack:(JUBInputCallBackBlock)inputCallBackBlock {
        
    __block JUBCustomInputAlert *inputAlert;
    
    [Tools doUIActionInMainThread:^{
        inputAlert = [JUBCustomInputAlert creatSelf];
        
        inputAlert.inputCallBackBlock = inputCallBackBlock;
                
        UIView *whiteMainView = [inputAlert addMainView];
        
        [inputAlert addSubviewAboveSuperView:whiteMainView];
    }];
        
    return inputAlert;
    
}

+ (JUBCustomInputAlert *)creatSelf {
    
    JUBCustomInputAlert *inputAlert = [[JUBCustomInputAlert alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    inputAlert.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    [[UIApplication sharedApplication].keyWindow addSubview:inputAlert];
        
    return inputAlert;
    
}

- (UIView *)addMainView {
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 50, 250)];
    
    mainView.center = CGPointMake(KScreenWidth/2, KScreenHeight/3);
    
    mainView.backgroundColor = [UIColor whiteColor];
    
    mainView.layer.cornerRadius = 4;
    
    mainView.layer.masksToBounds = YES;
    
    [self addSubview:mainView];
    
    return mainView;
    
}

- (void)addSubviewAboveSuperView:(UIView *)mainView {
    
    UILabel *titleLabel = [self addTitleLabelAboveSuperView:mainView];
    
    self.titleLabel = titleLabel;
    
    UITextField *textField = [self addTextFieldAboveSuperView:mainView frame:CGRectMake(40, CGRectGetMaxY(titleLabel.frame) + 40, CGRectGetWidth(mainView.frame) - 2 * 40, 30)];
    
    self.textField = textField;
    
    UILabel *errorMessageLabel = [self addErrorMessageLabelAboveSuperView:mainView frame:CGRectMake(40, CGRectGetMaxY(textField.frame) + 5, CGRectGetWidth(mainView.frame) - 2 * 40, 30)];
    
    self.errorMessageLabel = errorMessageLabel;
    
    [self addCancelAndOkButtonAboveSuperView:mainView];
    
}

#pragma mark - 添加mainview上面的子视图

- (UILabel *)addTitleLabelAboveSuperView:(UIView *)mainView {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainView.frame), 50)];
    
    titleLabel.text = @"Please enter a title";
    
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.backgroundColor = [[Tools defaultTools] colorWithHexString:@"#00ccff"];
    
    [mainView addSubview:titleLabel];
    
    return titleLabel;
    
}

- (UITextField *)addTextFieldAboveSuperView:(UIView *)mainView frame:(CGRect)frame {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
                
    textField.placeholder = @"";
                
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    textField.layer.borderWidth = 1;
    
    [textField addTarget:self
              action:@selector(changedInputPinTextField:)
    forControlEvents:UIControlEventEditingChanged];
        
    //Wait to set the keyboard type
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField becomeFirstResponder];
    });
    
    [mainView addSubview:textField];
        
    return textField;
    
}

- (UILabel *)addErrorMessageLabelAboveSuperView:(UIView *)mainView frame:(CGRect)frame {
    
    UILabel *errorMessageLabel = [[UILabel alloc] initWithFrame:frame];
        
    errorMessageLabel.font = [UIFont systemFontOfSize:16];
    
    errorMessageLabel.textColor = [[Tools defaultTools] colorWithHexString:@"#888888"];
    
    errorMessageLabel.textAlignment = NSTextAlignmentCenter;
        
    [mainView addSubview:errorMessageLabel];
    
    return errorMessageLabel;
    
}

- (void)addCancelAndOkButtonAboveSuperView:(UIView *)mainView {
    
    CGFloat mainViewWidth = CGRectGetWidth(mainView.frame);
    
    CGFloat buttonWidth = 120;
    
    CGFloat buttonSpace = (mainViewWidth - 2 * buttonWidth)/3;

    CGFloat buttonHeight = 40;
    
    CGFloat buttonY = CGRectGetHeight(mainView.frame) - 20 - buttonHeight;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(mainViewWidth/2 - buttonSpace/2 - buttonWidth, buttonY, buttonWidth, buttonHeight)];
    
    self.leftButton = leftButton;
    
    [leftButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [leftButton setBackgroundColor:[[Tools defaultTools] colorWithHexString:@"#00ccff"]];
    
    leftButton.layer.cornerRadius = 4;
    
    leftButton.layer.masksToBounds = YES;
    
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [mainView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(mainViewWidth/2 + buttonSpace/2, buttonY, buttonWidth, buttonHeight)];
    
    self.rightButton = rightButton;
    
    [rightButton setTitle:@"COMPLETE" forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [rightButton setBackgroundColor:[[Tools defaultTools] colorWithHexString:@"#00ccff"]];
        
    rightButton.layer.cornerRadius = 4;
        
    rightButton.layer.masksToBounds = YES;
    
    [rightButton addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    
    [mainView addSubview:rightButton];
    
}

#pragma mark - textField代理
- (void)changedInputPinTextField:(UITextField *)textField {
    
    if (self.limitLength > 0 && textField.text.length > self.limitLength) {
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
    }
    
}

#pragma mark - action
- (void)cancel {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self removeFromSuperview];
        
    });
    
}

- (void)ok {
    
    NSString *content = self.textField.text;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.inputCallBackBlock(content, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
            
            
        }, ^(NSString * _Nonnull errorMessage) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.errorMessageLabel.text = errorMessage;
            });
            
        });
        
    });
    
}

#pragma mark - getter setter
- (void)setTitle:(NSString *)title {
    
    _title = [title copy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleLabel.text = title;
    });
    
}

- (void)setTextFieldPlaceholder:(NSString *)textFieldPlaceholder {
    
    _textFieldPlaceholder = [textFieldPlaceholder copy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textField.placeholder = _textFieldPlaceholder;
    });
    
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    
    _keyboardType = keyboardType;
    
    self.textField.keyboardType = keyboardType;
    
}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle {
    
    _leftButtonTitle = [leftButtonTitle copy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.leftButton setTitle:_leftButtonTitle forState:UIControlStateNormal];
        
    });
    
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle {
    
    _rightButtonTitle = [rightButtonTitle copy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.rightButton setTitle:_rightButtonTitle forState:UIControlStateNormal];
        
    });
    
}

@end
