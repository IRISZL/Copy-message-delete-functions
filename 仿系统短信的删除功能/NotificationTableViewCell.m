//
//  NotificationTableViewCell.m
//  随便试试
//
//  Created by 张丽 on 15/7/14.
//  Copyright (c) 2015年 张丽. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "NotificationModel.h"

#import "Masonry.h"
#import "file.h"

@interface NotificationTableViewCell()

// 标题
@property (nonatomic, strong) UILabel *titleLabel;

// 时间
@property (nonatomic, strong) UILabel *timeLabel;

// 详情内容
@property (nonatomic, strong) UILabel *commentLabel;


@end


static NSInteger tagValue = 101;

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentLabel];
    
    [self setContrain];
    
    
}


// 动态布局
- (void)setContrain
{
    // 分割线
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xf3f3f4);
    [self.contentView addSubview:segment];
    
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 1));
    }];
    
    
    // 详情label
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.bottom.equalTo(segment.mas_bottom).with.offset(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(11);
    }];
    
    // 标题的label
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).with.offset(15);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 2 - 15);
        make.bottom.equalTo(self.commentLabel.mas_top).with.offset(-11);
        make.top.equalTo(self.contentView).with.offset(15);
    }];
    
    // 时间的label
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.titleLabel.mas_right).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.bottom.equalTo(self.commentLabel.mas_top).with.offset(-11);
        
    }];
    
}

#pragma mark - 懒加载
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _titleLabel.textColor = UIColorFromRGB(0x353d3f);
        
    }
    
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = UIColorFromRGB(0xbfc1c1);
    }
    
    return _timeLabel;

}

- (UILabel *)commentLabel
{
    if (_commentLabel == nil) {
        
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.numberOfLines = 1;
        _commentLabel.font = [UIFont systemFontOfSize:13];
        
    }
    
    return _commentLabel;

}

#pragma mark - 私有方法
- (void)setNotiModel:(NotificationModel *)notiModel
{
    _notiModel = notiModel;
    self.titleLabel.text = notiModel.title;
    self.timeLabel.text = notiModel.time;
    self.commentLabel.text = notiModel.comment;
    
}

+ (NSString *)cellIdenx
{
    return @"notificationCell";
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    if ([super init]) {
        
        self = [tableView dequeueReusableCellWithIdentifier:[NotificationTableViewCell cellIdenx]];
        
        if (self == nil) {
            
            self = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NotificationTableViewCell cellIdenx]];
        }
    }
    
    return self;
}

-(void)editing:(BOOL)editing animated:(BOOL)animated{
    if (editing) {
        
        if (self.editingStyle == (UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert)) {
            
            if (![self viewWithTag:tagValue]) {
              
                
            }
        }
        
    } else {
        
        UIView *editDotView = [self viewWithTag:tagValue];
        if (editDotView) {
            
            [editDotView removeFromSuperview];
        }
        
        
    }

}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self editing:editing animated:animated];

}


@end
