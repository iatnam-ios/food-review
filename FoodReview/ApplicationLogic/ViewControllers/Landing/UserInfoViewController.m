//
//  UserInfoViewController.m
//  FoodReview
//
//  Created by MTT on 07/06/2021.
//

#import "UserInfoViewController.h"
#import "CustomTextField.h"
#import "MBProgressHUD.h"
#import "ActionSheetPicker.h"

NSString * const kMaleGender = @"Nam";
NSString * const kFemaleGender = @"Nữ";
NSString * const kOtherGender = @"Khác";

@interface UserInfoViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *backingView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *displayNameLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *genderLabel;
@property (nonatomic, strong) UILabel *birthdayLabel;

@property (nonatomic, strong) CustomTextField *displayNameTextField;
@property (nonatomic, strong) CustomTextField *userNameTextField;
@property (nonatomic, strong) CustomTextField *emailTextField;
@property (nonatomic, strong) CustomTextField *descriptionTextField;
@property (nonatomic, strong) CustomTextField *genderTextField;
@property (nonatomic, strong) CustomTextField *birthdayTextField;

@end

@implementation UserInfoViewController {
    MBProgressHUD *hud;
    NSDate *selectedDate;
    NSInteger selectedGender;
    BOOL isChangedAvatar;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialize];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupAppearances];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Initialize

- (void)initialize {
    self.view.backgroundColor = UIColor.whiteColor;
    selectedDate = self.user.birthday;
    selectedGender = self.user.gender;
    isChangedAvatar = NO;
}

#pragma mark - SetupAppearances

- (void)setupAppearances {
    NSString *stringUrl = self.user.profileImageUrl;
    self.emailTextField.text = self.user.email;
    if (stringUrl && (![stringUrl isEqualToString:@""])) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:stringUrl] placeholderImage:[UIImage imageNamed:@"avatar-default"]];
    } else {
        self.imageView.image = [UIImage imageNamed:@"avatar-default"];
    }
    if (self.user.displayName) {
        self.displayNameTextField.text = self.user.displayName;
    }
    if (self.user.userName) {
        self.userNameTextField.text = self.user.userName;
    }
    if (self.user.userDescription) {
        self.descriptionTextField.text = self.user.userDescription;
    }
    if (self.user.birthday) {
        self.birthdayTextField.text = [self getDateStringFromDate:self.user.birthday];
    }
    switch (self.user.gender) {
        case MaleGender:
            self.genderTextField.text = kMaleGender;
            break;
        case FemaleGender:
            self.genderTextField.text = kFemaleGender;
            break;
        case OtherGender:
            self.genderTextField.text = kOtherGender;
            break;
        default:
            break;
    }
}

