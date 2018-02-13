
#import "XJGARSDKResSelViewController.h"

@interface XJGARSDKResSelViewController ()

//@property用于定于类属性，nonatomic表示不给set方法加锁，
//strong 修饰的属性会在赋值时调用被指向对象的 retain 方法，导致其引用计数加1 。weak 则不会。
//另外还有个 unsafe_unretained，跟 weak 类似，区别是被指向对象消失时不会“自动“变成 nil 。
//
//顾名思义：strong属性指的是对这个对象强烈的占有！不管别人对它做过什么，反正你就是占有着！它对于你随叫随到。weak指的是对这个对象弱弱的保持着联系，每次使用的时候你弱弱的问它一句“还在吗”，如果没人回应（变成nil），就说明它已经离开你了（大概是被系统残忍的回收了吧）。
//
//作者：Pinned
//链接：https://www.zhihu.com/question/20350816/answer/22307399
//来源：知乎
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
//
//只要有任何strong 指向某个对象A，ARC就不会摧毁它（A）。
//而weak所指向的对象B，只要没有其他strong指向该对象（B），ARC会摧毁它（B）。
@property (nonatomic, strong) id<XJGARSDKChangeResDelegate> XJGARSDKChangeResDelegate;


@end



//实现
@implementation XJGARSDKResSelViewController


//0 滤镜选择，1贴纸选择
int g_actoinType =0;
//用委托进行初始化，
//只能在init方法中给self赋值，Xcode判断是否为init方法规则：方法返回id，并且名字以init+大写字母开头+其他  为准则。例如：- (id) initWithXXX;
- (instancetype)initWithSetXJGARSDKChangeResDelegate:(id <XJGARSDKChangeResDelegate>)delegate actionType:(int)actionType
{
    self = [super init];
    [self setXJGARSDKChangeResDelegate:delegate];
    g_actoinType = actionType;
    return self;
}

//视图加载时回调函数
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Resource Select List";
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
    return XJGARSDK_FILTER_TOTLALNUM;
}

//最重要的部分，该方法的返回值决定各个表格行的控件
//The NSIndexPath class represents the path to a specific node in a tree of nested array collections.
//This path is known as an index path.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //必备。为表格行分配一个静态字符串作为标识符，使用重用机制。如果是自定义表格且表格高度动态变化的话最好取消重用机制。
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResourceSelectListCell"];
    
    // 自定义表格部分。如果只使用默认形式则只需要如下指定UITableViewCell格式，默认表格行的三个属性为textLabel、detailTextLabel、image
    // 分别对应UITableViewCell显示的标题、纤细的内容以及左边图标，如果使用自定义表格则指定相应的类进行初始化。
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ResourceSelectListCell"];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    //通过索引号获取文本标签的名字
//    cell.textLabel.text = [XJGARSDKResInterface getFilterNameByFilterIdx:(XJGARSDKFilterType)[indexPath row]];
    if(g_actoinType == 0)
        cell.textLabel.text = [XJGARSDKResInterface getFilterNameByFilterIdx:(XJGARSDKFilterType)[indexPath row]];
    if(g_actoinType == 1)
        cell.textLabel.text = [XJGARSDKResInterface getStickerNameByStickerIdx:(XJGARSDKStickerType)[indexPath row]];
    return cell;
}

#pragma mark - Table view delegate
//当滤镜被选择时，调用滤镜选择回调函数
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_XJGARSDKChangeResDelegate)
    {
        if(g_actoinType == 0)
            [_XJGARSDKChangeResDelegate onFilterSelected:(XJGARSDKFilterType)[indexPath row]];
        if(g_actoinType == 1)
            [_XJGARSDKChangeResDelegate onStickerPaperSelected:(XJGARSDKStickerType)[indexPath row]];
    }
    
    [[self navigationController] popViewControllerAnimated:true];
}
@end
