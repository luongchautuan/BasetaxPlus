//
//  BIProfileViewController.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/20/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BIProfileViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) IBOutlet UIImageView *imageProfile;
@property (assign, nonatomic) IBOutlet UILabel *lblDisplayName;
@property (assign, nonatomic) IBOutlet UILabel *lblEmail;
@property (assign, nonatomic) IBOutlet UITextField *txtDisplayName;

@property (assign, nonatomic) IBOutlet UITextField *txtEmail;
@property (assign, nonatomic) IBOutlet UIView *viewPopUp;
@property (assign, nonatomic) IBOutlet UIView *viewPopUpMain;
@property (assign, nonatomic) IBOutlet UIButton *btnEditImage;
@property (assign, nonatomic) IBOutlet UIButton *btnEditDisplayName;

@end
