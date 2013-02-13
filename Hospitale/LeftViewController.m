//
//  LeftViewController.m
//  Hospitale
//
//  Created by Rafael on 2/7/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "LeftViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IIViewDeckController.h"
#import "TableViewDataSourceSection.h"
#import "TableViewDataSourceRow.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LeftViewController ()
@property (nonatomic,strong) NSArray* dataSource;
@end

@implementation LeftViewController
@synthesize dataSource;


-(void)montaDataSource{
    TableViewDataSourceRow* pacientesInternados = [[TableViewDataSourceRow alloc] init];
    pacientesInternados.text = @"Pacientes Internados";
    pacientesInternados.selected = YES;

    TableViewDataSourceSection* clinico = [[TableViewDataSourceSection alloc] init];
    clinico.headerTitle = @"CLÍNICO";
    clinico.rows = [NSArray arrayWithObjects:pacientesInternados, nil];
    
    TableViewDataSourceRow* logOut = [[TableViewDataSourceRow alloc] init];
    logOut.text = @"Log Out";
    logOut.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FBBookmarkLogout" ofType:@"png"]];
    logOut.action = @selector(logOut:);

    TableViewDataSourceSection* system = [[TableViewDataSourceSection alloc] init];
    system.rows = [NSArray arrayWithObjects:logOut, nil];
    
    self.dataSource = [NSArray arrayWithObjects:clinico, system, nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tableView.frame = (CGRect) { self.tableView.frame.origin.x,
    self.tableView.frame.origin.y,
    320 - self.viewDeckController.leftLedgeSize,
    self.tableView.frame.size.height };
    [self.tableView setAllowsSelection:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self montaDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataSource count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *myImage = [UIImage imageNamed:@"FBMenuSectionHeaderBackground.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage] ;
    imageView.frame = CGRectMake(0, 0, tableView.frame.size.width, 30.0);
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width -10, 20)];

    NSString* title = ((TableViewDataSourceSection*)[self.dataSource objectAtIndex:section]).headerTitle;
    if (!title)
        title = @" ";
    label.backgroundColor= [UIColor clearColor];
    
    label.text = title;
    
    label.font = [UIFont boldSystemFontOfSize:14.0];
    label.textColor = UIColorFromRGB(0xa2a9b9);
   
    
    [imageView addSubview:label];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [((TableViewDataSourceSection*)[self.dataSource objectAtIndex:section]).rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.dataSource)
    {
        TableViewDataSourceSection* secao = (TableViewDataSourceSection*)[self.dataSource objectAtIndex:indexPath.section];
        TableViewDataSourceRow *item = (TableViewDataSourceRow*)[secao.rows objectAtIndex:indexPath.row];
        
        if(!cell)
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if(item.selected)
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FBMenuCellBackgroundSelected.png"]];
        else
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FBMenuCellBackground.png"]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];  
        
        cell.imageView.image = item.image;
        cell.textLabel.text = item.text;
        
        cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:17];
        cell.textLabel.textColor = UIColorFromRGB(0xa2a9b9);
        cell.textLabel.shadowColor = UIColorFromRGB(0x212838);
        cell.textLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        cell.textLabel.backgroundColor = UIColorFromRGB(0x32394b);
        self.tableView.backgroundColor = UIColorFromRGB(0x32394b);
    }
    return cell;
}


#pragma mark - Table view delegate
//#define SuppressPerformSelectorLeakWarning(Stuff) \
//do { \
//_Pragma("clang diagnostic push") \
//_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
//Stuff; \
//_Pragma("clang diagnostic pop") \
//} while (0)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewDataSourceSection* secao = (TableViewDataSourceSection*)[self.dataSource objectAtIndex:indexPath.section];
    TableViewDataSourceRow *item = (TableViewDataSourceRow*)[secao.rows objectAtIndex:indexPath.row];
    
    if (item.action)        
        [self performSelector:item.action withObject:item];
}

-(void)logOut:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
