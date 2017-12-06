//
//  XinxinTimer.h
//  hong5
//
//  Created by 新新 on 2017/12/6.
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XinxinTimer : NSObject


//初始化
- (instancetype)initWithTableView:(UITableView*)tableView dataArray:(NSArray*)dataArray;

///每秒走一次，回调block
- (void)countDownWithTabelView:(UITableView*)tableView dataArray:(NSArray*)dataArray;

/// 滑动过快的时候时间不会闪  (tableViewcell数据源方法里实现即可)
- (NSString *)countDownWithIndexPath:(NSIndexPath *)indexPath;

// 传入结束时间 | 计算与当前时间的差值
+ (NSString *)getNowTimeWithString:(NSInteger )aTimeString;

//销毁计时器
- (void)destoryTimer;


@property (nonatomic, strong) NSMutableArray      *dataArray;

@end
