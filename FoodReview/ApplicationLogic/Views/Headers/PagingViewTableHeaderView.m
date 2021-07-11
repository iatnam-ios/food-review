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

- (void)setTrendings:(NSArray<Category *> *)trendings {
    _trendings = trendings;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
}

- (void)setEditorsChoice:(NSArray<Category *> *)editorsChoice {
    _editorsChoice = editorsChoice;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
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
    if (indexPath.section == 0) {
        EditorsChoiceCollectionViewCell *editorsChoiceCollectionViewCell = (EditorsChoiceCollectionViewCell *)cell;
        editorsChoiceCollectionViewCell.editorsChoice = self.editorsChoice;
        [editorsChoiceCollectionViewCell.collectionView reloadData];
    } else if (indexPath.section == 1) {
        TrendingCollectionViewCell *trendingCollectionViewCell = (TrendingCollectionViewCell *)cell;
        trendingCollectionViewCell.trendings = self.trendings;
        [trendingCollectionViewCell.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.editorsChoice.count == 0) {
            return CGSizeZero;
        }
        return CGSizeMake(collectionView.frame.size.width, 44.0);
    } else {
        if (self.trendings.count == 0) {
            return CGSizeZero;
        }
        return CGSizeMake(collectionView.frame.size.width, 44.0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.editorsChoice.count > 0) {
            CGFloat itemWidth = (collectionView.frame.size.width - 20.0 - 12.0) / 3.0 * 2.0;
            CGFloat itemHeight = (itemWidth * 9.0 / 16.0) + 16.0;
            return CGSizeMake(collectionView.frame.size.width, itemHeight);
        }
    } else if (indexPath.section == 1) {
        CGFloat itemWidth = (collectionView.frame.size.width - 20.0 - 12.0) / 3.0 * 2.0;
        CGFloat itemHeight = (itemWidth * 9.0 / 16.0) + 16.0;
        return CGSizeMake(collectionView.frame.size.width, itemHeight);
    }
    return CGSizeMake(1.0, 1.0);
}


@end
