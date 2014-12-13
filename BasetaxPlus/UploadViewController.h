//
//  UploadViewController.h
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"

@interface UploadViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate, UIScrollViewDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ELCImagePickerControllerDelegate>

@property (retain, nonatomic) IBOutlet UIView *viewAddMore;
@property (retain, nonatomic) IBOutlet UIView *viewAddMoreMain;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain)NSMutableArray* documents;

@end
