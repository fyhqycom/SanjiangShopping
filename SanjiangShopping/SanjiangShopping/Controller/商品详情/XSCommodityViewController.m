//
//  XSCommodityViewController.m
//  SanjiangShopping
//
//  Created by 薛纪杰 on 11/18/15.
//  Copyright © 2015 Sanjiang Shopping Club Co., Ltd. All rights reserved.
//

#import "XSCommodityViewController.h"

#import "ThemeColor.h"

#import "XSCommodityPannelView.h"

#import "XSCommodityShowcaseTableViewCell.h"
#import "XSCommodityDescriptionTableViewCell.h"
#import "XSCommodityOptionTableViewCell.h"
#import "XSCommodityRecommendTableViewCell.h"
#import "XSCommodityMoreTableViewCell.h"

#import "XSCommodityDetailView.h"

static NSString * const showcaseID = @"showcase";
static NSString * const descriptionID = @"desc";
static NSString * const optionID = @"option";
static NSString * const recommendID = @"recommend";
static NSString * const moreID = @"more";

static CGFloat const showcaseHeight = 310;
static CGFloat const descriptionHeight = 135;
static CGFloat const optionHeight = 155;
static CGFloat const recommendHeight = 400;
static CGFloat const moreHeight = 54;

@interface XSCommodityViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) XSCommodityPannelView *pannelView;

@property (strong, nonatomic) XSCommodityDetailView *detailView;

@end

@implementation XSCommodityViewController
{
    BOOL _canInspect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.detailView];
    [self.view addSubview:self.pannelView];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _canInspect = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
    self.detailView.frame = CGRectMake(0, self.tableView.frame.size.height + self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
    self.pannelView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, self.view.frame.size.width, 50);
}

#pragma mark - private methods
- (void)customNavigationBar {
    self.navigationItem.title = @"商品详情";
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(comeBack)];
    leftButtonItem.tintColor = MAIN_TITLE_COLOR;
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)comeBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:showcaseID forIndexPath:indexPath];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:descriptionID forIndexPath:indexPath];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:optionID forIndexPath:indexPath];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:recommendID forIndexPath:indexPath];
            break;
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:moreID forIndexPath:indexPath];
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    switch (indexPath.row) {
        case 0:
            height = showcaseHeight;
            break;
        case 1:
            height = descriptionHeight;
            break;
        case 2:
            height = optionHeight;
            break;
        case 3:
            height = recommendHeight;
            break;
        case 4:
            height = moreHeight;
        default:
            break;
    }
    
    return height;
}

#pragma mark - UIScorllViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat estimate = 100;
    // 50 = panelView.frame.size.height
    CGFloat limit = (showcaseHeight + descriptionHeight + optionHeight + recommendHeight + moreHeight) - ([UIScreen mainScreen].bounds.size.height - 50) + estimate;
    if (scrollView.contentOffset.y > limit && _canInspect) {
        NSLog(@"下边界超出");
        _canInspect = NO;
        CGPoint center = self.view.center;
        CGPoint point  = CGPointMake(self.view.center.x, self.view.center.y - self.view.frame.size.height);
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.detailView.center = center;
            weakSelf.tableView.center  = point;
            weakSelf.navigationItem.title = @"图文详情";
        } completion:^(BOOL finished) {
            _canInspect = YES;
        }];
    }
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        
        _tableView.backgroundColor = BACKGROUND_COLOR;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor  = [UIColor clearColor];
        
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator   = NO;
        
        [_tableView registerClass:[XSCommodityShowcaseTableViewCell class] forCellReuseIdentifier:showcaseID];
        [_tableView registerNib:[UINib nibWithNibName:@"XSCommodityShowcaseTableViewCell" bundle:nil] forCellReuseIdentifier:showcaseID];
        
        [_tableView registerClass:[XSCommodityDescriptionTableViewCell class] forCellReuseIdentifier:descriptionID];
        [_tableView registerNib:[UINib nibWithNibName:@"XSCommodityDescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:descriptionID];
        
        [_tableView registerClass:[XSCommodityOptionTableViewCell class] forCellReuseIdentifier:optionID];
        [_tableView registerNib:[UINib nibWithNibName:@"XSCommodityOptionTableViewCell" bundle:nil] forCellReuseIdentifier:optionID];
        
        [_tableView registerClass:[XSCommodityRecommendTableViewCell class] forCellReuseIdentifier:recommendID];
        [_tableView registerNib:[UINib nibWithNibName:@"XSCommodityRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:recommendID];
        
        [_tableView registerClass:[XSCommodityMoreTableViewCell class] forCellReuseIdentifier:moreID];
        [_tableView registerNib:[UINib nibWithNibName:@"XSCommodityMoreTableViewCell" bundle:nil] forCellReuseIdentifier:moreID];
    }
    return _tableView;
}

- (XSCommodityDetailView *)detailView {
    if (_detailView == nil) {
        __weak typeof(self) weakSelf = self;
        CGPoint center = self.view.center;
        CGPoint point  = CGPointMake(self.view.center.x, self.view.center.y + self.view.frame.size.height);
        _detailView = [[XSCommodityDetailView alloc] initWithBackBlock:^(UIView *detailView) {
            weakSelf.tableView.center  = center;
            weakSelf.detailView.center = point;
            weakSelf.navigationItem.title = @"商品详情";
        }];
    }
    return _detailView;
}

- (XSCommodityPannelView *)pannelView {
    if (_pannelView == nil) {
        _pannelView = [[[NSBundle mainBundle] loadNibNamed:@"XSCommodityPannelView" owner:self options:nil] objectAtIndex:0];
        _pannelView.layer.borderWidth   = 0.5f;
        _pannelView.layer.borderColor   = [OTHER_SEPARATOR_COLOR CGColor];
    }
    return _pannelView;
}

@end
