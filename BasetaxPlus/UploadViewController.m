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
#import "ASIFormDataRequest.h"
#import "MainViewController.h"
#import "IncomeViewController.h"
#import "ExpenseViewController.h"
#import "DocumentReponsitory.h"
#import "LoginViewController.h"
#import "MobileCoreServices/MobileCoreServices.h"

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
    self.progressBarCount = 0;

    CGRect frame = CGRectMake(50, 300, 75, 75);
    self.progressbar = [self progressViewWithFrame:frame];

    self.progressbar.theme.sliceDividerHidden = YES;
    [self.view addSubview:self.progressbar];
    
    if (self.documents.count <= 0) {
        self.progressbar.hidden = YES;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ProgressBar

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
    MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
    // Only required in this demo to align vertically the progress views.
    view.center = CGPointMake(self.view.center.x, view.center.y + 50);
    
    return view;
}

- (UILabel *)labelAtY:(CGFloat)y andText:(NSString *)text
{
    CGRect frame = CGRectMake(5, y, 180, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:14];
    
    return label;
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
    if (!appdelegate.isLoginSucessfully)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please log in or register to add more income" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        
        [alert setTag:1];
        [alert show];
        [self.viewAddMore setHidden:YES];
        return;

    }
    
    [self.viewAddMore setHidden:YES];
    IncomeViewController* incomeViewController = [[IncomeViewController alloc] initWithNibName:@"IncomeViewController" bundle:nil];
    
    [self.navigationController pushViewController:incomeViewController animated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"SkipLogin: %ld", (long)buttonIndex);
    
    if (buttonIndex != 0)
    {
        NSLog(@"Cancel");
    }
    else
    {
        NSLog(@"LOgin");
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (IBAction)btnAddExpense_Clicked:(id)sender
{
    if (!appdelegate.isLoginSucessfully)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please log in or register to add more expense" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        
        [alert setTag:1];
        [alert show];
        [self.viewAddMore setHidden:YES];
        return;
        
    }
    
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
 //
//    UIActionSheet *action_sheet = [[UIActionSheet alloc]initWithTitle:@"Upload options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil];
//    
//    [action_sheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - Action scheet...

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *ipc=[[UIImagePickerController alloc] init ];
            
            ipc=[[UIImagePickerController alloc] init ];
            
            ipc.delegate=self;
            
            ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
            
            ipc.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
            
            [self presentModalViewController:ipc animated:YES];
            
            //            [self.parentViewController presentViewController:ipc animated:YES completion:nil];
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Camera capture is not supported in this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
    
    else if(buttonIndex == 1)
    {
        
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = 4; //Set the maximum number of images to select, defaults to 4
        elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
        elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
        elcPicker.imagePickerDelegate = self;
        
        //Present modally
        [self presentViewController:elcPicker animated:YES completion:nil];

    }
}

#pragma mark - Request delegates...

- (void)requestFinished:(ASIHTTPRequest *)request
{
}

- (void)uploadDocuments
{
    
}

-(void)RequestPhoto
{
//    NSData *dataTest=[[NSData alloc]init];
//    
//    ASIFormDataRequest *dataRequest=[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/transaction/%i/image",appDelegate.TransactionId]]];
//    
//    [dataRequest addBasicAuthenticationHeaderWithUsername:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"]andPassword:[[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"]];
//    
//    dataTest = [self compressImage:appDelegate.image];
//    
//    [dataRequest setData:dataTest forKey:@"file"];
//    [dataRequest setValidatesSecureCertificate:NO];
//    
//    [dataRequest setRequestMethod:@"POST"];
//    
//    [dataRequest setDelegate:self];
//    [dataRequest setTag:10];
//    
//    [dataRequest startAsynchronous];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(NSData *)compressImage:(UIImage *)image
{
    
    float actualHeight = image.size.height;
    
    float actualWidth = image.size.width;
    
    float maxHeight = 600.0;
    
    float maxWidth = 800.0;
    
    float imgRatio = actualWidth/actualHeight;
    
    float maxRatio = maxWidth/maxHeight;
    
    float compressionQuality = 0.5;//50 percent compression
    
    
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            
            imgRatio = maxHeight / actualHeight;
            
            actualWidth = imgRatio * actualWidth;
            
            actualHeight = maxHeight;
            
        }
        
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            
            imgRatio = maxWidth / actualWidth;
            
            actualHeight = imgRatio * actualHeight;
            
            actualWidth = maxWidth;
            
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
        
        
    }
    
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    
    UIGraphicsBeginImageContext(rect.size);
    
    [image drawInRect:rect];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    
    UIGraphicsEndImageContext();
    
    return imageData;
    
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

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }
    
    CGRect workingFrame = _scrollView.frame;
    workingFrame.origin.x = 0;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
    self.documents = [NSMutableArray arrayWithCapacity:[info count]];
    
    int documentIndex = 1;
    
    for (NSDictionary *dict in info)
    {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage])
            {
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                
                DocumentReponsitory* document = [[DocumentReponsitory alloc] init];
                document.imageOfDocument = image;
                
                NSString* nameOfDocument = [NSString stringWithFormat:@"Document %d", documentIndex];
                
                document.nameOfDocument =  nameOfDocument;
                
                [self.documents addObject:document];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 * (documentIndex + 1), 300, 50)];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor blackColor];
                label.numberOfLines = 0;
                
                label.text = nameOfDocument;
                
                [_scrollView addSubview:label];
                
                documentIndex = documentIndex + 1;
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
                
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
        else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo)
        {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage])
            {
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                
//                [_scrollView addSubview:imageview];
                
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
        else
        {
            NSLog(@"Uknown asset type");
        }
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [_scrollView release];
    [_btnSelectFileToUpload release];
    [_btnAddIncomeMain release];
    [super dealloc];
}
@end
