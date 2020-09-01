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
@property (nonatomic, weak) UIButton *disConnectBLEButton;
@property (nonatomic, weak) UIButton *scanBLEButton;

@end


@implementation JUBListBaseController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
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
        
        TransmitSegment.tintColor = [UIColor whiteColor];
        
        [self.view addSubview:TransmitSegment];
    }
    
    __weak JUBListBaseController *weakSelf = self;
    
    JUBMainView *view = [JUBMainView coinTestMainViewWithFrame:CGRectMake(0, CGRectGetMaxY(TransmitSegment.frame), KScreenWidth, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(TransmitSegment.frame)) buttonArray:self.buttonArray];
    
    [view setTransmissionViewCallBackBlock:^(NSInteger index) {
        NSLog(@"coinSeriesType = %ld", (long)index);
        
        [weakSelf gotoDetailAccordingCoinSeriesType:index];
    }];
    
    _transmissionView = view;
    
    [self.view addSubview:view];
}


//- (NSArray *)getButtonModelArray {
//
//    NSArray *buttonTitleArray = [self getButtonTitleArray];
//
//    NSMutableArray *buttonModelArray = [NSMutableArray array];
//
//    for (NSString *title in buttonTitleArray) {
//
//        JUBButtonModel *model = [[JUBButtonModel alloc] init];
//
//        model.title = title;
//
//        [buttonModelArray addObject:model];
//    }
//
//    return buttonModelArray;
//}


#pragma mark - 页面内部按钮回调方法
- (void)segmentAction:(UISegmentedControl *)seg {
    
    NSInteger index = [seg selectedSegmentIndex];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)index] forKey:selectedTransmitTypeIndexStr];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self selectTransmitTypeIndex:index];
    
    NSLog(@"segmentAction index = %ld", (long)index);
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


- (void)setShowBLEButton:(BOOL)showBLEButton {
    
    _showBLEButton = showBLEButton;
    
    if (showBLEButton) {
        self.disConnectBLEButton.hidden = NO;
        self.scanBLEButton.hidden = NO;
    }
    else {
        self.disConnectBLEButton.hidden = YES;
        self.scanBLEButton.hidden = YES;
    }
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
