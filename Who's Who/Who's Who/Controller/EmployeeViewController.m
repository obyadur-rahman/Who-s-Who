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

@interface EmployeeViewController ()
{
    NSMutableArray *_employees;
}
@property (weak, nonatomic) IBOutlet UITableView *employeeTableView;
@end


@implementation EmployeeViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadEmployees];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    Employee *emp = (Employee *)_employees[indexPath.row];
    cell.textLabel.text = emp.name;
    cell.detailTextLabel.text = emp.title;
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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


@end
