//
//  UserResultViewController.m
//  FoodReview
//
//  Created by MTT on 11/07/2021.
//

#import "UserResultViewController.h"
#import "UserCollectionViewCell.h"
#import "DetailUserViewController.h"
#import "User.h"
#import "MBProgressHUD.h"

@interface UserResultViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, readwrite) FIRFirestore *db;
@property (nonatomic, readwrite) FIRQuery *query;
@property (nonatomic) NSMutableArray<User *> *users;

@end

@implementation UserResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialize];
    [self setupViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self searchResult];
}

- (void)searchResult {
    if (self.searchText.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        self.query = [[self.db collectionWithPath:@"users"] queryWhereField:@"userName" isGreaterThanOrEqualTo:self.searchText];
        
        __weak typeof(self) weakSelf = self;
        [self.query addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            [hud hideAnimated:YES];
            
            if (snapshot == nil) {
                [Common alertWithRootView:weakSelf.view message:error.localizedDescription];
                return;
            }
            
            if (snapshot.documents.count == 0) {
                [Common alertWithRootView:weakSelf.navigationController.view message:@"Không tìm thấy kết quả!"];
                return;
            }
            
            NSMutableArray<User *> *results = [NSMutableArray new];
            
            for (FIRDocumentSnapshot *doc in snapshot.documents) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:doc.data];
                User *user = [[User alloc] initWithDictionary:dict];
                [results addObject:user];
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName contains[cd] %@", weakSelf.searchText];
            weakSelf.users = [NSMutableArray arrayWithArray:[results filteredArrayUsingPredicate:predicate]];
            
            [weakSelf.collectionView reloadData];
        }];
    } else {
        [self.users removeAllObjects];
        [self.collectionView reloadData];
    }
}

- (NSMutableArray<User *> *)users {
    if (!_users) {
        _users = [[NSMutableArray alloc] init];
    }
    return _users;
}

#pragma mark - Initialize

- (void)initialize {
    self.collectionView.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.db = [FIRFirestore firestore];
}

#pragma mark - SetupViews

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UserCollectionViewCell class] forCellWithReuseIdentifier:UserCollectionViewCell.identifier];
    }
    return _collectionView;
}

- (void)setupViews {
    [self.view addSubview: self.collectionView];

//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.users.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UserCollectionViewCell.identifier forIndexPath:indexPath];
    
    User *user = self.users[indexPath.item];
    [cell configueWithUser:user];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    User *user = self.users[indexPath.item];
    NSString *userId = [FIRAuth auth].currentUser.uid;
    if ((userId == nil) || (![userId isEqualToString:user.userId])) {
        DetailUserViewController *vc = [[DetailUserViewController alloc] init];
        vc.userId = user.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width - 28.0, 60.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 14.0, 90.0, 14.0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

#pragma mark - JXPagerViewListViewDelegate

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

@end
