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
#import "DocumentReponsitory.h"

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
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 4; //Set the maximum number of images to select, defaults to 4
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
    elcPicker.imagePickerDelegate = self;
    
    //Present modally
    [self presentViewController:elcPicker animated:YES completion:nil];
//
//    UIActionSheet *action_sheet = [[UIActionSheet alloc]initWithTitle:@"Upload options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil];
//    
//    [action_sheet showInView:[UIApplication sharedApplication].keyWindow];
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
    
    int documentIndex = 0;
    
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
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 30 * (documentIndex + 1), 300, 50)];
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
                
                [_scrollView addSubview:imageview];
                
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
    
//    self.chosenImages = images;
    
    [_scrollView setPagingEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
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
    [super dealloc];
}
@end
