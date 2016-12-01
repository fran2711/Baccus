//
//  FJLWineryTableViewController.m
//  Baccus
//
//  Created by Fran Lucena on 07/01/16.
//  Copyright © 2016 Fran Lucena. All rights reserved.
//

#import "FJLWineryTableViewController.h"
#import "FJLWineViewController.h"

#define IS_IPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

@interface FJLWineryTableViewController ()

@end

@implementation FJLWineryTableViewController

#pragma mark - Init

-(id) initWithModel: (FJLWineryModel *) aModel
              style:(UITableViewStyle) aStyle{
    
    if (self = [super initWithStyle: aStyle]) {
        _model = aModel;
        //Muestro el título de la App
        self.title = @"Baccus";
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setDefaults];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.model) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        indicator.hidesWhenStopped = YES;
        indicator.frame = CGRectMake(self.view.frame.size.width / 2 - 37 / 2, self.view.frame.size.height / 2 - 37 / 2, 37, 37);
        [indicator startAnimating];
        
        //Como desciendo de UITableViewController me da muy poca flexibilidad a la hora de añadir subvistas, lo añado como cabecera de la tabla
        self.tableView.tableHeaderView = indicator;
        
        [self performSelector:@selector(loadModel) withObject:nil afterDelay:0.1];
    }
}

- (void)loadModel
{
    self.model = [[FJLWineryModel alloc] init];
    self.tableView.tableHeaderView = nil;
    [self.tableView reloadData];
    
    // Avisar al delegado
    [self.delegate wineryTableViewController: self
                               didSelectWine:[self lastSelectedWine]];
}


#pragma mark - Table view data source

/*Pongo el nombre a las cabeceras de la lista
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == RED_WINE_SECTION) {
        return  @"Red Wines";
        
    }else if (section == WHITE_WINE_SECTION){
        return @"White Wines";
        
    }else{
        return @"Other Wines";
    }
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //Devuelvo el número de secciones que va a tener la tabla
    if (self.model) {
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    //Creo un contador
    NSInteger count = 0;
    
    //Devuelvo el número de filas que hay en las secciones
    if (section == RED_WINE_SECTION) {
        
        count = [self.model redWineCount];
        
    }else if (section == WHITE_WINE_SECTION){
        
        count = [self.model whiteWineCount];
        
    }else if (section == ROSE_WINE_SECTION){
        
        count = [self.model roseWineCount];
        
    }else{
        
        count = [self.model champagneWineCount];

    }
    
    return count;

}

//Celdas que se van a mostrar
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WineCell";
    
    //Averiguo de que vino (modelo) se trata
    FJLWineModel *wine = [self wineForIndexPath: indexPath];
    
    //Creo una tabla
    UITableViewCell *wineCell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (wineCell == nil) {
        //Tenemos que crearla a mano
        wineCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: CellIdentifier];
        
        //Aplico el diseño
        wineCell.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cell_bg.png"]];
        wineCell.textLabel.backgroundColor = [UIColor clearColor];
        wineCell.detailTextLabel.backgroundColor = [UIColor clearColor];
        wineCell.textLabel.font =[UIFont fontWithName:@"Helvetica" size: 18];
        wineCell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size: 16];
    }
    

    
    
    //Sincronizar celda (vista) y modelo (vino)
    if (wine.photo) {
        wineCell.imageView.image = wine.photo;
    }else{
        //Si no tiene imagen devuelvo una por defecto
        wineCell.imageView.image = [UIImage imageNamed:@"cell_icon_bg.png"];
    }
    
    wineCell.textLabel.text = wine.name;
    wineCell.detailTextLabel.text = wine.wineCompanyName;
    
    //Devuelvo la celda
    return wineCell;
}

#pragma mark - Table view delegate

-(void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (nonnull NSIndexPath *)indexPath{
    
    FJLWineModel *wine = [self wineForIndexPath: indexPath];

        //Aviso al delegado
        [self.delegate wineryTableViewController: self
                                   didSelectWine: wine];
        
        //Envio la notificación
        NSNotification *n = [NSNotification notificationWithName: NEW_WINE_NOTIFICATION_NAME
                                                          object: self
                                                        userInfo: @{WINE_KEY: wine}];
        
        [[NSNotificationCenter defaultCenter] postNotification: n];
        
        [self saveLastSelectedWineAtSection: indexPath.section
                                        row: indexPath.row];
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Devuelvo el mismo tamaño que le he puesto al background
    return 72;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    //Devuelvo el tamaño de la imagen de la cabecera
    return 30;
}

-(UIView *) tableView: (UITableView *) tableView viewForHeaderInSection: (NSInteger) section{
    
    FJLWineModel *wine = [self wineForIndexPath:[NSIndexPath indexPathForRow: 0
                                                                   inSection: section]];
    
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake( 0, 0, self.tableView.frame.size.width, 30)];
    
    UIImageView *backgroundHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"sectionBackground.png"]];
    
    [headerView addSubview: backgroundHeader];
    
    UILabel *name = [[UILabel alloc] initWithFrame: CGRectMake(10, 0, self.tableView.frame.size.width - 10, 30)];
    
    name.font = [UIFont fontWithName: @"Valentina-Regular" size:20];
    name.textColor = [UIColor whiteColor];
    name.text = wine.type;
    name.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:name];
    
    return headerView;
}


    /*
    if (indexPath.section == RED_WINE_SECTION) {
        
        wine = [self.model redWineAtIndex: indexPath.row];
        
    }else if (indexPath.section == WHITE_WINE_SECTION){
        
        wine = [self.model whiteWineAtIndex: indexPath.row];
        
    }else{
        
        wine = [self.model otherWineAtIndex: indexPath.row];
        
    }
    
    //Lo quito porque he creado el delegado que voy a necesitar en el .h
    //Creo un controlador para dicho vino
    FJLWineViewController *wineVC = [[FJLWineViewController alloc] initWithModel:wine];
    
    
    //Hago un push al navigation controller dentro del cual estoy
     
    [self.navigationController pushViewController:wineVC
                                         animated:YES];
    
    [self.delegate wineryTableViewController:self
                               didSelectWine:wine];
    
    
    //Creo notificación
    NSNotification *n = [NSNotification notificationWithName: NEW_WINE_NOTIFICATION_NAME
                                                      object: self
                                                    userInfo: @{WINE_KEY: wine}];
    
    
    //Envio la notificación
    [[NSNotificationCenter defaultCenter] postNotification: n];
    
    
    //Guardo el último vino seleccionado
    [self saveLastSelectedWineAtSection:indexPath.section
                                    row:indexPath.row];
     
     */


