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
#import "TableViewDataSourceRow.h"
#import "TableViewDataSourceSection.h"
#import "CustomDatePicker.h"

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

-(void)montaDataSource{
    //Monta dataset dos itens na tela
    TableViewDataSourceRow* especialidade = [[TableViewDataSourceRow alloc] init];
    especialidade.text = @"Especialidade";
    especialidade.detailText = self.filtroPacientesInternados.nomeEspecialidade;
    especialidade.stereotype = Search;
    especialidade.operation = @"CarregarEspecialidades";
    
    TableViewDataSourceRow* unidade = [[TableViewDataSourceRow alloc] init];
    unidade.text = @"Unidade";
    unidade.detailText = self.filtroPacientesInternados.nomeUnidadeOrganizacional;
    unidade.stereotype = Search;
    unidade.operation = @"ListarUnidadesAtendidasEnfermagemBasica";
    
    TableViewDataSourceRow* medico = [[TableViewDataSourceRow alloc] init];
    medico.text = @"Médico";
    medico.detailText = self.filtroPacientesInternados.nomeMedico;
    medico.stereotype = Search;
    medico.operation = @"ListarMedicosUltimaPrescricao_PacientesAtendimentoEmAberto";
    
    TableViewDataSourceRow* paciente = [[TableViewDataSourceRow alloc] init];
    paciente.text = @"Paciente";
    paciente.detailText = self.filtroPacientesInternados.nomePaciente;
    paciente.stereotype = Search;
    paciente.operation = @"ListarPessoasPossuemAtendimentoEmAberto";
    
    TableViewDataSourceSection* primeira = [[TableViewDataSourceSection alloc] init];
    primeira.rows = [NSArray arrayWithObjects:especialidade,unidade,medico,paciente, nil];
    
    TableViewDataSourceRow* dataInicial = [[TableViewDataSourceRow alloc] init];
    dataInicial.text = @"Data Inicial";
    dataInicial.detailText = self.filtroPacientesInternados.dataInicial;
    dataInicial.stereotype = Date;
    dataInicial.action = @selector(dtpDataInicial_ValueChanged:);
    
    TableViewDataSourceRow* dataFinal = [[TableViewDataSourceRow alloc] init];
    dataFinal.text = @"Data Final";
    dataFinal.detailText = self.filtroPacientesInternados.dataFinal;
    dataFinal.stereotype = Date;
    dataFinal.action = @selector(dtpDataFinal_ValueChanged:);
    
    TableViewDataSourceSection* segunda = [[TableViewDataSourceSection alloc] init];
    segunda.rows = [NSArray arrayWithObjects:dataInicial,dataFinal, nil];
    segunda.headerTitle = @"Abertura do Atendimento";
    
    self.dataSource = [NSArray arrayWithObjects:primeira,segunda, nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        

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
    [self.navigationController setToolbarHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self montaDataSource];
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
    return ((TableViewDataSourceSection*)[self.dataSource objectAtIndex:section]).headerTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((TableViewDataSourceSection*)[self.dataSource objectAtIndex:section]).rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *CellIdentifier;
    TableViewDataSourceSection* secao = (TableViewDataSourceSection*)[self.dataSource objectAtIndex:indexPath.section];
    TableViewDataSourceRow *item = (TableViewDataSourceRow*)[secao.rows objectAtIndex:indexPath.row];
    
    switch (item.stereotype) {
        case Search:
            CellIdentifier = @"Cell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(!cell)
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
            cell.textLabel.text = item.text;
            cell.detailTextLabel.text = item.detailText;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.detailTextLabel.numberOfLines = 0;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell sizeToFit];

            break;
        case Date:
            CellIdentifier = @"TextEditCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(!cell)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextEditCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            };
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            TextEditCell* textEditCell = (TextEditCell*)cell;

            textEditCell.textLabel2.text = item.text;
            [textEditCell.textLabel2 sizeToFit];
            UITextField* textEdit = textEditCell.textEdit2;
            textEdit.delegate = self;
            textEdit.text = [dateFormat stringFromDate: item.detailText];
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomDatePicker" owner:self options:nil];
            CustomDatePicker* datePicker = (CustomDatePicker*)[nib objectAtIndex:0];
            datePicker.action = item.action;
//            [datePicker.datePicker addTarget:self action:item.action forControlEvents:UIControlEventValueChanged];
            [datePicker.btnOk setTarget:self];
            [datePicker.btnOk setAction:@selector(btnOk:)];
            [datePicker.btnCancelar setTarget:self];
            [datePicker.btnCancelar setAction:@selector(btnCancelar:)];
            
            textEdit.inputView = datePicker;
            

            break;
    }
    
    return cell;
}


