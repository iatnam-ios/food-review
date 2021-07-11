//
//  AllPostsViewController.m
//  FoodReview
//
//  Created by MTT on 22/05/2021.
//

#import "AllPostsViewController.h"
#import "PostCollectionViewCell.h"
#import "DetailReviewViewController.h"

@interface AllPostsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, readwrite) FIRFirestore *db;
@property (nonatomic, readwrite) FIRQuery *query;

@end

@implementation AllPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialize];
    [self setupViews];
    [self getPosts];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)getPosts {
    switch (self.type) {
        case AllPosts:
            [self getAllPosts];
            break;
        case SnackPosts:
            [self getSnackPosts];
            break;
        case NearPosts:
            [self getNearPosts];
            break;
        case FollowPosts:
            [self getFollowPosts];
            break;
        default:
            if (self.userId) {
                [self getPostOfUserId:self.userId];
            }
            break;
    }
}

-(void)getPostOfUserId:(NSString *)userId {
    if (!self.query) {
        self.query = [[self.db collectionWithPath:@"reviews"] queryWhereField:@"userId" isEqualTo:userId];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.query addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (snapshot == nil) {
            [Common alertWithRootView:weakSelf.view message:error.localizedDescription];
            return;
        }
        
        if (snapshot.documents.count == 0) { return; }
        
        for (FIRDocumentSnapshot *doc in snapshot.documents) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:doc.data];
            dict[@"reviewId"] = doc.documentID;
            Review *review = [[Review alloc] initWithDictionary:dict];
            [weakSelf.reviews addObject:review];
        }
        [weakSelf.collectionView reloadData];
    }];
}

-(void)getAllPosts {
    if (!self.query) {
        self.query = [[[self.db collectionWithPath:@"reviews"] queryOrderedByField:@"createdDate" descending:YES] queryLimitedTo:10];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.query addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (snapshot == nil) {
            [Common alertWithRootView:weakSelf.view message:error.localizedDescription];
            return;
        }
        
        if (snapshot.documents.count == 0) { return; }
        FIRDocumentSnapshot *lastSnapshot = snapshot.documents.lastObject;
        weakSelf.query = [[[weakSelf.db collectionWithPath:@"reviews"] queryOrderedByField:@"createdDate" descending:YES] queryStartingAfterDocument:lastSnapshot];
        
        for (FIRDocumentSnapshot *doc in snapshot.documents) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:doc.data];
            dict[@"reviewId"] = doc.documentID;
            Review *review = [[Review alloc] initWithDictionary:dict];
            [weakSelf.reviews addObject:review];
        }
        [weakSelf.collectionView reloadData];
    }];
}

-(void)getSnackPosts {
    
}

-(void)getNearPosts {
    if (!self.query) {
        self.query = [[[self.db collectionWithPath:@"reviews"] queryOrderedByField:@"totalViews" descending:YES] queryLimitedTo:10];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.query addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (snapshot == nil) {
            [Common alertWithRootView:weakSelf.view message:error.localizedDescription];
            return;
        }
        
        if (snapshot.documents.count == 0) { return; }
        FIRDocumentSnapshot *lastSnapshot = snapshot.documents.lastObject;
        weakSelf.query = [[[weakSelf.db collectionWithPath:@"reviews"] queryOrderedByField:@"totalViews" descending:YES] queryStartingAfterDocument:lastSnapshot];
        
        for (FIRDocumentSnapshot *doc in snapshot.documents) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:doc.data];
            dict[@"reviewId"] = doc.documentID;
            Review *review = [[Review alloc] initWithDictionary:dict];
            [weakSelf.reviews addObject:review];
        }
        [weakSelf.collectionView reloadData];
    }];
}

-(void)getFollowPosts {
    FIRUser *user = [[FIRAuth auth] currentUser];
    if (user == nil) {
        return;
    }
    FIRQuery *query = [[[self.db collectionWithPath:@"relationships"] queryWhereField:@"followerId" isEqualTo:user.uid] queryLimitedTo:10];
    
    __weak typeof(self) weakSelf = self;
    
    [query addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (snapshot == nil) {
            [Common alertWithRootView:weakSelf.view message:error.localizedDescription];
            return;
        }
        if (snapshot.documents.count == 0) { return; }
        
        NSMutableArray *listUsers = [[NSMutableArray alloc] init];
        for (FIRDocumentSnapshot *doc in snapshot.documents) {
            NSString *followedId = doc.data[@"followedId"];
            [listUsers addObject:followedId];
        }
        
        self.query = [[[self.db collectionWithPath:@"reviews"] queryWhereField:@"userId" in:listUsers] queryLimitedTo:10];
        [self.query addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (snapshot == nil) {
                [Common alertWithRootView:weakSelf.view message:error.localizedDescription];
                return;
            }
            
            if (snapshot.documents.count == 0) { return; }
            
            for (FIRDocumentSnapshot *doc in snapshot.documents) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:doc.data];
                dict[@"reviewId"] = doc.documentID;
                Review *review = [[Review alloc] initWithDictionary:dict];
                [weakSelf.reviews addObject:review];
            }
            [weakSelf.collectionView reloadData];
        }];
    }];
}

- (NSMutableArray<Review *> *)reviews {
    if (!_reviews) {
        _reviews = [[NSMutableArray alloc] init];
    }
    return _reviews;
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
        [_collectionView registerClass:[PostCollectionViewCell class] forCellWithReuseIdentifier:PostCollectionViewCell.identifier];
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
    return self.reviews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PostCollectionViewCell.identifier forIndexPath:indexPath];
    
//    if (indexPath.item == 0) {
//        cell.titleLabel.text = @"Coffee House";
//        [cell.artwork sd_setImageWithURL:[NSURL URLWithString:@"https://firebasestorage.googleapis.com/v0/b/food-review-94b9e.appspot.com/o/coffee-cup-working-happy.jpg?alt=media&token=c46c4eae-fa03-4531-aa6d-b1c11de1f994"]];
//        [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:@"https://firebasestorage.googleapis.com/v0/b/food-review-94b9e.appspot.com/o/avatars%2Ftest%2Favatar-naruto.jpg?alt=media&token=ffed629c-f179-4c84-8470-6d710ed406fc"]];
//    } else {
//        cell.titleLabel.text = @"Bánh cuốn Thanh Trì";
//        [cell.artwork sd_setImageWithURL:[NSURL URLWithString:@"https://firebasestorage.googleapis.com/v0/b/food-review-94b9e.appspot.com/o/reviewPhoto%2Fbanh-cuon-thanh-tri.jpg?alt=media&token=b2a045a9-b433-4bee-b3e4-0fad37de4d2b"]];
//        [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:@"https://firebasestorage.googleapis.com/v0/b/food-review-94b9e.appspot.com/o/avatars%2Ftest%2Favatar-naruto.jpg?alt=media&token=ffed629c-f179-4c84-8470-6d710ed406fc"]];
//    }
    
    Review *review = self.reviews[indexPath.item];
    [cell configCellWithReview:review];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailReviewViewController *vc = [[DetailReviewViewController alloc] init];
    vc.review = self.reviews[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (collectionView.frame.size.width - 10.0 * 2 - 6.0) / 2.0;
    CGFloat itemHeight = itemWidth * 4.0 / 3.0 + 70.0;

    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0, 10.0, 90.0, 10.0);
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
