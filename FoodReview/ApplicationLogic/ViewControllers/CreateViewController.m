//
//  CreateViewController.m
//  FoodReview
//
//  Created by MTT on 18/05/2021.
//

#import "CreateViewController.h"
#import "PhotoCollectionViewCell.h"
#import "MBProgressHUD.h"
#import "RatingView.h"
#import "PlaceCollectionViewCell.h"
#import "Review.h"
#import "FUIAuthStrings.h"
#import "User.h"
#import "Place.h"
#import "CustomTextField.h"
#import "SearchPlacesViewController.h"
#import "DetailReviewViewController.h"


@interface CreateViewController ()<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, RatingViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *createButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *placeView;
@property (nonatomic, strong) UILabel *selectPlace;
@property (nonatomic, strong) PlaceCollectionViewCell *placeCell;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UILabel *rateLabel;

@property (nonatomic, strong) CustomTextField *titleTextField;
@property (nonatomic, strong) CustomTextField *hashtagTextField;
@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, strong) RatingView *overallRating;
@property (nonatomic, strong) RatingView *priceRating;
@property (nonatomic, strong) RatingView *smellRating;
@property (nonatomic, strong) RatingView *serveRating;
@property (nonatomic, strong) RatingView *hygieneRating;
@property (nonatomic, strong) RatingView *spaceRating;

@property (nonatomic, strong) NSMutableArray<UIImage *> *images;
@property (nonatomic, strong) NSMutableArray<NSString *> *imageUrls;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Place *place;

@end

@implementation CreateViewController {
    MBProgressHUD *hud;
    NSInteger uploadCount;
    SearchPlacesViewController *vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialize];
    [self setupViews];
}

- (void)setPresenter:(id<CreateReviewPresenter>)presenter {
    _presenter = presenter;
    presenter.output = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupAppearances];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 100);
}

#pragma mark - Initialize

- (void)initialize {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"Tạo bài viết";
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    self.createButton = [[UIBarButtonItem alloc] initWithTitle:@"Tạo" style:UIBarButtonItemStyleDone target:self action:@selector(didPressCreateButton:)];
    self.navigationItem.rightBarButtonItem = self.createButton;

    [self.presenter viewDidLoad];
}

#pragma mark - SetupAppearances

- (void)setupAppearances {
    FIRUser *user = [[FIRAuth auth] currentUser];
    if (user) {
        self.createButton.enabled = YES;
        self.user = [[User alloc] initWithUserId:user.uid userName:@"" displayName:@"" email:user.email];
    } else {
        self.createButton.enabled = NO;
    }
}

- (NSMutableArray<UIImage *> *)images {
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

- (NSMutableArray<NSString *> *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = [[NSMutableArray alloc] init];
    }
    return _imageUrls;
}

#pragma mark - SetupViews

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:PhotoCollectionViewCell.identifier];
    }
    return _collectionView;
}

- (UIView *)placeView {
    if (!_placeView) {
        _placeView = [[UIView alloc] init];
        _placeView.backgroundColor = UIColor.systemGray5Color;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPlaceView:)];
        [_placeView addGestureRecognizer:tap];
    }
    return _placeView;
}

- (PlaceCollectionViewCell *)placeCell {
    if (!_placeCell) {
        _placeCell = [[PlaceCollectionViewCell alloc] init];
        _placeCell.hidden = YES;
    }
    return _placeCell;
}

- (UILabel *)selectPlace {
    if (!_selectPlace) {
        _selectPlace = [[UILabel alloc] init];
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [[UIImage systemImageNamed:@"location.fill.viewfinder"] imageWithTintColor:UIColor.systemBlueColor renderingMode:UIImageRenderingModeAlwaysTemplate];

        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
        NSMutableAttributedString *addString = [[NSMutableAttributedString alloc] initWithString:@"Nhấn vào đây để chọn địa điểm"];
        [title appendAttributedString:addString];
        
        _selectPlace.attributedText = title;
        _selectPlace.textColor = UIColor.systemBlueColor;
        _selectPlace.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
    }
    return _selectPlace;
}

- (UILabel *)placeLabel {
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.text = @"Địa điểm";
        _placeLabel.textColor = [UIColor labelColor];
        _placeLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _placeLabel;
}

