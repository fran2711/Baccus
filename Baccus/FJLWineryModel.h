//
//  FJLWineryModel.h
//  Baccus
//
//  Created by Fran Lucena on 07/01/16.
//  Copyright © 2016 Fran Lucena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FJLWineModel.h"

#define RED_WINE_KEY    @"Tinto"
#define WHITE_WINE_KEY  @"Blanco"
#define ROSE_WINE_KEY  @"Rosado"
#define CHAMPAGNE_WINE_KEY @"Cava"

@interface FJLWineryModel : NSObject

@property (readonly, nonatomic) NSUInteger redWineCount; //Utilizo Count al final del nombre porque es la convención de nomenclatura de Cocoa para que en un NSArray saber cuantos objetos tiene.

@property (readonly, nonatomic) NSUInteger whiteWineCount;
@property (readonly, nonatomic) NSUInteger roseWineCount;
@property (readonly, nonatomic) NSUInteger champagneWineCount;

-(FJLWineModel *) redWineAtIndex: (NSUInteger) index;
-(FJLWineModel *) whiteWineAtIndex: (NSUInteger) index;
-(FJLWineModel *) roseWineAtIndex: (NSUInteger) index;
-(FJLWineModel *) champagneWineAtIndex: (NSUInteger) index;



@end
