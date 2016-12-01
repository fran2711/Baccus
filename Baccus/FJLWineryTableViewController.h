//
//  FJLWineryTableViewController.h
//  Baccus
//
//  Created by Fran Lucena on 07/01/16.
//  Copyright © 2016 Fran Lucena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJLWineryModel.h"

//Defino el número de las constantes
#define RED_WINE_SECTION 0
#define WHITE_WINE_SECTION 1
#define ROSE_WINE_SECTION 2
#define CHAMPAGNE_WINE_SECTION 3

#define NEW_WINE_NOTIFICATION_NAME @"newWine"
#define WINE_KEY @"wine"

#define SECTION_KEY @"section"
#define ROW_KEY @"row"
#define LAST_WINE_KEY @"lastWine"


//Poner @class delante es un Forward Declaration una clase adelantada, es decir, le estoy adelantando al controlador que esta clase se va a definir luego.
@class FJLWineryTableViewController;

//Creo el protocolo delegado para comunicar los MVC
@protocol FJLWineryTableViewControllerDelegate <NSObject>

-(void) wineryTableViewController: (FJLWineryTableViewController *) wineryVC
                    didSelectWine: (FJLWineModel *) aWine;


@end


@interface FJLWineryTableViewController : UITableViewController <FJLWineryTableViewControllerDelegate>


@property (strong, nonatomic) FJLWineryModel *model;

@property (weak, nonatomic) id<FJLWineryTableViewControllerDelegate> delegate;

//Inicializador designado
-(id) initWithModel: (FJLWineryModel *) aModel
              style:(UITableViewStyle) aStyle;

-(FJLWineModel *)lastSelectedWine;


@end


