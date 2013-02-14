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
@property (nonatomic,strong) NSIndexPath* selectedIndexPath;
@end

@implementation ItemsViewController
@synthesize data = _data;
@synthesize allData = _allData;
@synthesize operacao = _operacao;
@synthesize titulo = _titulo;
@synthesize valorSelecionado = _valorSelecionado;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize temPrevixo = _temPrevixo;

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
    
    if(!self.temPrevixo)
        [self requisitaDadosComConteudo:@""];
    else{
        self.searchBar.placeholder = @"Informe pelo menos 2 carateres.";
        [self.searchBar becomeFirstResponder];
    }
    
    inited = YES;
}

-(void)requisitaDadosComConteudo:(NSString*)conteudo{
    //Carrega as especialiades
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* url = [NSString stringWithFormat:@"%@clinico/enfermagem/testeClinico.svc/%@",[URLUtil getBackEndUrl],self.operacao];
    [AeCURLConnection post:url
               withContent:conteudo successBlock:^(NSData *data, id jsonData) {
                   
                   //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       
                       /* process downloaded data in Concurrent Queue */
                       self.allData = jsonData;
                       self.data = [[NSMutableArray alloc]initWithArray:self.allData];
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           /* update UI on Main Thread */
                           [self.tableView reloadData];
                           [self performSelector:@selector(selectRowAtIndexPath:) withObject:self.selectedIndexPath afterDelay:0.0];
                       });
                   });
               } errorBlock:^(NSError *error) {
                   NSLog(@"%@",error);
               } completeBlock:^{
                   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
               }];
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

-(void)retornaParaControlardorComNome:(NSString*)nome comValor:(int) valor{
    UINavigationController* navController = self.navigationController;
    NSUInteger arraySize = [navController.viewControllers count];
    
    FiltroPacientesInternadosController* prevController = (FiltroPacientesInternadosController*)[navController.viewControllers objectAtIndex:arraySize-2];
    
    if([self.operacao isEqualToString: @"CarregarEspecialidades"]){
        prevController.filtroPacientesInternados.nomeEspecialidade = nome;
        prevController.filtroPacientesInternados.codigoEspecialidade = valor;
    } else if([self.operacao isEqualToString: @"ListarUnidadesAtendidasEnfermagemBasica"]){
        prevController.filtroPacientesInternados.nomeUnidadeOrganizacional = nome;
        prevController.filtroPacientesInternados.codigoUnidadeOrganizacional = valor;
    } else if ([self.operacao isEqualToString: @"ListarMedicosUltimaPrescricao_PacientesAtendimentoEmAberto"]){
        prevController.filtroPacientesInternados.nomeMedico = nome;
        prevController.filtroPacientesInternados.codigoMedico = valor;
    } else if ([self.operacao isEqualToString: @"ListarPessoasPossuemAtendimentoEmAberto"]){
        prevController.filtroPacientesInternados.nomePaciente = nome;
        prevController.filtroPacientesInternados.codigoPaciente = valor;
    }
    
    [navController popViewControllerAnimated:TRUE];

}
- (IBAction)limparFiltro:(id)sender {
    [self retornaParaControlardorComNome:@"" comValor:0];
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
    cell.textLabel.numberOfLines =0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

    if ([[[self.data objectAtIndex: indexPath.row] objectForKey:@"Id"] integerValue] == self.valorSelecionado)
    {
        self.selectedIndexPath = [indexPath copy];
//        NSLog(@"%@",self.selectedIndexPath);
    }
    return cell;
}

-(int)buscaIndiceParaValorSelecionado:(NSInteger)valorSelecionado{
    if (self.valorSelecionado)
    {
        for (int i = 0; i < [self.data count]; i++) {
            id item = [self.data objectAtIndex:i];
            
            if ([[item objectForKey:@"Id"] integerValue] == valorSelecionado)
            {
                return i;
            }
        }
    }
    return -1;
}

- (void) selectRowAtIndexPath:(NSIndexPath *) path {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self buscaIndiceParaValorSelecionado:self.valorSelecionado] inSection:0] animated:TRUE scrollPosition:UITableViewScrollPositionMiddle];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellText = [[self.data objectAtIndex: indexPath.row] objectForKey:@"Valor"];
    UIFont *cellFont = [UIFont boldSystemFontOfSize:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height + 20;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(!self.temPrevixo)
    {
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
    }else
    {
        if([searchText length] >= 2){
            [self requisitaDadosComConteudo:[NSString stringWithFormat: @"{\"prefixText\":\"%@\"}", searchText]];
        }
    }

    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];	
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = [self.data objectAtIndex:indexPath.row];
    [self retornaParaControlardorComNome:[item objectForKey:@"Valor"] comValor:[(NSNumber*) [item objectForKey:@"Id"] integerValue]];
}

@end
