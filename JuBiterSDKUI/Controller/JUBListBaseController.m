//
//  JUBListBaseController.m
//  JuBiterSDKDemo
//
//  Created by 张川 on 2020/4/28.
//  Copyright © 2020 JuBiter. All rights reserved.
//  首页的基类，用户应该继承本类，去实现自己的业务逻辑

#import "JUBListBaseController.h"
#import "JUBDetailBaseController.h"

@interface JUBListBaseController ()

@property (nonatomic, weak, readonly) JUBMainView *transmissionView;
@property (nonatomic, weak) UIButton *rightNAVButton;
@property (nonatomic, weak) UIButton *leftNAVButton;

@end


@implementation JUBListBaseController

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
    
    NSString *indexStr = [[NSUserDefaults standardUserDefaults] objectForKey:selectedTransmitTypeIndexStr];
    
    if (!indexStr) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:selectedTransmitTypeIndexStr];
    }
}


#pragma mark - 初始化UI
- (void)baseInitUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"JuBiter SDK Demo";
    
    [self setNAVBtn];
    
    UISegmentedControl *TransmitSegment;
    
    {
        NSArray *array = [self getTransmitTypeArray];
        
        TransmitSegment = [[UISegmentedControl alloc] initWithItems:array];
        
        [TransmitSegment setFrame:CGRectMake(15, 20, KScreenWidth - 2 * 15, 40)];
        
        NSString *indexStr = [[NSUserDefaults standardUserDefaults] objectForKey:selectedTransmitTypeIndexStr];
        
        NSLog(@"segmentAction indexStr = %@", indexStr);
        
        if (indexStr.length > 0) {
            [TransmitSegment setSelectedSegmentIndex:[indexStr integerValue]];
        }
        else {
            [TransmitSegment setSelectedSegmentIndex:0];
        }
        
        [TransmitSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        
        TransmitSegment.tintColor = [[Tools defaultTools] colorWithHexString:@"#00ccff"];
        
        [self.view addSubview:TransmitSegment];
    }
    
    __weak JUBListBaseController *weakSelf = self;
    
    NSLog(@"self.view.frame = %f", CGRectGetHeight(self.view.frame));
    // 放在报警告代码的前面,其中`XXXXX`代表的就是第二部步查找的警告类型

    JUBMainView *view = [JUBMainView coinTestMainViewWithFrame:CGRectMake(0, CGRectGetMaxY(TransmitSegment.frame), KScreenWidth, KScreenHeight - KStatusBarHeight - KNavigationBarHeight - CGRectGetMaxY(TransmitSegment.frame)) buttonArray:self.buttonArray];
    
    [view setTransmissionViewCallBackBlock:^(NSInteger index) {
        NSLog(@"coinSeriesType = %ld", (long)index);
        
        [weakSelf doActionAccordingOption:index];
    }];
    
    _transmissionView = view;
    
    [self.view addSubview:view];
}

#pragma mark - 页面内部按钮回调方法
- (void)segmentAction:(UISegmentedControl *)seg {
    
    NSInteger index = [seg selectedSegmentIndex];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)index] forKey:selectedTransmitTypeIndexStr];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self selectTransmitTypeIndex:index];
    
    NSLog(@"segmentAction index = %ld", (long)index);
}

- (void)leftNAVButtonClick {
    
    NSLog(@"leftNAVButtonClick");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self leftNAVButtonClicked];
    });
    
}

- (void)rightNAVButtonClick {
    
    NSLog(@"rightNAVButtonClick");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self rightNAVButtonClicked];
    });
    
}

#pragma mark - 懒加载
- (NSInteger)selectedTransmitTypeIndex {
    
    NSString *indexStr = [[NSUserDefaults standardUserDefaults] objectForKey:selectedTransmitTypeIndexStr];
    
    return [indexStr integerValue];
}


#pragma mark - 获取界面所需要的数据，子类如果想设置数据，则可以重写此类方法
- (NSArray *)getTransmitTypeArray {
    
    return @[@"1", @"2", @"3"];
}


- (NSArray *)getButtonTitleArray {
    
    return @[@"1", @"2", @"3", @"4", @"5", @"6"];
}


#pragma mark - 页面按钮点击回调方法，子类如果想接受回调可以重写此类方法
- (void)doActionAccordingOption:(NSInteger)coinSeriesType {
    
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

- (void)setLeftNAVButtonTitle:(NSString *)leftNAVButtonTitle {
    
    _leftNAVButtonTitle = leftNAVButtonTitle;
    
    [self.leftNAVButton setTitle:leftNAVButtonTitle forState:UIControlStateNormal];
    
}

- (void)setRightNAVButtonTitle:(NSString *)rightNAVButtonTitle {
    
    _rightNAVButtonTitle = rightNAVButtonTitle;
    
    [self.rightNAVButton setTitle:rightNAVButtonTitle forState:UIControlStateNormal];
    
}

#pragma mark - 外部调用方法
- (void)addMsgData:(NSString *)msgData {
    
    [self.transmissionView addMsgData:msgData];
}


- (void)setNAVBtn {
    
    UIButton *leftNAVButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [leftNAVButton setTitle:@"leftNAVButton" forState:UIControlStateNormal];
    
    leftNAVButton.hidden = YES;
    
    [leftNAVButton setTitleColor:[[Tools defaultTools] colorWithHexString:@"#00ccff"] forState:UIControlStateNormal];
    
    [leftNAVButton addTarget:self action:@selector(leftNAVButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftNAVButton = leftNAVButton;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftNAVButton];
    
    leftItem.imageInsets = UIEdgeInsetsMake(0, 15,0, 0);//设置向左偏移
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightNAVButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [rightNAVButton setTitle:@"rightNAVButton" forState:UIControlStateNormal];
    
    rightNAVButton.hidden = YES;
    
    [rightNAVButton setTitleColor:[[Tools defaultTools] colorWithHexString:@"#00ccff"] forState:UIControlStateNormal];
    
    [rightNAVButton addTarget:self action:@selector(rightNAVButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightNAVButton = rightNAVButton;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightNAVButton];
    
    rightItem.imageInsets = UIEdgeInsetsMake(0, -15,0, 0);//设置向左偏移
    
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)setShowBLEButton:(BOOL)showBLEButton {
    
    _showBLEButton = showBLEButton;
    
    if (showBLEButton) {
        self.rightNAVButton.hidden = NO;
        self.leftNAVButton.hidden = NO;
    }
    else {
        self.rightNAVButton.hidden = YES;
        self.leftNAVButton.hidden = YES;
    }
}

#pragma mark - 回调子类方法
- (void)leftNAVButtonClicked {
    
    NSLog(@"leftNAVButtonClicked");
    
}

- (void)rightNAVButtonClicked {
    
    NSLog(@"rightNAVButtonClicked");
    
}

@end
