//
//  MainViewController.h
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface MainViewController : UIViewController<UIAlertViewDelegate, MenuViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *lblTaxRebate;
@property (retain, nonatomic) IBOutlet UILabel *lblTaxYear;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *btnMenu;

@end
