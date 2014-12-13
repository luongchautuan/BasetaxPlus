//
//  TaxYearViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 12/10/14.
//
//

#import "TaxYearViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface TaxYearViewController ()

@end

NSMutableArray *feeds;
NSMutableArray *data1;
NSString *responseString;

AppDelegate* appdelegate;

@implementation TaxYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.data = [[NSMutableArray alloc] init];
    
    NSLog(@"IN LOAD");
    
    appdelegate.activityIndicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appdelegate.activityIndicatorView.mode = MBProgressHUDAnimationFade;
    appdelegate.activityIndicatorView.labelText = @"Loading Tax Year";
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/taxyear/all"]];
    
    [request addBasicAuthenticationHeaderWithUsername:@"submitmytax" andPassword:@"T75w63UC"];
    
    [request setTag:1];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
    [request startAsynchronous];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
//    [self.tableViewYear reloadData];
    
}

- (IBAction)btnBack_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request delegates...

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"IN FNISH");
    if(request.tag == 1)
    {
        
        NSLog(@"Dashboard request finished");
        
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSLog(@"response string-->%@",responseString);
        
        SBJsonParser *json = [SBJsonParser new];
        feeds = [json objectWithString:responseString];
        NSLog(@"Feeds in income = %@",feeds);
        
        self.data = [[NSMutableArray alloc] initWithArray:[feeds valueForKey:@"description"]];
        
         NSLog(@"cell: %@", [self.data objectAtIndex:0]);
        
        data1 = [[NSMutableArray alloc] initWithArray:[feeds valueForKey:@"id"]];
        
        [appdelegate.activityIndicatorView hide:YES];
        
        [self.tableViewYear reloadData];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    NSLog(@"income request failed");
    
    NSLog(@"Code : %d, Error: %@",[[request error] code],[[request error] description]);
    
    NSLog(@"Error in YEAR");
    
}


#pragma mark - Table Delegates...

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Data: %lu", (unsigned long)self.data.count);
    return [self.data count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSLog(@"cell: %@", [self.data objectAtIndex:0]);
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.data objectAtIndex:indexPath.row]];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appdelegate.year = [self.data objectAtIndex:[indexPath row]];
    appdelegate.IDyear = [[data1 objectAtIndex:[indexPath row]] intValue];
    
    NSLog(@"tyear %@ tid %i",appdelegate.year,appdelegate.IDyear);
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
