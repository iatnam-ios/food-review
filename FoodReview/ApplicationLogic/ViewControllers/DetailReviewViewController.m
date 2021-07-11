//
//  DetailReviewViewController.m
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import "DetailReviewViewController.h"
#import "ListPhotoCollectionViewCell.h"
#import "PlaceCollectionViewCell.h"
#import "CommentCollectionViewCell.h"
#import "ContentCollectionReusableView.h"
#import "CommentCollectionReusableView.h"
#import "LandingViewController.h"
#import "DetailUserViewController.h"
#import "MBProgressHUD.h"
#import "FUIAuthStrings.h"
#import "Place.h"
#import "Comment.h"
#import "Reaction.h"

@interface DetailReviewViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CommentCollectionReusableDelegate>

@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) Reaction *reaction;
@property (nonatomic, strong) NSMutableArray<Comment *> *comments;

@property (nonatomic, strong) FIRFirestore *db;
@property (nonatomic, strong) id<FIRListenerRegistration> listener;

@end

@implementation DetailReviewViewController {
    CGFloat headerHeight;
    NSMutableString *hashtagStr;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateTotalViews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.listener remove];
}

#pragma mark - Initialize

- (void)initialize {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"] style:UIBarButtonItemStyleDone target:self action:@selector(didPressMoreButton)];
    self.navigationItem.rightBarButtonItem = moreButton;
    
    self.db = [FIRFirestore firestore];
}

#pragma mark - SetupAppearances

- (void)setupAppearances {
    self.navigationItem.titleView = self.barView;
    
    self.nameLabel.text = self.review.userName;
    self.timeLabel.text = self.review.createdDate.description;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.review.userAvatar] placeholderImage:[UIImage imageNamed:@"avatar-default"]];
    
    [self getPlaceWithId:self.review.placeId];
    [self getReactionForReview];
    [self getComment];
    
    hashtagStr = [[NSMutableString alloc] init];
    for (NSString *hashtag in self.review.hashtags) {
        [hashtagStr appendString:[NSString stringWithFormat:@"#%@   ", hashtag]];
    }
    
    CGFloat width = self.view.frame.size.width - 14.0 * 2.0;
    CGFloat titleHeight = [self expectedHeight:self.review.title width:width font:UIFont.titleBold];
    CGFloat contentHeight = [self expectedHeight:self.review.subtitle width:width font:UIFont.subtitleLight];
    CGFloat hashtagHeight = [self expectedHeight:hashtagStr width:width font:UIFont.titleRegular];
    
    headerHeight = 44.0 + titleHeight + contentHeight + hashtagHeight + 34.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self.view addGestureRecognizer:tap];
}

-(void)getPlaceWithId:(NSInteger)placeId {
    FIRDatabase *database = [FIRDatabase databaseWithURL:@"https://food-review-94b9e-default-rtdb.asia-southeast1.firebasedatabase.app"];
    FIRDatabaseReference *restaurantsRef = [database referenceWithPath:@"restaurants"];
    FIRDatabaseQuery *placeQuery = [[restaurantsRef queryOrderedByChild:@"Id"] queryEqualToValue:[NSNumber numberWithInteger:placeId]];

    [placeQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value;
            id plId = dict[@"Id"];
            if (plId) {
                self.place = [[Place alloc] initWithDictionary:dict];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                });
                break;
            }
        }
    }];
}

-(void)getComment {
    FIRQuery *commentQuery = [[self.db collectionWithPath:@"comments"] queryWhereField:@"reviewId" isEqualTo:self.review.reviewId];
    
    self.listener = [commentQuery addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (snapshot == nil) {
            NSLog(@"Error fetching documents: %@", error);
            return;
        }
        for (FIRDocumentChange *diff in snapshot.documentChanges) {
            if (diff.type == FIRDocumentChangeTypeAdded) {
                NSLog(@"New city: %@", diff.document.data);
                Comment *comment = [[Comment alloc] initWithDictionary:diff.document.data andId:diff.document.documentID];
                [self.comments addObject:comment];
            }
            if (diff.type == FIRDocumentChangeTypeModified) {
                NSLog(@"Modified city: %@", diff.document.data);
            }
            if (diff.type == FIRDocumentChangeTypeRemoved) {
                NSLog(@"Removed city: %@", diff.document.data);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        });
    }];
}

