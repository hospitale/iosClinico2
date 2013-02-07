//
//  ItemsViewController.m
//  Hospitale
//
//  Created by Developer on 1/23/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "ItemsViewController.h"
#import "AeCURLConnection.h"
#import "FiltroPacientesInternadosController.h"
#import "URLUtil.h"

@interface ItemsViewController ()

@end

@implementation ItemsViewController
@synthesize data = _data;
@synthesize allData = _allData;
@synthesize operacao = _operacao;

bool inited = NO;
int keyboardHeight;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)setup{
    

    if (!inited)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    
    //Carrega as especialiades
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* url = [NSString stringWithFormat:@"%@clinico/enfermagem/testeClinico.svc/%@",[URLUtil getBackEndUrl],self.operacao];
    [AeCURLConnection post:url
               withContent:@"" successBlock:^(NSData *data, id jsonData) {
                   
                   //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       
                       /* process downloaded data in Concurrent Queue */
                       self.allData = jsonData;
                       self.data = [[NSMutableArray alloc]initWithArray:self.allData];
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           /* update UI on Main Thread */
                           [self.tableView reloadData];
                       });
                   });
               } errorBlock:^(NSError *error) {
                   NSLog(@"%@",error);
               } completeBlock:^{
                   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
               }];
    
    inited = YES;
}

-(void)keyboardShown:(NSNotification*) notification{
    CGRect keyboardFrame;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGRect tableViewFrame = self.tableView.frame;
    keyboardHeight =keyboardFrame.size.height;
    tableViewFrame.size.height -= keyboardHeight;
    [self.tableView setFrame:tableViewFrame];
}

-(void)keyboardWillHide:(NSNotification*) notification{
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height += keyboardHeight;
    [self.tableView setFrame:tableViewFrame];
    //    [self.tableView setFrame:[[UIScreen mainScreen] bounds]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"Cell"];
    
    cell.textLabel.text = [[self.data objectAtIndex: indexPath.row] objectForKey:@"Valor"];
    
    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Filtra registros
        if([searchText length] == 0){
            [self.data removeAllObjects];
            [self.data addObjectsFromArray: self.allData];
        }else{
            [self.data removeAllObjects];
            for(int i = 0; i< [self.allData count];i++){
                NSString* item = [[self.allData objectAtIndex: i] objectForKey:@"Valor"];
                NSRange range = [item rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location != NSNotFound){
                    [self.data addObject:[self.allData objectAtIndex:i]];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    });

    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];	
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController* navController = self.navigationController;
    NSUInteger arraySize = [navController.viewControllers count];
    
    FiltroPacientesInternadosController* prevController = (FiltroPacientesInternadosController*)[navController.viewControllers objectAtIndex:arraySize-2];
    
    NSDictionary* item = [self.data objectAtIndex:indexPath.row];
    if(self.operacao == @"CarregarEspecialidades"){
        prevController.filtroPacientesInternados.nomeEspecialidade = [item objectForKey:@"Valor"];
        prevController.filtroPacientesInternados.codigoEspecialidade = [(NSNumber*) [item objectForKey:@"Id"] integerValue];
    } else if(self.operacao == @"ListarUnidadesAtendidasEnfermagemBasica"){
        prevController.filtroPacientesInternados.nomeUnidadeOrganizacional = [item objectForKey:@"Valor"];
        prevController.filtroPacientesInternados.codigoUnidadeOrganizacional = [(NSNumber*) [item objectForKey:@"Id"] integerValue];
    } else if (self.operacao == @"ListarMedicosUltimaPrescricao_PacientesAtendimentoEmAberto"){
        prevController.filtroPacientesInternados.nomeMedico = [item objectForKey:@"Valor"];
        prevController.filtroPacientesInternados.codigoMedico = [(NSNumber*) [item objectForKey:@"Id"] integerValue];
    }

    [navController popViewControllerAnimated:TRUE];
}

@end
