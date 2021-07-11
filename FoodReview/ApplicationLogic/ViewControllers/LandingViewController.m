//
//  LandingViewController.m
//  FoodReview
//
//  Created by MTT on 05/06/2021.
//

#import "LandingViewController.h"
#import "SignupViewController.h"
#import "LoginViewController.h"

@interface LandingViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *signupButton;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation LandingViewController

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
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Initialize

- (void)initialize {
    self.view.backgroundColor = UIColor.whiteColor;
}

#pragma mark - SetupAppearances

- (void)setupAppearances {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setPresenter:(id<LandingPresenter>)presenter {
    _presenter = presenter;
    presenter.output = self;
}

#pragma mark - SetupViews

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"icon_logo"];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"Food Review";
        _titleLabel.textColor = [UIColor colorWithHex:0x464646];
        _titleLabel.font = [UIFont boldSystemFontOfSize:36];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.text = @"Bạn cần đăng nhập tài khoản để sử dụng tính năng này!";
        _subtitleLabel.textColor = [UIColor colorWithHex:0x464646];
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightRegular];
    }
    return _subtitleLabel;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.layer.cornerRadius = 28.0;
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        [_loginButton setTitle:@"Đăng nhập" forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:UIColor.buttonColor];
        [_loginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(didPressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)signupButton {
    if (!_signupButton) {
        _signupButton = [[UIButton alloc] init];
        _signupButton.layer.cornerRadius = 28.0;
        _signupButton.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _signupButton.layer.borderWidth = 1.0;
        _signupButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        [_signupButton setTitle:@"Đăng ký" forState:UIControlStateNormal];
        [_signupButton setBackgroundColor:UIColor.whiteColor];
        [_signupButton setTitleColor:[UIColor colorWithHex:0x414665] forState:UIControlStateNormal];
        [_signupButton addTarget:self action:@selector(didPressSignUpButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signupButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
        [_closeButton setTintColor:UIColor.darkGrayColor];
        [_closeButton addTarget:self action:@selector(didPressCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)setupViews {
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.subtitleLabel];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.signupButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(8.0);
        make.leading.equalTo(self.view.mas_leading).offset(14.0);
        make.width.height.mas_equalTo(36.0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100.0);
        make.width.height.mas_equalTo(110.0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.imageView.mas_bottom).offset(36.0);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(23.0);
        make.leading.greaterThanOrEqualTo(self.view.mas_leading).offset(50.0);
        make.trailing.greaterThanOrEqualTo(self.view.mas_trailing).offset(-50.0);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(46.0);
        make.leading.equalTo(self.view.mas_leading).offset(50.0);
        make.height.mas_equalTo(56.0);
    }];
    
    [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.loginButton.mas_bottom).offset(23.0);
        make.leading.equalTo(self.view.mas_leading).offset(50.0);
        make.height.mas_equalTo(56.0);
    }];
}

- (void)didPressLoginButton:(UIButton *)sender {
//    [self.presenter didPressLoginButton];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)didPressSignUpButton:(UIButton *)sender {
    SignupViewController *signUpVC = [[SignupViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

- (void)didPressCloseButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