- (UILabel *)rateLabel {
    if (!_rateLabel) {
        _rateLabel = [[UILabel alloc] init];
        _rateLabel.text = @"Đánh giá";
        _rateLabel.textColor = [UIColor labelColor];
        _rateLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _rateLabel;
}

- (CustomTextField *)hashtagTextField {
    if (!_hashtagTextField) {
        _hashtagTextField = [[CustomTextField alloc] init];
        _hashtagTextField.isSmallSpace = YES;
        _hashtagTextField.placeholder = @"Nhập hashtag";
        _hashtagTextField.delegate = self;
        _hashtagTextField.secureTextEntry = NO;
        _hashtagTextField.returnKeyType = UIReturnKeyDefault;
        _hashtagTextField.keyboardType = UIKeyboardTypeDefault;
        _hashtagTextField.textContentType = UITextContentTypeUsername;
        _hashtagTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _hashtagTextField.textColor = [UIColor colorWithHex:0xb0b3c6];
        _hashtagTextField.font = [UIFont systemFontOfSize:16];
        _hashtagTextField.clipsToBounds = YES;
        _hashtagTextField.layer.cornerRadius = 8.0;
        _hashtagTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _hashtagTextField.layer.borderWidth = 1.0;
        [_hashtagTextField addTarget:self
                               action:@selector(textFieldDidChange)
                     forControlEvents:UIControlEventEditingChanged];
    }

    return _hashtagTextField;
}

- (CustomTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[CustomTextField alloc] init];
        _titleTextField.isSmallSpace = YES;
        _titleTextField.placeholder = @"Nhập tiêu đề";
        _titleTextField.delegate = self;
        _titleTextField.secureTextEntry = NO;
        _titleTextField.returnKeyType = UIReturnKeyNext;
        _titleTextField.keyboardType = UIKeyboardTypeDefault;
        _titleTextField.textContentType = UITextContentTypeGivenName;
        _titleTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _titleTextField.textColor = [UIColor blackColor];
        _titleTextField.font = [UIFont boldSystemFontOfSize:16.0];
        _titleTextField.clipsToBounds = YES;
        _titleTextField.layer.cornerRadius = 8.0;
        _titleTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _titleTextField.layer.borderWidth = 1.0;
        [_titleTextField addTarget:self
                                  action:@selector(textFieldDidChange)
                        forControlEvents:UIControlEventEditingChanged];
    }

    return _titleTextField;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.text = @"Nội dung";
        _contentTextView.delegate = self;
        _contentTextView.textColor = [UIColor colorWithHex:0xb0b3c6];
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.clipsToBounds = YES;
        _contentTextView.layer.cornerRadius = 8.0;
        _contentTextView.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _contentTextView.layer.borderWidth = 1.0;
    }

    return _contentTextView;
}

- (RatingView *)overallRating {
    if (!_overallRating) {
        _overallRating = [[RatingView alloc] init];
        _overallRating.ratingName.text = @"Tổng thể";
        _overallRating.ratingName.font = [UIFont boldSystemFontOfSize:14.0];
        _overallRating.delegate = self;
        _overallRating.ratingView.enabled = NO;
    }
    return _overallRating;
}

- (RatingView *)priceRating {
    if (!_priceRating) {
        _priceRating = [[RatingView alloc] init];
        _priceRating.ratingName.text = @"Giá cả";
        _priceRating.delegate = self;
    }
    return _priceRating;
}

- (RatingView *)smellRating {
    if (!_smellRating) {
        _smellRating = [[RatingView alloc] init];
        _smellRating.ratingName.text = @"Hương vị";
        _smellRating.delegate = self;
    }
    return _smellRating;
}

- (RatingView *)serveRating {
    if (!_serveRating) {
        _serveRating = [[RatingView alloc] init];
        _serveRating.ratingName.text = @"Phục vụ";
        _serveRating.delegate = self;
    }
    return _serveRating;
}

- (RatingView *)hygieneRating {
    if (!_hygieneRating) {
        _hygieneRating = [[RatingView alloc] init];
        _hygieneRating.ratingName.text = @"Vệ sinh";
        _hygieneRating.delegate = self;
    }
    return _hygieneRating;
}