#pragma mark - SetupViews
- (UIView *)backingView {
    if (!_backingView) {
        _backingView = [[UIView alloc] init];
        _backingView.backgroundColor = UIColor.clearColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackingView:)];
        [_backingView addGestureRecognizer:tap];
    }
    return _backingView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 40;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)displayNameLabel {
    if (!_displayNameLabel) {
        _displayNameLabel = [[UILabel alloc] init];
        _displayNameLabel.text = @"Họ và tên";
        _displayNameLabel.textColor = [UIColor labelColor];
        _displayNameLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _displayNameLabel;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.text = @"Tên đăng nhập";
        _userNameLabel.textColor = [UIColor labelColor];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _userNameLabel;
}

- (UILabel *)emailLabel {
    if (!_emailLabel) {
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.text = @"Email";
        _emailLabel.textColor = [UIColor labelColor];
        _emailLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _emailLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.text = @"Mô tả";
        _descriptionLabel.textColor = [UIColor labelColor];
        _descriptionLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _descriptionLabel;
}

- (UILabel *)genderLabel {
    if (!_genderLabel) {
        _genderLabel = [[UILabel alloc] init];
        _genderLabel.text = @"Giới tính";
        _genderLabel.textColor = [UIColor labelColor];
        _genderLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _genderLabel;
}

- (UILabel *)birthdayLabel {
    if (!_birthdayLabel) {
        _birthdayLabel = [[UILabel alloc] init];
        _birthdayLabel.text = @"Ngày sinh";
        _birthdayLabel.textColor = [UIColor labelColor];
        _birthdayLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _birthdayLabel;
}

- (UIButton *)updateButton {
    if (!_updateButton) {
        _updateButton = [[UIButton alloc] init];
        _updateButton.enabled = NO;
        _updateButton.layer.cornerRadius = 6.0;
        _updateButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        [_updateButton setTitle:@"Cập nhật" forState:UIControlStateNormal];
        [_updateButton setBackgroundColor:[UIColor colorWithHex:0x334d92]];
        [_updateButton setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
        [_updateButton setTitleColor:[UIColor colorWithHex:0xff5a66] forState:UIControlStateNormal];
        [_updateButton addTarget:self action:@selector(didPressUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        _selectButton.enabled = NO;
        _selectButton.backgroundColor = UIColor.blackColor;
        _selectButton.tintColor = UIColor.lightGrayColor;
        _selectButton.layer.cornerRadius = 10.0;
        _selectButton.layer.masksToBounds = YES;
        UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:12 weight:UIImageSymbolWeightLight];
        [_selectButton setImage:[UIImage systemImageNamed:@"photo" withConfiguration:configuration] forState:UIControlStateNormal];
    }
    return _selectButton;
}

- (CustomTextField *)userNameTextField {
    if (!_userNameTextField) {
        _userNameTextField = [[CustomTextField alloc] init];
        _userNameTextField.placeholder = @"Chưa có thông tin";
        _userNameTextField.delegate = self;
        _userNameTextField.secureTextEntry = NO;
        _userNameTextField.returnKeyType = UIReturnKeyDefault;
        _userNameTextField.keyboardType = UIKeyboardTypeDefault;
        _userNameTextField.textContentType = UITextContentTypeUsername;
        _userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _userNameTextField.textColor = [UIColor colorWithHex:0xb0b3c6];
        _userNameTextField.font = [UIFont systemFontOfSize:16];
        _userNameTextField.clipsToBounds = YES;
        _userNameTextField.layer.cornerRadius = 20.0;
        _userNameTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _userNameTextField.layer.borderWidth = 1.0;
        [_userNameTextField addTarget:self
                               action:@selector(textFieldDidChange)
                     forControlEvents:UIControlEventEditingChanged];
    }
    
    return _userNameTextField;
}

- (CustomTextField *)displayNameTextField {
    if (!_displayNameTextField) {
        _displayNameTextField = [[CustomTextField alloc] init];
        _displayNameTextField.placeholder = @"Chưa có thông tin";
        _displayNameTextField.delegate = self;
        _displayNameTextField.secureTextEntry = NO;
        _displayNameTextField.returnKeyType = UIReturnKeyNext;
        _displayNameTextField.keyboardType = UIKeyboardTypeDefault;
        _displayNameTextField.textContentType = UITextContentTypeGivenName;
        _displayNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _displayNameTextField.textColor = [UIColor colorWithHex:0xb0b3c6];
        _displayNameTextField.font = [UIFont systemFontOfSize:16];
        _displayNameTextField.clipsToBounds = YES;
        _displayNameTextField.layer.cornerRadius = 20.0;
        _displayNameTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _displayNameTextField.layer.borderWidth = 1.0;
        [_displayNameTextField addTarget:self
                                  action:@selector(textFieldDidChange)
                        forControlEvents:UIControlEventEditingChanged];
    }
    
    return _displayNameTextField;
}

- (CustomTextField *)emailTextField {
    if (!_emailTextField) {
        _emailTextField = [[CustomTextField alloc] init];
        _emailTextField.userInteractionEnabled = NO;
        _emailTextField.textColor = [UIColor colorWithHex:0xb0b3c6];
        _emailTextField.font = [UIFont systemFontOfSize:16];
        _emailTextField.clipsToBounds = YES;
        _emailTextField.layer.cornerRadius = 20.0;
        _emailTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _emailTextField.layer.borderWidth = 1.0;
    }
    
    return _emailTextField;
}

- (CustomTextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[CustomTextField alloc] init];
        _descriptionTextField.placeholder = @"Chưa có thông tin";
        _descriptionTextField.delegate = self;
        _descriptionTextField.textColor = [UIColor colorWithHex:0xb0b3c6];
        _descriptionTextField.font = [UIFont systemFontOfSize:16];
        _descriptionTextField.clipsToBounds = YES;
        _descriptionTextField.layer.cornerRadius = 20.0;
        _descriptionTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _descriptionTextField.layer.borderWidth = 1.0;
    }
    
    return _descriptionTextField;
}

- (CustomTextField *)genderTextField {
    if (!_genderTextField) {
        _genderTextField = [[CustomTextField alloc] init];
        _genderTextField.placeholder = @"Chưa có thông tin";
        _genderTextField.delegate = self;
        _genderTextField.returnKeyType = UIReturnKeyDefault;
        _genderTextField.keyboardType = UIKeyboardTypeDefault;
        _genderTextField.textColor = [UIColor colorWithHex:0xb0b3c6];
        _genderTextField.font = [UIFont systemFontOfSize:16];
        _genderTextField.clipsToBounds = YES;
        _genderTextField.layer.cornerRadius = 20.0;
        _genderTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _genderTextField.layer.borderWidth = 1.0;
    }
    
    return _genderTextField;
}

- (CustomTextField *)birthdayTextField {
    if (!_birthdayTextField) {
        _birthdayTextField = [[CustomTextField alloc] init];
        _birthdayTextField.placeholder = @"Chưa có thông tin";
        _birthdayTextField.delegate = self;
        _birthdayTextField.textColor = [UIColor colorWithHex:0xb0b3c6];
        _birthdayTextField.font = [UIFont systemFontOfSize:16];
        _birthdayTextField.clipsToBounds = YES;
        _birthdayTextField.layer.cornerRadius = 20.0;
        _birthdayTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _birthdayTextField.layer.borderWidth = 1.0;
    }
    
    return _birthdayTextField;
}

- (void)setupViews {
    [self.view addSubview:self.updateButton];
    [self.view addSubview:self.backingView];
    
    [self.backingView addSubview:self.imageView];
    [self.backingView addSubview:self.selectButton];
    
    [self.view addSubview:self.displayNameLabel];
    [self.view addSubview:self.displayNameTextField];
    
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.userNameTextField];
    
    [self.view addSubview:self.emailLabel];
    [self.view addSubview:self.emailTextField];
    
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.descriptionTextField];
    
    [self.view addSubview:self.genderLabel];
    [self.view addSubview:self.genderTextField];
    
    [self.view addSubview:self.birthdayLabel];
    [self.view addSubview:self.birthdayTextField];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(4.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-12.0);
        make.height.mas_equalTo(32.0);
        make.width.mas_equalTo(66.0);
    }];
    
    [self.backingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updateButton.mas_bottom).offset(4.0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.mas_equalTo(80.0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backingView);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.backingView.mas_trailing);
        make.bottom.equalTo(self.backingView.mas_bottom);
        make.width.height.mas_equalTo(20.0);
    }];
    
    [self.displayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.backingView.mas_bottom).offset(24.0);
    }];
    
    [self.displayNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.displayNameLabel.mas_bottom).offset(10.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.displayNameTextField.mas_bottom).offset(20.0);
    }];
    
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(10.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.userNameTextField.mas_bottom).offset(20.0);
    }];
    
    [self.descriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(10.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.descriptionTextField.mas_bottom).offset(20.0);
    }];
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.emailLabel.mas_bottom).offset(10.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.emailTextField.mas_bottom).offset(20.0);
    }];
    
    [self.genderTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.genderLabel.mas_bottom).offset(10.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.genderTextField.mas_bottom).offset(20.0);
    }];
    
    [self.birthdayTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20.0);
        make.top.equalTo(self.birthdayLabel.mas_bottom).offset(10.0);
        make.height.mas_equalTo(40.0);
    }];
}

