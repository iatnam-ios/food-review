//
//  TabBarController.m
//  FoodReview
//
//  Created by MTT on 18/05/2021.
//

#import "TabBarController.h"
#import "LandingViewController.h"
#import "SearchPlacesViewController.h"
#import "ApplicationLogic.h"
#import "ExternalInterfaces.h"

@interface TabBarController ()<UITabBarControllerDelegate>

@property (nonatomic) id<AppDataProvider> dataProvider;

@end

@implementation TabBarController

+ (instancetype)sharedInstance {
    static TabBarController *sharedInstance;
    
    if (sharedInstance == nil) {
        static dispatch_once_t once;
        
        dispatch_once(&once, ^{
            sharedInstance = [[TabBarController alloc] init];
        });
    }

    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialize];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self setupAppearances];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [self.view addSubview: self.statusBar];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self updateUIAppearances];
    self.statusBar.frame = self.view.window.windowScene.statusBarManager.statusBarFrame;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Initialize

- (void)initialize {
    self.dataProvider = [ExternalInterfaces makeAppDatabaseClient];
    self.delegate = self;
}

#pragma mark - SetupAppearances

- (void)setupAppearances {
    [UINavigationBar.appearance setBackgroundImage: [UIImage new] forBarMetrics: UIBarMetricsDefault];
    UINavigationBar.appearance.prefersLargeTitles = YES;
    UINavigationBar.appearance.translucent = YES;
    UINavigationBar.appearance.barStyle = UIBarStyleDefault;
    UINavigationBar.appearance.shadowImage = [UIImage new];
    
    UITabBar.appearance.translucent = YES;
    UITabBar.appearance.opaque = YES;
    UITabBar.appearance.layer.masksToBounds = YES;
    UITabBar.appearance.layer.shadowOffset = CGSizeMake(0.0, -6.0);
    UITabBar.appearance.layer.shadowRadius = 5.0;
    UITabBar.appearance.layer.shadowOpacity = 0.7;
    UITabBar.appearance.layer.shadowColor = UIColor.redPinkColor.CGColor;
    UITabBar.appearance.tintColor = UIColor.redPinkColor;
}

#pragma mark - UpdateUIAppearances

- (void)updateUIAppearances {
    self.statusBar.backgroundColor = UIColor.systemGroupedBackgroundColor;
    [UITabBar.appearance setBarTintColor: UIColor.systemGroupedBackgroundColor];
    [UINavigationBar.appearance setBarTintColor: UIColor.systemGroupedBackgroundColor];
    [UINavigationBar.appearance setTintColor: UIColor.systemBlueColor];
    [UINavigationBar.appearance setBackgroundColor: UIColor.systemGroupedBackgroundColor];
    [UINavigationBar.appearance setLargeTitleTextAttributes: @{NSForegroundColorAttributeName: UIColor.labelColor , NSFontAttributeName: [UIFont boldSystemFontOfSize:32.0]}];
    [UINavigationBar.appearance setTitleTextAttributes: @{NSForegroundColorAttributeName: UIColor.labelColor, NSFontAttributeName: [UIFont boldSystemFontOfSize:20.0]}];
}

#pragma mark - SetupViews

- (UIView *)statusBar {
    if (!_statusBar) {
        _statusBar = [[UIView alloc] init];
    }
    return _statusBar;
}

- (HomeViewController *)homeViewController {
    if (!_homeViewController) {
        _homeViewController = [[HomeViewController alloc] init];
    }
    return _homeViewController;
}

- (SearchViewController *)searchViewController {
    if (!_searchViewController) {
        _searchViewController = [[SearchViewController alloc] init];
    }
    return _searchViewController;
}

- (CreateViewController *)createViewController {
    if (!_createViewController) {
        _createViewController = [[CreateViewController alloc] init];
    }
    return _createViewController;
}

- (NotificationViewController *)notificationViewController {
    if (!_notificationViewController) {
        _notificationViewController = [[NotificationViewController alloc] init];
    }
    return _notificationViewController;
}

- (UserViewController *)userViewController {
    if (!_userViewController) {
        _userViewController = [[UserViewController alloc] init];
    }
    return _userViewController;
}

