//
//  PacientesInternadosViewController.m
//  Hospitale
//
//  Created by Rafael on 1/29/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "PacientesInternadosViewController.h"
#import "AeCURLConnection.h"
#import "PacienteTvc.h"
#import "DetalhePacienteController.h"
#import "URLUtil.h"

@interface PacientesInternadosViewController ()
@property (nonatomic,strong) NSArray* dados;
@property (nonatomic,weak) NSDictionary* pacienteSelecionado;
@end

@implementation PacientesInternadosViewController
@synthesize filtro = _filtro;
@synthesize pacienteSelecionado = _pacienteSelecionado;

BOOL loaded = NO;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setup{
    if(!loaded){
//        loaded = YES;
        //Carrega as especialiades
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSLog(@"Filtro: IdEspecialidade = %d",self.filtro.codigoEspecialidade);
        NSString* content = [NSString stringWithFormat:@"{\"dto\":{\"IdEspecialidade\":\"%d\",\"IdPessoa\":\"%d\",\"IdUnidadeOrganizacional\":\"%d\"}",
                             self.filtro.codigoEspecialidade ? self.filtro.codigoEspecialidade : -1,
                             self.filtro.codigoMedico ? self.filtro.codigoMedico : -1,
                             self.filtro.codigoUnidadeOrganizacional ? self.filtro.codigoUnidadeOrganizacional : -1];
        NSString* url = [NSString stringWithFormat:@"%@clinico/enfermagem/testeClinico.svc/CarregarPacientesInternados",[URLUtil getBackEndUrl]];
   
        [AeCURLConnection post:url withContent:content successBlock:^(NSData *data, id jsonData) {
                       
                       //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] );
                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                           
                           /* process downloaded data in Concurrent Queue */
                           self.dados = jsonData;
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if([self.dados count] == 0)
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção"
                                                                                   message:@"Nenhum registro encontrado com os filtros informados."
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil];
                                   [alert show];
                                   [self.navigationController popViewControllerAnimated:YES];
                               }
                               /* update UI on Main Thread */
                               [self.tableView reloadData];
                           });
                       });
                   } errorBlock:^(NSError *error) {
                       NSLog(@"%@",error);
                   } completeBlock:^{
                       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                   }];
    }

}

-(void)awakeFromNib{
    [super awakeFromNib];
    //[self setup];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setup];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setup];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int qtd = [self.dados count];
    return qtd;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSNumber* qtd = [[self.dados objectAtIndex:section] objectForKey:@"Quantidade"];
    return [qtd integerValue];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString* title = [[self.dados objectAtIndex:section] objectForKey:@"NomeEspecialidade"];
    if([title isEqualToString:@""])
        title = @"Sem Especialidade";
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Paciente";
    PacienteTvc *cell = (PacienteTvc*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PacienteTvc" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSMutableDictionary* grupo = [self.dados objectAtIndex: indexPath.section];
    NSMutableDictionary* item = [[grupo objectForKey:@"PacientesInternados"] objectAtIndex:indexPath.row];
    cell.lblPaciente.text = [item objectForKey:@"NomePaciente"];
    cell.lblAtendimento.text = [item objectForKey:@"IdAtendimento"];
    cell.lblEndereco.text = [NSString stringWithFormat:@"%@ - %@",[item objectForKey:@"NomeUnidadeOrganizacional"],[item objectForKey:@"NumeroLeito"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
    NSMutableDictionary* grupo = [self.dados objectAtIndex: indexPath.section];
    self.pacienteSelecionado = [[grupo objectForKey:@"PacientesInternados"] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"Detalhe Paciente" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Detalhe Paciente"]){
        DetalhePacienteController* controller = (DetalhePacienteController*)segue.destinationViewController;
        controller.pacienteInternado = [[PacienteInternado alloc]init];
    
        controller.pacienteInternado.numeroLeito = [self.pacienteSelecionado objectForKey:@"NumeroLeito"];
        controller.pacienteInternado.idAtendimento = [self.pacienteSelecionado objectForKey:@"IdAtendimento"];
        controller.pacienteInternado.nomePaciente = [self.pacienteSelecionado objectForKey:@"NomePaciente"];
        controller.pacienteInternado.dataAtendimento = [self.pacienteSelecionado objectForKey:@"DataAtendimento"];
        controller.pacienteInternado.nomeMedico = [self.pacienteSelecionado objectForKey:@"NomeMedico"];
        controller.pacienteInternado.nomeOperadora = [self.pacienteSelecionado objectForKey:@"NomeOperadora"];
        controller.pacienteInternado.diagnostico = [self.pacienteSelecionado objectForKey:@"Diagnostico"];
        controller.pacienteInternado.idSolicitacao = [self.pacienteSelecionado objectForKey:@"IdSolicitacao"];
        controller.pacienteInternado.idEspecialidade = [self.pacienteSelecionado objectForKey:@"IdEspecialidade"];
        controller.pacienteInternado.nomeEspecialidade = [self.pacienteSelecionado objectForKey:@"NomeEspecialidade"];
        controller.pacienteInternado.nomeUnidadeOrganizacional = [self.pacienteSelecionado objectForKey:@"NomeUnidadeOrganizacional"];
        
    }
}

@end
