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

NSString *UserID,*TransID,*RecordType,*Name,*Amount,*VAT,*CISDeduction,*PaymentType,*ReferenceName,*Description,*DateOfTrans,*Notes,*CreatedDate,*ModifiedDate;
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
    Amount = nil;
    
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate] ;
    
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
    
    [requestBusiness addBasicAuthenticationHeaderWithUsername:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"]andPassword:[[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"]];
    
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
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/user"]];
    
    [request addBasicAuthenticationHeaderWithUsername:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"]andPassword:[[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"]];
    [request setValidatesSecureCertificate:NO];
    
    [request startSynchronous];
    
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *json = [SBJsonParser new];
    feeds = [json objectWithString:responseString];
    
    vatinProfile = [feeds valueForKey:@"vatRegistered"];
    cisinProfile = [feeds valueForKey:@"cisRegistered"];


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
              
    }
    
    if(request.tag==1)
    {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        NSLog(@"Record All : %@", responseString);
        SBJsonParser *json = [SBJsonParser new];
        feeds = [json objectWithString:responseString];
        
        self.data =[feeds valueForKey:@"description"];
        
        [self.tableRecodeType reloadData];
        
    }
    
    if(request.tag==2)
    {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *json = [SBJsonParser new];
        feeds1 = [json objectWithString:responseString];
        
        self.data1 =[feeds1 valueForKey:@"description"];
        
    }
    
    if(request.tag==3)
    {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *json = [SBJsonParser new];
        feeds2 = [json objectWithString:responseString];
        
        self.data2 =[feeds2 valueForKey:@"description"];
        
    }
    
    if (request.tag == 4)
    {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        
        if (responseString.length > 5)
        {
            SBJsonParser *json = [SBJsonParser new];
            feeds = [json objectWithString:responseString];
            
            m_allBusinessName = [feeds valueForKeyPath:@"name"];
            m_allBusinessID = [feeds valueForKeyPath:@"id"];
            
            if (!isEdit)
            {
                self.txtBusiness.text = [m_allBusinessName objectAtIndex:0];
                businessID = [[m_allBusinessID objectAtIndex:0] intValue];
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
            [self RequestPhoto];
            
        }
    }
    
    if (request.tag == 9)
    {
        appdelegate.tidPhoto = appdelegate.transactionID;
        
        if(appdelegate.PhotoClick)
        {
            [self RequestPhoto];
            
        }
    }
    
    [appdelegate.activityIndicatorView hide:YES];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  [appdelegate.activityIndicatorView hide:YES];
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
    [super dealloc];
}
@end
