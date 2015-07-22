//
//  ViewController.m
//  仿系统短信的删除功能
//
//  Created by 张丽 on 15/7/17.
//  Copyright (c) 2015年 张丽. All rights reserved.
//

#import "ViewController.h"
#import "NotificationModel.h"
#import "NotificationTableViewCell.h"
#import "file.h"

static int viewTag = 101;

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL isEditing;

// 任务表
@property (nonatomic, strong) UITableView *notificationTableView;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) NSMutableArray *notiData;

// 建立一个装有全选和删除按钮的一个view
@property (nonatomic, strong) UIView *bottomView;

// 创建一个字典来接收
@property (nonatomic, strong) NSMutableDictionary *deletDic;

// 将button改成全局的
@property (nonatomic, strong) UIButton *editionButton;


// 设置一个用来判断是否有钩的那张图片
@property (nonatomic, strong) NSMutableArray *iconArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"通知";
    
    _isEditing = YES;
    
    [self.datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        NotificationModel *model = [NotificationModel notificationWithDic:obj];
        
        [self.notiData addObject:model];
    }];
    
    
    [self setUI];
    
    
}

- (void)setUI
{
    
    _editionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editionButton.frame = CGRectMake(0, 0, 40, 40);
    [_editionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_editionButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editionButton setTitleColor:UIColorFromRGB(0x353d3f) forState: UIControlStateNormal];
    [_editionButton addTarget:self action:@selector(editionRemove:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *edition = [[UIBarButtonItem alloc] initWithCustomView:_editionButton];
    
    self.navigationItem.rightBarButtonItem = edition;
    
    _deletDic = [NSMutableDictionary dictionary];
    
    [self.view addSubview:self.notificationTableView];
    [self.view addSubview:self.bottomView];
    
    
}


- (void)editionRemove:(UIButton *)button
{
    if ([button.titleLabel.text isEqual:@"编辑"]) {
        
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [self setAnimationEditing];
        [self.notificationTableView setEditing:YES animated:YES];
        
    } else if ([button.titleLabel.text isEqual:@"取消"]) {
        
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [self animationWithCancle];
        [_deletDic removeAllObjects];
        [self.notificationTableView setEditing:NO animated:YES];
        
    }
    
}

- (void)setAnimationEditing
{
    
    [UIView animateWithDuration:0.5f animations:^{
        
        CGRect notifiFrame = self.notificationTableView.frame;
        notifiFrame.size.height -= 44;
        self.notificationTableView.frame = notifiFrame;
        
        CGRect bottomFrame = self.bottomView.frame;
        bottomFrame.origin.y -= 44;
        self.bottomView.frame = bottomFrame;
        
    }];
    
    
    
}


- (void)animationWithCancle
{
    
    [UIView animateWithDuration:0.5f animations:^{
        
        CGRect notifiFrame = self.notificationTableView.frame;
        notifiFrame.size.height += 44;
        self.notificationTableView.frame = notifiFrame;
        
        CGRect bottomFrame = self.bottomView.frame;
        bottomFrame.origin.y += 44;
        self.bottomView.frame = bottomFrame;
        
    }];
    
    
    
    
}


/**
 *  选择全部的通知
 */
- (void)checkAllNotification:(UIButton *)button
{
    if (self.notiData.count == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有可选的通知了！！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        if ([button.titleLabel.text isEqualToString:@"全选"]) {
            
            [button setTitle:@"取消全选" forState:UIControlStateNormal];
            
            [self.notiData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:idx inSection:0];
                
                [self.notificationTableView cellForRowAtIndexPath:path].selected = YES;
                
                [self tableView:self.notificationTableView didSelectRowAtIndexPath:path];
                
                [self.notificationTableView cellForRowAtIndexPath:path].userInteractionEnabled = NO;
            }];
            
            
        } else {
            
            [button setTitle:@"全选" forState:UIControlStateNormal];
            
            [self.notiData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:idx inSection:0];
                
                [self.notificationTableView cellForRowAtIndexPath:path].selected = NO;
                [self tableView:self.notificationTableView didDeselectRowAtIndexPath:path];
                
                [self.notificationTableView cellForRowAtIndexPath:path].userInteractionEnabled = YES;
                
            }];
        }
    }
    
    
}


/**
 *  删除被选择的通知
 */
- (void)removeCheckNotification
{
    if (self.notiData.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有可以删除的数据了！！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        // 将要删除的数据从数组中进行移除
        
        NSArray *deleDatas = [NSArray arrayWithArray:[self.deletDic allValues]];
        
        [self.notiData removeObjectsInArray:deleDatas];
        
        NSArray *indexPaths = [NSArray arrayWithArray:[self.deletDic allKeys]];
        
        [self.notificationTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.deletDic removeAllObjects];
        [self.iconArray removeAllObjects];
        
        [self.notiData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [self.iconArray addObject:@(0)];
            
        }];
        
        
    }
    
}


#pragma mark - 懒加载
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColorFromRGB(0xf1f3f4);
        _bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width, 44);
        
        // 全选按钮
        UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        allButton.frame = CGRectMake(20, 0, ([UIScreen mainScreen].bounds.size.width - 20) / 2, 44);
        [allButton setTitle:@"全选" forState:UIControlStateNormal];
        allButton.titleEdgeInsets = UIEdgeInsetsMake(0, -110, 0, 0);
        [allButton setTitleColor:UIColorFromRGB(0x353d3f) forState: UIControlStateNormal];
        [allButton addTarget:self action:@selector(checkAllNotification:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:allButton];
        
        
        // 删除按钮
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        removeButton.frame = CGRectMake(CGRectGetMaxX(allButton.frame), 0, ([UIScreen mainScreen].bounds.size.width - 20)/2, 44);
        [removeButton setTitle:@"删除" forState:UIControlStateNormal];
        [removeButton setTitleColor:UIColorFromRGB(0x353d3f) forState: UIControlStateNormal];
        removeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -100);
        [removeButton addTarget:self action:@selector(removeCheckNotification) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:removeButton];
    }
    
    return _bottomView;
    
    
}

