//
//  FJLWineViewController.m
//  Baccus
//
//  Created by Fran Lucena on 28/12/15.
//  Copyright © 2015 Fran Lucena. All rights reserved.
//

#import "FJLWineViewController.h"
#import "FJLWebViewController.h"

#define kCustomFontHeader           [UIFont fontWithName:@"Valentina-Regular" size:17]
#define kCustomFontSubheader        [UIFont fontWithName:@"Valentina-Regular" size:15]
#define kCustomFontRegular          [UIFont fontWithName:@"Valentina-Regular" size:12]

#define IS_IPHONE  UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone

@implementation FJLWineViewController

#pragma mark - Init

-(id) initWithModel: (FJLWineModel *) aModel{
    
    //Cargo un xib u otro según el dispositivo
    NSString *nibName = nil;
    if (IS_IPHONE) {
        nibName = @"FJLWineViewControlleriPhone";
    }
    
    if (self = [super initWithNibName:nibName bundle:nil]) {
        _model = aModel;
        self.title = aModel.name;
    }
    return self;
}

#pragma mark - View Lifecycle

-(void)viewDidLoad{
    
    self.nameLabel.font = kCustomFontHeader;
    self.wineryNameLabel.font = kCustomFontSubheader;
    self.typeLabel.font = kCustomFontSubheader;
    self.originLabel.font = kCustomFontSubheader;
    self.grapesLabel.font = kCustomFontSubheader;
    self.notesView.font = kCustomFontRegular;


}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self syncModelWithView];
    
    
    //Si estoy en landscape, añado la vista que tengo para landscape
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        [self addPortraitViewWithProperFrame];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation)) {
        // Estoy en portrait
        [self.portraitView removeFromSuperview];
    }
    else {
        // Estoy en landscape
        [self addPortraitViewWithProperFrame];
    }
}

- (void)addPortraitViewWithProperFrame
{
    //Asigno el frame a la vista en portrait para que se redimensione
    //si la añado directamente como view, al no estar dentro de un VC, no se va a redimensionar
    CGRect iPhoneScreen = [[UIScreen mainScreen] bounds];
    CGRect portraitRect = CGRectMake(0, 0, iPhoneScreen.size.height, iPhoneScreen.size.width);
    self.portraitView.frame = portraitRect;
    [self.view addSubview:self.portraitView];
}


#pragma mark - Actions

-(IBAction)displayWebpage:(id)sender{
    
   /* //Hay que poner model antes de wineCompanyWeb porque parte de un modelo
    NSLog(@"Go to %@", self.model.wineCompanyWeb);*/
    
    
    //Creo un webVC
    FJLWebViewController *webVC = [[FJLWebViewController alloc] initWithModel:self.model];
    
    //Hago un push
    [self.navigationController pushViewController: webVC
                                         animated: YES];
}


//Creo un webVC y hago un push

#pragma mark - Utils
//No hace falta definirlo en el .h para que funcione, al estar en el .m lo puedo utilizar pero no estará visible desde fuera, esto se hace para utilidades y detalles de implementación
-(void)syncModelWithView{
    
    //Landscape
    self.nameLabel.text = self.model.name;
    self.typeLabel.text = self.model.type;
    self.originLabel.text = self.model.origin;
    self.wineryNameLabel.text = self.model.wineCompanyName;
    self.notesView.text = self.model.notes;
    self.photoView.image = self.model.photo;
    self.grapesLabel.text = [self arrayToString: self.model.grapes]; //Esto es porque grapesLabel es un array de strings
    
    // portrait
    self.nameLabelPortrait.text = self.model.name;
    self.typeLabelPortrait.text = self.model.type;
    self.originLabelPortrait.text = self.model.origin;
    self.wineryNameLabelPortrait.text = self.model.wineCompanyName;
    self.notesViewPortrait.text = self.model.notes;
    self.photoViewPortrait.image = self.model.photo;
    self.grapesLabelPortrait.text = [self arrayToString:self.model.grapes];
    
    [self displayRating: self.model.rating];//Sirve para el array del rating de los vinos
    
    NSLog(@"web: %@", self.model.wineCompanyWeb);
    
    if (self.model.wineCompanyWeb == nil) {
        self.webButton.enabled = NO;
    }else{
        self.webButton.enabled = YES;
    }
    
    self.title = self.model.name;
    
    //Ajusto los labels según su tamaño o reduzco la fuente para que valga tanto para iPhone como para iPad
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.wineryNameLabel.adjustsFontSizeToFitWidth = YES;
    self.typeLabel.adjustsFontSizeToFitWidth = YES;
    self.originLabel.adjustsFontSizeToFitWidth = YES;
    [self.grapesLabel sizeToFit];
    
    //Como las uvas pueden tener un tamaño bastante variable (ajustado mediante sizeToFit)
    //necesito bastante espacio para las notas subo el el frame de la nota
    //lo hago solo en iPhone por las restricciones de tamaño
    if (IS_IPHONE) {
        CGRect newFrame = self.notesView.frame;
        CGFloat offset = newFrame.origin.y - (self.grapesLabel.frame.origin.y + self.grapesLabel.frame.size.height + 10);
        newFrame.origin.y = self.grapesLabel.frame.origin.y + self.grapesLabel.frame.size.height + 10;
        newFrame.size.height += fabs(offset);
        self.notesView.frame = newFrame;
    }

}


//Metodo para limpiar el rating de vinos
-(void) clearRatings{
    
    for (UIImageView *imgView in self.ratingViews) {
        imgView.image = nil;
    }
}


//Implemento la utilidad del array del rating de los vinos
-(void) displayRating: (int) aRating{
    [self clearRatings];
    
    UIImage *glass = [UIImage imageNamed:@"copa_cell.png"];
    
    //Este for sirve para ir aumentando el número de copas llenas según sea el rating
    for (int i=0; i < aRating; i++) {
        [[self.ratingViews objectAtIndex:i] setImage: glass];
        [[self.ratingViewsPortrait objectAtIndex:i] setImage: glass];
    }
    
}

//Implemento la utilidad del array de strings
-(NSString *) arrayToString: (NSArray *) anArray{
    
    NSString *repr;
    
    if ([anArray count] == 1 ) { //Esto para que si hay vinos con un solo tipo de uva de un string predefinido
        repr = [@"100% " stringByAppendingString:[anArray lastObject]]; //Aquí lo que hace es devolver dos arrays y el segundo esta compuesto del ultimo string
    }else{
        //Dentro de else voy a poner el caso de que halla más de un tipo de uva
        repr = [[anArray componentsJoinedByString:@", "] stringByAppendingString:@"."];
    }
    
    return repr;
    
}
    

#pragma mark - UISplitViewControllerDelegate

-(void) splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc{
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

-(void) splitViewController:(UISplitViewController *) svc
     willShowViewController:(UIViewController *) aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *) barButtonItem{
    
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - WineryTableViewControllerDelegate

-(void) wineryTableViewController:(FJLWineryTableViewController *) aWineryVC
                    didSelectWine:(FJLWineModel *) aWine{
    
    self.model = aWine;
    self.title = aWine.name;
    [self syncModelWithView];
}


@end
