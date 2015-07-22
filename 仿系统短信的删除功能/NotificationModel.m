//
//  NotificationModel.m
//  随便试试
//
//  Created by 张丽 on 15/7/14.
//  Copyright (c) 2015年 张丽. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if ([super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

+ (instancetype)notificationWithDic:(NSDictionary *)dic
{
    return [[NotificationModel alloc] initWithDic:dic];
}

#pragma mark - 防止崩溃
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@", key);
}

@end
