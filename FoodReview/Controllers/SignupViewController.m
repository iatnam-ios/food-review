//
//  SignupViewController.m
//  FoodReview
//
//  Created by MTT on 05/06/2021.
//

#import "SignupViewController.h"
#import "UserInfoViewController.h"
#import "CustomTextField.h"
#import "FUIAuthStrings.h"
#import "MBProgressHUD.h"
#import "User.h"

static NSString *const kEmailRegex = @".+@([a-zA-Z0-9\\-]+\\.)+[a-zA-Z0-9]{2,63}";

@interface SignupViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) CustomTextField *userNameTextField;
@property (nonatomic, strong) CustomTextField *displayNameTextField;
@property (nonatomic, strong) CustomTextField *emailTextField;
@property (nonatomic, strong) CustomTextField *passwordTextField;

@end

@implementation SignupViewController {
    MBProgressHUD *hud;
    User *user;
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

#pragma mark - Initialize

- (void)initialize {
    self.view.backgroundColor = UIColor.whiteColor;
}

#pragma mark - SetupAppearances

- (void)setupAppearances {
    user = nil;
}

#pragma mark - SetupViews

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"Đăng ký";
        _titleLabel.textColor = [UIColor colorWithHex:0xff5a66];
        _titleLabel.font = [UIFont boldSystemFontOfSize:36];
    }
    return _titleLabel;
}

- (UIButton *)createButton {
    if (!_createButton) {
        _createButton = [[UIButton alloc] init];
        _createButton.enabled = NO;
        _createButton.layer.cornerRadius = 20.0;
        _createButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_createButton setTitle:@"Tạo tài khoản" forState:UIControlStateNormal];
        [_createButton setBackgroundColor:[UIColor colorWithHex:0x334d92]];
        [_createButton setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
        [_createButton setTitleColor:[UIColor colorWithHex:0xff5a66] forState:UIControlStateNormal];
        [_createButton addTarget:self action:@selector(didPressCreateButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage systemImageNamed:@"chevron.backward"] forState:UIControlStateNormal];
        [_backButton setTintColor:UIColor.darkGrayColor];
        [_backButton addTarget:self action:@selector(didPressBackButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (CustomTextField *)userNameTextField {
    if (!_userNameTextField) {
        _userNameTextField = [[CustomTextField alloc] init];
        _userNameTextField.placeholder = @"Tên tài khoản";
        _userNameTextField.delegate = self;
        _userNameTextField.secureTextEntry = NO;
        _userNameTextField.returnKeyType = UIReturnKeyNext;
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
        _displayNameTextField.placeholder = @"Họ và tên";
        _displayNameTextField.delegate = self;
        _displayNameTextField.secureTextEntry = NO;
        _displayNameTextField.returnKeyType = UIReturnKeyNext;
        _displayNameTextField.keyboardType = UIKeyboardTypeDefault;
        _displayNameTextField.textContentType = UITextContentTypeName;
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
        _emailTextField.placeholder = @"Email";
        _emailTextField.delegate = self;
        _emailTextField.secureTextEntry = NO;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.textContentType = UITextContentTypeEmailAddress;
        _emailTextField.textColor = [UIColor colorWithHex:0xb0b3c6];
        _emailTextField.font = [UIFont systemFontOfSize:16];
        _emailTextField.clipsToBounds = YES;
        _emailTextField.layer.cornerRadius = 20.0;
        _emailTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _emailTextField.layer.borderWidth = 1.0;
        [_emailTextField addTarget:self
                            action:@selector(textFieldDidChange)
                  forControlEvents:UIControlEventEditingChanged];
    }
    
    return _emailTextField;
}

- (CustomTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[CustomTextField alloc] init];
        _passwordTextField.placeholder = @"Mật khẩu";
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.rightView = [self visibilityToggleButtonForPasswordField];
        _passwordTextField.rightViewMode = UITextFieldViewModeAlways;
        _passwordTextField.returnKeyType = UIReturnKeyNext;
        _passwordTextField.keyboardType = UIKeyboardTypeDefault;
        _passwordTextField.textContentType = UITextContentTypePassword;
        _passwordTextField.textColor = [UIColor colorWithHex:0xb0b3c6];
        _passwordTextField.font = [UIFont systemFontOfSize:16];
        _passwordTextField.clipsToBounds = YES;
        _passwordTextField.layer.cornerRadius = 20.0;
        _passwordTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _passwordTextField.layer.borderWidth = 1.0;
        [_passwordTextField addTarget:self
                               action:@selector(textFieldDidChange)
                     forControlEvents:UIControlEventEditingChanged];
    }
    
    return _passwordTextField;
}

- (void)setupViews {
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.userNameTextField];
    [self.view addSubview:self.displayNameTextField];
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.createButton];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(8.0);
        make.leading.equalTo(self.view.mas_leading).offset(14.0);
        make.width.height.mas_equalTo(36.0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.top.equalTo(self.backButton.mas_bottom).offset(50.0);
    }];
    
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.leading.equalTo(self.view.mas_leading).offset(40.0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.displayNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.leading.equalTo(self.view.mas_leading).offset(40.0);
        make.top.equalTo(self.userNameTextField.mas_bottom).offset(20.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.leading.equalTo(self.view.mas_leading).offset(40.0);
        make.top.equalTo(self.displayNameTextField.mas_bottom).offset(20.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.leading.equalTo(self.view.mas_leading).offset(40.0);
        make.top.equalTo(self.emailTextField.mas_bottom).offset(20.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(30.0);
        make.leading.equalTo(self.view.mas_leading).offset(60.0);
        make.height.mas_equalTo(40.0);
    }];
}

#pragma mark - Utilities

+ (BOOL)isValidEmail:(NSString *)email {
    static dispatch_once_t onceToken;
    static NSPredicate *emailPredicate;
    dispatch_once(&onceToken, ^{
        emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kEmailRegex];
    });
    return [emailPredicate evaluateWithObject:email];
}

