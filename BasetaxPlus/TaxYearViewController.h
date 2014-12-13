//
//  TaxYearViewController.h
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/10/14.
//
//

#import <UIKit/UIKit.h>

@interface TaxYearViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewTable;
@property (strong, nonatomic) IBOutlet UITextField *yeartxt;
@property (strong, nonatomic) IBOutlet UITableView *tableViewYear;
@property(strong,nonatomic) NSString *year;
@property (nonatomic)NSMutableArray* data;
@end
