//
//  EmployeeViewController.m
//  Who's Who
//
//  Created by Obyadur Rahman on 3/9/14.
//  Copyright (c) 2014 Sky World Inc. All rights reserved.
//

#import "EmployeeViewController.h"
#import "TFHpple.h"
#import "Employee.h"
#import "EmployeeCell.h"
#import "ImageDownloader.h"
#import "Helper.h"

@interface EmployeeViewController ()
{
    NSMutableArray *_employees;
    BOOL isOnlineMode;
}

// the set of IconDownloader objects for each app
//
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (weak, nonatomic) IBOutlet UITableView *employeeTableView;

// refresh button action
//
- (IBAction)refreshEmployees:(id)sender;

@end


@implementation EmployeeViewController

// Get from EmployeeCell.xib
#define kRowHeight 210

// HTML/XML feed URL
NSString *const SERVER_URL = @"http://www.theappbusiness.com/our-team/";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark-
#pragma mark- View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterforeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterbackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    // Clear tableview seperator color
    //
    self.employeeTableView.separatorColor = [UIColor clearColor];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    _employees = [[NSMutableArray alloc] init];
    isOnlineMode = NO;
    
    // get list of employess from server
    [self loadEmployeeListFromServer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark-
#pragma mark- UIApplication Notification

- (void)applicationDidEnterforeground:(NSNotification *)notification
{
    [self loadEmployeeListFromServer];
}

- (void)applicationDidEnterbackground:(NSNotification *)notification
{
    if (isOnlineMode)
    {
        [Helper saveEmployeeData:_employees]; // save locally for later use
    }
}

#pragma mark-
#pragma mark- Refresh Employees

- (IBAction)refreshEmployees:(id)sender
{
    [self loadEmployeeListFromServer];
}


#pragma mark-
#pragma mark- UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_employees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"EmployeeCell";
    
    EmployeeCell *cell = (EmployeeCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmployeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell configCell];
    }
    
    
    Employee *emp = (Employee *)_employees[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@" %@\n\n",emp.name];
    cell.titleLabel.text = [NSString stringWithFormat:@" %@",emp.title];
    cell.biographyTextView.text = emp.biography;
    cell.photoUrlTextView.text = emp.photoUrl;
    
    // Only load cached images; defer new downloads until scrolling ends
    if (!emp.profileImage)
    {
        if (self.employeeTableView.dragging == NO && self.employeeTableView.decelerating == NO)
        {
            [self startImageDownload:emp forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        if (isOnlineMode) {
            cell.profileImageView.image = [UIImage imageNamed:@"loading.png"];
        }
        else {
            cell.profileImageView.image = [UIImage imageNamed:@"offline.png"];
        }
    }
    else
    {
        cell.profileImageView.image = emp.profileImage;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startImageDownload:
// -------------------------------------------------------------------------------
- (void)startImageDownload:(Employee *)employeeRecord forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil)
    {
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.employee = employeeRecord;
        [imageDownloader setCompletionHandler:^{
            
            EmployeeCell *cell = (EmployeeCell *)[self.employeeTableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.profileImageView.image = employeeRecord.profileImage;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their employee icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if ([_employees count] > 0)
    {
        NSArray *visiblePaths = [self.employeeTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Employee *empRecord = [_employees objectAtIndex:indexPath.row];
            
            if (!empRecord.profileImage)
                // Avoid the employee image download if the employee already has an image
            {
                [self startImageDownload:empRecord forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark - Load Employees

- (void)loadEmployeeListFromServer
{
    if ([Helper isConnectionAvailable])
    {
        isOnlineMode = YES;
        [self loadEmployees];
    }
    else
    {
        isOnlineMode = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Do you like to load previous contents?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag =  999; // custom tag
        [alert show];
        
    }
}

// -------------------------------------------------------------------------------
//	loadEmployees
// -------------------------------------------------------------------------------
- (void)loadEmployees
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *employeesUrl = [NSURL URLWithString:SERVER_URL];
        NSData *employeesHtmlData = [NSData dataWithContentsOfURL:employeesUrl];
        
        TFHpple *employeesParser = [TFHpple hppleWithHTMLData:employeesHtmlData];
        
        NSString *employeesXpathQueryString = @"//section[@id='users']/div[@class='wrapper']/div[@class='row']/div[@class='col col2']";
        NSArray *employeeNodes = [employeesParser searchWithXPathQuery:employeesXpathQueryString];
        
        NSMutableArray *employees = [[NSMutableArray alloc] init];
        for (TFHppleElement *employeeElement in employeeNodes) {
            
            if ([employeeElement children].count != 0 && [employeeElement children].count >=4)
            {
                @autoreleasepool {
                    Employee *employee = [[Employee alloc] init];
                    [employees addObject:employee];
                    
                    TFHppleElement *nameElement = [[employeeElement children] objectAtIndex:1];
                    NSString *nameTag = [[nameElement children][0] content];
                    employee.name =  (nameTag)?nameTag:@"";
                    
                    TFHppleElement *titleElement = [[employeeElement children] objectAtIndex:2];
                    NSString *titleTag = [[titleElement children][0] content];
                    employee.title = (titleTag)?titleTag:@"";
                    
                    TFHppleElement *biographyElement = [[employeeElement children] objectAtIndex:3];
                    NSString *biographyTag = [[biographyElement children][0] content];
                    employee.biography = (biographyTag)?biographyTag:@"";
                    
                    TFHppleElement *photoUrlDiv = [[employeeElement children] objectAtIndex:0];
                    TFHppleElement *photoUrlElement = [[photoUrlDiv children] objectAtIndex:0];
                    NSString *photoUrlTag = [photoUrlElement objectForKey:@"src"];
                    employee.photoUrl = (photoUrlTag)?photoUrlTag:@"";
                }
            }
        }
        
        // Update UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            _employees = employees;
            [self.employeeTableView reloadData];
        });
    });
}

#pragma mark-
#pragma mark- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Ok button pressed
    // load employess from local file
    //
    if (buttonIndex == 0 && alertView.tag == 999)
    {
        _employees = [Helper getEmployeeData];
        [self.employeeTableView reloadData];
    }
}

@end
