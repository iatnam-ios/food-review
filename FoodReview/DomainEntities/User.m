//
//  User.m
//  FoodReview
//
//  Created by MTT on 05/06/2021.
//

#import "User.h"

@implementation User

- (instancetype)initWithUserId:(NSString *)userId userName:(NSString *)userName displayName:(NSString *)displayName email:(NSString *)email {
    self = [super init];
    if (self) {
        _userId = userId;
        _userName = userName;
        _displayName = displayName;
        _email = email;
        _gender = NoneGender;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _userId = dictionary[kUserId];
        _email = dictionary[kEmail];
        _userName = dictionary[kUserName];
        _displayName = dictionary[kDisplayName];
        _userDescription = dictionary[kUserDescription];
        NSNumber *number = dictionary[kGender];
        if (number) {
            _gender = [number integerValue];
        } else {
            _gender = NoneGender;
        }
        
        _profileImageUrl = dictionary[kProfileImageUrl];
        FIRTimestamp *birthday = dictionary[kBirthday];
        _birthday = birthday.dateValue;
    }
    return self;
}

- (NSDictionary *)getDictionary {
    FIRTimestamp *timeStamp = [FIRTimestamp timestampWithDate:self.birthday];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[kUserId] = self.userId;
    dict[kEmail] = self.email;
    dict[kUserName] = self.userName;
    dict[kDisplayName] = self.displayName;
    dict[kUserDescription] = self.userDescription;
    dict[kGender] = [NSNumber numberWithInteger:self.gender];
    dict[kBirthday] = timeStamp;
    return dict;
}

@end
