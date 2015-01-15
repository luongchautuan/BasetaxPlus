//
//  MainViewController.h
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "SMTPSend/SKPSMTPMessage.h"
#import <MessageUI/MessageUI.h>

@interface MainViewController : UIViewController<UIAlertViewDelegate, MenuViewControllerDelegate, SKPSMTPMessageDelegate, MFMailComposeViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *lblTaxRebate;
@property (retain, nonatomic) IBOutlet UILabel *lblTaxYear;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *btnMenu;

@end
