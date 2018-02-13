

#import "MainViewController.h"
#import "ImageViewController.h"
#import "CameraViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

//回调函数，Called after the controller's view is loaded into memory.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Menu";
}


#pragma mark - Table view data source
//Asks the data source to return the number of sections in the table view.
//返回列表中总共该会有多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
    
//Tells the data source to return the number of rows in a given section of a table view.
//该方法返回值决定表格中指定分区应该包含多少个元素
//这里我只使用了一个分区，如果是需要多个分区的情况可以分别根据section来指定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

//最重要的部分，该方法的返回值决定各个表格行的控件
//The NSIndexPath class represents the path to a specific node in a tree of nested array collections.
//This path is known as an index path.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      //必备。为表格行分配一个静态字符串作为标识符，使用重用机制。如果是自定义表格且表格高度动态变化的话最好取消重用机制。
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewMenuCell"];
    // 自定义表格部分。如果只使用默认形式则只需要如下指定UITableViewCell格式，默认表格行的三个属性为textLabel、detailTextLabel、image
    // 分别对应UITableViewCell显示的标题、纤细的内容以及左边图标，如果使用自定义表格则指定相应的类进行初始化。
    if (cell == nil)
    {
        //Initializes a table cell with a style and a reuse identifier and returns it to the caller.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewMenuCell"];
        cell.textLabel.textColor = [UIColor blackColor];
        //UITableViewCellAccessoryDisclosureIndicator： The cell has an accessory control shaped like a chevron. And
        //this control indicates that tapping the cell triggers a push action. The control does not track touches.
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //根据表格行好indexPath.row对表格行内容进行设定
    switch ([indexPath row]) {
        case 0:
            cell.textLabel.text = @"Render Image Test";
            break;
        case 1:
            cell.textLabel.text = @"Render Camera Test";
            break;
        default:
            break;
    }
    
    return cell;
}
    
    
// 该返回值决定指定分区的页眉
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"XJGARSDK Demo" ;
    return title;
}
    
// 该返回值决定指定分区的页脚
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = @"=================================" ;
    return footer;  
}


#pragma mark - Table view delegate
//Tells the delegate that the specified row is now selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击图像例子时，初始化图像视图控制器，点击相机例子时，初始化相机视图控制器
    UIViewController* nextViewController = 0;
    switch ([indexPath row]) {
        case 0:
            NSLog(@"Render Image Test");
            nextViewController = [[ImageSampleViewController alloc] init];
            break;
        case 1:
            NSLog(@"Render Camera Test");
            nextViewController = [[CameraSampleViewController alloc] init];
            break;
        default:
            break;
    }
    
    if (nextViewController != 0)
        [self.navigationController pushViewController:nextViewController animated:YES];
}
@end
