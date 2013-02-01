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

@interface FiltroPacientesInternadosController ()
@property (nonatomic,strong) UIButton* btnRelatorio;
@end

@implementation FiltroPacientesInternadosController
@synthesize filtroPacientesInternados = _filtroPacientesInternados;
@synthesize btnRelatorio = _btnRelatorio;

-(FiltroPacientesInterdados *)filtroPacientesInternados{
    if(!_filtroPacientesInternados)
        _filtroPacientesInternados = [[FiltroPacientesInterdados alloc] init];
    return _filtroPacientesInternados;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.btnRelatorio = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.btnRelatorio.frame = CGRectMake(0, 0, 70, 40);
//    
//    [self.btnRelatorio setTitle:@"Relatório" forState:UIControlStateNormal];
//    [self.btnRelatorio addTarget:self action:@selector(btnRelatorio_TouchUpInside:) forControlEvents:UIControlEventAllEvents];
//    [self.view addSubview: self.btnRelatorio];
    
}
-(void)viewWillAppear:(BOOL)animated{
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
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return @"Abertura do Atendimento";
    }
    return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 1)
        return 2;
    return 1;
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
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        cell.textLabel.text = @"Especialidade";
        cell.detailTextLabel.text = self.filtroPacientesInternados.nomeEspecialidade;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        if(indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"Lista Especialidades" sender:self];
        }
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
