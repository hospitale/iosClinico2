//
//  FiltroPacientesInternadosController.m
//  Hospitale
//
//  Created by AeC on 1/31/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "FiltroPacientesInternadosController.h"
#import "FiltroPacientesInterdados.h"
#import "TextEditCell.h"
#import "PacientesInternadosViewController.h"
#import "ItemsViewController.h"
#import "IIViewDeckController.h"
#import "ItemFiltroPacientesInternados.h"
#import "SecaoItemFiltroPacientesInternados.h"

@interface FiltroPacientesInternadosController ()
@property (nonatomic,strong) UIButton* btnRelatorio;
@property (nonatomic,strong) NSString* operacao;
@property (nonatomic,strong) NSArray* dataSource;
@end

@implementation FiltroPacientesInternadosController
@synthesize filtroPacientesInternados = _filtroPacientesInternados;
@synthesize btnRelatorio = _btnRelatorio;
@synthesize operacao = _operacao;
@synthesize dataSource = _dataSource;

-(FiltroPacientesInterdados *)filtroPacientesInternados{
    if(!_filtroPacientesInternados)
        _filtroPacientesInternados = [[FiltroPacientesInterdados alloc] init];
    return _filtroPacientesInternados;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        ItemFiltroPacientesInternados* especialidade = [[ItemFiltroPacientesInternados alloc] init];
        especialidade.text = @"Especialidade";
        especialidade.detailText = self.filtroPacientesInternados.nomeEspecialidade;
        especialidade.stereotype = @"Search";
        especialidade.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        especialidade.operacao = @"CarregarEspecialidades";
        
        ItemFiltroPacientesInternados* unidade = [[ItemFiltroPacientesInternados alloc] init];
        unidade.text = @"Unidade";
        unidade.detailText = self.filtroPacientesInternados.nomeUnidadeOrganizacional;
        unidade.stereotype = @"Search";
        unidade.operacao = @"ListarUnidadesAtendidasEnfermagemBasica";
        
        ItemFiltroPacientesInternados* medico = [[ItemFiltroPacientesInternados alloc] init];
        medico.text = @"Médico";
        medico.detailText = self.filtroPacientesInternados.nomeMedico;
        medico.stereotype = @"Search";
        medico.operacao = @"ListarMedicosUltimaPrescricao_PacientesAtendimentoEmAberto";
        
        SecaoItemFiltroPacientesInternados* primeira = [[SecaoItemFiltroPacientesInternados alloc] init];
        primeira.itens = [NSArray arrayWithObjects:especialidade,unidade,medico, nil];
        
        ItemFiltroPacientesInternados* dataInicial = [[ItemFiltroPacientesInternados alloc] init];
        dataInicial.text = @"Data Inicial";
        dataInicial.detailText = self.filtroPacientesInternados.dataInicial;
        dataInicial.stereotype = @"Date";
        
        ItemFiltroPacientesInternados* dataFinal = [[ItemFiltroPacientesInternados alloc] init];
        dataFinal.text = @"Data Final";
        dataFinal.detailText = self.filtroPacientesInternados.dataFinal;
        dataFinal.stereotype = @"Date";
        
        SecaoItemFiltroPacientesInternados* segunda = [[SecaoItemFiltroPacientesInternados alloc] init];
        segunda.itens = [NSArray arrayWithObjects:dataInicial,dataFinal, nil];
        segunda.nome = @"Abertura do Atendimento";
        
        self.dataSource = [NSArray arrayWithObjects:primeira,segunda, nil];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataSource count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return ((SecaoItemFiltroPacientesInternados*)[self.dataSource objectAtIndex:section]).nome;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((SecaoItemFiltroPacientesInternados*)[self.dataSource objectAtIndex:section]).itens count];
}

- (IBAction)btnMenu_Pressed:(id)sender {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *CellIdentifier;
    if(indexPath.section == 0)
    {
        CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }else if (indexPath.section == 1)
    {
        CellIdentifier = @"TextEditCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextEditCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        };
    }
    TextEditCell* textEditCell = (TextEditCell*)cell;
    if(indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Especialidade";
                cell.detailTextLabel.text = self.filtroPacientesInternados.nomeEspecialidade;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                
            case 1:
                cell.textLabel.text = @"Unidade";
                cell.detailTextLabel.text = self.filtroPacientesInternados.nomeUnidadeOrganizacional;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                
            case 2:
                cell.textLabel.text = @"Médico";
                cell.detailTextLabel.text = self.filtroPacientesInternados.nomeMedico;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
        }
        
    }else if (indexPath.section == 1){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
        if (indexPath.row == 0){
            
            textEditCell.textLabel2.text = @"Data Inicial";
            [textEditCell.textLabel2 sizeToFit];
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITextField* textEdit = textEditCell.textEdit2;
            textEdit.text = [dateFormat stringFromDate: self.filtroPacientesInternados.dataInicial];
            
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(dtpDataInicial_ValueChanged:) forControlEvents:UIControlEventValueChanged];
            datePicker.tag = indexPath.row;
            
            textEdit.inputView = datePicker;
        }else if (indexPath.row == 1){
            textEditCell.textLabel2.text = @"Data Final";
            [textEditCell.textLabel2 sizeToFit];
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITextField* textEdit = textEditCell.textEdit2;
            textEdit.text = [dateFormat stringFromDate: self.filtroPacientesInternados.dataFinal];
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(dtpDataFinal_ValueChanged:) forControlEvents:UIControlEventValueChanged];
            datePicker.tag = indexPath.row;
            
            textEdit.inputView = datePicker;
        }
    }

    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50) ];
        footerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        UIButton *buttonLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buttonLogin.frame = CGRectMake(footerView.frame.origin.x +10, footerView.frame.origin.y+10, footerView.bounds.size.width - 20, 40);
        
        [buttonLogin setTitle:@"Relatório" forState:UIControlStateNormal];
        [buttonLogin addTarget:self action:@selector(btnRelatorio_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        buttonLogin.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        [footerView addSubview:buttonLogin];
        
        return footerView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 1){
        return 50;
    }
    else return 10;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                self.operacao = @"CarregarEspecialidades";
                break;
                
            case 1:
                self.operacao = @"ListarUnidadesAtendidasEnfermagemBasica";
                break;

            case 2:
                self.operacao = @"ListarMedicosUltimaPrescricao_PacientesAtendimentoEmAberto";
                break;
        }
        [self performSegueWithIdentifier:@"Lista Especialidades" sender:self];
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {

        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Pacientes Internados"])
    {
        ((PacientesInternadosViewController*)segue.destinationViewController).filtro = self.filtroPacientesInternados;
    }else if ([segue.identifier isEqualToString:@"Lista Especialidades"]){
        ((ItemsViewController*)segue.destinationViewController).operacao = self.operacao;
    }
}

-(void)dtpDataInicial_ValueChanged:(UIDatePicker*)sender{
    self.filtroPacientesInternados.dataInicial = sender.date;
    [self.tableView reloadData];
}

-(void)dtpDataFinal_ValueChanged:(UIDatePicker*)sender{
    self.filtroPacientesInternados.dataFinal = sender.date;
    [self.tableView reloadData];
}

- (void)btnRelatorio_TouchUpInside:(UIButton*)sender {
    [self performSegueWithIdentifier:@"Pacientes Internados" sender:self];

}


@end
