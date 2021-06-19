//
//  PagingViewTableHeaderView.m
//  FoodReview
//
//  Created by MTT on 22/05/2021.
//

#import "PagingViewTableHeaderView.h"
#import "BaseCollectionReusableView.h"
#import "EditorsChoiceCollectionViewCell.h"
#import "TrendingCollectionViewCell.h"

@interface PagingViewTableHeaderView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, BaseCollectionReusableViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect imageViewFrame;
@property (nonatomic) UICollectionView *collectionView;

@end

@implementation PagingViewTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self initialize];
        [self setupViews];
    }
    return self;
}

#pragma mark - Initialize

- (void)initialize {
    self.collectionView.backgroundColor = UIColor.systemGroupedBackgroundColor;
}

#pragma mark - SetupViews

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        [_collectionView registerClass:[BaseCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BaseCollectionReusableView.identifier];
        [_collectionView registerClass:[EditorsChoiceCollectionViewCell class] forCellWithReuseIdentifier:EditorsChoiceCollectionViewCell.identifier];
        [_collectionView registerClass:[TrendingCollectionViewCell class] forCellWithReuseIdentifier:TrendingCollectionViewCell.identifier];
    }
    return _collectionView;
}

- (void)setupViews {
    [self addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BaseCollectionReusableView.identifier forIndexPath:indexPath];
    headerView.delegate = self;
    headerView.tag = indexPath.section;
    
    if (indexPath.section == 0) {
        headerView.titleLabel.text = @"Hôm nay ăn gì?";
    } else if (indexPath.section == 1) {
        headerView.titleLabel.text = @"Món ăn nổi bật";
    } else if (indexPath.section == 2) {
        headerView.titleLabel.text = @"New Music";
    }
    return headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EditorsChoiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EditorsChoiceCollectionViewCell.identifier forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        TrendingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TrendingCollectionViewCell.identifier forIndexPath:indexPath];
        return cell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        EditorsChoiceCollectionViewCell *editorsChoiceCollectionViewCell = (EditorsChoiceCollectionViewCell *)cell;
//        editorsChoiceCollectionViewCell.editorsChoices = self.editorsChoices;
//        [editorsChoiceCollectionViewCell.collectionView reloadData];
//    } else if (indexPath.section == 1) {
//        TrendingCollectionViewCell *trendingCollectionViewCell = (TrendingCollectionViewCell *)cell;
//        trendingCollectionViewCell.isMostPlayed = NO;
//        trendingCollectionViewCell.tracks = self.recentlyPlayedSongs;
//        [trendingCollectionViewCell.collectionView reloadData];
//    } else if (indexPath.section == 2) {
//        TrendingCollectionViewCell *trendingCollectionViewCell = (TrendingCollectionViewCell *)cell;
//        trendingCollectionViewCell.isMostPlayed = NO;
//        trendingCollectionViewCell.tracks = self.trendings;
//        [trendingCollectionViewCell.collectionView reloadData];
//    } else if (indexPath.section == 3) {
//        NewMusicCollectionViewCell *newMusicCollectionViewCell = (NewMusicCollectionViewCell *)cell;
//        newMusicCollectionViewCell.tracks = self.tracks;
//        [newMusicCollectionViewCell.collectionView reloadData];
//    } else if (indexPath.section == 4) {
//        NewMusicCollectionViewCell *newMusicCollectionViewCell = (NewMusicCollectionViewCell *)cell;
//        newMusicCollectionViewCell.tracks = self.categories;
//        [newMusicCollectionViewCell.collectionView reloadData];
//    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (collectionView.frame.size.width - 20.0 - 12.0) / 3.0 * 2.0;
    CGFloat itemHeight = (itemWidth * 9.0 / 16.0) + 16.0;
    return CGSizeMake(collectionView.frame.size.width, itemHeight);
}


@end
