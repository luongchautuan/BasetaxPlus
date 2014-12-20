//
//  IncomeViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import "IncomeViewController.h"
#import "MobileCoreServices/MobileCoreServices.h"
#import <sqlite3.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "SBJson.h"

#define ACCEPTABLE_CHARECTERS @"0123456789."

@interface IncomeViewController ()


@end

NSString *UserID,*TransID,*RecordType,*Name, *Amount,*VAT,*CISDeduction,*PaymentType,*ReferenceName,*Description,*DateOfTrans,*Notes,*CreatedDate,*ModifiedDate;
NSString *newDate,*cid;
int flafID;
NSString *cisinProfile,*vatinProfile;

bool first,firsttable, isShowBusinessView, isShowViewDate, isShowViewRecordType, isEdit;
bool cashBool,otherBool,cardBool,chequeBool, isCurrentDay;
BOOL viewFlag;
NSMutableArray *weitAry;
NSString *responseString;
AppDelegate *appdelegate;
int record;
int paymentId;
int businessID;


@implementation IncomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isShowBusinessView = YES;
    isShowViewDate = YES;
    firsttable = YES;
    isShowViewRecordType = YES;
    self.amountIncome = nil;
    
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate] ;
    
    ASIHTTPRequest *requestUser = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/user"]];
    
    [requestUser addBasicAuthenticationHeaderWithUsername:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"]andPassword:[[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"]];
    [requestUser setValidatesSecureCertificate:NO];
    
    [requestUser startSynchronous];
    
    NSString *responseString = [[NSString alloc] initWithData:[requestUser responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *json = [SBJsonParser new];
    self.feeds = [json objectWithString:responseString];
    
    vatinProfile = [self.feeds valueForKey:@"vatRegistered"];
    cisinProfile = [self.feeds valueForKey:@"cisRegistered"];
    
    
    if (([cisinProfile intValue]==1) &&([vatinProfile intValue]==1))
    {
        NSLog(@"1-1");
        self.inputBox.frame=CGRectMake(113,4,205,229);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.inputBox.frame=CGRectMake(113,4,205,231);
        [UIView commitAnimations];
        
        
        self.txtAmount.frame=CGRectMake(122,5,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtAmount.frame=CGRectMake(122,5,205,31);
        [UIView commitAnimations];
        
        self.lineAmount.frame=CGRectMake(113,37,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineAmount.frame=CGRectMake(113,37,203,1);
        [UIView commitAnimations];
        
        self.txtVat.frame=CGRectMake(123,39,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtVat.frame=CGRectMake(123,39,205,31);
        [UIView commitAnimations];
        
        self.lineVat.frame=CGRectMake(113,71,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineVat.frame=CGRectMake(113,71,203,1);
        [UIView commitAnimations];
        
        self.txtCis.frame=CGRectMake(122,73,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtCis.frame=CGRectMake(122,73,205,31);
        [UIView commitAnimations];
        
        self.lineCis.frame=CGRectMake(113,105,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCis.frame=CGRectMake(113,105,203,1);
        [UIView commitAnimations];
        
        self.txtDate.frame=CGRectMake(123,106,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtDate.frame=CGRectMake(123,106,201,31);
        [UIView commitAnimations];
        
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        
        [dateformate setDateFormat:@"dd-MM-YYYY"];
        
        NSString *date_String=[dateformate stringFromDate:[NSDate date]];
        
        //        NSLog(@"Current Date: %@", date_String);
        self.txtDate.text = date_String;
        
        
        self.btnDate.frame=CGRectMake(122,106,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnDate.frame=CGRectMake(122,106,205,31);
        [UIView commitAnimations];
        
        self.lineDate.frame=CGRectMake(113,138,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineDate.frame=CGRectMake(113,138,203,1);
        [UIView commitAnimations];
        
        self.txtCustomerName.frame=CGRectMake(123,140,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtCustomerName.frame=CGRectMake(123,140,201,31);
        [UIView commitAnimations];
        
        self.lineCustomer.frame=CGRectMake(113,170,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCustomer.frame=CGRectMake(113,170,203,1);
        [UIView commitAnimations];
        
        
        self.txtInvoiceReference.frame=CGRectMake(123,172,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtInvoiceReference.frame=CGRectMake(123,172,201,31);
        [UIView commitAnimations];
        
        
        self.txtVat.hidden=NO;
        self.txtCis.hidden=NO;
        self.lineCis.hidden=NO;
        self.lineVat.hidden=NO;
        
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
        
        self.txtCustomerName.frame = CGRectMake(self.txtCis.frame.origin.x , self.txtCis.frame.origin.y, self.txtCustomerName.frame.size.width , self.txtCustomerName.frame.size.height );
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtCustomerName.frame = CGRectMake(self.txtCis.frame.origin.x , self.txtCis.frame.origin.y, self.txtCustomerName.frame.size.width , self.txtCustomerName.frame.size.height );
        [UIView commitAnimations];
        
        self.lineCustomer.frame = CGRectMake(self.lineCustomer.frame.origin.x , self.txtCis.frame.origin.y + self.txtCis.frame.size.height , self.lineCustomer.frame.size.width, 1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCustomer.frame = CGRectMake(self.lineCustomer.frame.origin.x , self.txtCis.frame.origin.y + self.txtCis.frame.size.height , self.lineCustomer.frame.size.width, 1);
        [UIView commitAnimations];
        
        self.txtInvoiceReference.frame = CGRectMake(self.txtInvoiceReference.frame.origin.x, self.lineCustomer.frame.origin.y + 1, self.txtInvoiceReference.frame.size.width, self.txtInvoiceReference.frame.size.height);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtInvoiceReference.frame = CGRectMake(self.txtInvoiceReference.frame.origin.x, self.lineCustomer.frame.origin.y + 1, self.txtInvoiceReference.frame.size.width, self.txtInvoiceReference.frame.size.height);
        [UIView commitAnimations];
        
        //Begin add method Business name
        
        self.lineBusiness.frame = CGRectMake(self.lineBusiness.frame.origin.x , self.txtInvoiceReference.frame.origin.y + self.txtInvoiceReference.frame.size.height , self.lineBusiness.frame.size.width, 1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineBusiness.frame = CGRectMake(self.lineBusiness.frame.origin.x , self.txtInvoiceReference.frame.origin.y + self.txtInvoiceReference.frame.size.height , self.lineBusiness.frame.size.width, 1);
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
        NSLog(@"0-1");
        self.inputBox.frame=CGRectMake(113,4,205,221);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.inputBox.frame=CGRectMake(113,4,205,221);
        [UIView commitAnimations];
        
        
        self.txtAmount.frame=CGRectMake(122,8,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtAmount.frame=CGRectMake(122,8,205,31);
        [UIView commitAnimations];
        
        self.lineAmount.frame=CGRectMake(113,41,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineAmount.frame=CGRectMake(113,41,203,1);
        [UIView commitAnimations];
        
        self.txtVat.frame=CGRectMake(122,45,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtVat.frame=CGRectMake(122,45,205,31);
        [UIView commitAnimations];
        
        self.lineVat.frame=CGRectMake(113,77,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineVat.frame=CGRectMake(113,77,203,1);
        [UIView commitAnimations];
        
        self.txtDate.frame=CGRectMake(123,81,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtDate.frame=CGRectMake(123,81,201,31);
        [UIView commitAnimations];
        
        //Set current date.
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        
        [dateformate setDateFormat:@"dd-MM-YYYY"];
        
        NSString *date_String=[dateformate stringFromDate:[NSDate date]];
        
        //        NSLog(@"Current Date: %@", date_String);
        self.txtDate.text = date_String;
        
        
        self.btnDate.frame=CGRectMake(122,80,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnDate.frame=CGRectMake(122,80,205,31);
        [UIView commitAnimations];
        
        self.lineDate.frame=CGRectMake(113,115,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineDate.frame=CGRectMake(113,115,203,1);
        [UIView commitAnimations];
        
        self.txtCustomerName.frame=CGRectMake(123,120,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtCustomerName.frame=CGRectMake(123,120,201,31);
        [UIView commitAnimations];
        
        self.lineCustomer.frame=CGRectMake(113,153,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCustomer.frame=CGRectMake(113,153,203,1);
        [UIView commitAnimations];
        
        
        self.txtInvoiceReference.frame=CGRectMake(123,159,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtInvoiceReference.frame=CGRectMake(123,159,201,31);
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
        NSLog(@"1-0");
        self.inputBox.frame=CGRectMake(113,4,205,221);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.inputBox.frame=CGRectMake(113,4,205,221);
        [UIView commitAnimations];
        
        
        self.txtAmount.frame=CGRectMake(122,8,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtAmount.frame=CGRectMake(122,8,205,31);
        [UIView commitAnimations];
        
        self.lineAmount.frame=CGRectMake(113,41,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineAmount.frame=CGRectMake(113,41,203,1);
        [UIView commitAnimations];
        
        self.txtCis.frame=CGRectMake(122,45,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtCis.frame=CGRectMake(122,45,205,31);
        [UIView commitAnimations];
        
        self.lineCis.frame=CGRectMake(113,77,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCis.frame=CGRectMake(113,77,203,1);
        [UIView commitAnimations];
        
        self.txtDate.frame=CGRectMake(123,81,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtDate.frame=CGRectMake(123,81,201,31);
        [UIView commitAnimations];
        
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        
        [dateformate setDateFormat:@"dd-MM-YYYY"];
        
        NSString *date_String=[dateformate stringFromDate:[NSDate date]];
        
        //        NSLog(@"Current Date: %@", date_String);
        self.txtDate.text = date_String;
        
        
        self.btnDate.frame=CGRectMake(122,80,205,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.btnDate.frame=CGRectMake(122,80,205,31);
        [UIView commitAnimations];
        
        self.lineDate.frame=CGRectMake(113,115,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineDate.frame=CGRectMake(113,115,203,1);
        [UIView commitAnimations];
        
        self.txtCustomerName.frame=CGRectMake(123,120,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtCustomerName.frame=CGRectMake(123,120,201,31);
        [UIView commitAnimations];
        
        self.lineCustomer.frame=CGRectMake(113,153,203,1);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.lineCustomer.frame=CGRectMake(113,153,203,1);
        [UIView commitAnimations];
        
        
        self.txtInvoiceReference.frame=CGRectMake(123,159,201,31);
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.5];
        self.txtInvoiceReference.frame=CGRectMake(123,159,201,31);
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

    
    UITapGestureRecognizer *tapGeusturePaymemt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusturePaymemt.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGeusturePaymemt];
    
    [tapGeusturePaymemt setCancelsTouchesInView:NO];

    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/type/record/income/all"]];
    
    [request addBasicAuthenticationHeaderWithUsername:@"submitmytax" andPassword:@"T75w63UC"];
    [request setTag:1];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
    request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/type/record/cisdeductions/all"]];
    
    [request addBasicAuthenticationHeaderWithUsername:@"submitmytax" andPassword:@"T75w63UC"];
    [request setTag:2];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
    ASIHTTPRequest *request1 = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/type/payment/all"]];
    
    [request1 addBasicAuthenticationHeaderWithUsername:@"submitmytax" andPassword:@"T75w63UC"];
    [request1 setTag:3];
    [request1 addRequestHeader:@"Content-Type" value:@"application/json"];
    [request1 setValidatesSecureCertificate:NO];
    [request1 setDelegate:self];
    [request1 startAsynchronous];
//    labelName.text=@"Sales";
    
    
    //Get All Business name from id
    ASIHTTPRequest *requestBusiness = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/business/all"]]];
    
    [requestBusiness addBasicAuthenticationHeaderWithUsername:appdelegate.userReponsitory.userName andPassword:appdelegate.userReponsitory.password];
    
    [requestBusiness setTag:4];
    [requestBusiness addRequestHeader:@"Content-Type" value:@"application/json"];
    
    [requestBusiness setValidatesSecureCertificate:NO];
    [requestBusiness setDelegate:self];
    [requestBusiness startAsynchronous];
    
    isCurrentDay = YES;
    isEdit = NO;
    
    cashBool =TRUE ;
    paymentId = 1;

}

-(void)viewWillAppear:(BOOL)animated
{


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.txtAmount resignFirstResponder];
    [self.txtCis resignFirstResponder];
    [self.txtCustomerName resignFirstResponder];
    [self.txtDate resignFirstResponder];
    [self.txtInvoiceReference resignFirstResponder];
    [self.txtVat resignFirstResponder];
    
    self.viewDate.hidden = YES;
    self.viewRecordType.hidden = YES;
//    [self.scrollVIew setFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height)];
    
}

#pragma mark - Request Delegates...
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    if (request.tag==10) {
        
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSLog(@"ReponseString Afer Add Photo: %@", responseString);
        [appdelegate.activityIndicatorView hide:YES];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Add Income Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    if(request.tag==1)
    {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        NSLog(@"Record All : %@", responseString);
        SBJsonParser *json = [SBJsonParser new];
        self.feeds = [json objectWithString:responseString];
        
        self.dataResponeRecordType =[self.feeds valueForKey:@"description"];
        
        [self.tableRecodeType reloadData];
        
    }
    
    if(request.tag==2)
    {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *json = [SBJsonParser new];
        self.feeds1 = [json objectWithString:responseString];
        
        self.data1 =[self.feeds1 valueForKey:@"description"];
        
    }
    
    if(request.tag==3)
    {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *json = [SBJsonParser new];
        self.feeds2 = [json objectWithString:responseString];
        
        self.data2 =[self.feeds2 valueForKey:@"description"];
        
    }
    
    if (request.tag == 4)
    {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        NSLog(@"Response String Business: %@", responseString);
        if (responseString.length > 5)
        {
            SBJsonParser *json = [SBJsonParser new];
            self.feeds = [json objectWithString:responseString];
            
            self.m_allBusinessName = [[NSMutableArray alloc] init];
            self.m_allBusinessName = [self.feeds valueForKeyPath:@"name"];
            
            NSLog(@"BusinessCount: %lu", (unsigned long)self.m_allBusinessName.count);
            self.m_allBusinessID = [self.feeds valueForKeyPath:@"id"];
            
            if (!isEdit)
            {
                self.txtBusiness.text = [self.m_allBusinessName objectAtIndex:0];
                businessID = [[self.m_allBusinessID objectAtIndex:0] intValue];
            }
            
            [self.tableBusiness reloadData];
            
        }
    }
    
    if (request.tag == 6)
    {
        NSString* string = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        SBJsonParser *json = [SBJsonParser new];
        NSMutableArray* responeDate = [json objectWithString:string];
        
        self.txtBusiness.text = [responeDate valueForKeyPath:@"name"];
    }
    
    if (request.tag == 7)
    {
        
    }
    
    if(request.tag==5)
    {
        
    }
    
    if (request.tag == 8)
    {
        NSString  *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        appdelegate.transactionID = [responseString intValue];
        
        appdelegate.tidPhoto = appdelegate.transactionID;
        
        if(appdelegate.PhotoClick)
        {
            [self uploadPhoto];
            
        }
    }
    
    if (request.tag == 9)
    {
        appdelegate.tidPhoto = appdelegate.transactionID;
        
        if(appdelegate.PhotoClick)
        {
            [self uploadPhoto];
            
        }
    }
    
//    [appdelegate.activityIndicatorView hide:YES];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  [appdelegate.activityIndicatorView hide:YES];
}


-(void)uploadPhoto
{
    NSData *dataTest = [[NSData alloc]init];
    
    ASIFormDataRequest *dataRequest = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/transaction/%i/image",appdelegate.transactionID]]];
    
    [dataRequest addBasicAuthenticationHeaderWithUsername:appdelegate.userReponsitory.userName andPassword:appdelegate.userReponsitory.password];
    
    dataTest = [self compressImage:appdelegate.image];
    
    [dataRequest setData:dataTest forKey:@"file"];
    [dataRequest setValidatesSecureCertificate:NO];
    
    [dataRequest setRequestMethod:@"POST"];
    
    [dataRequest setDelegate:self];
    [dataRequest setTag:10];
    
    [dataRequest startAsynchronous];
    
}

-(NSData *)compressImage:(UIImage *)image
{
    
    float actualHeight = image.size.height;
    
    float actualWidth = image.size.width;
    
    float maxHeight = 600.0;
    
    float maxWidth = 800.0;
    
    float imgRatio = actualWidth/actualHeight;
    
    float maxRatio = maxWidth/maxHeight;
    
    float compressionQuality = 0.5;//50 percent compression
    
    
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            
            imgRatio = maxHeight / actualHeight;
            
            actualWidth = imgRatio * actualWidth;
            
            actualHeight = maxHeight;
            
        }
        
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            
            imgRatio = maxWidth / actualWidth;
            
            actualHeight = imgRatio * actualHeight;
            
            actualWidth = maxWidth;
            
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
        
        
    }
    
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    
    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect:rect];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    
    UIGraphicsEndImageContext();
    
    return imageData;
    
}

#pragma mark - DatePicker Delegate
- (IBAction)dateSelected:(id)sender {
    
    
//    viewTable.hidden =YES;
    firsttable=YES;
}


#pragma mark - Table View Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != self.tableBusiness)
    {
        NSLog(@"return: %lu", (unsigned long)[self.dataResponeRecordType count]);
        return [self.dataResponeRecordType count];
    }
    
    NSLog(@"return: %lu", (unsigned long)self.m_allBusinessName.count);
    return self.m_allBusinessName.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (tableView != self.tableBusiness)
    {
        NSString *recordTypeName;
        recordTypeName = [self.dataResponeRecordType objectAtIndex:indexPath.row];
        
        cell.textLabel.text = recordTypeName;
        
        return cell;
    }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        NSLog(@"Name: %ld", (long)indexPath.row);
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.m_allBusinessName objectAtIndex:indexPath.row]];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.tableBusiness)
    {
        record = [indexPath row] + 1;
        
        self.viewRecordType.hidden = YES;
        firsttable=YES;
        
        self.lblRecordSelected.text=[self.dataResponeRecordType objectAtIndex:indexPath.row];
    }
    else
    {
        self.txtBusiness.text = [self.m_allBusinessName objectAtIndex:indexPath.row];
        self.viewBusiness.hidden = YES;
        isShowBusinessView = YES;
        
        businessID = [[self.m_allBusinessID objectAtIndex:indexPath.row] intValue];
    }
    
}

#pragma mark - Action scheet...

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            viewFlag = TRUE;
            
            UIImagePickerController *ipc=[[UIImagePickerController alloc] init ];
            
            ipc=[[UIImagePickerController alloc] init ];
            
            ipc.delegate=self;
            
            ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
            
            ipc.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
            
            [self presentModalViewController:ipc animated:YES];
            
            //            [self.parentViewController presentViewController:ipc animated:YES completion:nil];
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Camera capture is not supported in this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
    
    else if(buttonIndex == 1)
        
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            
        {
            viewFlag = TRUE;
            
            UIImagePickerController *ipc=[[UIImagePickerController alloc] init ];
            
            ipc=[[UIImagePickerController alloc] init ];
            
            ipc.delegate=self;
            
            ipc.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
            
            
            
            ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentModalViewController:ipc animated:YES];
            //            [self presentViewController:ipc animated:YES completion:nil];
            //            [self presentModalViewController:ipc animated:YES];
            
        }
    }
    
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet removeFromSuperview];
}


-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    appdelegate.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageReceipt.image = appdelegate.image;
    
    appdelegate.PhotoClick=TRUE;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.viewBusiness.hidden = YES;
    self.viewDate.hidden = YES;
    self.viewRecordType.hidden = YES;
    
    if (textField.tag == 1)
    {
        if ([self.txtAmount.text rangeOfString:@"£"].length != 0)
        {
            NSString* amount = [self.txtAmount.text stringByReplacingOccurrencesOfString:@"£" withString:@""];
            
            self.txtAmount.text = [NSString stringWithFormat:@"%@", amount];
        }
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1)
    {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSLocale *localeCurrency = [[NSLocale alloc]
                                    initWithLocaleIdentifier:@"en"];
        [formatter setLocale:localeCurrency];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        [formatter setGroupingSeparator:groupingSeparator];
        [formatter setGroupingSize:3];
        [formatter setAlwaysShowsDecimalSeparator:NO];
        [formatter setUsesGroupingSeparator:YES];
        
        self.amountIncome = textField.text;
        
        NSLog(@"Amount EndEditting: %@", self.amountIncome);
        NSString* amt = [[formatter stringFromNumber:[NSNumber numberWithFloat:[textField.text floatValue]]] substringFromIndex:1];
        NSString* amountAfterFormat = [[NSString stringWithFormat:@"£ "] stringByAppendingString:amt];
        
        if (textField.text.length) {
            self.txtAmount.text = amountAfterFormat;
        }
        
        
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if(textField.tag == 1)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    return YES;
}

#pragma mark - Button Sender

- (IBAction)btnBack_Clicked:(id)sender
{
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
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-YYYY"];
    newDate = [dateFormat stringFromDate:[self.datePicker date]];
    self.txtDate.text=newDate;
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
    NSLog(@"IDYEAR: %d", appdelegate.IDyear);
    
    if(appdelegate.IDyear == 1)
    {
        NSString *t= @"2012/04/06";
        NSString *t1= @"2013/04/05";
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd"];
        
        NSDate *c  = [dateFormat dateFromString:t];
        self.datePicker.minimumDate = c;
        
        NSDate *c1  = [dateFormat dateFromString:t1];
        self.datePicker.maximumDate = c1;
    }
    
    if(appdelegate.IDyear == 2)
    {
        NSString *t= @"2013/04/06";
        NSString *t1= @"2014/04/05";
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd"];
        
        NSDate *c  = [dateFormat dateFromString:t];
        self.datePicker.minimumDate = c;
        
        NSDate *c1  = [dateFormat dateFromString:t1];
        self.datePicker.maximumDate = c1;
    }
    
    if(appdelegate.IDyear == 3)
    {
        NSString *t= @"2014/04/06";
        NSString *t1= @"2015/04/05";
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd"];
        
        NSDate *c  = [dateFormat dateFromString:t];
        self.datePicker.minimumDate = c;
        
        NSDate *c1  = [dateFormat dateFromString:t1];
        self.datePicker.maximumDate = c1;
    }
    
    if(appdelegate.IDyear == 4)
    {
        NSString *t= @"2015/04/06";
        NSString *t1= @"2016/04/05";
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd"];
        
        NSDate *c  = [dateFormat dateFromString:t];
        self.datePicker.minimumDate = c;
        
        NSDate *c1  = [dateFormat dateFromString:t1];
        self.datePicker.maximumDate = c1;
    }    
    
    [self.txtDate resignFirstResponder];
    
//    self.viewDate.hidden = NO;
//    [self.view bringSubviewToFront:self.viewDate];
//    
//    if (([cisinProfile intValue]==0) &&([vatinProfile intValue]==0))
//    {
//        
//        if(first == YES)
//        {
//            self.viewDate.frame=CGRectMake(30,1000,300,250);
//            [UIView beginAnimations:@"" context:nil];
//            [UIView setAnimationDuration:0.5];
//            self.viewDate.frame=CGRectMake(30,80,300,255);
//            [UIView commitAnimations];
//            first=NO;
//        }
//        else
//        {
//            self.viewDate.frame=CGRectMake(30,80,300,255);
//            [UIView beginAnimations:@"" context:nil];
//            [UIView setAnimationDuration:0.5];
//            self.viewDate.frame=CGRectMake(30,1000,300,255);
//            [UIView commitAnimations];
//            first=YES;
//        }
//    }
//    
//    
//    if (([cisinProfile intValue]==1) &&([vatinProfile intValue]==1))
//    {
//        
//        if(first == YES)
//        {
//            self.viewDate.frame=CGRectMake(30,1000,300,250);
//            [UIView beginAnimations:@"" context:nil];
//            [UIView setAnimationDuration:0.5];
//            self.viewDate.frame=CGRectMake(30,138,300,255);
//            [UIView commitAnimations];
//            first=NO;
//        }
//        else
//        {
//            self.viewDate.frame=CGRectMake(30,138,300,255);
//            [UIView beginAnimations:@"" context:nil];
//            [UIView setAnimationDuration:0.5];
//            self.viewDate.frame=CGRectMake(30,1000,300,255);
//            [UIView commitAnimations];
//            first=YES;
//        }
//    }
//    
//    if (([cisinProfile intValue]==1) &&([vatinProfile intValue]==0))
//    {
//        
//        if(first == YES)
//        {
//            self.viewDate.frame=CGRectMake(30,1000,300,250);
//            [UIView beginAnimations:@"" context:nil];
//            [UIView setAnimationDuration:0.5];
//            self.viewDate.frame=CGRectMake(30,110,300,255);
//            [UIView commitAnimations];
//            first=NO;
//        }
//        else
//        {
//            self.viewDate.frame=CGRectMake(30,110,300,255);
//            [UIView beginAnimations:@"" context:nil];
//            [UIView setAnimationDuration:0.5];
//            self.viewDate.frame=CGRectMake(30,1000,300,255);
//            [UIView commitAnimations];
//            first=YES;
//        }
//    }
//    
//    if (([cisinProfile intValue]==0) &&([vatinProfile intValue]==1))
//    {
//        
//        if(first == YES)
//        {
//            self.viewDate.frame=CGRectMake(30,1000,300,250);
//            [UIView beginAnimations:@"" context:nil];
//            [UIView setAnimationDuration:0.5];
//            self.viewDate.frame=CGRectMake(30,110,300,255);
//            [UIView commitAnimations];
//            first=NO;
//        }
//        else
//        {
//            self.viewDate.frame=CGRectMake(30,110,300,255);
//            [UIView beginAnimations:@"" context:nil];
//            [UIView setAnimationDuration:0.5];
//            self.viewDate.frame=CGRectMake(30,1000,300,255);
//            [UIView commitAnimations];
//            first=YES;
//        }
//    }
    
    [self.txtCustomerName resignFirstResponder];
    [self.txtAmount resignFirstResponder];
    [self.txtInvoiceReference resignFirstResponder];
    [self.txtVat resignFirstResponder];
    [self.txtCis resignFirstResponder];

    
}
- (IBAction)btnSaveIncome_Clicked:(id)sender
{
    appdelegate.activityIndicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appdelegate.activityIndicatorView.mode = MBProgressHUDAnimationFade;
    appdelegate.activityIndicatorView.labelText = @"";
    
    if([self.txtAmount.text length ]>0 && [self.txtCustomerName.text length ]>0)
    {
        
//        if(!Amount || [Amount isEqual:[NSNull null]])
//        {
//            Amount = self.txtAmount.text;
//        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        
        NSDate *date  = [dateFormatter dateFromString:self.txtDate.text];
        
        NSLocale *locale = [[NSLocale alloc]
                            initWithLocaleIdentifier:@"en"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString* dateConvert = [dateFormatter stringFromDate:date];
        
        int yearID = 0;
        
        
        int time = (int)[date timeIntervalSince1970];
        
        
        NSString *yearBeginID1= @"2012-06-04";
        NSString *yearEndID1= @"2013-05-04";
        
        int timeAfterID1 = (int)[[dateFormatter dateFromString:yearEndID1] timeIntervalSince1970];
        int timeBeforeID1 = (int)[[dateFormatter dateFromString:yearBeginID1] timeIntervalSince1970];
        
        NSLog(@"Timer Before: %d, Time: %d, Time After: %d", timeBeforeID1, time, timeAfterID1);
        
        NSString *yearBeginID2 = @"2013-06-04";
        NSString *yearEndID2 = @"2014-05-04";
        
        int timeAfterID2 = [[dateFormatter dateFromString:yearEndID2] timeIntervalSince1970];
        int timeBeforeID2 = [[dateFormatter dateFromString:yearBeginID2] timeIntervalSince1970];
        
        
        NSString *yearBeginID3= @"2014-06-04";
        NSString *yearEndID3= @"2015-05-04";
        
        int timeAfterID3 = [[dateFormatter dateFromString:yearEndID3] timeIntervalSince1970];
        int timeBeforeID3 = [[dateFormatter dateFromString:yearBeginID3] timeIntervalSince1970];
        
        NSString *yearBeginID4= @"2015/04/06";
        NSString *yearEndID4= @"2016/04/05";
        
        int timeAfterID4 = [[dateFormatter dateFromString:yearEndID4] timeIntervalSince1970];
        int timeBeforeID4 = [[dateFormatter dateFromString:yearBeginID4] timeIntervalSince1970];
        
        if (timeBeforeID1 < time && time < timeAfterID1)
        {
            yearID = 1;
        }
        else if(timeBeforeID2 < time && time < timeAfterID2)
        {
            yearID = 2;
        }
        else if(timeBeforeID3 < time && time < timeAfterID3)
        {
            yearID = 3;
        }
        else if(timeBeforeID4 < time && time < timeAfterID4)
        {
            yearID = 4;
        }
        
        
        NSLog(@"Time: %d", yearID);
        
        
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/transaction"]];
        
        [request addBasicAuthenticationHeaderWithUsername:appdelegate.userReponsitory.userName andPassword:appdelegate.userReponsitory.password];
        
        [request setTag:8];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"accept" value:@"application/json"];
        
        if(cashBool ==TRUE)
            paymentId=1;
        if(chequeBool==TRUE)
            paymentId=2;
        if(cardBool ==TRUE)
            paymentId=3;
        if(otherBool ==TRUE)
            paymentId=4;
        
        NSString *uid;
        uid = appdelegate.userReponsitory.userID;
        
        NSString *dataContent = nil;
        
        if (([cisinProfile intValue]==1) &&([vatinProfile intValue]==1))
        {
            
            dataContent =[NSString stringWithFormat:@"{\"user\":{\"id\":\"%@\"},\"recordType\":{\"id\":%i},\"paymentType\":{\"id\":%i}, \"taxYear\":{\"id\":%i},\"name\":\"%@\",\"description\":\"%@\",\"reference\":\"%@\",\"amount\":%f,\"vat\":%i,\"cisDeduction\":%i, \"date\":\"%@\"}", uid, record,  paymentId, yearID, self.txtCustomerName.text, self.txtDescription.text, self.txtInvoiceReference.text,[self.amountIncome floatValue],[self.txtVat.text intValue],[self.txtCis.text intValue],dateConvert];
            
            if (self.txtBusiness.text.length > 0) {
                dataContent = [NSString stringWithFormat:@"{\"user\":{\"id\":\"%@\"},\"recordType\":{\"id\":%i},\"paymentType\":{\"id\":%i}, \"taxYear\":{\"id\":%i}, \"business\":{\"id\":\"%@\"},\"name\":\"%@\",\"description\":\"%@\",\"reference\":\"%@\",\"amount\":%f,\"vat\":%i,\"cisDeduction\":%i, \"date\":\"%@\"}",uid,record,  paymentId,yearID,[NSString stringWithFormat:@"%d",businessID], self.txtCustomerName.text,self.txtDescription.text,self.txtInvoiceReference.text,[self.amountIncome floatValue],[self.txtVat.text intValue],[self.txtCis.text intValue],dateConvert];
            }
            
        }
        
        
        if (([cisinProfile intValue]==0) &&([vatinProfile intValue]==0))
        {
            NSLog(@"UID: %@", uid);
            NSLog(@"record: %d", record);
            NSLog(@"paymentId: %d", paymentId);
            NSLog(@"yearID: %d", yearID);
            NSLog(@"self.txtCustomerName.text: %@", self.txtCustomerName.text);
            NSLog(@"self.txtVat.text: %@", self.txtVat.text);
            NSLog(@"Amount: %f", [self.amountIncome floatValue]);
            
            dataContent =[NSString stringWithFormat:@"{\"user\":{\"id\":\"%@\"},\"recordType\":{\"id\":%i},\"paymentType\":{\"id\":%i},\"taxYear\":{\"id\":%i},\"name\":\"%@\",\"description\":\"%@\",\"reference\":\"%@\",\"amount\":%f,\"date\":\"%@\"}", uid, record, paymentId, yearID, self.txtCustomerName.text, self.txtDescription.text, self.txtVat.text, [self.amountIncome floatValue], dateConvert];
            
            if (self.txtBusiness.text.length > 0) {
                dataContent =[NSString stringWithFormat:@"{\"user\":{\"id\":\"%@\"},\"recordType\":{\"id\":%i},\"paymentType\":{\"id\":%i},\"taxYear\":{\"id\":%i},\"business\":{\"id\":\"%@\"},\"name\":\"%@\",\"description\":\"%@\",\"reference\":\"%@\",\"amount\":%f,\"date\":\"%@\"}",uid,record,paymentId,yearID, [NSString stringWithFormat:@"%d",businessID] ,self.txtCustomerName.text,self.txtDescription.text,self.txtInvoiceReference.text, [self.amountIncome floatValue], dateConvert];
            }
            
        }
        
        if (([cisinProfile intValue]==0) &&([vatinProfile intValue]==1))
        {
            
            dataContent =[NSString stringWithFormat:@"{\"user\":{\"id\":\"%@\"},\"recordType\":{\"id\":%i},\"paymentType\":{\"id\":%i},\"taxYear\":{\"id\":%i},\"name\":\"%@\",\"description\":\"%@\",\"reference\":\"%@\",\"amount\":%f,\"vat\":%i,\"date\":\"%@\"}",uid,record,paymentId,yearID,self.txtCustomerName.text,self.txtDescription.text,self.txtInvoiceReference.text,[self.amountIncome floatValue],[self.txtVat.text intValue],dateConvert];
            
            if (self.txtBusiness.text.length > 0) {
                dataContent =[NSString stringWithFormat:@"{\"user\":{\"id\":\"%@\"},\"recordType\":{\"id\":%i},\"paymentType\":{\"id\":%i},\"taxYear\":{\"id\":%i},\"business\":{\"id\":\"%@\"},\"name\":\"%@\",\"description\":\"%@\",\"reference\":\"%@\",\"amount\":%f,\"vat\":%i,\"date\":\"%@\"}",uid,record,paymentId,yearID,[NSString stringWithFormat:@"%d",businessID], self.txtCustomerName.text,self.txtDescription.text,self.txtInvoiceReference.text,[self.amountIncome floatValue],[self.txtVat.text intValue], dateConvert];
            }
            
        }
        
        if (([cisinProfile intValue]==1) &&([vatinProfile intValue]==0))
        {
            
            dataContent =[NSString stringWithFormat:@"{\"user\":{\"id\":\"%@\"},\"recordType\":{\"id\":%i},\"paymentType\":{\"id\":%i},\"taxYear\":{\"id\":%i},\"name\":\"%@\",\"description\":\"%@\",\"reference\":\"%@\",\"amount\":%f,\"cisDeduction\":%i,\"date\":\"%@\"}",uid,record,paymentId,yearID,self.txtCustomerName.text,self.txtDescription.text,self.txtInvoiceReference.text,[self.amountIncome floatValue],[self.txtCis.text intValue],dateConvert];
            
            if (self.txtBusiness.text.length > 0) {
                dataContent =[NSString stringWithFormat:@"{\"user\":{\"id\":\"%@\"},\"recordType\":{\"id\":%i},\"paymentType\":{\"id\":%i},\"taxYear\":{\"id\":%i},\"business\":{\"id\":\"%@\"}, \"name\":\"%@\",\"description\":\"%@\",\"reference\":\"%@\",\"amount\":%f,\"cisDeduction\":%i,\"date\":\"%@\"}",uid,record,paymentId,yearID, [NSString stringWithFormat:@"%d",businessID] ,self.txtCustomerName.text,self.txtDescription.text,self.txtInvoiceReference.text,[self.amountIncome floatValue],[self.txtCis.text intValue],dateConvert];
            }
            
        }
        
        [request appendPostData:[dataContent dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValidatesSecureCertificate:NO];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request startSynchronous];
       
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Amount and Customer Name are mandatory fields." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [appdelegate.activityIndicatorView hide:YES];
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

- (IBAction)btnCash_Clicked:(id)sender
{
    UIButton *btn1 = sender;
    
    [btn1 setImage:[UIImage imageNamed:@"cash button (select).png"] forState:UIControlStateNormal];
    
    cardBool=FALSE;
    chequeBool=FALSE;
    otherBool=FALSE;
    
    [self.btnCard setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnCheque setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnOther setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];

}

- (IBAction)btnCheque_Clicked:(id)sender
{
    UIButton *btn1 = sender;
    
    chequeBool =TRUE ;
    [btn1 setImage:[UIImage imageNamed:@"cheque button ( select).png"] forState:UIControlStateNormal];
    
    [self.btnCard setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnCash setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    [self.btnOther setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    cardBool=FALSE;
    cashBool=FALSE;
    otherBool=FALSE;
  
}

- (IBAction)btnCard_Clicked:(id)sender
{
    UIButton *btn1 = sender;
    
    [btn1 setImage:[UIImage imageNamed:@"card button (select).png"] forState:UIControlStateNormal];
    cardBool = TRUE;
    
    [self.btnCash setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    [self.btnCheque setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnOther setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    cashBool=FALSE;
    chequeBool=FALSE;
    otherBool=FALSE;

}

- (IBAction)btnOther_Clicked:(id)sender
{
    UIButton *btn1 = sender;
    
    otherBool =TRUE ;
    
    [btn1 setImage:[UIImage imageNamed:@"other button (select).png"] forState:UIControlStateNormal];
    
    [self.btnCard setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnCheque setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnCash setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    
    cardBool=FALSE;
    chequeBool=FALSE;
    cashBool=FALSE;

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
    [_imageReceipt release];
    [_btnAddReceipt release];
    [_txtAmount release];
    [_txtVat release];
    [_txtCis release];
    [_txtVat release];
    [_btnDate release];
    [_txtDate release];
    [_txtCustomerName release];
    [_txtInvoiceReference release];
    [_btnBusiness release];
    [_viewDate release];
    [_datePicker release];
    [_btnDateDone release];
    [_viewBusiness release];
    [_tableBusiness release];
    [_viewRecordType release];
    [_tableRecodeType release];
    [_lblRecodeType release];
    [_lblNoteDescription release];
    [_btnRecordType release];
    [_lblRecordSelected release];
    [_scrollView release];
    [_lineAmount release];
    [_lineBusiness release];
    [_lineVat release];
    [_lineCis release];
    [_lineDate release];
    [_lineCustomer release];
    [_inputBox release];
    [_txtBusiness release];
    [_btnCash release];
    [_btnCheque release];
    [_btnCard release];
    [_btnOther release];
    [_textViewDescription release];
    [_txtDescription release];
    [super dealloc];
}
@end
