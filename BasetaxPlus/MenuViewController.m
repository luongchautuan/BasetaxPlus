//
//  MenuViewController.m
//  BasetaxPlus
//
//  Created by Hung Kiet Ngo on 1/9/15.
//
//

#import "MenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"


@interface MenuViewController ()

@end

AppDelegate* appdelegate;

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSDictionary *profile = [[NSDictionary alloc] initWithObjectsAndKeys:@"Profile", @"title", @"", @"detail", @"menu_img_customer.png", @"icon", nil];
    NSDictionary *aboutUs = [[NSDictionary alloc] initWithObjectsAndKeys:@"About Us", @"title", @"", @"detail", @"menu_img_customer.png", @"icon", nil];
    NSDictionary *contact = [[NSDictionary alloc] initWithObjectsAndKeys:@"Contact", @"title", @"", @"detail", @"menu_img_customer.png", @"icon", nil];
    
    self.arrData = [[NSArray alloc] initWithObjects:profile,aboutUs,contact, nil];
    
//    self.arrData = [NSArray arrayWithObjects:profile, aboutUs, contact, nil];
    
    [self.tableView reloadData];

}

#pragma mark - tableview delegatge

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    NSLog(@"Array Data: %lu", (unsigned long)self.arrData.count);
    
//    if (self.arrData.count > 0)
//    {
        NSDictionary *currData = [self.arrData objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [currData objectForKey:@"title"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [currData objectForKey:@"detail"]];
        cell.imageView.image = [UIImage imageNamed:[currData objectForKey:@"icon"]];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectCategory:indexPath.row];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
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
    [_tableView release];
    [super dealloc];
}
@end