- (RatingView *)spaceRating {
    if (!_spaceRating) {
        _spaceRating = [[RatingView alloc] init];
        _spaceRating.ratingName.text = @"Không gian";
        _spaceRating.delegate = self;
    }
    return _spaceRating;
}


- (void)setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.collectionView];
    [self.scrollView addSubview:self.titleTextField];
    [self.scrollView addSubview:self.contentTextView];
    [self.scrollView addSubview:self.hashtagTextField];
    [self.scrollView addSubview:self.placeLabel];
    [self.scrollView addSubview:self.placeView];
    [self.scrollView addSubview:self.rateLabel];
    [self.scrollView addSubview:self.overallRating];
    [self.scrollView addSubview:self.smellRating];
    [self.scrollView addSubview:self.hygieneRating];
    [self.scrollView addSubview:self.priceRating];
    [self.scrollView addSubview:self.spaceRating];
    [self.scrollView addSubview:self.serveRating];
    
    [self.placeView addSubview:self.selectPlace];
    [self.placeView addSubview:self.placeCell];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.mas_equalTo(120.0);
    }];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(14.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(8.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-8.0);
        make.height.mas_equalTo(36.0);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTextField.mas_bottom).offset(8.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(8.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-8.0);
        make.height.mas_equalTo(150.0);
    }];
    
    [self.hashtagTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).offset(8.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(8.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-8.0);
        make.height.mas_equalTo(36.0);
    }];
    
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hashtagTextField.mas_bottom).offset(20.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(8.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-8.0);
        make.height.mas_equalTo(24.0);
    }];
    
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.placeLabel.mas_bottom).offset(8.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(8.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-8.0);
        make.height.mas_equalTo(80.0);
    }];
    
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.placeView.mas_bottom).offset(10.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(8.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-8.0);
        make.height.mas_equalTo(30.0);
    }];
    
    [self.overallRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rateLabel.mas_bottom).offset(4.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(14.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(30.0);
    }];
    
    [self.smellRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.overallRating.mas_bottom).offset(4.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(14.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(30.0);
    }];
    
    [self.hygieneRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.smellRating.mas_bottom).offset(4.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(14.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(30.0);
    }];
    
    [self.priceRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hygieneRating.mas_bottom).offset(4.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(14.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(30.0);
    }];
    
    [self.spaceRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceRating.mas_bottom).offset(4.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(14.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(30.0);
    }];
    
    [self.serveRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spaceRating.mas_bottom).offset(4.0);
        make.leading.equalTo(self.scrollView.mas_leading).offset(14.0);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(30.0);
    }];
    
    [self.selectPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.placeView);
    }];
    
    [self.placeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.placeView);
    }];
}

#pragma mark - Utilities

- (NSString *)getDateStringFromDate:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd/MM/yyyy";
    NSString *stringDate = [format stringFromDate:date];
    return stringDate;
}

