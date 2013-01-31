//
//  FiltroPacientesInternadosController.m
//  Hospitale
//
//  Created by AeC on 1/31/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "FiltroPacientesInternadosController.h"
#import "FiltroPacientesInterdados.h"

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"Especialidade";
        cell.detailTextLabel.text = self.filtroPacientesInternados.nomeEspecialidade;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
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


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
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
}

- (void)btnRelatorio_TouchUpInside:(UIButton*)sender {
    [self performSegueWithIdentifier:@"Pacientes Internados" sender:self];

}


@end
