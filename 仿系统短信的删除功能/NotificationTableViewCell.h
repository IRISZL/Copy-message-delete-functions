//
//  NotificationTableViewCell.h
//  随便试试
//
//  Created by 张丽 on 15/7/14.
//  Copyright (c) 2015年 张丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotificationModel;

@interface NotificationTableViewCell : UITableViewCell

@property (nonatomic, strong) NotificationModel *notiModel;



- (instancetype)initWithTableView:(UITableView *)tableView;




@end


