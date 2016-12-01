//
//  FJLWebViewController.m
//  Baccus
//
//  Created by Fran Lucena on 28/12/15.
//  Copyright © 2015 Fran Lucena. All rights reserved.
//

#import "FJLWebViewController.h"
#import "FJLWineryTableViewController.h"

#define IS_IPHONE  UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone


@interface FJLWebViewController ()

@end

@implementation FJLWebViewController

#pragma mark -  Init

- (id)initWithModel:(FJLWineModel *) aModel
{
    if (self = [super initWithNibName: nil
                               bundle: nil]) {
        _model = aModel;
        self.title = aModel.wineCompanyName;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    // Se recomienda que en el iPhone la webView muestre toda
    // la página y que el usuario, si quiere, cambie el zoom
    // con el gesto de "pinch to zoom"
    if (IS_IPHONE) {
        
        self.browserView.scalesPageToFit = YES;
    }
    
    // Alta en notificaciones
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(modelDidChange:)
                                                 name: NEW_WINE_NOTIFICATION_NAME
                                               object: nil];
    
    
    
    [self syncViewToModel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    // Baja en notificaciones
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}




#pragma mark -  Notifications

- (void)modelDidChange:(NSNotification *) aNotification
{
    FJLWineModel *newWine = [aNotification.userInfo objectForKey: WINE_KEY];
    self.model = newWine;
    
    [self syncViewToModel];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad: (UIWebView *)webView
{
    [self.activityView setHidden: NO];
    [self.activityView startAnimating];
}

- (void)webViewDidFinishLoad: (UIWebView *)webView
{
    [self.activityView stopAnimating];
    [self.activityView setHidden: YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code != -999) {
        // El error -999 se da cuando lanzas una nueva petición
        // antes de que la actual haya terminado.
        // No tiene sentido molestar al usuario en ese caso.
        [self.activityView stopAnimating];
        [self.activityView setHidden: YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}


#pragma mark - Utils

- (void)syncViewToModel
{
    self.title = self.model.wineCompanyName;
    self.browserView.delegate = self;
    NSLog(@"%@", self.model.wineCompanyWeb);
    [self.browserView loadRequest:[NSURLRequest requestWithURL: self.model.wineCompanyWeb]];
}

@end