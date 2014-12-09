//
//  UploadViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import "UploadViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "MainViewController.h"
#import "IncomeViewController.h"
#import "ExpenseViewController.h"

@interface UploadViewController ()

@end

AppDelegate* appdelegate;

@implementation UploadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.viewAddMore addGestureRecognizer:tapGeusture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tap Handler

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    NSLog(@"TAP");
    self.viewAddMore.hidden = YES;
}

#pragma mark - Button Sender

- (IBAction)btnAddIncome_Clicked:(id)sender
{
    [self.viewAddMore setHidden:YES];
    IncomeViewController* incomeViewController = [[IncomeViewController alloc] initWithNibName:@"IncomeViewController" bundle:nil];
    
    [self.navigationController pushViewController:incomeViewController animated:YES];
}

- (IBAction)btnAddExpense_Clicked:(id)sender
{
    [self.viewAddMore setHidden:YES];
    ExpenseViewController* expenseViewController = [[ExpenseViewController alloc] initWithNibName:@"ExpenseViewController" bundle:nil];
    [self.navigationController pushViewController:expenseViewController animated:YES];
}

- (IBAction)btnBack_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnUploadFiles_Clicked:(id)sender
{
    UIActionSheet *action_sheet = [[UIActionSheet alloc]initWithTitle:@"Upload options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil];
    
    [action_sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)btnAddMore_Clicked:(id)sender
{
    self.viewAddMore.hidden = NO;
    self.viewAddMoreMain.hidden = NO;
    self.viewAddMoreMain.frame=CGRectMake(24,-130, 288, 130);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    self.viewAddMoreMain.frame=CGRectMake(24 ,65, 288, 130);
    [UIView commitAnimations];
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
    [_viewAddMore release];
    [_viewAddMoreMain release];
    [super dealloc];
}
@end
