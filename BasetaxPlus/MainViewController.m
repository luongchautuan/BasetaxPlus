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
#import "SubmitViewController.h"
#import "BIProfileViewController.h"

@interface MainViewController ()

@end

AppDelegate* appdelegate;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    if (appdelegate.result.height == 480) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 630)];
    }
    else
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 576)];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (appdelegate.year.length <= 0) {
        self.lblTaxYear.text = @"2013-14";
    }
    else
    {
        self.lblTaxYear.text = appdelegate.year;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Sender

- (IBAction)btnYourDetails_Clicked:(id)sender
{
    if(appdelegate.isLoginSucessfully)
    {
        BIProfileViewController* profileViewController = [[BIProfileViewController alloc] initWithNibName:@"BIProfileViewController" bundle:nil];
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
    else
    {
        LoginViewController* loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }

}

- (IBAction)btnDocumentScanned_Clicked:(id)sender
{
    UploadViewController* uploadDocumentsViewController = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
    [self.navigationController pushViewController:uploadDocumentsViewController animated:YES];
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
    SubmitViewController* submitViewController = [[SubmitViewController alloc] initWithNibName:@"SubmitViewController" bundle:nil];
    [self.navigationController pushViewController:submitViewController animated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController* loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }

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
    [_lblTaxYear release];
    [super dealloc];
}
@end
