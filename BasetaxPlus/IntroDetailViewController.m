//
//  IntroDetailViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import "IntroDetailViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface IntroDetailViewController ()

@end

AppDelegate* appdelegate;
BOOL isShowViewDate;
NSString *cisinProfile,*vatinProfile;

@implementation IntroDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UITapGestureRecognizer *tapGeusturePaymemt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusturePaymemt.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGeusturePaymemt];
    
    [tapGeusturePaymemt setCancelsTouchesInView:NO];
    
    isShowViewDate = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.txtDateOfBirth resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtPostCode resignFirstResponder];
    [self.txtTelephone resignFirstResponder];
    [self.txtUniqueTaxpyer resignFirstResponder];
    
     [self.viewMain setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
}

#pragma mark - Button Sender

- (IBAction)btnBack_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSelecteDate_Clicked:(id)sender
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
- (IBAction)btnSaveIntroductionYourSelf_Clicked:(id)sender
{
    appdelegate.activityIndicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appdelegate.activityIndicatorView.mode = MBProgressHUDAnimationFade;
    appdelegate.activityIndicatorView.labelText = @"";
    
    if (self.txtFirstName.text.length > 0 && self.txtLastName.text.length > 0 )
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        
        NSDate *date  = [dateFormatter dateFromString:self.txtDateOfBirth.text];
        
        NSLocale *locale = [[NSLocale alloc]
                            initWithLocaleIdentifier:@"en"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString* dateConvert = [dateFormatter stringFromDate:date];

        ASIHTTPRequest *requestUser = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/user"]];
        
        [requestUser addBasicAuthenticationHeaderWithUsername:appdelegate.userReponsitory.userName andPassword:appdelegate.userReponsitory.password];
        [requestUser setValidatesSecureCertificate:NO];
        
        [requestUser startSynchronous];
        
        NSString *responseString = [[NSString alloc] initWithData:[requestUser responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *json = [SBJsonParser new];
        self.feeds = [json objectWithString:responseString];
        
        vatinProfile = [self.feeds valueForKey:@"vatRegistered"];
        cisinProfile = [self.feeds valueForKey:@"cisRegistered"];

        NSString* isVat = nil;
        NSString* isCis = nil;
        
        if ([vatinProfile intValue] == 1) {
            isVat = @"true";
        }
        else
        {
            isVat = @"false";
        }
        if ([cisinProfile intValue] == 1) {
            isCis = @"true";
        }
        else
        {
            isCis = @"false";
        }
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/user"]];
        
        [request addBasicAuthenticationHeaderWithUsername:appdelegate.userReponsitory.userName andPassword:appdelegate.userReponsitory.password];
        
        [request setTag:8];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"accept" value:@"application/json"];

        NSString *dataContent = nil;
        
         dataContent = [NSString stringWithFormat:@"{\"password\":\"%@\",\"name\":\"%@\",\"active\":true, \"email\":\"%@\", \"utr\":\"01646133611\",\"nationalInsurance\":\"%@\",\"dateOfBirth\":\"%@\",\"telephone\":\"%@\",\"address1\":\"NULL\",\"address2\":\"NULL\",\"address3\":\"NULL\", \"postcode\":\"%@\", \"bankName\":\"Bank\", \"accountName\":\"accountName\", \"accountNumber\":\"accountNumber\", \"sortCode\":\"sortCode\", \"gatewayId\":\"gatewayId\",\"gatewayPw\":\"abc\",\"cisRegistered\":\"%@\",\"vatRegistered\":\"%@\"}",appdelegate.userReponsitory.password, self.txtFirstName.text,  self.txtEmail.text,self.txtNationalInsurance.text, dateConvert, self.txtTelephone.text,self.txtPostCode.text, isCis, isVat];
        
        NSLog(@"dataContent: %@", dataContent);
        
        [request appendPostData:[dataContent dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValidatesSecureCertificate:NO];
        [request setRequestMethod:@"PUT"];
        [request setDelegate:self];
        [request startSynchronous];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [appdelegate.activityIndicatorView hide:YES];
    }
}

#pragma mark - Request Delegates...
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 8)
    {
        [appdelegate.activityIndicatorView hide:YES];
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Add Your Tax Details Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [appdelegate.activityIndicatorView hide:YES];
}

- (IBAction)btnDateDone_Clicked:(id)sender
{
    self.viewDate.hidden = YES;
    isShowViewDate = YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-YYYY"];
    NSString* newDate = [dateFormat stringFromDate:[self.datePicker date]];
    self.txtDateOfBirth.text = newDate;

}

- (IBAction)selectDateFromPopUp:(id)sender
{
    NSDate *myDate = [self.datePicker date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-YYYY"];
    NSString *time = [dateFormat stringFromDate:myDate];
    
    self.txtDateOfBirth.text = time;
}

#pragma mark - Textfield delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 3) {
        [self.viewMain setFrame:CGRectMake(0, -40, self.viewMain.frame.size.width, self.viewMain.frame.size.height)];
    }
    
    if (textField.tag == 4) {
         [self.viewMain setFrame:CGRectMake(0, -60, self.viewMain.frame.size.width, self.viewMain.frame.size.height)];
    }
    if (textField.tag == 5) {
         [self.viewMain setFrame:CGRectMake(0, -80, self.viewMain.frame.size.width, self.viewMain.frame.size.height)];
    }
    if (textField.tag == 6) {
         [self.viewMain setFrame:CGRectMake(0, -150, self.viewMain.frame.size.width, self.viewMain.frame.size.height)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [self.viewMain setFrame:CGRectMake(0, 70, self.viewMain.frame.size.width, self.viewMain.frame.size.height)];
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
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
    [_txtFirstName release];
    [_txtLastName release];
    [_txtUniqueTaxpyer release];
    [_txtDateOfBirth release];
    [_txtTelephone release];
    [_txtPostCode release];
    [_txtEmail release];
    [_btnMenu release];
    [_btnSave release];
    [_viewDate release];
    [_btnSaveDate release];
    [_datePicker release];
    [_scrollVIew release];
    [_viewMain release];
    [_txtNationalInsurance release];
    [super dealloc];
}
@end
