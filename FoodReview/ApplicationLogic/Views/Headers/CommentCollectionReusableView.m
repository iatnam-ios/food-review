//
//  CommentCollectionReusableView.m
//  FoodReview
//
//  Created by MTT on 09/07/2021.
//

#import "CommentCollectionReusableView.h"
#import "CustomTextField.h"

@interface CommentCollectionReusableView()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, strong) CustomTextField *commentTextField;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UITextView *commentTextView;


@end

@implementation CommentCollectionReusableView

- (void)dealloc
{
    [self removeObserverForKeyboardNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
        [self setupViews];
    }
    
    return self;
}

+ (NSString *)identifier {
    return @"reuseCommentCollectionReusableView";
}

#pragma mark - Initialize

- (void)initialize {
    self.backgroundColor = UIColor.whiteColor;
    [self addObserverForKeyboardNotifications];
}

- (void)addObserverForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserverForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    [self.commentTextView becomeFirstResponder];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    
}

#pragma mark - SetupViews

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        _likeButton.tintColor = UIColor.systemBlueColor;
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        [_likeButton setTitleColor:UIColor.steelColor forState:UIControlStateNormal];
        
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:14.0 weight:UIImageSymbolWeightLight];
        [_likeButton setImage:[UIImage systemImageNamed:@"hand.thumbsup" withConfiguration:config] forState: UIControlStateNormal];
        [_likeButton setImage:[UIImage systemImageNamed:@"hand.thumbsup.fill" withConfiguration:config] forState: UIControlStateSelected];
        [_likeButton addTarget:self action:@selector(didPressLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UIButton *)dislikeButton {
    if (!_dislikeButton) {
        _dislikeButton = [[UIButton alloc] init];
        _dislikeButton.tintColor = UIColor.systemBlueColor;
        _dislikeButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        [_dislikeButton setTitleColor:UIColor.steelColor forState:UIControlStateNormal];
        
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:14.0 weight:UIImageSymbolWeightLight];
        [_dislikeButton setImage:[UIImage systemImageNamed:@"hand.thumbsdown" withConfiguration:config] forState: UIControlStateNormal];
        [_dislikeButton setImage:[UIImage systemImageNamed:@"hand.thumbsdown.fill" withConfiguration:config] forState: UIControlStateSelected];
        [_dislikeButton addTarget:self action:@selector(didPressDislikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dislikeButton;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = UIFont.titleSmall;
        _commentLabel.textColor = UIColor.steelColor;
        _commentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _commentLabel;
}

- (UIView *)accessoryView {
    if (_accessoryView == nil) {
        _accessoryView = [[UIView alloc] init];
        _accessoryView.backgroundColor = UIColor.systemBackgroundColor;
    }
    return _accessoryView;
}

- (UIButton *)commentButton {
    if (_commentButton == nil) {
        _commentButton = [[UIButton alloc] init];
        _commentButton.tintColor = UIColor.systemBlueColor;
        [_commentButton setImage:[UIImage systemImageNamed:@"paperplane.fill"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(didPressCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UITextView *)commentTextView {
    if (!_commentTextView) {
        _commentTextView = [[UITextView alloc] init];
        //_commentTextView.delegate = self;
        _commentTextView.textColor = [UIColor colorWithHex:0xb0b3c6];
        _commentTextView.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
        _commentTextView.clipsToBounds = YES;
        _commentTextView.layer.cornerRadius = 8.0;
        _commentTextView.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _commentTextView.layer.borderWidth = 1.0;
    }

    return _commentTextView;
}

- (CustomTextField *)commentTextField {
    if (!_commentTextField) {
        _commentTextField = [[CustomTextField alloc] init];
        _commentTextField.placeholder = @"Viết bình luận...";
        _commentTextField.delegate = self;
        _commentTextField.secureTextEntry = NO;
        _commentTextField.returnKeyType = UIReturnKeyNext;
        _commentTextField.keyboardType = UIKeyboardTypeDefault;
        _commentTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _commentTextField.textColor = [UIColor colorWithHex:0xb0b3c6];
        _commentTextField.font = [UIFont systemFontOfSize:16];
        _commentTextField.clipsToBounds = YES;
        _commentTextField.layer.cornerRadius = 20.0;
        _commentTextField.layer.borderColor = [UIColor colorWithHex:0xb0b3c6].CGColor;
        _commentTextField.layer.borderWidth = 1.0;
    }
    
    return _commentTextField;
}

- (void)setupViews {
    [self addSubview:self.likeButton];
    [self addSubview:self.dislikeButton];
    [self addSubview:self.commentLabel];
    [self addSubview:self.commentTextField];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10.0);
        make.leading.mas_equalTo(self.mas_leading).offset(14.0);
        make.height.mas_equalTo(24.0);
        make.width.mas_equalTo(60.0);
    }];
    
    [self.dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10.0);
        make.leading.mas_equalTo(self.likeButton.mas_trailing).offset(4.0);
        make.height.mas_equalTo(24.0);
        make.width.mas_equalTo(60.0);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10.0);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(24.0);
    }];

    [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.likeButton.mas_bottom).offset(14.0);
        make.leading.mas_equalTo(self.mas_leading).offset(14.0);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.accessoryView addSubview:self.commentTextView];
    [self.accessoryView addSubview:self.commentButton];
    
    self.accessoryView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50.0);
    self.commentTextView.frame = CGRectMake(10.0, 3.0, SCREEN_WIDTH - 72.0, 44.0);
    self.commentButton.frame = CGRectMake(SCREEN_WIDTH - 56.0, 0.0, 50.0, 50.0);
    self.commentTextField.inputAccessoryView = self.accessoryView;
}

#pragma mark - Config

- (void)configViewWithLikes:(NSInteger)likes dislikes:(NSInteger)dislikes andComments:(NSInteger)comments {
    [self.likeButton setTitle:[Common suffixNumber:[NSNumber numberWithInteger:likes]] forState:UIControlStateNormal];
    [self.dislikeButton setTitle:[Common suffixNumber:[NSNumber numberWithInteger:dislikes]] forState:UIControlStateNormal];
    NSString *commentStr = [Common suffixNumber:[NSNumber numberWithInteger:comments]];
    self.commentLabel.text = [NSString stringWithFormat:@"%@ Bình luận", commentStr];
}

#pragma mark - Action

-(void)didPressLikeButton:(UIButton *)sender {
    [self.delegate didPressLikeButton:self];
}

-(void)didPressDislikeButton:(UIButton *)sender {
    [self.delegate didPressDislikeButton:self];
}

-(void)didPressCommentButton:(UIButton *)sender {
    if (self.commentTextView.text.length > 0) {
        [self.delegate didPressCommentButton:sender withComment:self.commentTextView.text];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

@end
