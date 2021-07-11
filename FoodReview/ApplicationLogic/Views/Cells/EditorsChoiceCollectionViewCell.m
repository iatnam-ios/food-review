//
//  EditorsChoiceCollectionViewCell.m
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import "EditorsChoiceCollectionViewCell.h"
#import "NewDishCollectionViewCell.h"
#import "ListPlacesViewController.h"
#import "TabBarController.h"

@interface EditorsChoiceCollectionViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation EditorsChoiceCollectionViewCell

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
    return @"reuseEditorsChoiceCollectionViewCell";
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
    return self.editorsChoice.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewDishCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewDishCollectionViewCell.identifier forIndexPath:indexPath];
//    if (indexPath.item == 0) {
//        cell.titleLabel.text = @"Phở";
//        [cell.artwork sd_setImageWithURL:[NSURL URLWithString:@"https://firebasestorage.googleapis.com/v0/b/food-review-94b9e.appspot.com/o/reviewPhoto%2Fhuong-dan-chi-tiet-cach-nau-pho-bo-thom-ngon-bo-duong-cho-ca-nha.png?alt=media&token=2cc4b10b-c6f6-47fa-8e2a-f8021a9bc688"]];
//    } else {
//        cell.titleLabel.text = @"Cơm tấm";
//        [cell.artwork sd_setImageWithURL:[NSURL URLWithString:@"https://firebasestorage.googleapis.com/v0/b/food-review-94b9e.appspot.com/o/reviewPhoto%2Fcom-tam-la-mon-an-binh-dan.jpg?alt=media&token=53d969a6-8ce5-491b-b4be-b682a59f0b2c"]];
//    }
    
    Category *category = self.editorsChoice[indexPath.item];
    [cell configCellWithPlace:category];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Category *category = self.editorsChoice[indexPath.item];
    ListPlacesViewController *vc = [[ListPlacesViewController alloc] init];
    vc.category = category;
    
    [TabBarController.sharedInstance.homeViewController.navigationController pushViewController:vc animated:YES];
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
//    CGFloat itemWidth = (self.collectionView.frame.size.width - 20.0 - 12.0) / 3.0 * 2.0;
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