-(void)getReactionForReview {
    FIRUser *user = [[FIRAuth auth] currentUser];
    if (user) {
        FIRQuery *reactionQuery = [[[self.db collectionWithPath:@"reactions"] queryWhereField:@"userId" isEqualTo:user.uid] queryWhereField:@"reviewId" isEqualTo:self.review.reviewId];
        
        [reactionQuery getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error getting documents: %@", error);
            } else {
                if (snapshot.documents.count > 0) {
                    FIRDocumentSnapshot *document = snapshot.documents.firstObject;
                    self.reaction = [[Reaction alloc] initWithDictionary:document.data andReactionId:document.documentID];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                    });
                }
            }
        }];
    }
}

-(void)updateTotalViews {
    FIRDocumentReference *reviewRef = [[self.db collectionWithPath:@"reviews"] documentWithPath:self.review.reviewId];

    [self.db runTransactionWithBlock:^id _Nullable(FIRTransaction * _Nonnull transaction, NSError *__autoreleasing  _Nullable * _Nullable errorPointer) {
        FIRDocumentSnapshot *reviewDocument = [transaction getDocument:reviewRef error:errorPointer];
        
        if (*errorPointer != nil) { return nil; }
        
        if (![reviewDocument.data[@"totalViews"] isKindOfClass:[NSNumber class]]) {
            *errorPointer = [NSError errorWithDomain:@"AppErrorDomain" code:-1 userInfo:@{
                NSLocalizedDescriptionKey: @"Unable to retreive totalViews from snapshot"
            }];
            return nil;
        }
        self.review.totalViews = [reviewDocument.data[@"totalViews"] integerValue];
        self.review.likes =[reviewDocument.data[@"likes"] integerValue];
        self.review.dislikes =[reviewDocument.data[@"dislikes"] integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        // Note: this could be done without a transaction
        //       by updating the views using FieldValue.increment()
        [transaction updateData:@{ @"totalViews": @(self.review.totalViews + 1) } forDocument:reviewRef];
        
        return nil;
    } completion:^(id  _Nullable result, NSError * _Nullable error) {
        
    }];
}

- (CGFloat)expectedHeight:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    CGSize maximumLabelSize = CGSizeMake(width, 9999);
    
    CGRect expectedLabelRect = [text boundingRectWithSize:maximumLabelSize
                                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                               attributes:@{ NSFontAttributeName: font }
                                                  context:nil];
    CGSize *expectedLabelSize = &expectedLabelRect.size;
    
    return expectedLabelSize->height;
}

- (NSMutableArray<Comment *> *)comments {
    if (_comments == nil) {
        _comments = [[NSMutableArray alloc] init];
    }
    return _comments;
}

#pragma mark - SetupViews

- (UIView *)barView {
    if (_barView == nil) {
        _barView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAvatar)];
        [_barView addGestureRecognizer:tap];
    }
    return _barView;
}

- (UIImageView *)avatar {
    if (_avatar == nil) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = self.navigationController.navigationBar.bounds.size.height / 2.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAvatar)];
        [_avatar addGestureRecognizer:tap];
    }
    return _avatar;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColor.blackColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColor.steelColor;
        _timeLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight];
    }
    return _timeLabel;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ListPhotoCollectionViewCell class] forCellWithReuseIdentifier:ListPhotoCollectionViewCell.identifier];
        [_collectionView registerClass:[PlaceCollectionViewCell class] forCellWithReuseIdentifier:PlaceCollectionViewCell.identifier];
        [_collectionView registerClass:[CommentCollectionViewCell class] forCellWithReuseIdentifier:CommentCollectionViewCell.identifier];
        
        [_collectionView registerClass:ContentCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ContentCollectionReusableView.identifier];
        [_collectionView registerClass:CommentCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CommentCollectionReusableView.identifier];
    }
    return _collectionView;
}