#pragma mark - FJLWineryTableViewControllerDelegate

-(void)wineryTableViewController: (FJLWineryTableViewController *) wineryVC
                   didSelectWine: (FJLWineModel *)aWine{
    //Creo el controlador
    FJLWineViewController *wineVC = [[FJLWineViewController alloc] initWithModel:aWine];
    
    //Hago un push
    [self.navigationController pushViewController: wineVC
                                         animated: YES];
}

#pragma mark - Utils

-(FJLWineModel *) wineForIndexPath: (NSIndexPath *) indexPath{
    
    //Averiguo de que vino se tarta
    FJLWineModel *wine = nil;
    
    if (indexPath.section == RED_WINE_SECTION) {
        
        wine = [self.model redWineAtIndex: indexPath.row];
        
    }else if (indexPath.section == WHITE_WINE_SECTION){
        
        wine = [self.model whiteWineAtIndex: indexPath.row];
        
    }else if (indexPath.section == ROSE_WINE_SECTION){
        
        wine = [self.model roseWineAtIndex: indexPath.row];
        
    }else{
        
        wine = [self.model champagneWineAtIndex: indexPath.row];
        
    }
    
    return wine;
}


#pragma mark - NSUserDefaults


-(NSDictionary *)setDefaults{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Muestro por defecto el primer vino
    NSDictionary *defaultWine = @{SECTION_KEY: @(RED_WINE_SECTION), ROW_KEY: @0};
    
    //Asigno el primer vino
    [defaults setObject: defaultWine
                 forKey: LAST_WINE_KEY];

    //Lo guardo
    [defaults synchronize];
    
    return defaultWine;
    
}

-(void)saveLastSelectedWineAtSection: (NSUInteger)section row: (NSUInteger)row{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@{SECTION_KEY : @(section),
                          ROW_KEY : @(row)}
                 forKey: LAST_WINE_KEY];
    
    [defaults synchronize];
                          
                          
}

//Guardo el último vino seleccionado
-(FJLWineModel *) lastSelectedWine{
    
    NSIndexPath *indexPath = nil;
    NSDictionary *coords = nil;
    
    coords = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_WINE_KEY];
    
    if (coords == nil) {
        //Pongo el valor por defecto al no haber una interacción anterior
        coords = [self setDefaults];
    }else{
        //Ya hay algo, es decir, en algún momento se guardó.
        //No hay nada especial que hacer
    }
    
    //Transformo esas coordenadas en un indexPath
    indexPath = [NSIndexPath indexPathForRow:[[coords objectForKey:ROW_KEY] integerValue]
                                   inSection:[[coords objectForKey:SECTION_KEY] integerValue]];
    
    //Devuelvo el vino que se corresponde a las coordenadas
    return [self wineForIndexPath:indexPath];
    
    
    
}



@end
