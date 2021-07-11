//
//  UserViewController.m
//  FoodReview
//
//  Created by MTT on 18/05/2021.
//

#import "UserViewController.h"
#import "AllPostsViewController.h"
#import "UserTableHeaderView.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "LandingViewController.h"
#import "TabBarController.h"
#import "UserInfoViewController.h"
#import "Relationship.h"

@interface UserViewController ()<JXPagerViewDelegate, JXCategoryViewDelegate, UserTableHeaderViewDelegate>

@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) UserTableHeaderView *userHeaderView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (nonatomic, readwrite) FIRUser *firUser;
@property (nonatomic, strong) User *user;

@end

@implementation UserViewController {
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
    [self setupAppearances];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pagingView.frame = self.view.bounds;
}

#pragma mark - Initialize

- (void)initialize {
    self.navigationItem.title = @"Thông tin";
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    self.navigationController.navigationBar.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.view.backgroundColor = UIColor.systemGroupedBackgroundColor;
    
    heightForHeaderInSection = 50;
    heightForTableHeaderView = 200;
    
    self.db = [FIRFirestore firestore];
    
    if (self.userId == nil) {
        self.firUser = [[FIRAuth auth] currentUser];
        if (self.firUser) {
            self.userId = self.firUser.uid;
            self.isCurrentUser = YES;
        } else {
            LandingViewController *vc = [[LandingViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    
    
    
    if (self.isCurrentUser) {
        UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"] style:UIBarButtonItemStyleDone target:self action:@selector(didPressMoreButton:)];
        self.navigationItem.rightBarButtonItem = moreButton;

    } else {

    }
}

#pragma mark - SetupAppearances

-(void)setupAppearances {
    if (self.userId) {
        FIRDocumentReference *userRef = [[self.db collectionWithPath:@"users"] documentWithPath:self.userId];
        
        [userRef getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (snapshot.exists) {
                // Document data may be nil if the document exists but has no keys or values.
                NSLog(@"Document data: %@", snapshot.data);
                User *user = [[User alloc] initWithDictionary:snapshot.data];
                self.user = user;
                [self setupHeader:user];
            } else {
                NSLog(@"Document does not exist");
            }
        }];
        
        FIRQuery *reviewQuery = [[self.db collectionWithPath:@"reviews"] queryWhereField:@"userId" isEqualTo:self.userId];
        
        [reviewQuery addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (error) {
                [self.userHeaderView setReviewLabel:0];
            } else {
                [self.userHeaderView setReviewLabel:snapshot.documents.count];
            }
        }];
        
        FIRQuery *followerQuery = [[self.db collectionWithPath:@"relationships"] queryWhereField:@"followedId" isEqualTo:self.userId];
        
        [followerQuery addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (error) {
                [self.userHeaderView setFollowerLabel:0];
            } else {
                [self.userHeaderView setFollowerLabel:snapshot.documents.count];
                for (NSDictionary *dict in snapshot.documents) {
                    NSString *followerId = dict[@"followerId"];
                    if (!self.isCurrentUser) {
                        if ([followerId isEqualToString:self.firUser.uid]) {
                            self.userHeaderView.followButton.selected = YES;
                        }
                    }
                }
            }
        }];
        
        FIRQuery *followedQuery = [[self.db collectionWithPath:@"relationships"] queryWhereField:@"followerId" isEqualTo:self.userId];
        
        [followedQuery addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (error) {
                [self.userHeaderView setFollowedLabel:0];
            } else {
                [self.userHeaderView setFollowedLabel:snapshot.documents.count];
            }
        }];
    }
}

-(void)setupHeader:(User *)user {
    if (self.isCurrentUser) {
        [self.userHeaderView setupForCurrentUser:user];
    } else {
        [self.userHeaderView setup:user];
    }
}

#pragma mark - SetupViews

- (void)setupViews {
    _userHeaderView = [[UserTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, heightForTableHeaderView)];
    _userHeaderView.delegate = self;

    _categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, heightForHeaderInSection);
    self.categoryView.titles = @[@"Bài viết", @"Hình ảnh"];
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
    return heightForTableHeaderView;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return heightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 2;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    AllPostsViewController *vc = [[AllPostsViewController alloc] init];
    vc.userId = self.userId;
    vc.type = (PostType)10;
    return vc;
}

//- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
//    [self.userHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
//}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

-(void)didPressMoreButton:(UIBarButtonItem *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Đăng xuất" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSError *error;
        [[FIRAuth auth] signOut:&error];
        if (error == nil) {
            self.userId = nil;
            [TabBarController.sharedInstance setSelectedIndex:0];
        } else {
            [Common alertWithRootView:self.view message:error.localizedDescription];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:action];
    [alertController addAction:cancel];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (void)didPressFollowButton:(UIButton *)sender {
    if (sender.isSelected) {
        Relationship *rela = [[Relationship alloc] initWithFollowerId:self.firUser.uid followedId:self.userId createdDate:[NSDate date]];
        [[[self.db collectionWithPath:@"relationships"] documentWithPath:rela.relationshipId] setData:[rela getDictionary] completion:^(NSError * _Nullable error) {
            if (error) {
                sender.selected = NO;
            }
        }];
    } else {
        NSString *relaId = [NSString stringWithFormat:@"%@_%@", self.firUser.uid, self.userId];
        [[[self.db collectionWithPath:@"relationships"] documentWithPath:relaId] deleteDocumentWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                sender.selected = YES;
            }
        }];
    }
}

- (void)didPressDetailButton:(UIButton *)sender {
    UserInfoViewController *vc = [[UserInfoViewController alloc] init];
    vc.user = self.user;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
