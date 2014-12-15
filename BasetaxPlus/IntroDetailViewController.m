//
//  IntroDetailViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import "IntroDetailViewController.h"
#import "AppDelegate.h"

@interface IntroDetailViewController ()

@end

AppDelegate* appdelegate;
BOOL isShowViewDate;

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

- (IBAction)btnDateDone_Clicked:(id)sender
{
    self.viewDate.hidden = YES;
    isShowViewDate = YES;
}

- (IBAction)selectDateFromPopUp:(id)sender
{
    NSDate *myDate = [self.datePicker date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
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
    [super dealloc];
}
@end
