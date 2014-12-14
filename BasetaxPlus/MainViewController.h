//
//  MainViewController.h
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *lblTaxRebate;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@end
