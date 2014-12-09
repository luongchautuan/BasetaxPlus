//
//  ExpenseViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/6/14.
//
//

#import "ExpenseViewController.h"

@interface ExpenseViewController ()

@end

bool cashBool,otherBool,cardBool,chequeBool;

@implementation ExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSaveExpense_Clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCheckCashPopup:(id)sender
{
    UIButton *btn1 = sender;
    
    [btn1 setImage:[UIImage imageNamed:@"cash button (select).png"] forState:UIControlStateNormal];
    
    cardBool=FALSE;
    chequeBool=FALSE;
    otherBool=FALSE;
    
    
    [self.btnCard setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnCheque setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnOther setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    
    //    self.txtPaymentType.text = @"Cash";
    //    [self checkStateOfButtonPopup:isCheckTypeInPopup];
}

- (IBAction)onCheckChequePopup:(id)sender
{
    UIButton *btn1 = sender;
    
    chequeBool =TRUE ;
    [btn1 setImage:[UIImage imageNamed:@"cheque button ( select).png"] forState:UIControlStateNormal];
    
    
    [self.btnCard setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnCash setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    [self.btnOther setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    cardBool=FALSE;
    cashBool=FALSE;
    otherBool=FALSE;
    
    //    self.txtPaymentType.text = @"Cheque";
    
}

- (IBAction)onCheckCardPopup:(id)sender
{
    UIButton *btn1 = sender;
    
    [btn1 setImage:[UIImage imageNamed:@"card button (select).png"] forState:UIControlStateNormal];
    cardBool = TRUE;
    
    [self.btnCash setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    [self.btnCheque setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnOther setImage:[UIImage imageNamed:@"other button.png"] forState:UIControlStateNormal];
    cashBool=FALSE;
    chequeBool=FALSE;
    otherBool=FALSE;
    
    //    self.txtPaymentType.text = @"Card";
    
}

- (IBAction)onCheckOtherPopup:(id)sender
{
    UIButton *btn1 = sender;
    
    otherBool =TRUE ;
    
    [btn1 setImage:[UIImage imageNamed:@"other button (select).png"] forState:UIControlStateNormal];
    
    [self.btnCard setImage:[UIImage imageNamed:@"Card-button.png"] forState:UIControlStateNormal];
    [self.btnCheque setImage:[UIImage imageNamed:@"cheque button.png"] forState:UIControlStateNormal];
    [self.btnCash setImage:[UIImage imageNamed:@"cash button.png"] forState:UIControlStateNormal];
    
    cardBool=FALSE;
    chequeBool=FALSE;
    cashBool=FALSE;
    
    //    self.txtPaymentType.text = @"Other";
    
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
    [_btnCash release];
    [_btnCheque release];
    [_btnCard release];
    [_btnOther release];
    [_txtProviderShop release];
    [_btnCheckDisallowable release];
    [_btnInformation release];
    [_viewInformation release];
    [super dealloc];
}
@end
