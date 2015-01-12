//
//  AppDelegate.h
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UserReponsitory.h"
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MMDrawerController * drawerController;
@property (nonatomic)MBProgressHUD* activityIndicatorView;
@property (nonatomic)int transactionID;
@property (nonatomic,readwrite) int IDyear;
@property(nonatomic,strong)NSString *year;
@property(strong,readwrite)NSMutableArray *feeds;
@property(strong,nonatomic)UIImage *image;
@property (nonatomic,readwrite) int tidPhoto;
@property (nonatomic,readwrite) BOOL PhotoClick;
@property (nonatomic)BOOL isLoginSucessfully;
@property (nonatomic, retain)UserReponsitory* userReponsitory;
@property (nonatomic)BOOL isLoginSucesss;
@property (nonatomic) CGSize result;

@end