-(void)btnCancelar:(UIBarButtonItem*)sender{
    [self resignFirstResponder];
    [self.tableView reloadData];
}

-(void)btnOk:(UIBarButtonItem*)sender{
    CustomDatePicker* datePicker = (CustomDatePicker*)currentEditingField.inputView;
    [self performSelector:datePicker.action withObject:datePicker.datePicker];
    [self resignFirstResponder];
    [self montaDataSource];
    [self.tableView reloadData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentEditingField = textField;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewDataSourceSection* secao = (TableViewDataSourceSection*)[self.dataSource objectAtIndex:indexPath.section];
    TableViewDataSourceRow *item = (TableViewDataSourceRow*)[secao.rows objectAtIndex:indexPath.row];
    
    NSString *cellText;
    if([item.detailText isKindOfClass:[NSString class]])
        cellText = item.detailText;
    else
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];

        cellText = [dateFormat stringFromDate: item.detailText];
    }

    if (cellText && (![cellText isEqualToString:@""]))
    {
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
        CGSize constraintSize = CGSizeMake(140.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        return labelSize.height + 20;
    }
    else
        return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == ([self.dataSource count]-1)){
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
    TableViewDataSourceSection* secao = (TableViewDataSourceSection*)[self.dataSource objectAtIndex:indexPath.section];
    TableViewDataSourceRow *item = (TableViewDataSourceRow*)[secao.rows objectAtIndex:indexPath.row];
    
    switch (item.stereotype) {
        case Search:
            self.operacao = item.operation;
            [self performSegueWithIdentifier:@"Lista Especialidades" sender:self];
            break;
            
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Pacientes Internados"])
    {
        ((PacientesInternadosViewController*)segue.destinationViewController).filtro = self.filtroPacientesInternados;
    }else if ([segue.identifier isEqualToString:@"Lista Especialidades"]){
        ItemsViewController* itensViewController =  ((ItemsViewController*)segue.destinationViewController);
        itensViewController.operacao = self.operacao;
        if([self.operacao isEqualToString: @"CarregarEspecialidades"]){
            itensViewController.title = @"Especialidades";
            itensViewController.valorSelecionado = self.filtroPacientesInternados.codigoEspecialidade;
        } else if([self.operacao isEqualToString: @"ListarUnidadesAtendidasEnfermagemBasica"]){
            itensViewController.title =  @"Unidades";
            itensViewController.valorSelecionado = self.filtroPacientesInternados.codigoUnidadeOrganizacional;
        } else if ([self.operacao isEqualToString: @"ListarMedicosUltimaPrescricao_PacientesAtendimentoEmAberto"]){
            itensViewController.temPrevixo = true;
            itensViewController.title =  @"Médicos";
            itensViewController.valorSelecionado = self.filtroPacientesInternados.codigoMedico;
        } else if ([self.operacao isEqualToString: @"ListarPessoasPossuemAtendimentoEmAberto"]){
            itensViewController.title =  @"Pacientes";
            itensViewController.temPrevixo = true;
            itensViewController.valorSelecionado = self.filtroPacientesInternados.codigoPaciente;
        }
    }
}

-(void)dtpDataInicial_ValueChanged:(UIDatePicker*)sender{
    self.filtroPacientesInternados.dataInicial = sender.date;
}

-(void)dtpDataFinal_ValueChanged:(UIDatePicker*)sender{
    self.filtroPacientesInternados.dataFinal = sender.date;
}

- (void)btnRelatorio_TouchUpInside:(UIButton*)sender {
    [self performSegueWithIdentifier:@"Pacientes Internados" sender:self];
}

- (IBAction)btnMenu_Pressed:(id)sender {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)limpar:(id)sender {
    self.filtroPacientesInternados = [[FiltroPacientesInterdados alloc] init];
    [self montaDataSource];
    [self.tableView reloadData];
}


@end
