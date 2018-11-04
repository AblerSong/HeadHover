//
//  ViewController.m
//  TableHeadHover
//
//  Created by song on 2018/11/4.
//  Copyright © 2018年 song. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh/MJRefresh.h>
#define HeightHead 200.0
#define HeightPlaceholder 80.0

@interface ViewController ()
@property (nonatomic, strong) UIImageView *headImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *))
    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    // tableHeaderView
    UIView *tableHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, HeightHead)];
    tableHead.hidden = YES;
    self.tableView.tableHeaderView = tableHead;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(HeightHead, 0, 0, 0);
    // 刷新控件
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = -HeightHead;
    //悬停view
    [self.tableView addSubview:self.headImageView];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    
    return cell;
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, HeightHead)];
        _headImageView.backgroundColor = [UIColor redColor];
        _headImageView.image = [UIImage imageNamed:@"head.bundle/saber.jpg"];
        UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HeightHead - HeightPlaceholder, self.view.bounds.size.width, HeightPlaceholder)];
        placeLabel.text = @"我是悬停";
        placeLabel.textColor = [UIColor whiteColor];
        placeLabel.textAlignment = NSTextAlignmentCenter;
        placeLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [_headImageView addSubview:placeLabel];
    }
    return _headImageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat placeHolderHeight =  HeightHead - HeightPlaceholder;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        self.headImageView.frame = CGRectMake(0, offsetY, self.headImageView.bounds.size.width, self.headImageView.bounds.size.height);
    }else if (offsetY > placeHolderHeight){
        self.headImageView.frame = CGRectMake(0, offsetY - placeHolderHeight, self.headImageView.bounds.size.width, self.headImageView.bounds.size.height);
    }else{
        self.headImageView.frame = CGRectMake(0, 0, self.headImageView.bounds.size.width, self.headImageView.bounds.size.height);
    }
}

@end
