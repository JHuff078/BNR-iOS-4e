//
//  BNRAppDelegate.m
//  iTahDoodle
//
//  Created by Julian Huff on 2014-04-13.
//  Copyright (c) 2014 Huff. All rights reserved.
//

#import "BNRAppDelegate.h"

//Helper function to fetch the path to our to-do data stored on disk
NSString *BNRDocPath() {
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [pathList[0] stringByAppendingPathComponent:@"data.td"];
}

@implementation BNRAppDelegate

#pragma mark - Application deligate callbacks

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Load an exisiting dataset or create a new one
    NSArray *plist = [NSArray arrayWithContentsOfFile:BNRDocPath()];
    if (plist) {
        //We have a dataset; copy it into tasks
        self.tasks = [plist mutableCopy];
    } else {
        //There is no dataset; create a new one
        self.tasks = [NSMutableArray array];
    }
    
    //Create and configue the UIWindow instance
    //A CGRect is a struct with an orgin (x, y) and a size (width, hiehgt)
    CGRect winFrame = [[UIScreen mainScreen] bounds];
    UIWindow *theWindow = [[UIWindow alloc] initWithFrame:winFrame];
    self.window = theWindow;
    
    //Define the frame rectangles of the three UI elements
    //CGRectMake() creates a CRect from (x, y, width, height)
    CGRect tableFrame = CGRectMake(0, 80, winFrame.size.width, winFrame.size.height - 100);
    CGRect fieldFrame = CGRectMake(20, 40, 200, 31);
    CGRect buttonFrame = CGRectMake(228, 40, 72, 31);
    
    //Create and configure the UITableView instance
    self.taskTable = [[UITableView alloc] initWithFrame:tableFrame
                                                  style:UITableViewStylePlain];
    self.taskTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Make the BNRAppDelegate the table view's dataSource
    self.taskTable.dataSource = self;
    
    //Tell the table view which class to instantiate whenever it needs to create a new cell
    [self.taskTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    //Create and configure the UITExtField instance where new tsks will be entered
    self.taskField = [[UITextField alloc] initWithFrame:fieldFrame];
    self.taskField.borderStyle = UITextBorderStyleRoundedRect;
    self.taskField.placeholder = @"Type a task, tap Insert";
    
    //Create and configure the UIButton instance
    self.insertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.insertButton.frame = buttonFrame;
    
    //Give the button a title
    [self.insertButton setTitle:@"Insert"
                       forState:UIControlStateNormal];
    
    //Set the target and action for the Insert button
    [self.insertButton addTarget:self
                          action:@selector(addTask:)
                forControlEvents:UIControlEventTouchUpInside];
    
    //Add our three UI elements to the window
    [self.window addSubview:self.taskTable];
    [self.window addSubview:self.taskField];
    [self.window addSubview:self.insertButton];

    //Finalize the window and put it on the scree
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //Save our tasks array to disk
    [self.tasks writeToFile:BNRDocPath()
                 atomically:YES];
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

#pragma mark - Actions

- (void)addTask:(id)sender {
    //Get the task
    NSString *text = [self.taskField text];
    
    //Quit here if taskField is empty
    if ([text length] ==0) {
        return;
    }
    
    //Add it to the working array
    [self.tasks addObject:text];
    
    //Refresh the table tso that the new item shows up
    [self.taskTable reloadData];
    
    //Clear out the text field
    [self.taskField setText:@""];
    
    //Dismiss the keyboard
    [self.taskField resignFirstResponder];
}

#pragma mark - Table view management

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Because this table view only hase one section, the number of rows in it is equal to the number of items in the tasks array
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //To improve performance, this mehod first chechks for an existing cell object that we can reuse.
    //If there isn't one, then a new cell is created
    UITableViewCell *c = [self.taskTable dequeueReusableCellWithIdentifier:@"Cell"];
    
    //Then we (re)configure the vell based on themodel object, in this case the tasks array, …
    NSString *item = [self.tasks objectAtIndex:indexPath.row];
    c.textLabel.text = item;
    
    //… and hand the properly configured cell back to the table view
    return c;
}
@end
