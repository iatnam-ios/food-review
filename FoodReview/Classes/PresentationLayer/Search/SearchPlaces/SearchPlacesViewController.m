//
//  SearchPlacesViewController.m
//  FoodReview
//
//  Created by MTT on 08/06/2021.
//

#import <CoreLocation/CoreLocation.h>
#import "SearchPlacesViewController.h"
#import "PlaceCollectionViewCell.h"
#import "BaseCollectionReusableView.h"
#import "Place.h"
#import "SearchPlacesPresenter.h"

@interface SearchPlacesViewController ()<UISearchBarDelegate, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray<Place *> *places;
@property (nonatomic, strong) NSMutableArray<Place *> *suggestionPlaces;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic) BOOL isSearchPlace;

@end

@implementation SearchPlacesViewController

@synthesize presenter;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialize];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //[self setupAppearances];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self requestLocation];
}

#pragma mark - Initialize

- (void)initialize {
    self.isSearchPlace = NO;
    self.definesPresentationContext = YES;
    
    self.navigationItem.title = @"Địa điểm";
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    self.navigationController.navigationBar.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.collectionView.backgroundColor = UIColor.systemGroupedBackgroundColor;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self requestLocation];
    }];
    
    [self.presenter viewDidLoad];
}

- (NSMutableArray<Place *> *)places {
    if (!_places) {
        _places = [NSMutableArray new];
    }
    return _places;
}

- (NSMutableArray<Place *> *)suggestionPlaces {
    if (!_suggestionPlaces) {
        _suggestionPlaces = [NSMutableArray new];
    }
    return _suggestionPlaces;
}

- (CLLocation *)currentLocation {
    if (!_currentLocation) {
        _currentLocation = [[CLLocation alloc] initWithLatitude:21.00732289163568 longitude:105.84314621427002];
    }
    return _currentLocation;
}

#pragma mark - SetupAppearances

- (void)setupAppearances {
    FIRDatabase *database = [FIRDatabase databaseWithURL:@"https://food-review-94b9e-default-rtdb.asia-southeast1.firebasedatabase.app"];
    FIRDatabaseReference *restaurantsRef = [database referenceWithPath:@"restaurants"];
    FIRDatabaseQuery *placeQuery = [[[restaurantsRef queryOrderedByChild:@"DistrictId"] queryEqualToValue:@24] queryLimitedToFirst:20];
    
    [placeQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%lu", (unsigned long)snapshot.childrenCount);
        NSMutableArray<Place *> *results = [NSMutableArray new];
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value;
            Place *place = [[Place alloc] initWithDictionary:dict];
            [results addObject:place];
        }
        
        [self.suggestionPlaces removeAllObjects];
        [results sortUsingComparator:^NSComparisonResult(Place *obj1, Place *obj2) {
            if (obj1.avgRatingOriginal > obj2.avgRatingOriginal) {
                return NSOrderedAscending;
            } else if (obj1.avgRatingOriginal < obj2.avgRatingOriginal) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        self.suggestionPlaces = [NSMutableArray arrayWithArray:results];
        if (!self.isSearchPlace) {
            [self.collectionView reloadData];
        }
    }];
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

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchBar.delegate = self;
        _searchController.searchResultsUpdater = self;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.definesPresentationContext = YES;
        _searchController.obscuresBackgroundDuringPresentation = NO;
        _searchController.searchBar.placeholder = @"Tìm địa điểm...";
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.barStyle = UIBarStyleDefault;
        _searchController.searchBar.translucent = YES;
        [_searchController.searchBar setTintColor: UIColor.redPinkColor];
        _searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _searchController;
}

- (void)setupViews {
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)searchPlace:(NSString *)searchString {
    NSString *editedString = [NSString stringWithFormat:@"%@%@",[[searchString substringToIndex:1] uppercaseString],[searchString substringFromIndex:1]];
    
    FIRDatabase *database = [FIRDatabase databaseWithURL:@"https://food-review-94b9e-default-rtdb.asia-southeast1.firebasedatabase.app"];
    FIRDatabaseReference *restaurantsRef = [database referenceWithPath:@"restaurants"];
    FIRDatabaseQuery *placeQuery = [[[restaurantsRef queryOrderedByChild:@"Name"] queryStartingAtValue:editedString] queryLimitedToFirst:100];
    
    [placeQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%lu", (unsigned long)snapshot.childrenCount);
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
}

#pragma mark - SearchPlacesCollectionViewProtocol

- (void)updateCollectionItems:(NSArray *)array {
    self.suggestionPlaces = [NSMutableArray arrayWithArray:array];
    [self.collectionView reloadData];
}

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

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        self.isSearchPlace = YES;
        [self searchPlace:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (self.isSearchPlace) {
        self.isSearchPlace = NO;
        [self.collectionView reloadData];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isSearchPlace) {
        return self.places.count;
    } else {
        return self.suggestionPlaces.count;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionReusableView.identifier forIndexPath:indexPath];
    headerView.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    headerView.seeAllButton.hidden = YES;
    
    if (self.isSearchPlace) {
        headerView.titleLabel.text = @"Kết quả";
    } else {
        headerView.titleLabel.text = @"Địa điểm gần đây";
    }
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlaceCollectionViewCell.identifier forIndexPath:indexPath];
    Place *place;
    if (self.isSearchPlace) {
        place = self.places[indexPath.item];
    } else {
        place = self.suggestionPlaces[indexPath.item];
    }
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
    return UIEdgeInsetsMake(10.0, 14.0, 10.0, 14.0);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44.0);
}

@end
