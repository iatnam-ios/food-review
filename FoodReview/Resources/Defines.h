//
//  Defines.h
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#ifndef Defines_h
#define Defines_h

static NSString * const kSortByNewestFirst = @"Newest First";
static NSString * const kSortByOldestFirst = @"Oldest First";
static NSString * const kSortByTitle = @"Title";
static NSString * const kSortByArtist = @"Artist";

static NSString * const kUserId = @"userId";
static NSString * const kEmail = @"email";
static NSString * const kUserName = @"userName";
static NSString * const kDisplayName = @"displayName";
static NSString * const kUserDescription = @"userDescription";
static NSString * const kGender = @"gender";
static NSString * const kProfileImageUrl = @"profileImageUrl";
static NSString * const kBirthday = @"birthday";

typedef enum Gender {
    MaleGender = 0,
    FemaleGender = 1,
    OtherGender = 2,
    NoneGender = 3,
}Gender;

#define WEBSITE                         @"http://l7mobile.com/"
#define EMAIL_SUPPORT                   @"support@l7mobile.com"
#define EMAIL_SUPPORT_SUBJECT           @"Music Tube Feedback:"
#define APP_ID                          @"1040036079"
#define OLD_SCHEMA_VERSION              @"OLD_SCHEMA_VERSION"

#define PREF_PLAYING_MODE               @"PREF_PLAYING_MODE"
#define PREF_SORT_PLAYLISTS             @"PREF_SORT_PLAYLISTS"
#define PREF_SORT_TYPE                  @"PREF_SORT_TYPE"
#define PREF_VIDEO_RESOLUTION           @"PREF_VIDEO_RESOLUTION"
#define PREF_SHUFFLE_PLAYING            @"PREF_SHUFFLE_PLAYING"
#define PREF_REPEAT_PLAYING             @"PREF_REPEAT_PLAYING"
#define PREF_LEADING_ACTION             @"PREF_LEADING_ACTION"
#define PREF_TRAILING_ACTION            @"PREF_TRAILING_ACTION"

#define sharedTabBar                    [TabBarController sharedInstance]
#define IS_LANDSCAPE                    UIInterfaceOrientationIsLandscape([TabBarController sharedInstance].preferredInterfaceOrientationForPresentation)
#define IS_IPAD                         [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad
#define IS_IPHONE                       [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
#define SCREEN_HEIGHT                   UIScreen.mainScreen.bounds.size.height
#define SCREEN_WIDTH                    UIScreen.mainScreen.bounds.size.width
#define COUNT_PLUS_ADS_ACTION           1
#define COUNT_PLUS_ADS_PLAY             3
#define ADS_COUNT_MAX                   7
#define ADS_TIMER                       180

#define IS_LEADING_ON                   [[NSUserDefaults standardUserDefaults] boolForKey:PREF_LEADING_ACTION]
#define IS_TRAILING_ON                  [[NSUserDefaults standardUserDefaults] boolForKey:PREF_TRAILING_ACTION]
#define IS_SHUFFLE_ON                   [[NSUserDefaults standardUserDefaults] boolForKey:PREF_SHUFFLE_PLAYING]
#define IS_VIDEO_MODE                   [[NSUserDefaults standardUserDefaults] boolForKey:PREF_PLAYING_MODE]
#define IS_HD_RESOLUTION                [[NSUserDefaults standardUserDefaults] boolForKey:PREF_VIDEO_RESOLUTION]

#define IS_SCREEN_4_INCHES              ((fabs((double)[[ UIScreen mainScreen] bounds].size.width - (double)568) < DBL_EPSILON) || (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON))

#define IS_SCREEN_4_7_INCHES            ((fabs((double)[[UIScreen mainScreen] bounds].size.width - (double)667) < DBL_EPSILON) || (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < DBL_EPSILON))

#define IS_SCREEN_5_5_INCHES            ((fabs((double)[[UIScreen mainScreen] bounds].size.width - (double)736) < DBL_EPSILON) || (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < DBL_EPSILON))


#endif /* Defines_h */
