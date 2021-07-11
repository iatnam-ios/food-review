//
//  HomeViewController.m
//  FoodReview
//
//  Created by MTT on 18/05/2021.
//

#import "HomeViewController.h"
#import "AllPostsViewController.h"
#import "PagingViewTableHeaderView.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"

@interface HomeViewController ()<JXPagerViewDelegate, JXCategoryViewDelegate>

@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) PagingViewTableHeaderView *userHeaderView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@end

@implementation HomeViewController {
    CGFloat heightForTableHeaderView;
    CGFloat heightForHeaderInSection;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialize];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pagingView.frame = self.view.bounds;
}

#pragma mark - Initialize

- (void)initialize {
    self.navigationItem.title = @"Khám phá";
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    self.navigationController.navigationBar.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    
    heightForHeaderInSection = 50;
    heightForTableHeaderView = 0;
    
    [self.presenter viewDidLoad];
}

#pragma mark - SetupAppearances


#pragma mark - SetupViews

- (void)setPresenter:(id<HomePresenter>)presenter {
    _presenter = presenter;
    presenter.output = self;
}

- (void)setupViews {
    _userHeaderView = [[PagingViewTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightForTableHeaderView)];

    _categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, heightForHeaderInSection);
    self.categoryView.titles = @[@"Tất cả", @"Xem nhiều", @"Theo dõi", @"Ăn vặt"];
    self.categoryView.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    lineView.indicatorWidth = 30;
    self.categoryView.indicators = @[lineView];

    _pagingView = [[JXPagerView alloc] initWithDelegate:self];
    [self.view addSubview:self.pagingView];

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;

    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    self.pagingView.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
}

#pragma mark - Supporting Methods

- (void)presenterDidReceiveEditorsChoice:(NSArray<Category *> *)items {
    if (self.userHeaderView.editorsChoice.count == 0) {
        CGFloat height = ((self.view.bounds.size.width - 20.0 - 12.0) / 1.5 * 9.0 / 16.0 + 16.0) + 44.0;
        heightForTableHeaderView += height;
        [self.pagingView resizeTableHeaderViewHeightWithAnimatable:YES duration:0.5 curve:UIViewAnimationCurveLinear];
    }
    self.userHeaderView.editorsChoice = items;
}

- (void)presenterDidReceiveTrending:(NSArray<Category *> *)items {
    if (self.userHeaderView.trendings.count == 0) {
        CGFloat height = ((self.view.bounds.size.width - 20.0 - 12.0) / 1.5 * 9.0 / 16.0 + 16.0) + 44.0;
        heightForTableHeaderView += height;
        [self.pagingView resizeTableHeaderViewHeightWithAnimatable:YES duration:0.5 curve:UIViewAnimationCurveLinear];
    }
    self.userHeaderView.trendings = items;
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return heightForTableHeaderView;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return heightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 4;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    AllPostsViewController *vc = [[AllPostsViewController alloc] init];
    vc.type = (PostType)index;
    return vc;
}

//- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
//    [self.userHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
//}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

@end
