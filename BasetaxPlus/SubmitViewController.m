//
//  SubmitViewController.m
//  BasetaxPlus
//
//  Created by beesightsoft2 on 12/14/14.
//
//

#import "SubmitViewController.h"

@interface SubmitViewController ()

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnCloseApp_Clicked:(id)sender
{
     exit(0);
}
- (IBAction)btnContactUs_Clicked:(id)sender
{
    if([MFMailComposeViewController canSendMail])
    {
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;
        
        NSString *subject;
        
        subject = @"BasetaxPlus Enquiry";
        
        [mailer setSubject:subject];
        [mailer setTitle:@"Invite"];
        
        NSString* emailToRecipents = @" tax@basetax.co.uk";
        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            /*	NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");*/
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deleted" message:@"Your mail has been Deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
            break;
        case MFMailComposeResultSaved:
            //  NSLog(@"Mail saved: you saved the email message in the Drafts folder");
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Saved" message:@"Your Conversation has been saved to Draft" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
            
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Send successfully." delegate:self cancelButtonTitle:@"Thank you!" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
        case MFMailComposeResultFailed:
            
        {
            NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Your valuable FeedBack has been Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

@end
