//
//  RegisterViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import "RegisterViewController.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface RegisterViewController ()

@end

AppDelegate* appdelegate;

@implementation RegisterViewController

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
    
    [self.txtEmail setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPasscode setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    
    //set gesture for return to close soft keyboard
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGeusture];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    
    self.txtEmail.leftView = paddingView;
    self.txtEmail.leftViewMode = UITextFieldViewModeAlways;
    
    self.txtPasscode.leftView = paddingView2;
    self.txtPasscode.leftViewMode = UITextFieldViewModeAlways;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        NSLog(@"Result Height: %f", result.height);
        if(result.height == 480)
        {
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 100)];
        }
    }

}

- (IBAction)onRegister:(id)sender
{
    appdelegate.activityIndicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appdelegate.activityIndicatorView.mode = MBProgressHUDAnimationFade;
    appdelegate.activityIndicatorView.labelText = @"";
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    
    if([self.txtEmail.text length ]>0 && [self.txtName.text length]>0 && [self.txtPasscode.text length ]>0 && [self.txtConfirmPasscode.text length]>0)
    {
        
        NSString *pass, *conpass;
        pass = self.txtPasscode.text;
        conpass = self.txtConfirmPasscode.text;
        
        if ([pass isEqualToString:conpass])
        {
            if([self.txtPasscode.text length] > 3 && [self.txtPasscode.text length] < 7)
            {
                if ([emailTest evaluateWithObject:self.txtEmail.text] == NO) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                    [appdelegate.activityIndicatorView hide:YES];
                    
                    return;
                }
                else
                {
                    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/user"]];
                    
                    [request addBasicAuthenticationHeaderWithUsername:@"submitmytax"andPassword:@"T75w63UC"];
                    
                    [request addRequestHeader:@"Content-Type" value:@"application/json"];
                    [request addRequestHeader:@"accept" value:@"application/json"];
                    
                    NSString *dataContent =[NSString stringWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\",\"name\":\"%@\",\"active\":true}", self.txtEmail.text, self.txtPasscode.text, self.txtName.text];
                    NSLog(@"dataContent: %@", dataContent);
                    
                    [request appendPostData:[dataContent dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    [request setValidatesSecureCertificate:NO];
                    [request setRequestMethod:@"POST"];
                    [request setDelegate:self];
                    [request startAsynchronous];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Password restriction " message:@"password should be 4 to 6" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [appdelegate.activityIndicatorView hide:YES];
            }
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Password mismatched" message:@"password and conform password are not same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            [appdelegate.activityIndicatorView hide:YES];
        }
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Fill All" message:@"Fill all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
        [appdelegate.activityIndicatorView hide:YES];
        
        
        //        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/user"]];
        //
        //
        //        [request setTag:1];
        //        [request addBasicAuthenticationHeaderWithUsername:self.edtUsername.text andPassword:self.edtPassword.text];
        //
        //        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        //        [request setValidatesSecureCertificate:NO];
        //        [request setDelegate:self];
        //        [request startAsynchronous];
    }
    
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark return to close soft keyboard

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.txtConfirmPasscode resignFirstResponder];
    [self.txtName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPasscode resignFirstResponder];
    
    [self.scrollView setContentOffset:CGPointMake(0, -20)];
}

#pragma mark - Text Field delegates...

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGSize result;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        result = [[UIScreen mainScreen] bounds].size;
    }

    
    if (textField.tag == 0)
    {
        if (result.height == 480)
        {
            [self.scrollView setContentOffset:CGPointMake(0,150)];
        }
        else
            [self.scrollView setContentOffset:CGPointMake(0,50)];
        
    }
    if (textField.tag == 1)
    {
        if (result.height == 480)
        {
            [self.scrollView setContentOffset:CGPointMake(0,150)];
        }
        else
            [self.scrollView setContentOffset:CGPointMake(0,100)];
    }
    if (textField.tag == 2)
    {
        if (result.height == 480)
        {
            [self.scrollView setContentOffset:CGPointMake(0,150)];
        }
        else
            [self.scrollView setContentOffset:CGPointMake(0,100)];
    }
    if (textField.tag == 3)
    {
        if (result.height == 480)
        {
            [self.scrollView setContentOffset:CGPointMake(0,250)];
        }
        else
            [self.scrollView setContentOffset:CGPointMake(0,100)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, -20)];
    
    return YES;
}


#pragma mark - Request delegates...

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString  *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    
    if(request.tag == 1)
    {
        if ([request responseStatusCode] == 409)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Username Already Exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if([request responseStatusCode] == 201)
        {
            [appdelegate.activityIndicatorView hide:YES];
        }
        
        if([request responseStatusCode] == 200)
        {
            
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [appdelegate.activityIndicatorView hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Registration failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
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
    [_btnRegister release];
    [_txtPasscode release];
    [_txtEmail release];
    [_txtName release];
    [_txtConfirmPasscode release];
    [_btnBack release];
    [_lblTitle release];
    [_scrollView release];
    [super dealloc];
}
@end
