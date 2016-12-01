//
//  FJLWineModel.m
//  Baccus
//
//  Created by Fran Lucena on 28/12/15.
//  Copyright © 2015 Fran Lucena. All rights reserved.
//

#import "FJLWineModel.h"


@implementation FJLWineModel

@synthesize photo = _photo;

#pragma mark - Propiedades

//Getter personalizado
-(UIImage *) photo{
    //Esto va a bloquear la app durante unos segundos para descargar las imagenes porque debería hacerlo en segundo plano, lo vere más adelante.
    //Cargo solo la imagen si hace falta.
    if(_photo == nil){
        _photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
    }
    
    return _photo;
    
}


#pragma mark - Class Methods

//Constructores de Conveniencia o Metodos de Clase
+(id) wineWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineryName
              type: (NSString *) aType
            origin: (NSString *) anOrigin
            grapes: (NSArray *) arrayOfGrapes
    wineCompanyWeb: (NSURL *) aURL
             notes: (NSString *) aNotes
            rating: (int) aRating
          photoURL: (NSURL *) aPhotoURL{
    
    return [[self alloc] initWithName: aName
                      wineCompanyName: aWineryName
                                 type: aType
                               origin: anOrigin
                               grapes: arrayOfGrapes
                       wineCompanyWeb: aURL
                                notes: aNotes
                               rating: aRating
                             photoURL: aPhotoURL];
    
}

+(id) wineWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineryName
              type: (NSString *) aType
            origin: (NSString *) anOrigin{
    
    return [[self alloc] initWithName: aName
                      wineCompanyName: aWineryName
                                 type: aType
                               origin: anOrigin];
    
}

#pragma mark - JSON

//Con esto recibo los datos JSON y se lo paso al inicializador
-(id) initWithDictionary:(NSDictionary *)aDict{
    
    return [self initWithName: [aDict objectForKey:@"name"]
              wineCompanyName: [aDict objectForKey:@"company"]
                         type: [aDict objectForKey:@"type"]
                       origin: [aDict objectForKey:@"origin"]
                       grapes: [self extractGrapesFromJSONArray: [aDict objectForKey:@"grapes"]]
               wineCompanyWeb: [NSURL URLWithString:[aDict objectForKey:@"wine_web"]]
                        notes: [aDict objectForKey:@"notes"]
                       rating: [[aDict objectForKey:@"name"] intValue]
                     photoURL: [NSURL URLWithString:[aDict objectForKey:@"picture"]]];
}


-(NSDictionary *)proxyForJSON{
    
    return @{@"name" : self.name,
             @"wineCompanyName" : self.wineCompanyName,
             @"wineCompanyWeb" : [self.wineCompanyWeb path],
             @"type" : self.type,
             @"origin" : self.origin,
             @"grapes" : self.grapes,
             @"notes" : self.notes,
             @"rating" : @(self.rating),
             @"photo" : [self.photoURL path]};
    
}

#pragma mark - Init

//Inicializador Designado

-(id) initWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineryName
              type: (NSString *) aType
            origin: (NSString *) anOrigin
            grapes: (NSArray *) arrayOfGrapes
    wineCompanyWeb: (NSURL *) aURL
             notes: (NSString *) aNotes
            rating: (int) aRating
          photoURL: (NSURL *)aPhotoURL{
    
    
    if (self = [super init]) {
        //Asigno los parametros a las variables de instancia
        _name = aName;
        _wineCompanyName = aWineryName;
        _type = aType;
        _origin = anOrigin;
        _grapes = arrayOfGrapes;
        _wineCompanyWeb = aURL;
        _notes = aNotes;
        _rating = aRating;
        _photoURL = aPhotoURL;
    }
    
    return self;
}

//Inicializador Conveniencia

-(id) initWithName: (NSString *) aName
   wineCompanyName: (NSString *) aWineCompanyName
              type: (NSString *) aType
            origin: (NSString *) anOrigin{
    
    return [self initWithName: aName
              wineCompanyName: aWineCompanyName
                         type: aType
                       origin: anOrigin
                       grapes: nil
               wineCompanyWeb: nil
                        notes: nil
                       rating: NO_RATING
                     photoURL: nil];
}

-(NSString *) description{
    
    return [NSString stringWithFormat:@"Name: %@\nCompany name: %@\nType: %@\nOrigin: %@\nGrapes: %@\nCompany web: %@\nNotes: %@\nRating: %d\n", self.name, self.wineCompanyName, self.type, self.origin, self.grapes, self.wineCompanyWeb, self.notes, self.rating];
}

#pragma mark - Utils
//Metodo para extraer Grapes del JSON Array
-(NSArray*)extractGrapesFromJSONArray: (NSArray*)JSONArray{
    
    NSMutableArray *grapes = [NSMutableArray arrayWithCapacity:[JSONArray count]];
    
    for (NSDictionary *dict in JSONArray) {
        [grapes addObject:[dict objectForKey:@"grape"]];
    }
    
    return grapes;
}

-(NSArray *)packGrapesIntoJSONArray{
    
    NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:[self.grapes count]];
    
    for (NSString *grape in self.grapes) {
        
        [jsonArray addObject:@{@"grape": grape}];
    }
    
    return jsonArray;
    
}


@end