#pragma mark - Utilities

- (NSString *)getDateStringFromDate:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd/MM/yyyy";
    NSString *stringDate = [format stringFromDate:date];
    return stringDate;
}

- (void)updateUserInfo {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Đang cập nhật ...";
    
    NSData *data = UIImageJPEGRepresentation(self.imageView.image, 0.1);
    
    if (isChangedAvatar && data) {
        NSString *imageName = [NSUUID UUID].UUIDString;
        
        FIRStorage *storage = [FIRStorage storage];
        // Create a root reference
        FIRStorageReference *storageRef = [storage reference];
        // Create a reference to the file you want to upload
        FIRStorageReference *avatarRef = [[storageRef child:@"avatars"] child:[NSString stringWithFormat:@"%@/%@.jpg", self.user.userId, imageName]];
        
        // Upload the file to the path "avatars/userId/imageName.jpg"
        FIRStorageUploadTask *uploadTask = [avatarRef putData:data
                                                     metadata:nil
                                                   completion:^(FIRStorageMetadata *metadata,
                                                                NSError *error) {
            if (error != nil) {
                // Uh-oh, an error occurred!
                [self updateUserInfoWithProfileImageUrl:nil];
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                // You can also access to download URL after upload.
                [avatarRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        [self updateUserInfoWithProfileImageUrl:nil];
                    } else {
                        NSString *stringUrl = [URL absoluteString];
                        [self updateUserInfoWithProfileImageUrl:stringUrl];
                    }
                }];
            }
        }];
    } else {
        [self updateUserInfoWithProfileImageUrl:nil];
    }
}

