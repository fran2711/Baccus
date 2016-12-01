//
//  FJLWineModel.h
//  Baccus
//
//  Created by Fran Lucena on 28/12/15.
//  Copyright © 2015 Fran Lucena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//Constante

#define NO_RATING -1
#define SAVE_PHOTO_KEY @"savePhoto"


@interface FJLWineModel : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic, readonly) UIImage *photo;
@property (strong, nonatomic) NSURL *photoURL;
@property (strong, nonatomic) NSURL *wineCompanyWeb;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSString *origin;
@property (nonatomic) int rating;
@property (strong, nonatomic) NSArray *grapes;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *wineCompanyName;

//Métodos de Clase
+(id) wineWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineryName
              type: (NSString *) aType
            origin: (NSString *) anOrigin
            grapes: (NSArray *) arrayOfGrapes
    wineCompanyWeb: (NSURL *) aURL
             notes: (NSString *) aNotes
            rating: (int) aRating
          photoURL: (NSURL *) aPhotoURL;


+(id) wineWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineryName
              type: (NSString *) aType
            origin: (NSString *) anOrigin;


//Inicializador Designado
-(id) initWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineryName
              type: (NSString *) aType
            origin: (NSString *) anOrigin
            grapes: (NSArray *) arrayOfGrapes
    wineCompanyWeb: (NSURL *) aURL
             notes: (NSString *) aNotes
            rating: (int) aRating
          photoURL: (NSURL *) aPhotoURL;

//Inicializador de Conveniencia
-(id) initWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineryName
              type: (NSString *) aType
            origin: (NSString *) anOrigin;

//Inicializador a partir de diccionario JSON
-(id) initWithDictionary: (NSDictionary *) aDict;



@end
