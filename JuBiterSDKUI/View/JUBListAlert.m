//
//  JUBListAlert.m
//  JuBiterSDKDemo
//
//  Created by zhangchuan on 2020/8/12.
//  Copyright © 2020 JuBiter. All rights reserved.
//

#import "JUBListAlert.h"
#import "FTConstant.h"
#import "Tools.h"
#import "JUBListCell.h"

@interface JUBListAlert()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) JUBSelectCellCallBackBlock selectCellCallBackBlock;

@property (nonatomic, strong) NSMutableArray<NSString *> *itemsArray;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UITableView *listTableView;

@property (nonatomic, weak) UIButton *closeButton;

@end

@implementation JUBListAlert

+ (JUBListAlert *)showCallBack:(JUBSelectCellCallBackBlock)selectCellCallBackBlock {
        
//    __block BOOL isDone = NO;
       
   __block JUBListAlert *listAlert;
    
    [Tools doUIActionInMainThread:^{
        listAlert = [JUBListAlert creatSelf];
        
        listAlert.selectCellCallBackBlock = selectCellCallBackBlock;
        
        UIView *whiteMainView = [listAlert addMainView];
        
        [listAlert addSubviewAboveSuperView:whiteMainView];
    }];
    
    return listAlert;
    
}

+ (JUBListAlert *)creatSelf {
    
    JUBListAlert *inPutAddressView = [[JUBListAlert alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    inPutAddressView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    [[UIApplication sharedApplication].keyWindow addSubview:inPutAddressView];
        
    return inPutAddressView;
    
}

- (UIView *)addMainView {
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 50, 300)];
    
    mainView.center = CGPointMake(KScreenWidth/2, KScreenHeight*2/5);
    
    mainView.backgroundColor = [UIColor whiteColor];
    
    mainView.layer.cornerRadius = 4;
    
    mainView.layer.masksToBounds = YES;
    
    [self addSubview:mainView];
        
    return mainView;
    
}

- (void)addSubviewAboveSuperView:(UIView *)mainView {
    
    self.titleLabel = [self addTitleLabelAboveSuperView:mainView];
        
    self.closeButton = [self addCloseButtonAboveSuperView:mainView];
    
    self.listTableView = [self addBLEListAboveSuperView:mainView];
        
}

- (void)setTitle:(NSString *)title {
    
    NSString *tempTitle = [title copy];
    
    _title = tempTitle;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleLabel.text = tempTitle;
    });
    
}

#pragma mark - 添加mainview上面的子视图

- (UILabel *)addTitleLabelAboveSuperView:(UIView *)mainView {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainView.frame), 50)];
    
    titleLabel.text = self.title ? self.title : @"请设置标题内容";
    
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.backgroundColor = [[Tools defaultTools] colorWithHexString:@"#00ccff"];
    
    [mainView addSubview:titleLabel];
    
    return titleLabel;
        
}

- (UITableView *)addBLEListAboveSuperView:(UIView *)mainView {
    
    UITableView *listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(mainView.frame), CGRectGetHeight(mainView.frame) - CGRectGetHeight(self.titleLabel.frame) - CGRectGetHeight(self.closeButton.frame)) style:UITableViewStylePlain];
    
    listTableView.showsVerticalScrollIndicator = NO;
    
    listTableView.delegate = self;
    
    listTableView.dataSource = self;
    
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [listTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenHeight, 64)]];
    
    listTableView.backgroundColor = [[Tools defaultTools] colorWithHexString:@"#ffffff"];
    
    self.listTableView = listTableView;
    
    [mainView addSubview:listTableView];
    
    return listTableView;
    
}

- (UIButton *)addCloseButtonAboveSuperView:(UIView *)mainView {
    
    CGFloat mainViewWidth = CGRectGetWidth(mainView.frame);
    
    CGFloat buttonWidth = mainViewWidth;
    
    CGFloat buttonHeight = 40;
    
    CGFloat buttonY = CGRectGetHeight(mainView.frame) - buttonHeight;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonY, buttonWidth, buttonHeight)];
    
    [closeButton setTitle:@"CLOSE" forState:UIControlStateNormal];
    
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [closeButton setBackgroundColor:[[Tools defaultTools] colorWithHexString:@"#00ccff"]];
    
    closeButton.layer.cornerRadius = 4;
    
    closeButton.layer.masksToBounds = YES;
    
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    [mainView addSubview:closeButton];
    
    return closeButton;
    
}

- (void)close {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.selectCellCallBackBlock(nil);
        
    });
    
    [self cancel];
    
}

- (void)cancel {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self removeFromSuperview];
        
    });
    
}

#pragma mark - 刷新tableview的方法

- (void)addItem:(NSString *)item {
        
    [self.itemsArray addObject:item];
    
    [self reloadTableView];
    
}

- (void)addItems:(NSArray<NSString *> *)items {
    
    [self.itemsArray addObjectsFromArray:items];
    
    [self reloadTableView];
    
}

- (void)removeItem:(NSString *)item {
        
    [self.itemsArray removeObject:item];
    
    [self reloadTableView];
    
}

- (void)removeAllItems {
        
    [self.itemsArray removeAllObjects];
    
    [self reloadTableView];
    
}

#pragma mark - tableview UITableViewDataSource delegate

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return _itemsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JUBListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[JUBListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.content = _itemsArray[indexPath.row];
    
    cell.textAlignment = self.textAlignment;
    
    return  cell;
}

#pragma mark - cell删除逻辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
 
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
 
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *deletedItem = self.itemsArray[indexPath.row];
                
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            if (self.deleteCellCallBackBlock) {
                self.deleteCellCallBackBlock(deletedItem);
            }
            
        });
        
        [self cancel];
        
    }
    
}
 
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.selectCellCallBackBlock(self.itemsArray[indexPath.row]);
        
    });
    
    [self cancel];
    
}

#pragma mark - 刷新tableview的方法

- (void)reloadTableView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.listTableView reloadData];
        
    });
    
}

#pragma mark - 懒加载

- (NSMutableArray *)itemsArray {
    
    if (!_itemsArray) {
        
        _itemsArray = [NSMutableArray array];
        
    }
    
    return _itemsArray;
    
}

#pragma mark - setter getter

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    
    _textAlignment = textAlignment;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.listTableView reloadData];
        
    });
    
}

@end
