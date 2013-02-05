//
//  DetalhePacienteController.m
//  Hospitale
//
//  Created by Rafael on 2/5/13.
//  Copyright (c) 2013 AeC. All rights reserved.
//

#import "DetalhePacienteController.h"

@interface DetalhePacienteController ()

@end

@implementation DetalhePacienteController
@synthesize pacienteInternado = _pacienteInternado;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return section == 0 ? 7 : 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1)
        return @"Diagnóstico";
    return nil;
}

-(NSString*)textForRow:(NSIndexPath*)indexPath{
    NSString* result;
    if(indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                result =_pacienteInternado.nomePaciente;
                break;
            case 1:
                result = _pacienteInternado.numeroLeito;
                break;
            case 2:
                result = _pacienteInternado.dataAtendimento;
                break;
            case 3:
                result = _pacienteInternado.nomeMedico;
                break;
            case 4:
                result = _pacienteInternado.nomeOperadora;
                
                break;
            case 5:
                result = _pacienteInternado.nomeEspecialidade;
                
                break;
            case 6:
                result = _pacienteInternado.nomeUnidadeOrganizacional;
                break;
        }
    }else{
        result = _pacienteInternado.diagnostico;
      
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    if(indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = [self textForRow:indexPath];
                break;
            case 1:
                cell.textLabel.text = @"Leito";
                cell.detailTextLabel.text = [self textForRow:indexPath];
                break;
            case 2:
                cell.textLabel.text = @"Data";
                cell.detailTextLabel.text = [self textForRow:indexPath];
                break;
            case 3:
                cell.textLabel.text = @"Médico";
                cell.detailTextLabel.text = [self textForRow:indexPath];
                break;
            case 4:
                cell.textLabel.text = @"Operadora";
                cell.detailTextLabel.text = [self textForRow:indexPath];
                
                break;
            case 5:
                cell.textLabel.text = @"Especialidade";
                cell.detailTextLabel.text = [self textForRow:indexPath];
                break;
            case 6:
                cell.textLabel.text = @"Unidade";
                cell.detailTextLabel.text = [self textForRow:indexPath];
                
                break;
        }
    }
    else{
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.textLabel.text = [self textForRow:indexPath];
    }
    [cell.textLabel setLineBreakMode: NSLineBreakByWordWrapping];
    [cell.detailTextLabel setLineBreakMode: NSLineBreakByWordWrapping];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        NSString *cellText = [self textForRow:indexPath];
        UIFont *cellFont = indexPath.section == 0 ? [UIFont boldSystemFontOfSize:17.0] : [UIFont systemFontOfSize:17.0];
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        return labelSize.height + 20;
    }
    else
        return 50;

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