- (NSArray *)datas
{
    if (_datas == nil) {
        _datas = @[
                   @{@"title":@"通知",@"time":@"2015-5-21",@"comment":@"0"},
                   @{@"title":@"通知",@"time":@"2015-5-21",@"comment":@"1"},
                   @{@"title":@"通知",@"time":@"2015-5-21",@"comment":@"2"},
                   @{@"title":@"通知",@"time":@"9:30",@"comment":@"3"},
                   @{@"title":@"通知",@"time":@"昨天",@"comment":@"4"},
                   @{@"title":@"通知",@"time":@"昨天",@"comment":@"5"},
                   @{@"title":@"通知",@"time":@"昨天",@"comment":@"6"},
                   @{@"title":@"通知",@"time":@"昨天",@"comment":@"7"},
                   @{@"title":@"通知",@"time":@"昨天",@"comment":@"8"},
                   @{@"title":@"通知",@"time":@"昨天",@"comment":@"9"},
                   @{@"title":@"通知",@"time":@"昨天",@"comment":@"10"}
                   ];
        
    }
    
    return _datas;
    
    
    
    
}

- (NSMutableArray *)notiData
{
    if (_notiData == nil) {
        
        _notiData = [NSMutableArray array];
    }
    
    return _notiData;
    
    
}

- (UITableView *)notificationTableView
{
    if (_notificationTableView == nil) {
        
        CGFloat app_width = [UIScreen mainScreen].bounds.size.width;
        CGFloat app_height = [UIScreen mainScreen].bounds.size.height;
        _notificationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, app_width, app_height) style:UITableViewStylePlain];
        _notificationTableView.dataSource = self;
        _notificationTableView.delegate = self;
        _notificationTableView.allowsSelectionDuringEditing = YES;
        _notificationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _notificationTableView;
    
    
}


- (NSMutableArray *)iconArray
{
    if (_iconArray == nil) {
        
        _iconArray = [NSMutableArray array];
        
        for (int i = 0; i < self.notiData.count; i++) {
            
            [_iconArray addObject:@(0)];
        }
        
        
    }
    
    return _iconArray;
}


#pragma mark - 表的数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _notiData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NotificationTableViewCell *notiCell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
    
    if (notiCell == nil) {
        
        notiCell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCell"];
    }
    
    int identIcon = [self.iconArray[indexPath.row] intValue];
    
    // 创建一个数组，来进行全部的标记，然后判断
    if ([notiCell viewWithTag:viewTag] && identIcon == 0) {
        // 这个控件存在并且标记为0 删除这个控件
        
        [self removeAIconViewWithTableView:notiCell];
        
    } else if ([notiCell viewWithTag:viewTag] == nil && identIcon == 1) {
        // 这个控件不存在 但是标志为1 则创建这个控件
        
        [self creatAIconViewWithTableViewCell:notiCell];
        
    }
    
    notiCell.notiModel = self.notiData[indexPath.row];
    notiCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return notiCell;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_editionButton.titleLabel.text isEqual:@"取消"]) {
        
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleDelete;
    
}


#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_editionButton.titleLabel.text isEqual:@"编辑"]) {
        
#warning 进行按钮的点击事件
        
        
    } else if ([_editionButton.titleLabel.text isEqual:@"取消"]) {
        
        
        [self.deletDic setObject:self.notiData[indexPath.row] forKey:indexPath];
        
        [self.iconArray replaceObjectAtIndex:indexPath.row withObject:@(1)];
        
        NotificationTableViewCell *cell =  (NotificationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        [self creatAIconViewWithTableViewCell:cell];
        
    }
};

- (void)creatAIconViewWithTableViewCell:(NotificationTableViewCell *)cell
{
    
    UIImage *img = [UIImage imageNamed:@"home_task_selected"];
    UIImageView *editDotView = [[UIImageView alloc] initWithImage:img];
    editDotView.tag = viewTag;
    editDotView.frame = CGRectMake(11.5f, 21.5f, 23, 23);
    
    [cell addSubview:editDotView];
    
}

- (void)removeAIconViewWithTableView:(NotificationTableViewCell *)cell
{
    if ([cell viewWithTag:viewTag]) {
        
        [[cell viewWithTag:viewTag] removeFromSuperview];
    }
    
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_editionButton.titleLabel.text isEqual:@"取消"]) {
        
        [self.deletDic removeObjectForKey:indexPath];
        
        NotificationTableViewCell *cell =  (NotificationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        [self removeAIconViewWithTableView:cell];
        
        [self.iconArray replaceObjectAtIndex:indexPath.row withObject:@(0)];
    }
}

// 让tableview和uiviewcontroller变成可编辑状态
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    [_notificationTableView setEditing:editing animated:animated];
    
    
}

// 指定哪一行可以编辑 哪行不能编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}

// 判断点击按钮的样式  来去做添加和删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger row = [indexPath row];
        // 先将data中的数据进行相应的删除
        [self.notiData removeObjectAtIndex:row];
        [self.iconArray removeObjectAtIndex:row];
        
        // 构建 索引处的行数的数组
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        
        // 删除 索引的方法 后面是动画样式
        [_notificationTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
