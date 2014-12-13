//
//  MainViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "IntroDetailViewController.h"
#import "UploadViewController.h"
#import "AppDelegate.h"
#import "TaxYearViewController.h"

@interface MainViewController ()

@end

AppDelegate* appdelegate;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 576)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Sender

- (IBAction)btnYourDetails_Clicked:(id)sender
{
    LoginViewController* loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (IBAction)btnDocumentScanned_Clicked:(id)sender
{
    if (appdelegate.isLoginSucessfully)
    {
        UploadViewController* uploadDocumentsViewController = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
        [self.navigationController pushViewController:uploadDocumentsViewController animated:YES];

    }
    else
    {
        UIAlertView* msg = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please login your Details on the Step 2" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show];

    }
}

- (IBAction)btnTaxYear_Clicked:(id)sender
{
    TaxYearViewController* taxYearViewController = [[TaxYearViewController alloc] initWithNibName:@"TaxYearViewController" bundle:nil];
    [self.navigationController pushViewController:taxYearViewController animated:YES];
}

- (IBAction)btnYourSummary_Clicked:(id)sender
{
    IntroDetailViewController* introDetailViewController = [[IntroDetailViewController alloc] initWithNibName:@"IntroDetailViewController" bundle:nil];
    [self.navigationController pushViewController:introDetailViewController animated:YES];
    
}
- (IBAction)btnSubmit_Clicked:(id)sender
{
    UIAlertView* msg = [[UIAlertView alloc] initWithTitle:@"" message:@"Thank you for submitting your information. Your tax return will be prepared within the next few hours. Please contact to tax@basetax.co.uk" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [msg show];
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
    [_scrollView release];
    [_lblTaxRebate release];
    [super dealloc];
}
@end
