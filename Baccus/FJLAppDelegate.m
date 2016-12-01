//
//  AppDelegate.m
//  Baccus
//
//  Created by Fran Lucena on 28/12/15.
//  Copyright © 2015 Fran Lucena. All rights reserved.
//

#import "FJLAppDelegate.h"
#import "FJLWineViewController.h"
#import "FJLWineryModel.h"
#import "FJLWineryTableViewController.h"

#define IS_IPHONE  UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone


@implementation FJLAppDelegate
- (void)customiseAppeareance
{
    UIColor *oldBurgundy = [UIColor colorWithRed:0.26
                                           green:0.19
                                            blue:0.18
                                           alpha:1.0];
    
    if (IS_IPHONE) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBackgroundPortrait.png"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBackgroundLandscape.png"] forBarMetrics:UIBarMetricsCompact];
    }
    else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBackgroundPortraitiPad.png"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBackgroundLandscapeiPad.png"] forBarMetrics:UIBarMetricsCompact];
    }
    
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [shadow setShadowOffset: CGSizeMake(0.0f, 1.0f)];
    
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSShadowAttributeName: shadow,
                                                           NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:20]}];
    
    
    
    
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSShadowAttributeName: shadow,
                                                           NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:12]} forState:UIControlStateNormal];
    
    // Color de los separadores de sección en las las tablas
    [[UITableViewHeaderFooterView appearance] setTintColor:oldBurgundy];
    
    // Botón de hacia atrás con la Elasticina del Profesor Saturnino Bacterio
    UIImage *backBtn = [UIImage imageNamed:@"backBtn"];
    backBtn = [backBtn resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBtn
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
}

- (UIViewController *)rootViewControllerForPhoneWithModel
{
    // Controladores
    FJLWineryTableViewController *wineryVC = [[FJLWineryTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Combinador
    UINavigationController *wineryNav = [[UINavigationController alloc] initWithRootViewController:wineryVC];
    
    // Delegados
    wineryVC.delegate = wineryVC;
    
    return wineryNav;
}

- (UIViewController *)rootViewControllerForPadWithModel
{
    // Controladores
    FJLWineryTableViewController *wineryVC = [[FJLWineryTableViewController alloc] initWithStyle:UITableViewStylePlain];
    FJLWineViewController *wineVC = [[FJLWineViewController alloc] initWithModel:[wineryVC lastSelectedWine]];
    
    // Combinadores
    UINavigationController *wineNav = [[UINavigationController alloc] initWithRootViewController:wineVC];
    UINavigationController *wineryNav = [[UINavigationController alloc] initWithRootViewController:wineryVC];
    
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    splitVC.viewControllers = @[wineryNav, wineNav];
    
    
    // Delegados
    splitVC.delegate = wineVC;
    wineryVC.delegate = wineVC;
    
    return splitVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Configuramos aspecto gráfico
    [self customiseAppeareance];
    
    // No cargamos el modelo aqui ya que al hacerlo de forma sincrona nos bloquea la interfaz y no hay nada cargado
    
    // Configuramos controladores, combinadores y delegados según
    // el tipo de dispositivo
    UIViewController *rootVC = nil;
    if (!IS_IPHONE) {
        // Tableta
        rootVC = [self rootViewControllerForPadWithModel];
    }
    else {
        rootVC = [self rootViewControllerForPhoneWithModel];
    }
    self.window.rootViewController = rootVC;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
