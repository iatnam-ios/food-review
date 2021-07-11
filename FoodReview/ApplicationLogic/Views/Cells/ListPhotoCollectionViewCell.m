//
//  ListPhotoCollectionViewCell.m
//  FoodReview
//
//  Created by MTT on 08/07/2021.
//

#import "ListPhotoCollectionViewCell.h"
#import "PhotoCollectionViewCell.h"

@interface ListPhotoCollectionViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation ListPhotoCollectionViewCell

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

- (void)setPhotos:(NSArray<NSString *> *)photos {
    _photos = photos;
    self.countLabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)photos.count];
}

#pragma mark - Identifier

+ (NSString *)identifier {
    return @"reuseListPhotoCollectionViewCell";
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
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:PhotoCollectionViewCell.identifier];
    }
    return _collectionView;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        _countLabel.textColor = UIColor.whiteColor;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        _countLabel.layer.masksToBounds = YES;
        _countLabel.layer.cornerRadius = 8.0;
    }
    return _countLabel;
}

- (void)setupViews {
    [self addSubview: self.collectionView];
    [self addSubview:self.countLabel];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).offset(-18.0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10.0);
        make.height.mas_equalTo(22.0);
        make.width.mas_equalTo(36.0);
    }];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionViewCell.identifier forIndexPath:indexPath];
    
    NSString *stringUrl = self.photos[indexPath.item];
    [cell configCellWithImageUrl:[NSURL URLWithString:stringUrl]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat itemWidth = scrollView.frame.size.width;
    CGFloat targetOffset = scrollView.contentOffset.x;
    
    if (targetOffset <= 0) {
        targetOffset = 0;
    }
    
    int value = floorf(targetOffset / itemWidth) + 1;
    
    self.countLabel.text = [NSString stringWithFormat:@"%d/%lu", value, (unsigned long)self.photos.count];
}

@end
