//
//  MenuViewController.h
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 1/9/15.
//
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate <NSObject>

@optional
- (void)selectCategory:(int)ID;

@end

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (assign) id<MenuViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain)NSArray *arrData;
@end
