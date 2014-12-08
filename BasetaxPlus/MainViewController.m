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

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    UploadViewController* uploadDocumentsViewController = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
    [self.navigationController pushViewController:uploadDocumentsViewController animated:YES];
}

- (IBAction)btnYourSummary_Clicked:(id)sender
{
    IntroDetailViewController* introDetailViewController = [[IntroDetailViewController alloc] initWithNibName:@"IntroDetailViewController" bundle:nil];
    [self.navigationController pushViewController:introDetailViewController animated:YES];
    
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
