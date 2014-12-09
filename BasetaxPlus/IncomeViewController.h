//
//  IncomeViewController.h
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import <UIKit/UIKit.h>

@interface IncomeViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate, UIScrollViewDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *feeds;
    NSMutableArray *feeds1;
    NSMutableArray *feeds2;
    NSMutableArray *feeds3;
    NSMutableArray *feeds4;
    NSString *databaseName;
    NSString *databasePath;
    
    NSMutableArray* m_allBusinessName;
    NSMutableArray* m_allBusinessID;

}

@property(strong,nonatomic)NSMutableArray *data;
@property(strong,nonatomic)NSMutableArray *data1;
@property(strong,nonatomic)NSMutableArray *data2;
@property(strong,nonatomic)NSMutableArray *data3;
@property(strong,nonatomic)NSMutableArray *data4;

@property (retain, nonatomic) IBOutlet UIImageView *inputBox;

@property (retain, nonatomic) IBOutlet UIImageView *lineBusiness;
@property (retain, nonatomic) IBOutlet UIImageView *lineCustomer;

@property (retain, nonatomic) IBOutlet UIImageView *lineVat;
@property (retain, nonatomic) IBOutlet UIImageView *lineCis;
@property (retain, nonatomic) IBOutlet UIImageView *lineDate;

@property (retain, nonatomic) IBOutlet UITextField *txtBusiness;
@property (retain, nonatomic) IBOutlet UIImageView *imageReceipt;
@property (retain, nonatomic) IBOutlet UIButton *btnAddReceipt;
@property (retain, nonatomic) IBOutlet UITextField *txtAmount;
@property (retain, nonatomic) IBOutlet UITextField *txtCis;
@property (retain, nonatomic) IBOutlet UITextField *txtVat;
@property (retain, nonatomic) IBOutlet UIButton *btnDate;
@property (retain, nonatomic) IBOutlet UITextField *txtDate;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UITextField *txtCustomerName;
@property (retain, nonatomic) IBOutlet UITextField *txtInvoiceReference;

@property (retain, nonatomic) IBOutlet UIButton *btnBusiness;
@property (retain, nonatomic) IBOutlet UIView *viewDate;
@property (retain, nonatomic) IBOutlet UIButton *btnDateDone;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) IBOutlet UIView *viewBusiness;
@property (retain, nonatomic) IBOutlet UITableView *tableBusiness;
@property (retain, nonatomic) IBOutlet UIView *viewRecordType;
@property (retain, nonatomic) IBOutlet UITableView *tableRecodeType;
@property (retain, nonatomic) IBOutlet UILabel *lblRecodeType;
@property (retain, nonatomic) IBOutlet UILabel *lblNoteDescription;
@property (retain, nonatomic) IBOutlet UIButton *btnRecordType;
@property (retain, nonatomic) IBOutlet UILabel *lblRecordSelected;
@property (retain, nonatomic) IBOutlet UIImageView *lineAmount;
@property (retain, nonatomic) IBOutlet UIButton *btnCash;
@property (retain, nonatomic) IBOutlet UIButton *btnCard;
@property (retain, nonatomic) IBOutlet UIButton *btnOther;

@property (retain, nonatomic) IBOutlet UIButton *btnCheque;

@end
