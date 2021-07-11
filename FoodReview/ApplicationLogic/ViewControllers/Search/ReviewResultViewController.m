//
//  ReviewResultViewController.m
//  FoodReview
//
//  Created by MTT on 11/07/2021.
//

#import "ReviewResultViewController.h"
#import "PostCollectionViewCell.h"
#import "DetailReviewViewController.h"
#import "Review.h"
#import "MBProgressHUD.h"

@interface ReviewResultViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, readwrite) FIRFirestore *db;
@property (nonatomic, readwrite) FIRQuery *query;
@property (nonatomic) NSMutableArray<Review *> *reviews;

@end

@implementation ReviewResultViewController

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
        self.query = [[self.db collectionWithPath:@"reviews"] queryWhereField:@"title" isGreaterThanOrEqualTo:self.searchText];
        
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
            
            NSMutableArray<Review *> *results = [NSMutableArray new];
            
            for (FIRDocumentSnapshot *doc in snapshot.documents) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:doc.data];
                dict[@"reviewId"] = doc.documentID;
                Review *review = [[Review alloc] initWithDictionary:dict];
                [results addObject:review];
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@", weakSelf.searchText];
            weakSelf.reviews = [NSMutableArray arrayWithArray:[results filteredArrayUsingPredicate:predicate]];
            
            [weakSelf.collectionView reloadData];
        }];
    } else {
        [self.reviews removeAllObjects];
        [self.collectionView reloadData];
    }
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
