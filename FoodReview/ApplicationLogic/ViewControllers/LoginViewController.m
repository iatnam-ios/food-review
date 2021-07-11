//
//  LoginViewController.m
//  FoodReview
//
//  Created by MTT on 05/06/2021.
//

#import "LoginViewController.h"
#import "CustomTextField.h"
#import "MBProgressHUD.h"
#import "FUIAuthStrings.h"

static NSString *const kEmailRegex = @".+@([a-zA-Z0-9\\-]+\\.)+[a-zA-Z0-9]{2,63}";

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) CustomTextField *emailTextField;
@property (nonatomic, strong) CustomTextField *passwordTextField;

@end

@implementation LoginViewController {
    MBProgressHUD *hud;
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
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setPresenter:(id<LoginPresenter>)presenter {
    _presenter = presenter;
    presenter.output = self;
}

#pragma mark - SetupViews

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"Đăng nhập";
        _titleLabel.textColor = [UIColor colorWithHex:0xff5a66];
        _titleLabel.font = [UIFont boldSystemFontOfSize:36];
    }
    return _titleLabel;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.enabled = NO;
        _loginButton.layer.cornerRadius = 28.0;
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_loginButton setTitle:@"Đăng nhập" forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor colorWithHex:0xff5a66]];
        [_loginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(didPressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
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
        _emailTextField.font = [UIFont systemFontOfSize:18];
        _emailTextField.clipsToBounds = YES;
        _emailTextField.layer.cornerRadius = 28.0;
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
        _passwordTextField.font = [UIFont systemFontOfSize:18];
        _passwordTextField.clipsToBounds = YES;
        _passwordTextField.layer.cornerRadius = 28.0;
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
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];

    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(8.0);
        make.leading.equalTo(self.view.mas_leading).offset(14.0);
        make.width.height.mas_equalTo(36.0);
    }];

    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20.0);
        make.top.equalTo(self.backButton.mas_bottom).offset(50.0);
    }];
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.leading.equalTo(self.view.mas_leading).offset(25.0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40.0);
        make.height.mas_equalTo(56.0);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.leading.equalTo(self.view.mas_leading).offset(25.0);
        make.top.equalTo(self.emailTextField.mas_bottom).offset(24.0);
        make.height.mas_equalTo(56.0);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(30.0);
        make.leading.equalTo(self.view.mas_leading).offset(50.0);
        make.height.mas_equalTo(56.0);
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

- (void)signInWithDefaultValue:(NSString *)email andPassword:(NSString *)password {
    if (![[self class] isValidEmail:email]) {
        [Common alertWithRootView:self.view message:FUILocalizedString(kStr_InvalidEmailError)];
        return;
    }
    if (password.length <= 0) {
        [Common alertWithRootView:self.view message:FUILocalizedString(kStr_InvalidPasswordError)];
        return;
    }
    if (self.presenter) {
        [self.presenter loginWithEmail:email andPassword:password];
    } else {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"Xin chờ ...";

        FIRAuthCredential *credential = [FIREmailAuthProvider credentialWithEmail:email password:password];

        void (^completeSignInBlock)(FIRAuthDataResult *, NSError *) = ^(FIRAuthDataResult *authResult, NSError *error) {
            [self->hud hideAnimated:YES];

            if (error) {
                switch (error.code) {
                    case FIRAuthErrorCodeWrongPassword:
                        [Common alertWithRootView:self.view message:FUILocalizedString(kStr_WrongPasswordError)];
                        return;
                    case FIRAuthErrorCodeUserNotFound:
                        [Common alertWithRootView:self.view message:FUILocalizedString(kStr_UserNotFoundError)];
                        return;
                    case FIRAuthErrorCodeUserDisabled:
                        [Common alertWithRootView:self.view message:FUILocalizedString(kStr_AccountDisabledError)];
                        return;
                    case FIRAuthErrorCodeTooManyRequests:
                        [Common alertWithRootView:self.view message:FUILocalizedString(kStr_SignInTooManyTimesError)];
                        return;
                }
            }

            [self dismissNavigationControllerAnimated:YES completion:^{

            }];
        };

        [FIRAuth.auth signInWithCredential:credential completion:completeSignInBlock];
    }
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
    if (textField == _emailTextField) {
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField) {
        [self signInWithDefaultValue:_emailTextField.text andPassword:_passwordTextField.text];
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
    [self didChangeEmail:_emailTextField.text orPassword:_passwordTextField.text];
}

- (void)didChangeEmail:(NSString *)email orPassword:(NSString *)password {
    BOOL enableActionButton = email.length > 0 && password.length > 0;
    self.loginButton.enabled = enableActionButton;
}

- (void)didPressLoginButton:(UIButton *)sender {
    [self signInWithDefaultValue:_emailTextField.text andPassword:_passwordTextField.text];
}

- (void)didPressBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
