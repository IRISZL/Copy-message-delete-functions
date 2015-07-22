//
//  NotificationModel.h
//  随便试试
//
//  Created by 张丽 on 15/7/14.
//  Copyright (c) 2015年 张丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSString *comment;


- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)notificationWithDic:(NSDictionary *)dic;

@end