- (void)setupViews {
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:20.0 weight:UIImageSymbolWeightRegular];
    self.homeViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"house" withConfiguration:configuration] selectedImage:[UIImage systemImageNamed:@"house.fill" withConfiguration:configuration]];
    self.searchViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"magnifyingglass" withConfiguration:configuration] selectedImage:[UIImage systemImageNamed:@"magnifyingglass" withConfiguration:configuration]];
    self.createViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"plus.circle" withConfiguration:configuration] selectedImage:[UIImage systemImageNamed:@"plus.circle.fill" withConfiguration:configuration]];
    self.notificationViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"bell" withConfiguration:configuration] selectedImage:[UIImage systemImageNamed:@"bell.fill" withConfiguration:configuration]];
    self.userViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"person" withConfiguration:configuration] selectedImage:[UIImage systemImageNamed:@"person.fill" withConfiguration:configuration]];
    
    self.homeViewController.tabBarItem.tag = 0;
    self.searchViewController.tabBarItem.tag = 1;
    self.createViewController.tabBarItem.tag = 2;
    self.notificationViewController.tabBarItem.tag = 3;
    self.userViewController.tabBarItem.tag = 4;
    
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController: self.homeViewController];
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController: self.searchViewController];
    UINavigationController *createNav = [[UINavigationController alloc] initWithRootViewController: self.createViewController];
    UINavigationController *notiNav = [[UINavigationController alloc] initWithRootViewController: self.notificationViewController];
    UINavigationController *userNav = [[UINavigationController alloc] initWithRootViewController: self.userViewController];
    
    self.viewControllers = @[homeNav, searchNav, createNav, notiNav, userNav];
}

#pragma mark - Supporting Methods

- (nullable UINavigationController *)currentNavigationController {
    UITabBarItem *selectedItem = self.tabBar.selectedItem;
    if (selectedItem) {
        if (selectedItem.tag == 0) {
            return self.homeViewController.navigationController;
        } else if (selectedItem.tag == 1) {
            return self.searchViewController.navigationController;
        } else if (selectedItem.tag == 2) {
            return self.createViewController.navigationController;
        } else if (selectedItem.tag == 3) {
            return self.notificationViewController.navigationController;
        } else {
            return self.userViewController.navigationController;
        }
    }
    return nil;
}

#pragma mark - UITabbarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if (viewController.tabBarItem.tag > 2) {
//        if (FIRAuth.auth.currentUser == nil) {
//            LandingViewController *vc = [[LandingViewController alloc] init];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            nav.modalPresentationStyle = UIModalPresentationFullScreen;
//            [viewController presentViewController:nav animated:YES completion:nil];
//        }
//    } else if (viewController.tabBarItem.tag == 2) {
//        if (FIRAuth.auth.currentUser == nil) {
//            UIViewController *vc = [ViewControllerRouter.shared createSearchPlacesVC];
//            [self.createViewController.navigationController pushViewController:vc animated:YES];
//        }
//    }
    
    return YES;
}

#pragma mark - Tabbar

- (void)addAnimationSelected:(NSInteger)index {
    CGRect rect = [self frameForTabInTabBar:self.tabBar withIndex:index];
    UIView *vf = [[UIView alloc] init];
    vf.frame = rect;
    vf.backgroundColor = [UIColor clearColor];
    vf.clipsToBounds = YES;
    
    [self.tabBar addSubview:vf];
    
    UIView *v = [[UIView alloc] init];
    v.frame = CGRectMake((vf.frame.size.width - 5) / 2, (vf.frame.size.height - 5) / 2, 5, 5);
    v.backgroundColor = UIColor.redPinkColor;
    v.layer.cornerRadius = v.frame.size.height / 2;
    v.alpha = 0.4;
    
    [vf addSubview:v];
    
    [UIView animateWithDuration:0.3 animations:^{
        v.alpha = 0.1;
        v.transform = CGAffineTransformMakeScale(30, 30);
    } completion:^(BOOL finished) {
        [vf removeFromSuperview];
    }];
}

- (CGRect)frameForTabInTabBar:(UITabBar *)tabBar withIndex:(NSUInteger)index {
    NSMutableArray *tabBarItems = [NSMutableArray arrayWithCapacity:[tabBar.items count]];
    
    for (UIView *view in tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")] && [view respondsToSelector:@selector(frame)]) {
            [tabBarItems addObject:view];
        }
    }
    
    if ([tabBarItems count] == 0) {
        // no tabBarItems means either no UITabBarButtons were in the subView, or none responded to -frame
        // return CGRectZero to indicate that we couldn't figure out the frame
        return CGRectZero;
    }
    
    // sort by origin.x of the frame because the items are not necessarily in the correct order
    [tabBarItems sortUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        if (view1.frame.origin.x < view2.frame.origin.x) {
            return NSOrderedAscending;
        }
        
        if (view1.frame.origin.x > view2.frame.origin.x) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    CGRect frame = CGRectZero;
    
    if (index < [tabBarItems count]) {
        // viewController is in a regular tab
        UIView *tabView = tabBarItems[index];
        
        if ([tabView respondsToSelector:@selector(frame)]) {
            frame = tabView.frame;
        }
    } else {
        // our target viewController is inside the "more" tab
        UIView *tabView = [tabBarItems lastObject];
        
        if ([tabView respondsToSelector:@selector(frame)]) {
            frame = tabView.frame;
        }
    }
    
    return frame;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self addAnimationSelected:item.tag];
}

@end