- (void)signUpWithEmail:(NSString *)email
            andPassword:(NSString *)password
            andUsername:(NSString *)username {
    if (![[self class] isValidEmail:email]) {
        [Common alertWithRootView:self.view message:FUILocalizedString(kStr_InvalidEmailError)];
        return;
    }
    if (password.length <= 0) {
        [Common alertWithRootView:self.view message:FUILocalizedString(kStr_InvalidPasswordError)];
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Xin chờ ...";
    
    FIRAuth *auth = [FIRAuth auth];
    
    // Check for the presence of an anonymous user and whether automatic upgrade is enabled.
    if (auth.currentUser.isAnonymous) {
        FIRAuthCredential *credential = [FIREmailAuthProvider credentialWithEmail:email password:password];
        
        [auth.currentUser linkWithCredential:credential
                                  completion:^(FIRAuthDataResult *_Nullable authResult,
                                               NSError * _Nullable error) {
            if (error) {
                [self->hud hideAnimated:YES];
                [self finishSignUpWithAuthDataResult:nil error:error];
                return;
            }
            FIRUserProfileChangeRequest *request = [authResult.user profileChangeRequest];
            request.displayName = username;
            [request commitChangesWithCompletion:^(NSError *_Nullable error) {
                [self->hud hideAnimated:YES];
                
                if (error) {
                    [self finishSignUpWithAuthDataResult:nil error:error];
                    return;
                }
                [self finishSignUpWithAuthDataResult:authResult error:nil];
            }];
        }];
    } else {
        [auth createUserWithEmail:email
                         password:password
                       completion:^(FIRAuthDataResult *_Nullable authDataResult,
                                    NSError *_Nullable error) {
            if (error) {
                [self->hud hideAnimated:YES];
                
                [self finishSignUpWithAuthDataResult:nil error:error];
                return;
            }

            self->user = [[User alloc] initWithUserId:authDataResult.user.uid userName:username displayName:self.displayNameTextField.text email:authDataResult.user.email];
            
            FIRFirestore *store = [FIRFirestore firestore];
            FIRWriteBatch *batch = [store batch];
            FIRCollectionReference *collection = [store collectionWithPath:@"users"];
            FIRDocumentReference *userRef = [collection documentWithPath:self->user.userId];
            
            [batch setData:[self->user getDictionary] forDocument:userRef];
            [batch commitWithCompletion:^(NSError * _Nullable error) {
                [self->hud hideAnimated:YES];
                
                if (error) {
                    [authDataResult.user deleteWithCompletion:nil];
                    [self finishSignUpWithAuthDataResult:nil error:error];
                    return;
                }
                [self finishSignUpWithAuthDataResult:authDataResult error:nil];
            }];
        }];
    }
}

- (void)finishSignUpWithAuthDataResult:(nullable FIRAuthDataResult *)authDataResult
                                 error:(nullable NSError *)error {
    if (error) {
        switch (error.code) {
            case FIRAuthErrorCodeEmailAlreadyInUse:
                [Common alertWithRootView:self.view message:FUILocalizedString(kStr_EmailAlreadyInUseError)];
                return;
            case FIRAuthErrorCodeInvalidEmail:
                [Common alertWithRootView:self.view message:FUILocalizedString(kStr_InvalidEmailError)];
                return;
            case FIRAuthErrorCodeWeakPassword:
                [Common alertWithRootView:self.view message:FUILocalizedString(kStr_WeakPasswordError)];
                return;
            case FIRAuthErrorCodeTooManyRequests:
                [Common alertWithRootView:self.view message:FUILocalizedString(kStr_SignUpTooManyTimesError)];
                return;
            default:
                [Common alertWithRootView:self.view message:error.localizedDescription];
                return;
        }
    } else {
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
        userInfoVC.user = user;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _userNameTextField) {
        [_displayNameTextField becomeFirstResponder];
    } else if (textField == _displayNameTextField) {
        [_emailTextField becomeFirstResponder];
    } else if (textField == _emailTextField) {
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField) {
        [self signUpWithEmail:_emailTextField.text andPassword:_passwordTextField.text andUsername:_userNameTextField.text];
    }
    return NO;
}

#pragma mark - Password field visibility toggle button

- (UIButton *)visibilityToggleButtonForPasswordField {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 24, 24);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.tintColor = [UIColor lightGrayColor];
    [self updateIconForRightViewButton:button];
    [button addTarget:self
               action:@selector(togglePasswordFieldVisibility:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)updateIconForRightViewButton:(UIButton *)button {
    NSString *imageName = _passwordTextField.secureTextEntry ? @"eye.fill" : @"eye.slash.fill";
    UIImage *image = [UIImage systemImageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];
}

#pragma mark - Action

- (void)togglePasswordFieldVisibility:(UIButton *)button {
    // Make sure cursor is placed correctly by disabling and enabling the text field.
    _passwordTextField.enabled = NO;
    _passwordTextField.secureTextEntry = !_passwordTextField.secureTextEntry;
    [self updateIconForRightViewButton:button];
    _passwordTextField.enabled = YES;
    [_passwordTextField becomeFirstResponder];
}

- (void)textFieldDidChange {
    [self didChangeEmail:_emailTextField.text orPassword:_passwordTextField.text orUserName:_userNameTextField.text orDisplayName:_displayNameTextField.text];
}

- (void)didChangeEmail:(NSString *)email
            orPassword:(NSString *)password
            orUserName:(NSString *)username
         orDisplayName:(NSString *)displayName {
    BOOL enableActionButton = email.length > 0 && password.length > 0 && username.length > 0 && displayName.length > 0;

    self.createButton.enabled = enableActionButton;
}

- (void)didPressCreateButton:(UIButton *)sender {
    [self signUpWithEmail:_emailTextField.text andPassword:_passwordTextField.text andUsername:_userNameTextField.text];
}

- (void)didPressBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
