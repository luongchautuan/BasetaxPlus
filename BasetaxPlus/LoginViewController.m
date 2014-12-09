//
//  LoginViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

AppDelegate* appdelegate;

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self initScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initScreen
{
    UIColor* color = [[UIColor alloc] initWithRed:198.0/255.0 green:224.0/255.0 blue:168.0/255.0 alpha:1.0];
    
    [self.txtUsername setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPassword setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    
    //set gesture for return to close soft keyboard
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGeusture];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    
    self.txtUsername.leftView = paddingView;
    self.txtUsername.leftViewMode = UITextFieldViewModeAlways;
    
    self.txtPassword.leftView = paddingView2;
    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (IBAction)btnBack_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onLogin:(id)sender
{
    
    appdelegate.activityIndicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appdelegate.activityIndicatorView.mode = MBProgressHUDAnimationFade;
    appdelegate.activityIndicatorView.labelText = @"";
    
    if([self.txtPassword.text length] <1 ||[self.txtUsername.text length]<1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [appdelegate.activityIndicatorView hide:YES];
    }
    else
    {
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/user"]];
        
        
        [request setTag:1];
        [request addBasicAuthenticationHeaderWithUsername:self.txtUsername.text andPassword:self.txtPassword.text];
        
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request setValidatesSecureCertificate:NO];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    
}

- (IBAction)onRegister:(id)sender {
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)closeMenu
{
}

#pragma mark return to close soft keyboard

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.txtPassword resignFirstResponder];
    [self.txtUsername resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - Text Field delegates...

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==0)
    {
        [self.scrollView setContentOffset:CGPointMake(0,50)];
    }
    
    if (textField.tag==1)
    {
        [self.scrollView setContentOffset:CGPointMake(0,100)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField== self.txtUsername)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    if(textField == self.txtPassword)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    
    return YES;
}


#pragma mark - Request delegates...

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    if(request.tag == 1)
//    {
//        if([request responseStatusCode] == 200)
//        {
//            BIUser* user = [[BIUser alloc] init];
//            user.userName = self.edtUsername.text;
//            user.password = self.edtPassword.text;
//            
//            appdelegate.currentUser = user;
//            
//            appdelegate.isLoginSucesss = YES;
//            
//            BIDashBoard *pushToVC = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
//            [self.navigationController pushViewController:pushToVC animated:YES];
//        }
//    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
   
    [appdelegate.activityIndicatorView hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Authentication failed" message:@"Username and password mismatched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

- (IBAction)onSkipLogin:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Authentication Information" message:@"Are you want to login later?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    NSLog(@"SkipLogin: %ld", (long)buttonIndex);
//    
//    if (buttonIndex == 1)
//    {
//        //Check user config or check created bussiness
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        BOOL isExistBussiness = [defaults boolForKey:@"bussiness"];
//        
//        if (isExistBussiness)
//        {
//            BIBussiness* bussinessForUser = [defaults rm_customObjectForKey:@"bussinessForUser"];
//            appdelegate.bussinessForUser = bussinessForUser;
//            
//            appdelegate.isLoginSucesss = NO;
//            
//            BIDashBoard *pushToVC = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
//            [self.navigationController pushViewController:pushToVC animated:YES];
//            
//        }
//        else
//        {
//            BIAddNewBussiness *pushToVC = [[BIAddNewBussiness alloc] initWithNibName:@"BIAddNewBussiness" bundle:nil];
//            [self.navigationController pushViewController:pushToVC animated:YES];
//        }
//    }
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
    [_btnMenu release];
    [_txtUsername release];
    [_txtPassword release];
    [_btnLogin release];
    [_btnRegister release];
    [_scrollView release];
    [super dealloc];
}
@end