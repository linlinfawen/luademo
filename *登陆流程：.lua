 *登陆流程：
 *(如果流程改动了，请更新下这里)
 *init：界面初始化
 *onEnter：注册事件监听
 *selectLogin：zm版本是自动登陆，hy版本会调用sdk等待用户手动登陆
 *sendCmdGetServerList：通过url,请求服务器列表
 *onGetServerList:获取到服务器列表，zm版本自动选择服务器，hy版本需要玩家手动选择
 *doLogin:
 *  getEUInfo:欧盟玩家验证
 *  sendCmdCheckUpdateInfo：检查是否版本更新（目前没用上）
 *  sendCmdGetNoticeInfo：请求游戏公告
 *  sendCmdLogin:
 *      hotUpdateStartupRes:请求热更新地址，并且更新启动资源
 *          LuaHelper::initLua:热更新完才会初始化lua框架
 *      LoginCommand:发送登陆命令
 *      CCCommonUtils::initOperation:登陆后服务器，会推送init消息，初始化游戏，并发送MSG_INIT_FINISH事件
 *hotUpdateAfterLoginRes：登陆后，根据玩家数据，选择下载指定资源
 *stepLoading：开始走进度条，没有什么实质性的操作
 *gotoScene(SCENE_ID_MAIN)：进度条满了，进入主城