- (void)setupViews {
    [self.barView addSubview:self.avatar];
    [self.barView addSubview:self.nameLabel];
    [self.barView addSubview:self.timeLabel];

    CGFloat barHeight = self.navigationController.navigationBar.bounds.size.height;
    CGFloat barWidth = self.navigationController.navigationBar.bounds.size.width - 100.0;
    
    self.barView.frame = CGRectMake(0, 0, barWidth, barHeight);
    self.avatar.frame = CGRectMake(0, 0, barHeight, barHeight);
    self.nameLabel.frame = CGRectMake(barHeight + 10.0, 0, barWidth - barHeight - 10.0, 22.0);
    self.timeLabel.frame = CGRectMake(barHeight + 10.0, 24.0, barWidth - barHeight - 10.0, 20.0);
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 2) {
        return self.comments.count;
    } else if ((section == 1) && (self.place == nil)) {
        return 0;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ListPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ListPhotoCollectionViewCell.identifier forIndexPath:indexPath];
        cell.photos = self.review.images;
        return cell;
    } else if (indexPath.section == 1) {
        PlaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PlaceCollectionViewCell.identifier forIndexPath:indexPath];
        [cell configueWithPlace:self.place andDistance:@""];
        return cell;
    }
    CommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CommentCollectionViewCell.identifier forIndexPath:indexPath];
    Comment *comment = self.comments[indexPath.item];
    [cell configCellWithComment:comment];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ContentCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ContentCollectionReusableView.identifier forIndexPath:indexPath];
        
        [headerView configViewWithTitle:self.review.title content:self.review.subtitle hashtag:hashtagStr rating:self.review.rate.overall andTotalViews:self.review.totalViews];
        return headerView;
    } else if (indexPath.section == 2) {
        CommentCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CommentCollectionReusableView.identifier forIndexPath:indexPath];
        
        headerView.delegate = self;
        [headerView configViewWithLikes:self.review.likes dislikes:self.review.dislikes andComments:self.review.comments];
        if (self.reaction) {
            if (self.reaction.type) {
                headerView.likeButton.selected = YES;
                headerView.dislikeButton.selected = NO;
            } else {
                headerView.likeButton.selected = NO;
                headerView.dislikeButton.selected = YES;
            }
        } else {
            headerView.likeButton.selected = NO;
            headerView.dislikeButton.selected = NO;
        }
        
        return headerView;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    } else if (section == 1) {
        return CGSizeMake(collectionView.frame.size.width, headerHeight);
    }
    return CGSizeMake(collectionView.frame.size.width, 94.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat collectionWidth = collectionView.frame.size.width;
    
    if (indexPath.section == 0) {
        return CGSizeMake(collectionWidth, collectionWidth);
    } else if (indexPath.section == 1) {
        if (self.place) {
            return CGSizeMake(collectionWidth - 14.0 * 2.0, 80.0);
        }
        return CGSizeMake(1.0, 1.0);
    } else {
        if (self.comments.count > 0) {
            Comment *comment = self.comments[indexPath.item];
            
            CGFloat contentWidth = collectionWidth - 64.0;
            CGFloat contentHeight = [self expectedHeight:comment.content width:contentWidth font:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
            CGFloat itemHeight = 54.0 + contentHeight;
            return CGSizeMake(collectionWidth - 14.0 * 2.0, itemHeight);
        }
        return CGSizeMake(1.0, 1.0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0.0, 10.0, 4.0, 10.0);
    }
    return UIEdgeInsetsMake(0.0, 14.0, 10.0, 14.0);
}

-(void)didPressMoreButton {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Bạn muốn" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"Chia sẻ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:shareAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)didPressLikeButton:(CommentCollectionReusableView *)sender {
    FIRUser *user = [[FIRAuth auth] currentUser];
    if (user) {
        if (self.reaction) {
            if (self.reaction.type) {
                FIRDocumentReference *reactionRef = [[self.db collectionWithPath:@"reactions"] documentWithPath:self.reaction.reactionId];
                FIRDocumentReference *reviewRef = [[self.db collectionWithPath:@"reviews"] documentWithPath:self.review.reviewId];
                
                [self.db runTransactionWithBlock:^id _Nullable(FIRTransaction * _Nonnull transaction, NSError *__autoreleasing  _Nullable * _Nullable errorPointer) {
                    FIRDocumentSnapshot *reviewDocument = [transaction getDocument:reviewRef error:errorPointer];
                    
                    if (*errorPointer != nil) { return nil; }
                    
                    NSInteger likesCount = [reviewDocument.data[@"likes"] integerValue];
                    
                    [transaction updateData:@{@"likes" : @(likesCount - 1)} forDocument:reviewRef];
                    [transaction deleteDocument:reactionRef];
                    return nil;
                } completion:^(id  _Nullable result, NSError * _Nullable error) {
                    if (!error) {
                        sender.likeButton.selected = NO;
                        self.reaction = nil;
                        self.review.likes = self.review.likes - 1;
                        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                    }
                }];
            } else {
                FIRDocumentReference *reactionRef = [[self.db collectionWithPath:@"reactions"] documentWithPath:self.reaction.reactionId];
                FIRDocumentReference *reviewRef = [[self.db collectionWithPath:@"reviews"] documentWithPath:self.review.reviewId];
                
                [self.db runTransactionWithBlock:^id _Nullable(FIRTransaction * _Nonnull transaction, NSError *__autoreleasing  _Nullable * _Nullable errorPointer) {
                    FIRDocumentSnapshot *reviewDocument = [transaction getDocument:reviewRef error:errorPointer];
                    
                    if (*errorPointer != nil) { return nil; }
                    
                    NSInteger likesCount = [reviewDocument.data[@"likes"] integerValue];
                    NSInteger dislikesCount = [reviewDocument.data[@"dislikes"] integerValue];
                    
                    [transaction updateData:@{@"likes" : @(likesCount + 1), @"dislikes" : @(dislikesCount - 1)} forDocument:reviewRef];
                    [transaction updateData:@{@"type" : @YES} forDocument:reactionRef];
                    return nil;
                } completion:^(id  _Nullable result, NSError * _Nullable error) {
                    if (!error) {
                        sender.likeButton.selected = YES;
                        sender.dislikeButton.selected = NO;
                        self.reaction.type = YES;
                        self.review.likes = self.review.likes + 1;
                        self.review.dislikes = self.review.dislikes - 1;
                        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                    }
                }];
            }
        } else {
            self.reaction = [[Reaction alloc] initWithUserId:user.uid reviewId:self.review.reviewId type:YES andDate:[NSDate date]];
            
            FIRDocumentReference *reactionRef = [[self.db collectionWithPath:@"reactions"] documentWithAutoID];
            FIRDocumentReference *reviewRef = [[self.db collectionWithPath:@"reviews"] documentWithPath:self.review.reviewId];
            
            self.reaction.reactionId = reactionRef.documentID;
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.reaction getDictionary]];
            
            [self.db runTransactionWithBlock:^id _Nullable(FIRTransaction * _Nonnull transaction, NSError *__autoreleasing  _Nullable * _Nullable errorPointer) {
                FIRDocumentSnapshot *reviewDocument = [transaction getDocument:reviewRef error:errorPointer];
                
                if (*errorPointer != nil) { return nil; }
                
                NSInteger likesCount = [reviewDocument.data[@"likes"] integerValue];
                
                [transaction updateData:@{@"likes" : @(likesCount + 1)} forDocument:reviewRef];
                [transaction setData:dict forDocument:reactionRef];
                return nil;
            } completion:^(id  _Nullable result, NSError * _Nullable error) {
                if (!error) {
                    sender.likeButton.selected = YES;
                    self.review.likes = self.review.likes + 1;
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                }
            }];
        }
    } else {
        LandingViewController *vc = [[LandingViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)didPressDislikeButton:(CommentCollectionReusableView *)sender {
    FIRUser *user = [[FIRAuth auth] currentUser];
    if (user) {
        if (self.reaction) {
            if (!self.reaction.type) {
                FIRDocumentReference *reactionRef = [[self.db collectionWithPath:@"reactions"] documentWithPath:self.reaction.reactionId];
                FIRDocumentReference *reviewRef = [[self.db collectionWithPath:@"reviews"] documentWithPath:self.review.reviewId];
                
                [self.db runTransactionWithBlock:^id _Nullable(FIRTransaction * _Nonnull transaction, NSError *__autoreleasing  _Nullable * _Nullable errorPointer) {
                    FIRDocumentSnapshot *reviewDocument = [transaction getDocument:reviewRef error:errorPointer];
                    
                    if (*errorPointer != nil) { return nil; }
                    
                    NSInteger dislikesCount = [reviewDocument.data[@"dislikes"] integerValue];
                    
                    [transaction updateData:@{@"dislikes" : @(dislikesCount - 1)} forDocument:reviewRef];
                    [transaction deleteDocument:reactionRef];
                    return nil;
                } completion:^(id  _Nullable result, NSError * _Nullable error) {
                    if (!error) {
                        self.reaction = nil;
                        self.review.dislikes = self.review.dislikes - 1;
                        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                    }
                }];
            } else {
                FIRDocumentReference *reactionRef = [[self.db collectionWithPath:@"reactions"] documentWithPath:self.reaction.reactionId];
                FIRDocumentReference *reviewRef = [[self.db collectionWithPath:@"reviews"] documentWithPath:self.review.reviewId];
                
                [self.db runTransactionWithBlock:^id _Nullable(FIRTransaction * _Nonnull transaction, NSError *__autoreleasing  _Nullable * _Nullable errorPointer) {
                    FIRDocumentSnapshot *reviewDocument = [transaction getDocument:reviewRef error:errorPointer];
                    
                    if (*errorPointer != nil) { return nil; }
                    
                    NSInteger likesCount = [reviewDocument.data[@"likes"] integerValue];
                    NSInteger dislikesCount = [reviewDocument.data[@"dislikes"] integerValue];
                    
                    [transaction updateData:@{@"likes" : @(likesCount - 1), @"dislikes" : @(dislikesCount + 1)} forDocument:reviewRef];
                    [transaction updateData:@{@"type" : @NO} forDocument:reactionRef];
                    return nil;
                } completion:^(id  _Nullable result, NSError * _Nullable error) {
                    if (!error) {
                        self.reaction.type = NO;
                        self.review.likes = self.review.likes - 1;
                        self.review.dislikes = self.review.dislikes + 1;
                        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                    }
                }];
            }
        } else {
            self.reaction = [[Reaction alloc] initWithUserId:user.uid reviewId:self.review.reviewId type:NO andDate:[NSDate date]];
            
            FIRDocumentReference *reactionRef = [[self.db collectionWithPath:@"reactions"] documentWithAutoID];
            FIRDocumentReference *reviewRef = [[self.db collectionWithPath:@"reviews"] documentWithPath:self.review.reviewId];
            
            self.reaction.reactionId = reactionRef.documentID;
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self.reaction getDictionary]];
            
            [self.db runTransactionWithBlock:^id _Nullable(FIRTransaction * _Nonnull transaction, NSError *__autoreleasing  _Nullable * _Nullable errorPointer) {
                FIRDocumentSnapshot *reviewDocument = [transaction getDocument:reviewRef error:errorPointer];
                
                if (*errorPointer != nil) { return nil; }
                
                NSInteger dislikesCount = [reviewDocument.data[@"dislikes"] integerValue];
                
                [transaction updateData:@{@"dislikes" : @(dislikesCount + 1)} forDocument:reviewRef];
                [transaction setData:dict forDocument:reactionRef];
                return nil;
            } completion:^(id  _Nullable result, NSError * _Nullable error) {
                if (!error) {
                    self.review.dislikes = self.review.dislikes + 1;
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                }
            }];
        }
    } else {
        LandingViewController *vc = [[LandingViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)didPressCommentButton:(UIButton *)sender withComment:(nonnull NSString *)content {
    [self.view endEditing:YES];
    FIRUser *user = [[FIRAuth auth] currentUser];
    if (user) {
        Comment *comment = [[Comment alloc] initWithUserId:user.uid reviewId:self.review.reviewId createdDate:[NSDate date] andComment:content];
        
        FIRDocumentReference *commentRef = [[self.db collectionWithPath:@"comments"] documentWithAutoID];
        FIRDocumentReference *userRef = [[self.db collectionWithPath:@"users"] documentWithPath:user.uid];
        
        FIRDocumentReference *reviewRef = [[self.db collectionWithPath:@"reviews"] documentWithPath:self.review.reviewId];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[comment getDictionary]];
        
        [self.db runTransactionWithBlock:^id _Nullable(FIRTransaction * _Nonnull transaction, NSError *__autoreleasing  _Nullable * _Nullable errorPointer) {
            FIRDocumentSnapshot *userDocument = [transaction getDocument:userRef error:errorPointer];
            FIRDocumentSnapshot *reviewDocument = [transaction getDocument:reviewRef error:errorPointer];
            
            if (*errorPointer != nil) { return nil; }
            
            dict[@"userName"] = userDocument.data[@"displayName"];
            dict[@"userAvatar"] = userDocument.data[@"profileImageUrl"];
            
            NSInteger commentCount = 0;
            NSNumber *number = reviewDocument.data[@"comments"];
            if (number) {
                commentCount = [number integerValue];
            }
            
            [transaction updateData:@{@"comments" : @(commentCount + 1)} forDocument:reviewRef];
            [transaction setData:dict forDocument:commentRef];
            return nil;
        } completion:^(id  _Nullable result, NSError * _Nullable error) {
            if (error) {
                [Common alertWithRootView:self.view message:error.localizedDescription];
                return;
            }
            self.review.comments = self.review.comments + 1;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        }];
    } else {
        LandingViewController *vc = [[LandingViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)didTapView:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

-(void)didTapAvatar {
    NSString *userId = [FIRAuth auth].currentUser.uid;
    if ((userId == nil) || (![userId isEqualToString:self.review.userId])) {
        DetailUserViewController *vc = [[DetailUserViewController alloc] init];
        vc.userId = self.review.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
