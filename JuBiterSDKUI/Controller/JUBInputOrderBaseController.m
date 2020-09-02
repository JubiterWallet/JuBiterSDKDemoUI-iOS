//
//  JUBInputOrderBaseController.m
//  JuBiterSDKDemo
//
//  Created by 张川 on 2020/4/28.
//  Copyright © 2020 JuBiter. All rights reserved.

#import "JUBInputOrderBaseController.h"

@interface JUBInputOrderBaseController ()<UITextViewDelegate>

@property (nonatomic, weak, readonly) JUBMainView *transmissionView;
@property (nonatomic, weak) UIButton *disConnectBLEButton;
@property (nonatomic, weak) UIButton *scanBLEButton;

@property (nonatomic, weak) UITextView *apduTextView;

@end


@implementation JUBInputOrderBaseController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
            
    [self baseInitData];

    [self baseInitUI];
            
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

}


- (void)baseInitData {

}


#pragma mark - 初始化UI
- (void)baseInitUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"JuBiter SDK Demo";
        
    [self initOrderUI];
    
    __weak JUBInputOrderBaseController *weakSelf = self;
    
    JUBMainView *view = [JUBMainView coinTestMainViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.apduTextView.frame) + 10, KScreenWidth, KScreenHeight - KStatusBarHeight - KNavigationBarHeight - CGRectGetHeight(self.apduTextView.frame) - 10) buttonArray:self.buttonArray];
        
    [view setTransmissionViewCallBackBlock:^(NSInteger index) {
        
        [weakSelf gotoDetailAccordingCoinSeriesType:index];
        
    }];
    
    _transmissionView = view;
    
    [self.view addSubview:view];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.apduContent = textView.text;
        
    NSRange selection = textView.selectedRange;
    if (selection.location + selection.length == [textView.text length]) {
        CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.start];
        CGFloat overflow = caretRect.origin.y + caretRect.size.height - (textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top);
        
        if (overflow > 0.0f) {
            CGPoint offset = textView.contentOffset;
            offset.y += overflow + 7.0f;
            [UIView animateWithDuration:0.2f animations:^{
            [textView setContentOffset:offset];
            }];
        }
    } else {
        [textView scrollRangeToVisible:selection];
    }
}

//初始化界面上部的指令UI
- (void)initOrderUI {
            
    NSString *apduTextViewText = self.apduTextView ? self.apduTextView.text : @"";
    
    CGFloat edge = 20;
        
    {
        UITextView *apduTextView = [[UITextView alloc] initWithFrame:CGRectMake(edge, 10, KScreenWidth - 2 * edge, 140)];
        
        apduTextView.text = apduTextViewText;
        
        apduTextView.font = [UIFont systemFontOfSize:15];
        
        apduTextView.delegate = self;
        
        apduTextView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 15.0, 0.0);
                                
        [self.view addSubview:apduTextView];
        
        apduTextView.layer.borderColor = [[Tools defaultTools] colorWithHexString:@"#e0e0e0"].CGColor;
        
        apduTextView.layer.borderWidth = 1;

        self.apduTextView = apduTextView;
                
    }

}

#pragma mark - 页面按钮点击回调方法，子类如果想接受回调可以重写此类方法
- (void)gotoDetailAccordingCoinSeriesType:(NSInteger)coinSeriesType {
    
}


- (void)selectTransmitTypeIndex:(NSInteger)index {
    
}

#pragma mark - setter和getter
- (void)setButtonArray:(NSArray<JUBButtonModel *> *)buttonArray {
    
    _buttonArray = buttonArray;
    
    if (self.transmissionView) {
        self.transmissionView.buttonArray = buttonArray;
    }
    
}


- (void)setShowBLEButton:(BOOL)showBLEButton {
        
    if (showBLEButton) {
        self.scanBLEButton.hidden = YES;
        self.disConnectBLEButton.hidden = YES;
    }
    else {
        self.scanBLEButton.hidden = NO;
        self.disConnectBLEButton.hidden = NO;
    }
}

- (void)setApduContent:(NSString *)apduContent {
    
    _apduContent = apduContent;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.apduTextView.text = apduContent;
        
    });
    
}

#pragma mark - 外部调用方法
- (void)addMsgData:(NSString *)msgData {
    
    [self.transmissionView addMsgData:msgData];
}


- (void)setNAVBtn {
    
    UIButton *scanBLEButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [scanBLEButton setTitle:@"Scan BLE" forState:UIControlStateNormal];
    
    scanBLEButton.hidden = YES;
    
    [scanBLEButton setTitleColor:[[Tools defaultTools] colorWithHexString:@"#00ccff"] forState:UIControlStateNormal];
    
    [scanBLEButton addTarget:self action:@selector(scanBLEButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.scanBLEButton = scanBLEButton;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:scanBLEButton];
    
    leftItem.imageInsets = UIEdgeInsetsMake(0, 15,0, 0);//设置向左偏移
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *disConnectBLEButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [disConnectBLEButton setTitle:@"Off BLE" forState:UIControlStateNormal];
    
    disConnectBLEButton.hidden = YES;
    
    [disConnectBLEButton setTitleColor:[[Tools defaultTools] colorWithHexString:@"#00ccff"] forState:UIControlStateNormal];
    
    [disConnectBLEButton addTarget:self action:@selector(disConnectBLEButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.disConnectBLEButton = disConnectBLEButton;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:disConnectBLEButton];
    
    rightItem.imageInsets = UIEdgeInsetsMake(0, -15,0, 0);//设置向左偏移
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)scanBLEButtonClick {
    
    NSLog(@"scanBLEButtonClick");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self scanBLEButtonClicked];
    });
    
}

- (void)scanBLEButtonClicked {
    
    NSLog(@"scanBLEButtonClicked");
    
}

- (void)disConnectBLEButtonClick {
    
    NSLog(@"disConnectBLEButtonClick");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self disConnectBLEButtonClicked];
    });
    
}

- (void)disConnectBLEButtonClicked {
    
    NSLog(@"disConnectBLEButtonClicked");
    
}

@end
