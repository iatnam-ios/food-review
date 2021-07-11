//
//  FirebaseDatabaseClient.m
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import "FirebaseDatabaseClient.h"
#import "FUIAuthStrings.h"

NSString * const FirebaseDatabaseURL = @"https://food-review-94b9e-default-rtdb.asia-southeast1.firebasedatabase.app";

@implementation FirebaseDatabaseClient

- (void)getCurrentUserWithBlock:(UserResponseBlock)block {
    FIRUser *userFIR = [[FIRAuth auth] currentUser];
    if (userFIR) {
        User *user = [[User alloc] initWithUserId:userFIR.uid userName:@"" displayName:@"" email:userFIR.email];
        block(user);
    } else {
        block(nil);
    }
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password andWithBlock:(LoginResponseBlock)block {
    FIRAuthCredential *credential = [FIREmailAuthProvider credentialWithEmail:email password:password];
    
    void (^completeSignInBlock)(FIRAuthDataResult *, NSError *) = ^(FIRAuthDataResult *authResult, NSError *error) {
        NSString *errorString;
        User *user;
        if (error) {
            switch (error.code) {
                case FIRAuthErrorCodeWrongPassword:
                    errorString = FUILocalizedString(kStr_WrongPasswordError);
                    break;
                case FIRAuthErrorCodeUserNotFound:
                    errorString = FUILocalizedString(kStr_UserNotFoundError);
                    break;
                case FIRAuthErrorCodeUserDisabled:
                    errorString = FUILocalizedString(kStr_AccountDisabledError);
                    break;
                case FIRAuthErrorCodeTooManyRequests:
                    errorString = FUILocalizedString(kStr_SignInTooManyTimesError);
                    break;
            }
        } else {
            FIRUser *userLogin = authResult.user;
            user = [[User alloc] initWithUserId:userLogin.uid userName:@"" displayName:@"" email:userLogin.email];
        }
        block(user, errorString);
    };
    
    [FIRAuth.auth signInWithCredential:credential completion:completeSignInBlock];
}

- (void)getPlacesMatchSearchString:(NSString *)searchText withBlock:(PlacesResponseBlock)block {
    FIRDatabase *database = [FIRDatabase databaseWithURL:FirebaseDatabaseURL];
    FIRDatabaseReference *restaurantsRef = [database referenceWithPath:@"restaurants"];
    FIRDatabaseQuery *placeQuery = [[[restaurantsRef queryOrderedByChild:@"Name"] queryStartingAtValue:searchText] queryLimitedToFirst:100];
    
    [placeQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%lu", (unsigned long)snapshot.childrenCount);
        NSMutableArray<Place *> *results = [NSMutableArray new];
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value;
            Place *place = [[Place alloc] initWithDictionary:dict];
            [results addObject:place];
        }
        
        block(results, nil);
    }];
}

- (void)getPlacesFromDistrictId:(NSInteger)districtId withBlock:(PlacesResponseBlock)block {
    NSNumber *district = [NSNumber numberWithInteger:districtId];
    FIRDatabase *database = [FIRDatabase databaseWithURL:FirebaseDatabaseURL];
    FIRDatabaseReference *restaurantsRef = [database referenceWithPath:@"restaurants"];
    FIRDatabaseQuery *placeQuery = [[[restaurantsRef queryOrderedByChild:@"DistrictId"] queryEqualToValue:district] queryLimitedToFirst:20];
    
    [placeQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%lu", (unsigned long)snapshot.childrenCount);
        NSMutableArray<Place *> *results = [NSMutableArray new];
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value;
            Place *place = [[Place alloc] initWithDictionary:dict];
            [results addObject:place];
        }
        
        block(results, nil);
    }];
}

- (void)getEditorsChoiceWithBlock:(CategoriesResponseBlock)block {
    FIRDatabase *database = [FIRDatabase databaseWithURL:FirebaseDatabaseURL];
    FIRDatabaseReference *categoriesRef = [database referenceWithPath:@"categories"];
    FIRDatabaseQuery *categoryQuery = [[categoriesRef queryOrderedByChild:@"ResultCount"] queryLimitedToLast:10];
    
    [categoryQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%lu", (unsigned long)snapshot.childrenCount);
        NSMutableArray<Category *> *results = [NSMutableArray new];
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value;
            Category *category = [[Category alloc] initWithDictionary:dict];
            [results addObject:category];
        }
        
        block(results, nil);
    }];
}

- (void)getTrendingWithBlock:(CategoriesResponseBlock)block {
    FIRDatabase *database = [FIRDatabase databaseWithURL:FirebaseDatabaseURL];
    FIRDatabaseReference *categoriesRef = [database referenceWithPath:@"categories"];
    FIRDatabaseQuery *categoryQuery = [[categoriesRef queryOrderedByChild:@"Id"] queryLimitedToLast:10];
    
    [categoryQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%lu", (unsigned long)snapshot.childrenCount);
        NSMutableArray<Category *> *results = [NSMutableArray new];
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value;
            Category *category = [[Category alloc] initWithDictionary:dict];
            [results addObject:category];
        }
        
        block(results, nil);
    }];
}

@end
