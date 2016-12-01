//
//  FJLWineryModel.m
//  Baccus
//
//  Created by Fran Lucena on 07/01/16.
//  Copyright © 2016 Fran Lucena. All rights reserved.
//

#import "FJLWineryModel.h"

@interface FJLWineryModel()

@property (strong, nonatomic) NSMutableArray *redWines;
@property (strong, nonatomic) NSMutableArray *whiteWines;
@property (strong, nonatomic) NSMutableArray *roseWines;
@property (strong, nonatomic) NSMutableArray *champagneWines;

@end

@implementation FJLWineryModel

#pragma mark - Properties

- (NSUInteger)redWineCount
{
    return [self.redWines count];
}

- (NSUInteger)whiteWineCount
{
    return [self.whiteWines count];
}

- (NSUInteger)roseWineCount
{
    return [self.roseWines count];
}

- (NSUInteger)champagneWineCount
{
    return [self.champagneWines count];
}


#pragma mark - Init
-(id)init{
    
    if (self = [super init]) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://golang.bz/baccus/wines.json"]];
        NSURLResponse *response = [[NSURLResponse alloc] init];
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (data != nil) {
            // No ha habido error
            NSArray * JSONObjects = [NSJSONSerialization JSONObjectWithData: data
                                                                    options: kNilOptions
                                                                      error: &error];
            
            if (JSONObjects != nil) {
                // No ha habido error
                for(NSDictionary *dict in JSONObjects){
                    FJLWineModel *wine = [[FJLWineModel alloc] initWithDictionary: dict];
                    
                    // Añadimos al tipo adecuado
                    if (wine.type != nil) {
                     
                    if ([wine.type isEqualToString:RED_WINE_KEY]) {
                        if (!self.redWines) {
                            self.redWines = [NSMutableArray arrayWithObject:wine];
                        }
                        else {
                            [self.redWines addObject:wine];
                        }
                    }
                    else if ([wine.type isEqualToString:WHITE_WINE_KEY]) {
                        if (!self.whiteWines) {
                            self.whiteWines = [NSMutableArray arrayWithObject:wine];
                        }
                        else {
                            [self.whiteWines addObject:wine];
                        }                    }
                    else if ([wine.type isEqualToString:ROSE_WINE_KEY]) {
                        if (!self.roseWines) {
                            self.roseWines = [NSMutableArray arrayWithObject: wine];
                        }
                        else {
                            [self.roseWines addObject:wine];
                        }
                    }
                    else {
                        if (!self.champagneWines) {
                            self.champagneWines = [NSMutableArray arrayWithObject: wine];
                        }
                        else {
                            [self.champagneWines addObject: wine];
                        }
                    }
                }
                    
                }
                
            }else{
                // Se ha producido un error al parsear el JSON
                NSLog(@"Error al parsear JSON: %@", error.localizedDescription);
            
            }
        }else{
            // Error al descargar los datos del servidor
            NSLog(@"Error al descargar datos del servidor: %@", error.localizedDescription);
        }
    }
    return self;
}



#pragma mark - Other

- (FJLWineModel *)redWineAtIndex:(NSUInteger)index
{
    return [self.redWines objectAtIndex:index];
}

- (FJLWineModel *)whiteWineAtIndex:(NSUInteger)index
{
    return [self.whiteWines objectAtIndex:index];
}

- (FJLWineModel *)roseWineAtIndex:(NSUInteger)index
{
    return [self.roseWines objectAtIndex:index];
}

- (FJLWineModel *)champagneWineAtIndex:(NSUInteger)index
{
    return [self.champagneWines objectAtIndex:index];
}


@end
