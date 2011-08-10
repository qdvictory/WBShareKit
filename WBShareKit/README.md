1，WBShareKey.h中修改配置信息
2.app delegate中添加
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[WBShareKit mainShare] handleOpenURL:url];   
    return YES;
}
3.具体调用请查看WBShareKitViewController.m