- (void)dismissNavigationControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.navigationController.presentingViewController == nil){
        if (completion){
            completion();
        }
    } else {
        [self.navigationController dismissViewControllerAnimated:animated completion:completion];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField == _userNameTextField) {
//        [_displayNameTextField becomeFirstResponder];
//    } else if (textField == _displayNameTextField) {
//        [_emailTextField becomeFirstResponder];
//    } else if (textField == _emailTextField) {
//        [_passwordTextField becomeFirstResponder];
//    } else if (textField == _passwordTextField) {
//        [self signUpWithEmail:_emailTextField.text andPassword:_passwordTextField.text andUsername:_userNameTextField.text];
//    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Nội dung"]) {
         textView.text = @"";
         textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Nội dung";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - Action

- (void)textFieldDidChange {
    [self didChangeUserName:self.hashtagTextField.text orDisplayName:self.titleTextField.text];
}

- (void)didChangeUserName:(NSString *)username orDisplayName:(NSString *)displayName {
    BOOL enableActionButton = username.length > 0 && displayName.length > 0;

    //self.createButton.enabled = enableActionButton;
}

- (void)didPressCreateButton:(UIButton *)sender {
    [self createReview];
}

- (void)didTapPlaceView:(UITapGestureRecognizer *)gestureRecognizer {
    vc = [[SearchPlacesViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.didSelectedPlace = ^(Place * _Nonnull place) {
        weakSelf.place = place;
        [weakSelf.placeCell configueWithPlace:place andDistance:@""];
        weakSelf.placeCell.hidden = NO;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectedImage;
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    if (editedImage) {
        selectedImage = editedImage;
    } else {
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        selectedImage = originalImage;
    }

    if (selectedImage) {
        [self.images addObject:selectedImage];
        [self.collectionView reloadData];
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count + 1;
}

#pragma mark - UICollectionViewDatasource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionViewCell.identifier forIndexPath:indexPath];
    
    if (indexPath.item == self.images.count) {
        [cell configCellAddImage];
    } else {
        [cell configCellWithImage:self.images[indexPath.item]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.images.count) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = collectionView.frame.size.height - 8.0 * 2;

    return CGSizeMake(itemHeight, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
}

- (void)didChangeValue:(NSInteger)value {
    float rate = (self.smellRating.rate + self.hygieneRating.rate + self.priceRating.rate + self.spaceRating.rate + self.serveRating.rate) / 5.0;
    
    self.overallRating.ratingView.value = rate / 2.0;
    self.overallRating.rate = rate;
    
    switch ((int)self.overallRating.ratingView.value) {
        case 1:
            self.overallRating.rating.text = @"Tệ";
            break;
        case 2:
            self.overallRating.rating.text = @"Cần cải thiện";
            break;
        case 3:
            self.overallRating.rating.text = @"Bình thường";
            break;
        case 4:
            self.overallRating.rating.text = @"Tốt";
            break;
        case 5:
            self.overallRating.rating.text = @"Xuất sắc";
            break;
        default:
            self.overallRating.rating.text = @"";
            break;
    }
}

-(void)createReview {
    if (!self.user) {
        [Common alertWithRootView:self.view message:@"Bạn cần đăng nhập để tạo bài viết!"];
        return;
    }
    
    if (self.images.count == 0) {
        [Common alertWithRootView:self.view message:@"Bạn cần chọn hình ảnh cho bài viết!"];
        return;
    }
    
    if (!self.place) {
        [Common alertWithRootView:self.view message:@"Bạn cần chọn một địa điểm!"];
        return;
    }
    
    if (self.titleTextField.text.length == 0) {
        [Common alertWithRootView:self.view message:@"Bạn cần nhập tên bài viết!"];
        [self.titleTextField becomeFirstResponder];
        return;
    }
    
    if (self.contentTextView.text.length == 0) {
        [Common alertWithRootView:self.view message:@"Bạn cần nhập nội dung bài viết!"];
        [self.contentTextView becomeFirstResponder];
        return;
    }
    
    if (self.hashtagTextField.text.length == 0) {
        [Common alertWithRootView:self.view message:@"Bạn cần nhập hashtag cho bài viết!"];
        [self.hashtagTextField becomeFirstResponder];
        return;
    }
    
    if (self.overallRating.rate <= 0) {
        [Common alertWithRootView:self.view message:@"Bạn cần chấm điểm cho địa điểm!"];
        [self.titleTextField becomeFirstResponder];
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Đăng bài ...";

    uploadCount = 0;
    for (UIImage *image in self.images) {
        [self uploadImage:image completion:^(NSString * _Nullable tringUrl, NSError * _Nullable error) {
            self->uploadCount += 1;
            if (error) {
                [Common alertWithRootView:self.view message:error.localizedDescription];
            } else {
                [self.imageUrls addObject:tringUrl];
            }
            if (self->uploadCount == self.images.count) {
                [self uploadReview];
            }
        }];
    }
}

-(void)uploadReview {
    Review *review = [[Review alloc] initWithTitle:self.titleTextField.text subtitle:self.contentTextView.text createdDate:[NSDate date] totalViews:0 userId:self.user.userId placeId:self.place.placeId hashtags:@[self.hashtagTextField.text] andImages:self.imageUrls];
    
    Rating *rating = [[Rating alloc] init];
    rating.overall = self.overallRating.rate;
    rating.price = self.priceRating.rate;
    rating.smell = self.smellRating.rate;
    rating.space = self.spaceRating.rate;
    rating.hygiene = self.hygieneRating.rate;
    rating.serve = self.serveRating.rate;
    review.rate = rating;
    
    FIRFirestore *store = [FIRFirestore firestore];
    FIRDocumentReference *reviewRef = [[store collectionWithPath:@"reviews"] documentWithAutoID];
    FIRDocumentReference *userRef = [[store collectionWithPath:@"users"] documentWithPath:self.user.userId];
    
    review.reviewId = reviewRef.documentID;
    
    [store runTransactionWithBlock:^id _Nullable(FIRTransaction * _Nonnull transaction, NSError *__autoreleasing  _Nullable * _Nullable errorPointer) {
        FIRDocumentSnapshot *userDocument = [transaction getDocument:userRef error:errorPointer];
        
        if (*errorPointer != nil) { return nil; }
        
        review.userName = userDocument.data[@"displayName"];
        review.userAvatar = userDocument.data[@"profileImageUrl"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[review getDictionary]];
        [transaction setData:dict forDocument:reviewRef];
        return nil;
    } completion:^(id  _Nullable result, NSError * _Nullable error) {
        [self->hud hideAnimated:YES];
        
        if (error) {
            [Common alertWithRootView:self.view message:error.localizedDescription];
            return;
        }
        
        [self updatePlaceWithReview:review];
    }];
}

-(void)updatePlaceWithReview:(Review *)review {
    FIRDatabase *database = [FIRDatabase databaseWithURL:@"https://food-review-94b9e-default-rtdb.asia-southeast1.firebasedatabase.app"];
    FIRDatabaseReference *restaurantsRef = [database referenceWithPath:@"restaurants"];
    FIRDatabaseQuery *placeQuery = [[restaurantsRef queryOrderedByChild:@"Id"] queryEqualToValue:[NSNumber numberWithInteger:review.placeId]];
    
    [placeQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        for (FIRDataSnapshot *child in snapshot.children) {
            FIRDatabaseReference *placeRef = child.ref;
            [placeRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
                NSMutableDictionary *place = currentData.value;
                if (!place || [place isEqual:[NSNull null]]) {
                    return [FIRTransactionResult successWithValue:currentData];
                }
                
                NSInteger totalReviews = [place[@"TotalReview"] integerValue];
                float avgRatingOriginal = [place[@"AvgRatingOriginal"] floatValue];
                avgRatingOriginal = (avgRatingOriginal * totalReviews + review.rate.overall) / (totalReviews + 1);
                
                place[@"TotalReview"] = @(totalReviews + 1);
                place[@"AvgRatingOriginal"] = @(avgRatingOriginal);
                place[@"AvgRating"] = [NSString stringWithFormat:@"%.1f", avgRatingOriginal];
                
                // Set value and report transaction success
                currentData.value = place;
                return [FIRTransactionResult successWithValue:currentData];
            } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                [Common alertWithRootView:self.view message:@"Đăng bài viết thành công"];
                DetailReviewViewController *vc = [[DetailReviewViewController alloc] init];
                vc.review = review;
                [self.navigationController pushViewController:vc animated:YES];
            }];

            break;
        }
    }];
}

-(void)uploadImage:(UIImage *)image completion:(void (^)(NSString* _Nullable tringUrl, NSError* _Nullable error))completion {
    NSString *imageName = [NSUUID UUID].UUIDString;
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    FIRStorage *storage = [FIRStorage storage];
    // Create a root reference
    FIRStorageReference *storageRef = [storage reference];
    // Create a reference to the file you want to upload
    FIRStorageReference *photoRef = [[[[storageRef child:@"reviewPhoto"] child:[NSString stringWithFormat:@"%@", self.user.userId]] child:[NSString stringWithFormat:@"%ld", (long)self.place.placeId]] child:[NSString stringWithFormat:@"%@.jpg", imageName]];
    
    [photoRef putData:data
             metadata:nil
           completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            completion(nil, error);
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            // You can also access to download URL after upload.
            [photoRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error != nil) {
                    completion(nil, error);
                } else {
                    NSString *stringUrl = [URL absoluteString];
                    completion(stringUrl, nil);
                }
            }];
        }
    }];
}


@end
