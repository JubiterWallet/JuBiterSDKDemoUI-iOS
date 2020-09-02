//
//  JUBOrderHistoryManager.m
//  JuBiterSDKUI
//
//  Created by zhangchuan on 2020/9/2.
//  Copyright © 2020 JuBiter. All rights reserved.
//

#import "JUBOrderHistoryManager.h"

@interface JUBOrderHistoryManager()

@property (nonatomic, strong) NSArray *historys;

@end

@implementation JUBOrderHistoryManager

static JUBOrderHistoryManager *_instance;

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _instance = [[self alloc] init];
        
        _instance.historys = [_instance findHistoryFromDoc];
    });

    return _instance;
}

- (NSArray<NSString *> *)findHistoryFromDoc {
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    NSString *path = [docPath stringByAppendingPathComponent:@"numbers.plist"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *historys = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:data error:nil];
    NSLog(@"numbers = %@", historys);
    
    return historys;
}

#pragma mark - 对外api

- (void)saveHistory:(NSArray<NSString *> *)historys {
    
    //沙盒根目录
    NSString *docPath = NSHomeDirectory();
    //完整的文件路径
    NSString *path = [docPath stringByAppendingPathComponent:@"Documents/numbers.plist"];
    
    //将数据归档到path文件路径里面
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:historys requiringSecureCoding:NO error:nil];
    BOOL success = [data writeToFile:path atomically:NO];
    
    if (success) {
        NSLog(@"文件归档成功");
        self.historys = historys;
        
    } else {
        NSLog(@"文件归档失败");
    }
    
}

- (NSMutableArray<NSString *> *)findHistory {
    return [self.historys mutableCopy];
}

@end
