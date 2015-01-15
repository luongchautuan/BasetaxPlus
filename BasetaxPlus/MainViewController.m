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
#import "UIViewController+MMDrawerController.h"
#import "BIProfileViewController.h"
#import "DocumentReponsitory.h"
#import "AboutUsViewController.h"

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
    
     [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (appdelegate.year.length <= 0) {
        self.lblTaxYear.text = @"2013-14";
        appdelegate.IDyear = 1;
    }
    else
    {
        self.lblTaxYear.text = appdelegate.year;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Menu Delegate

- (IBAction)showCat:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)selectCategory:(int)ID
{
    switch (ID)
    {
        case 0:
        {
            BIProfileViewController *profileViewController = [[BIProfileViewController alloc] initWithNibName:@"BIProfileViewController" bundle:nil];
            [self.navigationController pushViewController:profileViewController animated:YES];
        }
            break;
        case 1:
        {
            //About Us
            AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
            [self.navigationController pushViewController:aboutUsViewController animated:YES];
        }
            
            break;
        case 2:
        {
            //Contact
            if([MFMailComposeViewController canSendMail])
            {
                
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
                mailer.mailComposeDelegate = self;
                
                NSString *subject;
                
                subject = @"BasetaxPlus Contact";
                
                [mailer setSubject:subject];
                [mailer setTitle:@"Invite"];
                
                NSString* emailToRecipents = @"tax@basetax.co.uk";
                
                NSArray *toRecipents = [NSArray arrayWithObject:emailToRecipents];
                [mailer setMessageBody:@"" isHTML:NO];
                [mailer setToRecipients:toRecipents];
                
                [self presentViewController:mailer animated:YES completion:nil];
                
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Failure"
                                      message:@"Your device doesn't support the composer sheet"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }

        }
            break;
        default:
            break;
    }
}


#pragma mark - Button Sender

- (IBAction)btnYourDetails_Clicked:(id)sender
{
    if(appdelegate.isLoginSucessfully)
    {
        IntroDetailViewController* introDetailViewController = [[IntroDetailViewController alloc] initWithNibName:@"IntroDetailViewController" bundle:nil];
        [self.navigationController pushViewController:introDetailViewController animated:YES];
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
//    IntroDetailViewController* introDetailViewController = [[IntroDetailViewController alloc] initWithNibName:@"IntroDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:introDetailViewController animated:YES];
    
}
- (IBAction)btnSubmit_Clicked:(id)sender
{
    if (appdelegate.isLoginSucessfully && appdelegate.documents.count > 0)
    {
        UIAlertView* confirmMessage = [[UIAlertView alloc] initWithTitle:nil message:@" Are you ready to submit your detail to Basetax?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Not yet", nil];
        [confirmMessage setTag:1];
        [confirmMessage show];
    }
    else if (appdelegate.isLoginSucessfully && appdelegate.documents.count == 0)
    {
        UIAlertView* confirmMessage = [[UIAlertView alloc] initWithTitle:nil message:@"Please upload documents before submit to Basetax." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [confirmMessage show];
    }
    else
    {
        UIAlertView* confirmMessage = [[UIAlertView alloc] initWithTitle:nil message:@"Please log in or register to submit to Basetax" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [confirmMessage show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 1) {
        if (buttonIndex == 0) {
            
            //the guts of the message.
            SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
            testMsg.fromEmail = @"skyatnight.luong@gmail.com";
            testMsg.toEmail = @"Kah@basetax.com";
            testMsg.relayHost = @"smtp.gmail.com";
            testMsg.requiresAuth = YES;
            testMsg.login = @"skyatnight.luong@gmail.com";
            testMsg.pass = @"20091991lop12a01";
            testMsg.subject = [NSString stringWithFormat:@"Basetaxplus - submission from [%@]", appdelegate.userReponsitory.userName];
            testMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
            
            
            // Only do this for self-signed certs!
            // testMsg.validateSSLChain = NO;
            testMsg.delegate = self;
            
            //email contents
           
            NSString * bodyMessage = @"Please find the documents submitted by [";
            
            for (DocumentReponsitory* document in appdelegate.documents)
            {
                bodyMessage = [bodyMessage stringByAppendingString:document.nameOfDocument];
                bodyMessage = [bodyMessage stringByAppendingString:@", "];
            }

            bodyMessage = [bodyMessage stringByAppendingString:[NSString stringWithFormat:@"] on [%@] as attached.\n\nThank you.\n\nRegards\n\nBasetax Team", appdelegate.dateSentDocument]];
            
            NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey, bodyMessage ,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
            
            testMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
            
            [testMsg send];

            
            SubmitViewController* submitViewController = [[SubmitViewController alloc] initWithNibName:@"SubmitViewController" bundle:nil];
            [self.navigationController pushViewController:submitViewController animated:YES];

        }
    }
    else if([alertView tag] == 2)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        if (buttonIndex == 1) {
            LoginViewController* loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:loginViewController animated:YES];
        }
    }
  
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    
}

- (void)messageSent:(SKPSMTPMessage *)message
{
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            /*	NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");*/
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deleted" message:@"Your mail has been Deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setTag:2];
            [alert show];
            
        }
            break;
        case MFMailComposeResultSaved:
            //  NSLog(@"Mail saved: you saved the email message in the Drafts folder");
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Saved" message:@"Your Conversation has been saved to Draft" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setTag:2];
            [alert show];
            
            
        }
            break;
            
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Send successfully." delegate:self cancelButtonTitle:@"Thank you!" otherButtonTitles:nil];
            [alert setTag:2];
            [alert show];
            
            
        }
            break;
        case MFMailComposeResultFailed:
            
        {
            NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Your valuable FeedBack has been Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setTag:2];
            [alert show];
            
            
        }
            break;
        default:
            NSLog(@"Mail not sent");
            break;
    }
    
    NSLog(@"Disconnect EMAIL");
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
    [_btnMenu release];
    [super dealloc];
}
@end
