//
//  TrendingCollectionViewCell.m
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import "TrendingCollectionViewCell.h"
#import "NewDishCollectionViewCell.h"

@interface TrendingCollectionViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation TrendingCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateUIAppearances];
}

#pragma mark - UpdateUIAppearances

+ (NSString *)identifier {
    return @"reuseTrendingCollectionViewCell";
}

#pragma mark - UpdateUIAppearances

- (void)updateUIAppearances {
    self.collectionView.backgroundColor = UIColor.systemGroupedBackgroundColor;
}

#pragma mark - SetupViews

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[NewDishCollectionViewCell class] forCellWithReuseIdentifier:NewDishCollectionViewCell.identifier];
    }
    return _collectionView;
}

- (void)setupViews {
    [self addSubview: self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewDishCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewDishCollectionViewCell.identifier forIndexPath:indexPath];
    
    cell.titleLabel.text = @"New Dish Collection View Cell";
    [cell.artwork sd_setImageWithURL:[NSURL URLWithString:@"https://homepages.cae.wisc.edu/~ece533/images/fruits.png"]];
    
//    NSObject<Prototype> *editorsChoice = self.editorsChoices[indexPath.item];
//    [cell configureCell:(EditorsChoice *)editorsChoice];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (collectionView.frame.size.width - 20.0 - 12.0) / 3.0 * 2.0;
    CGFloat itemHeight = (itemWidth * 9.0 / 16.0);

    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0);
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    CGFloat itemWidth = self.collectionView.frame.size.width - 40.0;
//    CGFloat currentOffset = scrollView.contentOffset.x;
//    CGFloat targetOffset = targetContentOffset->x;
//    CGFloat newTargetOffset = 0.0;
//
//    if (targetOffset > currentOffset) {
//        NSInteger items = ceilf(currentOffset / itemWidth);
//        newTargetOffset = items * itemWidth + (items - 1) * 12.0 + 20.0 - 8.0;
//    } else {
//        NSInteger items = floorf(currentOffset / itemWidth);
//        newTargetOffset = items * itemWidth + (items - 1) * 12.0 + 20.0 - 8.0;
//    }
//
//    targetContentOffset->x = newTargetOffset;
//    [scrollView setContentOffset: CGPointMake(newTargetOffset, 0.0) animated: YES];
//}

@end
