//
//  PlaceResultViewController.m
//  FoodReview
//
//  Created by MTT on 11/07/2021.
//

#import "PlaceResultViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PlaceCollectionViewCell.h"
#import "BaseCollectionReusableView.h"
#import "SearchPlacesPresenter.h"
#import "MBProgressHUD.h"

@interface PlaceResultViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray<Place *> *places;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation PlaceResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialize];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupAppearances];
}

#pragma mark - Initialize

- (void)initialize {
    self.collectionView.backgroundColor = UIColor.systemGroupedBackgroundColor;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (NSMutableArray<Place *> *)places {
    if (!_places) {
        _places = [NSMutableArray new];
    }
    return _places;
}

- (CLLocation *)currentLocation {
    if (!_currentLocation) {
        _currentLocation = [[CLLocation alloc] initWithLatitude:21.00732289163568 longitude:105.84314621427002];
    }
    return _currentLocation;
}

#pragma mark - SetupAppearances

- (void)setupAppearances {
    [self searchResult];
}

- (void)searchResult {
    if (self.searchText.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        
        NSString *editedString = [NSString stringWithFormat:@"%@%@",[[self.searchText substringToIndex:1] uppercaseString],[self.searchText substringFromIndex:1]];
        
        FIRDatabase *database = [FIRDatabase databaseWithURL:@"https://food-review-94b9e-default-rtdb.asia-southeast1.firebasedatabase.app"];
        FIRDatabaseReference *restaurantsRef = [database referenceWithPath:@"restaurants"];
        FIRDatabaseQuery *placeQuery = [[[restaurantsRef queryOrderedByChild:@"Name"] queryStartingAtValue:editedString] queryLimitedToFirst:100];
        
        [placeQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            [hud hideAnimated:YES];
            
            if (snapshot.children.allObjects.count == 0) {
                [Common alertWithRootView:self.navigationController.view message:@"Không tìm thấy kết quả!"];
                return;
            }
            
            NSMutableArray<Place *> *results = [NSMutableArray new];
            for (FIRDataSnapshot *child in snapshot.children) {
                NSDictionary *dict = child.value;
                Place *place = [[Place alloc] initWithDictionary:dict];
                [results addObject:place];
            }
            
            [self.places removeAllObjects];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"placeName contains[cd] %@", editedString];
            self.places = [NSMutableArray arrayWithArray:[results filteredArrayUsingPredicate:predicate]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }];
    } else {
        [self.places removeAllObjects];
        [self.collectionView reloadData];
    }
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
        [_collectionView registerClass:[PlaceCollectionViewCell class] forCellWithReuseIdentifier:PlaceCollectionViewCell.identifier];
        [_collectionView registerClass:[BaseCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BaseCollectionReusableView.identifier];
    }
    return _collectionView;
}

- (void)setupViews {
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - SearchPlacesCollectionViewProtocol

- (void)showProgressView {
    
}

- (void)hideProgressView {
    
}

- (void)requestLocation {
    if (![CLLocationManager locationServicesEnabled]) {
        [self displayLocationServicesDisabledAlert];
        return;
    }
    
    if (self.locationManager.authorizationStatus == kCLAuthorizationStatusDenied) {
        [self displayLocationServicesDeniedAlert];
        return;
    }
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestLocation];
}

- (void)displayLocationServicesDisabledAlert {
    
}

- (void)displayLocationServicesDeniedAlert {
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    if (location) {
        self.currentLocation = location;
    }
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.places.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlaceCollectionViewCell.identifier forIndexPath:indexPath];
    Place *place = self.places[indexPath.item];;

    CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];
    [cell configueWithPlace:place andDistance:[Common getDistanceFromLocation:self.currentLocation toLocation:placeLocation]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width - 28.0, 80.0);
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
