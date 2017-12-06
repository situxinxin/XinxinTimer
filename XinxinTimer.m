//
//  XinxinTimer.m
//  hong5
//
//  Created by 新新 on 2017/12/6.
//  Copyright © 2017年 com.hong5.ios. All rights reserved.
//

#import "XinxinTimer.h"

@implementation XinxinTimer
{
    dispatch_source_t           _timer;
    UITableView         *       _tableView;
}

- (instancetype)initWithTableView:(UITableView*)tableView dataArray:(NSArray*)dataArray {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _dataArray = [NSMutableArray arrayWithArray:dataArray];
        [self destoryTimer];
        [self countDownWithTabelView:_tableView dataArray:_dataArray];
    }
    return self;
}



#pragma mark -  传入数据 开始倒计时
- (void)countDownWithTabelView:(UITableView*)tableView dataArray:(NSArray*)dataArray {
    
    _tableView = tableView;
    _dataArray= [NSMutableArray arrayWithArray:dataArray];
    
    if (_timer==nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (dataArray.count > 0) {
                    NSArray  *cells = tableView.visibleCells; //取出屏幕可见ceLl
                    for (UITableViewCell * cell in cells) {
                        NSString* tempEndTime;
                        if ([dataArray[0] isKindOfClass:[NSArray class]]) {
                            NSInteger section = cell.tag / 1000;
                            NSInteger row = cell.tag % 1000;
                            tempEndTime = dataArray[section][row];
                        }else {
                            tempEndTime = dataArray[cell.tag];
                        }
                        for (UIView * labText in cell.contentView.subviews) {
                            if (labText.tag == 13141516) {
                                UILabel * textLabel = (UILabel *)labText;
                                NSInteger endTime = tempEndTime.longLongValue; //+ _less;
                                textLabel.text = [XinxinTimer getNowTimeWithString:endTime];
                            }
                        }
                    }
                }
            
            });
        });
        dispatch_resume(_timer); // 启动定时器
    }
    
}

#pragma mark -  滑动过快的时候不会闪
- (NSString *)countDownWithIndexPath:(NSIndexPath *)indexPath{
    NSString* tempEndTime;
    if ([_dataArray[0] isKindOfClass:[NSArray class]]) {
        tempEndTime = _dataArray[indexPath.section][indexPath.row];
    }else {
        tempEndTime = _dataArray[indexPath.row];
    }
    NSInteger endTime = tempEndTime.longLongValue;
    
    return [XinxinTimer getNowTimeWithString:endTime];
    
}
#pragma mark -  传入结束时间 | 计算与当前时间的差值
+ (NSString *)getNowTimeWithString:(NSInteger )aTimeString{
    
    NSDate * sjDate = [NSDate date];   //手机时间
    NSInteger sjInteger = [sjDate timeIntervalSince1970];  // 手机当前时间戳
    
    NSTimeInterval timeInterval = aTimeString - sjInteger;
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    
    dayStr = [NSString stringWithFormat:@"%d",days];                     //天
    hoursStr = [NSString stringWithFormat:@"%d",hours];                  //小时
    if(minutes<10)                                                       //分钟
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    if(seconds < 10)                                                     //秒
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"支付时间已过！";
    }
    return [NSString stringWithFormat:@"剩余兑换时间: %@:%@:%@", hoursStr,minutesStr,secondsStr];
    
}

/**
 *  主动销毁定时器
 */
-(void)destoryTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
}



@end
