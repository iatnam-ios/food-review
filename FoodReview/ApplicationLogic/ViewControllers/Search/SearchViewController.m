//
//  VideoViewController.m
//  FoodReview
//
//  Created by MTT on 18/05/2021.
//

#import "SearchViewController.h"
#import "ReviewResultViewController.h"
#import "PlaceResultViewController.h"
#import "UserResultViewController.h"
#import "HashtagResultViewController.h"
#import "PagingViewTableHeaderView.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"

@interface SearchViewController ()<UISearchBarDelegate, UISearchResultsUpdating, JXPagerViewDelegate, JXCategoryViewDelegate>

@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) PagingViewTableHeaderView *userHeaderView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ReviewResultViewController *reviewController;
@property (nonatomic, strong) PlaceResultViewController *placeController;
@property (nonatomic, strong) UserResultViewController *userController;
@property (nonatomic, strong) HashtagResultViewController *hashtagController;

@end

@implementation SearchViewController

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
    self.navigationItem.title = @"Tìm kiếm";
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    self.navigationController.navigationBar.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.definesPresentationContext = YES;
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;

}

#pragma mark - SetupAppearances

- (ReviewResultViewController *)reviewController {
    if (_reviewController == nil) {
        _reviewController = [[ReviewResultViewController alloc] init];
    }
    return _reviewController;
}

- (PlaceResultViewController *)placeController {
    if (_placeController == nil) {
        _placeController = [[PlaceResultViewController alloc] init];
    }
    return _placeController;
}

- (UserResultViewController *)userController {
    if (_userController == nil) {
        _userController = [[UserResultViewController alloc] init];
    }
    return _userController;
}

- (HashtagResultViewController *)hashtagController {
    if (_hashtagController == nil) {
        _hashtagController = [[HashtagResultViewController alloc] init];
    }
    return _hashtagController;
}

#pragma mark - SetupViews

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchBar.delegate = self;
        _searchController.searchResultsUpdater = self;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.definesPresentationContext = YES;
        _searchController.obscuresBackgroundDuringPresentation = NO;
        _searchController.searchBar.placeholder = @"Nhập từ khoá...";
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.barStyle = UIBarStyleDefault;
        _searchController.searchBar.translucent = YES;
        [_searchController.searchBar setTintColor: UIColor.redPinkColor];
        _searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _searchController;
}

- (void)setupViews {
    _userHeaderView = [[PagingViewTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.0)];

    _categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 50.0);
    self.categoryView.titles = @[@"Bài viết", @"Địa điểm", @"Tài khoản", @"Hashtag"];
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

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 0.0;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 50.0;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 4;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        return self.reviewController;
    } else if (index == 1) {
        return self.placeController;
    } else if (index == 2) {
        return self.userController;
    } else {
        return self.hashtagController;
    }
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        self.reviewController.searchText = searchBar.text;
        self.placeController.searchText = searchBar.text;
        self.userController.searchText = searchBar.text;
        self.hashtagController.searchText = searchBar.text;
        
        NSInteger index = self.categoryView.selectedIndex;
        if (index == 0) {
            [self.reviewController searchResult];
        } else if (index == 1) {
            [self.placeController searchResult];
        } else if (index == 2) {
            [self.userController searchResult];
        } else {
            [self.hashtagController searchResult];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

@end
