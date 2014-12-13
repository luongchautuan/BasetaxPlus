//
//  ExpenseViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import "ExpenseViewController.h"
#import "MobileCoreServices/MobileCoreServices.h"
#import <sqlite3.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "SBJson.h"

@interface ExpenseViewController ()

@end

bool cashBool,otherBool,cardBool,chequeBool;

NSString *responseString,*disallowable,*newDate;
int paymentId=1;
NSMutableArray *feeds;
NSMutableArray *feeds1;
NSMutableArray* m_allBusinessName;
NSMutableArray* m_allBusinessID;
int record;
int businessID;
BOOL viewFlag, isShowBusinessView, isShowViewDate, isShowViewRecordType;
NSString *cisinProfile,*vatinProfile;
NSString *UserID,*TransID,*RecordType,*Name,*Amount,*VAT,*CISDeduction,*PaymentType,*ReferenceName,*Description,*DateOfTrans,*Notes,*CreatedDate,*ModifiedDate,*disallo;

AppDelegate *appDelegate;

@implementation ExpenseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isShowBusinessView = YES;
    isShowViewDate = YES;

    isShowViewRecordType = YES;
    
    UITapGestureRecognizer *tapGeusturePaymemt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusturePaymemt.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGeusturePaymemt];
    
    [tapGeusturePaymemt setCancelsTouchesInView:NO];

}

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.txtAmount resignFirstResponder];
    [self.txtCis resignFirstResponder];
    [self.txtCustomerName resignFirstResponder];
    [self.txtDate resignFirstResponder];
    [self.txtExpenseReference resignFirstResponder];
    [self.txtVat resignFirstResponder];
    
    self.viewDate.hidden = YES;
    self.viewRecordType.hidden = YES;
    //    [self.scrollVIew setFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/user"]];
    
    [request addBasicAuthenticationHeaderWithUsername:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"]andPassword:[[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"]];
    [request setValidatesSecureCertificate:NO];
    
    [request startSynchronous];
    
    
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"response string-->%@",responseString);
    SBJsonParser *json = [SBJsonParser new];
    feeds = [json objectWithString:responseString];
    NSLog(@"result in profile = %@",feeds);
    
    
    vatinProfile=[feeds valueForKey:@"vatRegistered"];
    cisinProfile=[feeds valueForKey:@"cisRegistered"];
    
    if (([cisinProfile intValue]==1) &&([vatinProfile intValue]==1))
    {
        self.inputBox.frame=CGRectMake(112,4,205,230);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.inputBox.frame=CGRectMake(112,4,205,230);
        [UIView commitAnimations];
        
        
        self.txtAmount.frame=CGRectMake(122,5,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtAmount.frame=CGRectMake(122,5,205,31);
        [UIView commitAnimations];
        
        self.lineAmount.frame=CGRectMake(112,37,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineAmount.frame=CGRectMake(112,37,203,1);
        [UIView commitAnimations];
        
        self.txtVat.frame=CGRectMake(122,39,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtVat.frame=CGRectMake(122,39,205,31);
        [UIView commitAnimations];
        
        self.lineVat.frame=CGRectMake(112,71,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineVat.frame=CGRectMake(112,71,203,1);
        [UIView commitAnimations];
        
        self.txtCis.frame=CGRectMake(122,73,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtCis.frame=CGRectMake(122,73,205,31);
        [UIView commitAnimations];
        
        self.lineCis.frame=CGRectMake(112,105,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCis.frame=CGRectMake(112,105,203,1);
        [UIView commitAnimations];
        
        self.txtDate.frame=CGRectMake(123,106,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtDate.frame=CGRectMake(123,106,201,31);
        
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        
        [dateformate setDateFormat:@"dd-MM-YYYY"];
        
        NSString *date_String=[dateformate stringFromDate:[NSDate date]];
        
        NSLog(@"Current Date: %@", date_String);
        self.txtDate.text = date_String;
        
        
        [UIView commitAnimations];
        
        
        self.btnDate.frame=CGRectMake(122,106,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnDate.frame=CGRectMake(122,106,205,31);
        [UIView commitAnimations];
        
        self.lineDate.frame=CGRectMake(112,138,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineDate.frame=CGRectMake(112,138,203,1);
        [UIView commitAnimations];
        
        self.txtProviderShop.frame=CGRectMake(123,140,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtProviderShop.frame=CGRectMake(123,140,201,31);
        [UIView commitAnimations];
        
        self.lineCustomer.frame=CGRectMake(112,170,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCustomer.frame=CGRectMake(112,170,203,1);
        [UIView commitAnimations];
        
        
        self.txtExpenseReference.frame=CGRectMake(123,172,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtExpenseReference.frame=CGRectMake(123,172,201,31);
        [UIView commitAnimations];
        
        //Begin add method Business name
        
        self.viewBusiness.frame=CGRectMake(10,232,300,120);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewBusiness.frame=CGRectMake(10,232,300,120);
        [UIView commitAnimations];
        
        
        
        self.lineBusiness.frame=CGRectMake(113,201,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineBusiness.frame=CGRectMake(113,201,203,1);
        [UIView commitAnimations];
        
        self.txtBusiness.frame = CGRectMake(123,205,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtBusiness.frame=CGRectMake(123,205,201,31);
        [UIView commitAnimations];
        
        self.btnBusiness.frame = CGRectMake(123,205,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnBusiness.frame = CGRectMake(123,205,201,31);
        [UIView commitAnimations];
        
        //End
        
        self.txtVat.hidden = NO;
        self.txtCis.hidden = NO;
        self.lineVat.hidden = NO;
        self.lineCis.hidden = NO;
        
    }
    
    int height = 31;
    
    if (([cisinProfile intValue]==0) &&([vatinProfile intValue]==0))
    {
        NSLog(@"0-0");
        
        self.inputBox.frame = CGRectMake(self.inputBox.frame.origin.x , self.inputBox.frame.origin.y, self.inputBox.frame.size.width, self.inputBox.frame.size.height - height);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.inputBox.frame= CGRectMake(self.inputBox.frame.origin.x , self.inputBox.frame.origin.y, self.inputBox.frame.size.width, self.inputBox.frame.size.height - height);
        [UIView commitAnimations];
        
        self.txtDate.frame = CGRectMake(self.txtVat.frame.origin.x , self.txtVat.frame.origin.y , self.txtDate.frame.size.width ,self.txtDate.frame.size.height );
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtDate.frame = CGRectMake(self.txtVat.frame.origin.x ,self.txtVat.frame.origin.y , self.txtDate.frame.size.width , self.txtDate.frame.size.height );
        [UIView commitAnimations];
        
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        
        [dateformate setDateFormat:@"dd-MM-YYYY"];
        
        NSString *date_String=[dateformate stringFromDate:[NSDate date]];
        self.txtDate.text = date_String;
        
        self.btnDate.frame = CGRectMake(self.txtVat.frame.origin.x , self.txtVat.frame.origin.y, self.btnDate.frame.size.width , self.btnDate.frame.size.height );
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnDate.frame = CGRectMake(self.txtVat.frame.origin.x , self.txtVat.frame.origin.y, self.btnDate.frame.size.width , self.btnDate.frame.size.height );
        [UIView commitAnimations];
        
        self.lineDate.frame = CGRectMake(self.lineDate.frame.origin.x , self.txtDate.frame.origin.y + self.txtDate.frame.size.height , self.lineDate.frame.size.width,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineDate.frame = CGRectMake(self.lineDate.frame.origin.x , self.txtDate.frame.origin.y + self.txtDate.frame.size.height , self.lineDate.frame.size.width,1);
        [UIView commitAnimations];
        
        self.txtProviderShop.frame = CGRectMake(self.txtCis.frame.origin.x , self.txtCis.frame.origin.y, self.txtProviderShop.frame.size.width , self.txtProviderShop.frame.size.height );
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtProviderShop.frame = CGRectMake(self.txtCis.frame.origin.x , self.txtCis.frame.origin.y, self.txtProviderShop.frame.size.width , self.txtProviderShop.frame.size.height );
        [UIView commitAnimations];
        
        self.lineCustomer.frame = CGRectMake(self.lineCustomer.frame.origin.x , self.txtCis.frame.origin.y + self.txtCis.frame.size.height , self.lineCustomer.frame.size.width, 1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCustomer.frame = CGRectMake(self.lineCustomer.frame.origin.x , self.txtCis.frame.origin.y + self.txtCis.frame.size.height , self.lineCustomer.frame.size.width, 1);
        [UIView commitAnimations];
        
        self.txtExpenseReference.frame = CGRectMake(self.txtExpenseReference.frame.origin.x, self.lineCustomer.frame.origin.y + 1, self.txtExpenseReference.frame.size.width, self.txtExpenseReference.frame.size.height);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtExpenseReference.frame = CGRectMake(self.txtExpenseReference.frame.origin.x, self.lineCustomer.frame.origin.y + 1, self.txtExpenseReference.frame.size.width, self.txtExpenseReference.frame.size.height);
        [UIView commitAnimations];
        
        //Begin add method Business name
        
        self.lineBusiness.frame = CGRectMake(self.lineBusiness.frame.origin.x , self.txtExpenseReference.frame.origin.y + self.txtExpenseReference.frame.size.height , self.lineBusiness.frame.size.width, 1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineBusiness.frame = CGRectMake(self.lineBusiness.frame.origin.x , self.txtExpenseReference.frame.origin.y + self.txtExpenseReference.frame.size.height , self.lineBusiness.frame.size.width, 1);
        [UIView commitAnimations];
        
        self.txtBusiness.frame = CGRectMake(self.txtBusiness.frame.origin.x, self.lineBusiness.frame.origin.y + 1, self.txtBusiness.frame.size.width, self.txtBusiness.frame.size.height);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtBusiness.frame = CGRectMake(self.txtBusiness.frame.origin.x, self.lineBusiness.frame.origin.y + 1, self.txtBusiness.frame.size.width, self.txtBusiness.frame.size.height);
        [UIView commitAnimations];
        
        self.btnBusiness.frame = CGRectMake(self.btnBusiness.frame.origin.x, self.lineBusiness.frame.origin.y + 1, self.btnBusiness.frame.size.width, self.btnBusiness.frame.size.height);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnBusiness.frame = CGRectMake(self.btnBusiness.frame.origin.x, self.lineBusiness.frame.origin.y + 1, self.btnBusiness.frame.size.width, self.btnBusiness.frame.size.height);
        [UIView commitAnimations];
        
        self.viewDate.frame = CGRectMake(self.viewDate.frame.origin.x, self.lineDate.frame.origin.y + 5, self.viewDate.frame.size.width, self.viewDate.frame.size.height);
        self.viewBusiness.frame = CGRectMake(self.viewBusiness.frame.origin.x, self.inputBox.frame.size.height + 5, self.viewBusiness.frame.size.width, self.viewBusiness.frame.size.height);
        //End
        
        self.txtVat.hidden=YES;
        self.txtCis.hidden=YES;
        self.lineVat.hidden=YES;
        self.lineCis.hidden=YES;
    }
    
    
    
    if (([cisinProfile intValue]==0) &&([vatinProfile intValue]==1))
    {
        self.inputBox.frame=CGRectMake(112,4,205,221);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.inputBox.frame=CGRectMake(112,4,205,221);
        [UIView commitAnimations];
        
        
        self.txtAmount.frame=CGRectMake(122,8,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtAmount.frame=CGRectMake(122,8,205,31);
        [UIView commitAnimations];
        
        self.lineAmount.frame=CGRectMake(112,41,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineAmount.frame=CGRectMake(112,41,203,1);
        [UIView commitAnimations];
        
        self.txtVat.frame=CGRectMake(122,45,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtVat.frame=CGRectMake(122,45,205,31);
        [UIView commitAnimations];
        
        self.lineVat.frame=CGRectMake(112,77,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineVat.frame=CGRectMake(112,77,203,1);
        [UIView commitAnimations];
        
        self.txtDate.frame=CGRectMake(123,81,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtDate.frame=CGRectMake(123,81,201,31);
        
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        
        [dateformate setDateFormat:@"dd-MM-YYYY"];
        
        NSString *date_String=[dateformate stringFromDate:[NSDate date]];
        
        NSLog(@"Current Date: %@", date_String);
        self.txtDate.text = date_String;
        
        
        [UIView commitAnimations];
        
        self.btnDate.frame=CGRectMake(122,80,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnDate.frame=CGRectMake(122,80,205,31);
        [UIView commitAnimations];
        
        self.lineDate.frame=CGRectMake(112,115,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineDate.frame=CGRectMake(112,115,203,1);
        [UIView commitAnimations];
        
        self.txtProviderShop.frame=CGRectMake(123,120,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtProviderShop.frame=CGRectMake(123,120,201,31);
        [UIView commitAnimations];
        
        self.lineCustomer.frame=CGRectMake(112,153,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCustomer.frame=CGRectMake(112,153,203,1);
        [UIView commitAnimations];
        
        
        self.txtExpenseReference.frame=CGRectMake(123,159,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtExpenseReference.frame=CGRectMake(123,159,201,31);
        [UIView commitAnimations];
        
        //Begin add method Business name
        
        self.viewBusiness.frame=CGRectMake(10,232,300,120);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewBusiness.frame=CGRectMake(10,232,300,120);
        [UIView commitAnimations];
        
        
        
        self.lineBusiness.frame=CGRectMake(113,190,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineBusiness.frame=CGRectMake(113,190,203,1);
        [UIView commitAnimations];
        
        self.txtBusiness.frame=CGRectMake(123,193,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtBusiness.frame=CGRectMake(123,193,201,31);
        [UIView commitAnimations];
        
        self.btnBusiness.frame = CGRectMake(123,193,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnBusiness.frame=CGRectMake(123,193,201,31);
        [UIView commitAnimations];
        
        //End
        
        
        self.txtCis.hidden=YES;
        self.lineCis.hidden=YES;
        self.txtVat.hidden=NO;
        self.lineVat.hidden=NO;
    }
    
    
    
    if (([cisinProfile intValue]==1) &&([vatinProfile intValue]==0))
    {
        self.inputBox.frame=CGRectMake(112,4,205,221);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.inputBox.frame=CGRectMake(112,4,205,221);
        [UIView commitAnimations];
        
        
        self.txtAmount.frame=CGRectMake(122,8,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtAmount.frame=CGRectMake(122,8,205,31);
        [UIView commitAnimations];
        
        self.lineAmount.frame=CGRectMake(112,41,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineAmount.frame=CGRectMake(112,41,203,1);
        [UIView commitAnimations];
        
        self.txtCis.frame=CGRectMake(122,45,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtCis.frame=CGRectMake(122,45,205,31);
        [UIView commitAnimations];
        
        self.lineCis.frame=CGRectMake(112,77,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCis.frame=CGRectMake(112,77,203,1);
        [UIView commitAnimations];
        
        self.txtDate.frame=CGRectMake(123,81,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtDate.frame=CGRectMake(123,81,201,31);
        
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        
        [dateformate setDateFormat:@"dd-MM-YYYY"];
        
        NSString *date_String=[dateformate stringFromDate:[NSDate date]];
        
        NSLog(@"Current Date: %@", date_String);
        self.txtDate.text = date_String;
        
        
        [UIView commitAnimations];
        
        self.btnDate.frame=CGRectMake(122,80,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnDate.frame=CGRectMake(122,80,205,31);
        [UIView commitAnimations];
        
        self.lineDate.frame=CGRectMake(112,115,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineDate.frame=CGRectMake(112,115,203,1);
        [UIView commitAnimations];
        
        self.txtProviderShop.frame=CGRectMake(123,120,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtProviderShop.frame=CGRectMake(123,120,201,31);
        [UIView commitAnimations];
        
        self.lineCustomer.frame=CGRectMake(112,153,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCustomer.frame=CGRectMake(112,153,203,1);
        [UIView commitAnimations];
        
        self.txtExpenseReference.frame=CGRectMake(123,159,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtExpenseReference.frame=CGRectMake(123,159,201,31);
        [UIView commitAnimations];
        
        //Begin add method Business name
        
        self.viewBusiness.frame=CGRectMake(10,232,300,120);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.viewBusiness.frame=CGRectMake(10,232,300,120);
        [UIView commitAnimations];     
        
        self.lineBusiness.frame=CGRectMake(113,190,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineBusiness.frame=CGRectMake(113,190,203,1);
        [UIView commitAnimations];
        
        self.txtBusiness.frame=CGRectMake(123,193,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtBusiness.frame=CGRectMake(123,193,201,31);
        [UIView commitAnimations];
        
        self.btnBusiness.frame = CGRectMake(123,193,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnBusiness.frame=CGRectMake(123,193,201,31);
        [UIView commitAnimations];
        
        //End
        
        self.txtVat.hidden=YES;
        self.lineVat.hidden=YES;
        self.txtCis.hidden=NO;
        self.lineCis.hidden=NO;
        
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSaveExpense_Clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAddReceipt_Clicked:(id)sender
{
    UIActionSheet *action_sheet = [[UIActionSheet alloc]initWithTitle:@"Upload options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil];
    
    [action_sheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (IBAction)btnSaveDate_Clicked:(id)sender
{
    self.viewDate.hidden = YES;
}

- (IBAction)btnDateSelected_Clicked:(id)sender
{
    isShowViewDate = !isShowViewDate;
    if (isShowViewDate) {
        self.viewDate.hidden = YES;
    }
    else
    {
        self.viewDate.hidden = NO;
    }
    
}

- (IBAction)btnRecordTypeSelected_Clicked:(id)sender
{
    isShowViewRecordType = !isShowViewRecordType;
    if (isShowViewRecordType) {
        self.viewRecordType.hidden = YES;
    }
    else
    {
        self.viewRecordType.hidden = NO;
    }
}

- (IBAction)btnBusinessSelected_Clicked:(id)sender
{
    isShowBusinessView = !isShowBusinessView;
    if (isShowBusinessView) {
        self.viewBusiness.hidden = YES;
    }
    else
    {
        self.viewBusiness.hidden = NO;
    }
}


- (IBAction)onCheckCashPopup:(id)sender
{
    UIButton *btn1 = sender;
    
    [btn1 setImage:[UIImage imageNamed:@"cash button (select).png"] forState:UIControlStateNormal];
    
    cardBool = FALSE;
    chequeBool = FALSE;
    otherBool = FALSE;
    
    [self.btnCard setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnCheque setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnOther setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    
    //    self.txtPaymentType.text = @"Cash";
    //    [self checkStateOfButtonPopup:isCheckTypeInPopup];
}

- (IBAction)onCheckChequePopup:(id)sender
{
    UIButton *btn1 = sender;
    
    chequeBool = TRUE ;
    [btn1 setImage:[UIImage imageNamed:@"cheque button ( select).png"] forState:UIControlStateNormal];    
    
    [self.btnCard setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnCash setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    [self.btnOther setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    
    cardBool = FALSE;
    cashBool = FALSE;
    otherBool = FALSE;
    
    //    self.txtPaymentType.text = @"Cheque";
    
}

- (IBAction)onCheckCardPopup:(id)sender
{
    UIButton *btn1 = sender;
    
    [btn1 setImage:[UIImage imageNamed:@"card button (select).png"] forState:UIControlStateNormal];
    cardBool = TRUE;
    
    [self.btnCash setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    [self.btnCheque setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnOther setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    
    cashBool = FALSE;
    chequeBool = FALSE;
    otherBool = FALSE;
    
    //    self.txtPaymentType.text = @"Card";
    
}

- (IBAction)onCheckOtherPopup:(id)sender
{
    UIButton *btn1 = sender;
    
    otherBool = TRUE ;
    
    [btn1 setImage:[UIImage imageNamed:@"other button (select).png"] forState:UIControlStateNormal];
    
    [self.btnCard setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnCheque setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnCash setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    
    cardBool = FALSE;
    chequeBool = FALSE;
    cashBool = FALSE;
    
    //    self.txtPaymentType.text = @"Other";
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_btnCash release];
    [_btnCheque release];
    [_btnCard release];
    [_btnOther release];
    [_txtProviderShop release];
    [_btnCheckDisallowable release];
    [_btnInformation release];
    [_viewInformation release];
    [super dealloc];
}
@end