- (void)updateUserInfoWithProfileImageUrl:(nullable NSString *)stringUrl {
    FIRFirestore *store = [FIRFirestore firestore];
    FIRWriteBatch *batch = [store batch];
    FIRCollectionReference *collection = [store collectionWithPath:@"users"];
    FIRDocumentReference *userRef = [collection documentWithPath:self.user.userId];
    
    if (stringUrl) {
        [batch updateData:@{kProfileImageUrl : stringUrl} forDocument:userRef];
    }
    
    NSString *displayName = self.displayNameTextField.text;
    if (displayName.length > 0 && self.user.displayName != displayName) {
        [batch updateData:@{kDisplayName : displayName} forDocument:userRef];
    }
    
    NSString *userName = self.userNameTextField.text;
    if (userName.length > 0 && self.user.userName != userName) {
        [batch updateData:@{kUserName : userName} forDocument:userRef];
    }
    
    NSString *description = self.descriptionTextField.text;
    if (self.user.userName != description) {
        [batch updateData:@{kUserDescription : description} forDocument:userRef];
    }
    
    if (selectedGender != self.user.gender) {
        [batch updateData:@{kGender : [NSNumber numberWithInteger:selectedGender]} forDocument:userRef];
    }
    
    if (selectedDate != self.user.birthday) {
        [batch updateData:@{kBirthday : [FIRTimestamp timestampWithDate:selectedDate]} forDocument:userRef];
    }
    
    [batch commitWithCompletion:^(NSError * _Nullable error) {
        [self->hud hideAnimated:YES];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
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
    if (textField == _displayNameTextField || textField == _descriptionTextField) {
        return YES;
    }
    if (textField == _genderTextField) {
        NSInteger index = selectedGender;
        if (index == NoneGender) {
            index = OtherGender;
        }
        [ActionSheetStringPicker showPickerWithTitle:@"Chọn giới tính"
                                                rows:@[kMaleGender, kFemaleGender, kOtherGender]
                                    initialSelection:index
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self->selectedGender = selectedIndex;
            self.genderTextField.text = selectedValue;
            if (self.user.gender != selectedIndex) {
                [self didChangeUserName:self.userNameTextField.text orDisplayName:self.displayNameTextField.text];
            }
        }
                                         cancelBlock:nil
                                              origin:textField];
    } else if (textField == _birthdayTextField) {
        NSDate *date = selectedDate;
        if (date) {
            date = [NSDate date];
        }
        [ActionSheetDatePicker showPickerWithTitle:@"Chọn ngày sinh"
                                    datePickerMode:UIDatePickerModeDate
                                      selectedDate:date
                                         doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            self->selectedDate = selectedDate;
            self.birthdayTextField.text = [self getDateStringFromDate:selectedDate];
            if (self.user.birthday != selectedDate) {
                [self didChangeUserName:self.userNameTextField.text orDisplayName:self.displayNameTextField.text];
            }
        }
                                       cancelBlock:nil
                                            origin:textField];
    }
    return NO;
}

#pragma mark - Action

- (void)textFieldDidChange {
    [self didChangeUserName:self.userNameTextField.text orDisplayName:self.displayNameTextField.text];
}

- (void)didChangeUserName:(NSString *)username orDisplayName:(NSString *)displayName {
    BOOL enableActionButton = username.length > 0 && displayName.length > 0;

    self.updateButton.enabled = enableActionButton;
}

- (void)didPressUpdateButton:(UIButton *)sender {
    [self updateUserInfo];
}

- (void)didTapBackingView:(UITapGestureRecognizer *)gestureRecognizer {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
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
        self.imageView.image = selectedImage;
        isChangedAvatar = YES;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
