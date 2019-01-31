unit GSProto;

interface

const
  //后台管理中心---客户端
  CM_REGIST_SERVER_RET  = 1000; //发送连接请求
  CM_RELOADDATALL       = 1001; //重新加载全部数据
  CM_RELOADNPC          = 1002; //重新加载NPC
  CM_RELOAD_FUNCTION    = 1003;
  CM_REFRESHCORSS       = 1004; //刷新跨服配置
  CM_RELOADCONFIG       = 1005; //刷新引擎配置
  CM_RELOADLANG         = 1006; //刷新语言包
  CM_IW_PAYALL          = 1007; //平台数据汇总
  //后台管理中心---服务端
  SM_REGIST_SERVER      = 2000; //服务端返回连接请求
  SM_RELOADDATALL       = 2001; //重新加载全部数据 后台列表信息
  SM_RELOADNPC          = 2002; //重新加载NPC
  SM_RELOAD_FUNCTION    = 2003; //刷新功能脚本
  SM_REFRESHCORSS       = 2004; //刷新跨服配置
  SM_RELOADCONFIG       = 2005; //刷新引擎配置
  SM_RELOADLANG         = 2006; //刷新语言包
  SM_IW_PAYALL          = 1007; //平台数据汇总

  //后台与逻辑通讯-----------------------------------
  MSS_REGIST_SERVER_RET = 10000; //回应注册服务器结果(tag为0表示成功)
  MSS_KEEP_ALIVE        = 10001; //保持连接
  MSS_RELOADNPC         = 10002; //刷新NPC(数据段为Encode(地图名称 + \n + NPC名称))
  MSS_RELOADNOTICE      = 10003; //刷新公告
  MSS_KICKPLAY          = 10004; //踢角色下线（数据段为编码后的角色名称）
  MSS_KICKUSER          = 10005; //踢账号下线（数据段为编码后的账号字符串）
  MSS_QUERYPLAYONLINE   = 10006; //查询角色是否在线（数据段为编码后的角色名称）
  MSS_QUERYUSERONLINE   = 10007; //查询账号是否在线（数据段为编码后的账号字符串）
  MSS_ADDNOTICE         = 10008; //添加公告
  MSS_DELNOTICE         = 10009; //删除公告
  MSS_DELAY_UPHOLE      = 10010; //进入倒计时维护状态(param=倒计时秒数)
  MSS_CANLCE_UPHOLE     = 10011; //取消倒计时维护状态
  MSS_SET_EXPRATE       = 10012; //设置经验倍率(param为倍率，1表示1倍，2表示2倍)
  MSS_SHUTUP            = 10013; //禁言(Param = 时间, 单位是分钟,数据段为编码后的角色名称)
  MSS_RELEASESHUTUP     = 10014; //解禁言（数据段为编码后的角色名称）
  MSS_RELOAD_FUNCTION   = 10015; //刷新功能脚本
  MSS_APPLY_ACROSS_SERVER_RET = 10016;//后台返回的申请跨服结果  Tag = 0 为成功, 1 为失败  数据段为:  申请的角色名
  MSS_GET_ARENA_SCORE_RANK    = 10017; //后台引擎请求获取擂台积分排行榜
  MSS_RELOAD_LOGIN_SCRIPT     = 10018; //后台重新加载登陆脚本
  MSS_RELOAD_ROBOTNPC         = 10019; //后台重新加载机器人脚本
  MSS_RELOAD_SHOP             = 10020; //后台重新加载商城物品
  MSS_GET_CURR_PROCESS_MEM_USED  = 10021; //获取引擎当前的内存使用量(接近2G处于危险状态,即容易崩溃)
  MSS_ADD_PLAYER_RESULTPOINT     = 10022; //增加玩家的返点数(绑定元宝),Recog为绑定元宝数值, 可以是正负,当为负数时就是减少玩家的绑定元宝, 数据段为角色名称.
  MSS_RELOAD_ABUSEINFORMATION    = 10023; //重新加载文字发言过滤信息库
  MSS_RELOAD_MONSTER_SCRIPT      = 10024; //重新加载怪物脚本（数据段为编码后的角色名称)
  MSS_OPEN_GAMBLE                = 10025; //开启赌博系统
  MSS_CLOSE_GAMBLE               = 10026; //关闭赌博系统
  MSS_OPEN_COMMONSERVER  = 10027; //开启跨服
  MSS_CLOSE_COMMONSERVER = 10028; //关闭跨服
  MSS_SEND_OFFMSGTOACOTOR	 = 10029;	//后台给玩家直接发送离线消息  数据段为(角色名称 + \n +回复的消息内容)：
	MSS_OPEN_COMPENSATE		 = 10030;	//后台开启补偿 数据段为：(param为补偿方案ID Tag表示补偿时间(分钟))
	MSS_CLOSE_COMPENSATE	 = 10031;	//后台关闭补偿 数据段为：(补偿方案ID)
  MSS_ADD_FILTERWORDS		 = 10032;	//后台添加屏蔽字 (Param = 0 为增加 1为删除 Tag = 1 添加发言的屏蔽字 2 添加创建角色的屏蔽字）
  MSS_SET_DROPRATE		   = 10033;	//后台设置红白名掉落概率 param:1白背，2白装，3红背，4红装, Tag：概率（百分数)
  MSS_SET_QUICKSOFT		   = 10034;	//后台设置外挂的设置   参数Param ：int值
  MSS_SET_CHATLEVEL		   = 10035;	//后台设置聊天等级  Param 是频道id, Tag是最小等级
  MSS_SET_DELGUILD       = 10036; //后台删除行会
  MSS_SET_HUNDREDSERVER  = 10037;	//后台设置百服活动
  MSS_SET_RELOADCONFIG	 = 10038;	//后台加载引擎配置
	MSS_SET_REMOVEITEM	   = 10039;	//删除玩家的物品  名字 物品GUID 位置
	MSS_SET_REMOVEMONEY		 = 10040;	//删除玩家金钱		名字  类型 钱数量
  MSS_DELAY_COMBINE		   = 10041;	//后台设置合服倒计时
  MSS_GET_NOTICESTR		   = 10042;	//后台请求公告列表
  MSS_SET_REFRESHCORSS	 = 10043;	//后台刷新跨服配置
  MSS_SET_COMMON_SRVID   = 10044; //设置跨服的服务器ID
  MSS_GET_COMMON_SRVID	 = 10045; //获取跨服的服务器Id
  MSS_SET_SURPRISERET		 = 10046;	//后台设置惊喜回馈(Tag:库ID，param为开启的时间（小时），最后跟开启时间,格式如：2013-01-01 10:0:0)
  MSS_RESET_GAMBLE	  	 = 10047;	//重置寻宝元宝消耗
  MSS_SET_CHANGENAME   	 = 10048;	//设置改名字功能 Param 0为关闭 1为开启
  MSS_SET_OLDPLAYERBACK  = 10049;	//设置老玩家回归 Param 0为关闭 1为开启
  MSS_SET_RELOADLANG	   = 10050;	//加载语言包
  MSS_SET_GROUPON	       = 10051;	//后台设置团购(Tag:库ID（ID=0表示查看开启状态），param为持续的时间（小时）（持续时间为0表示关闭），最后跟开启时间,格式如：2013-01-01 10:0:0)
  MSS_SET_CROSSBATTLE    = 10052;	//开启开启跨服降魔战场 Tag	0 关闭 1 开启
  MSS_SET_CROSSBATTLENUM = 10053; //设置跨服降魔战场的人数
  MSS_RELOAD_ITMEFUNCTION = 10054; //刷新道具脚本
  MSS_VIEW_STATE         = 10055; //查看系统各种状态

  MCS_REGIST_SERVER       = 20000; //向服务器注册(param=服务器ID，数据段为编码后的服务器名称)
  MCS_KEEP_ALIVE          = 20001; //客户端回应保持连接
  MCS_RELOADNPC_RET       = 20002; //返回刷新NPC结果(tag为0表示成功，否则表示失败。param表示加载的NPC数量)
  MCS_RELOADNOTICE_RET    = 20003; //返回刷新公告结果(tag为0表示成功,否则表示失败，当失败时数据段为编码后的错误描述字符串)
  MCS_KICKPLAY_RET        = 20004; //返回踢角色下线结果(tag为0表示成功，1表示角色不在线)
  MCS_KICKUSER_RET        = 20005; //返回题账号下线结果(tag为0表示成功，1表示角色不在线)
  MCS_QUERYPLAYONLINE_RET = 20006; //返回查询角色是否在线结果(tag为1表示在线)
  MCS_QUERYUSERONLINE_RET = 20007; //返回查询账号是否在线结果(tag为1表示在线)
  MCS_ADDNOTICE_RET       = 20008; //返回添加公告结果(tag为0表示成功)
  MCS_DELNOTICE_RET       = 20009; //返回删除公告结果(tag为0表示成功，1表示不存在此公告内容)
  MCS_DELAY_UPHOLE_RET    = 20010; //返回进入倒计时维护结果(tag为0表示成功)
  MCS_CANLCE_UPHOLE_RET   = 20011; //返回取消倒计时维护状态结果(tag为0表示成功)
  MCS_SET_EXPRATE_RET     = 20012; //返回设置经验倍率结果(tag为0表示成功，param为实际设置的倍率，可能不同于请求设置的倍率)
  MCS_SHUTUP_RET          = 20013; //返回禁言结果(tag为0表示成功)
  MCS_RELEASESHUTUP_RET   = 20014; //返回解禁言结果(tag为0表示成功)
  MCS_RELOAD_FUNCTION_RET = 20015; //刷新功能脚本结果(tag为0表示成功)
  MCS_APPLY_ACROSS_SERVER = 20016; //引擎转发给后台管理器的申请跨服消息  Recog = 操作流水号, Tag = 服务器ID 数据段内容为:  账号名称/角色名称
  MCS_GET_ARENA_SCORE_RANK_RET= 20017; //后台引擎请求获取擂台积分排行榜结果 Param = 记录的条数（最大值为50，最小值为0）
                                       //数据段为 加密后的排行信息格式为:  角色ID/角色名/国家ID/胜利场数/失败场数/积分值 + #13
  MCS_RELOAD_LOGIN_SCRIPT_RET = 20018; //后台重新加载登陆脚本结果(tag为0表示成功)
  MCS_RELOAD_ROBOTNPC_RET     = 20019; //后台重新加载机器人脚本结果(tag为0表示成功)
  MCS_RELOAD_SHOP_RET         = 20020; //后台重新加载商城物品结果(tag为0表示成功)
  MCS_GET_CURR_PROCESS_MEM_USED_RET = 20021; //获取引擎当前的内存使用量结果(tag为0表示成功,此时Param为内存使用量,单位: MB)
  MCS_ADD_PLAYER_RESULTPOINT_RET    = 20022; //后台给玩家增加返点(绑定元宝)的返回结果(tag为0表示成功, 1表示人物不在线或者角色名不正确) 
  MCS_RELOAD_ABUSEINFORMATION_RET   = 20023; //重新加载文字发言过滤信息库(tag为0表示成功)
  MCS_RELOAD_MONSTER_SCRIPT_RET     = 20024; //重新加载怪物脚本返回(tag为0表示成功)
  MCS_OPEN_GAMBLE          = 20025; //开启赌博系统返回(tag为0表示成功)
  MCS_CLOSE_GAMBLE         = 20026; //关闭赌博系统返回(tag为0表示成功)
  MCS_OPEN_COMMONSERVER    = 20027; //开启跨服
  MCS_CLOSE_COMMONSERVER   = 20028; //关闭跨服
  MCS_SEND_OFFMSGTOACOTOR	 = 20029;	//返回后台给玩家直接发送离线消息结果(tag为0表示成功)
	MCS_OPEN_COMPENSATE_RET	 = 20030;	//后台开启补偿返回 (tag为0表示成功 否则返回当前开启的补偿方案ID)
	MCS_CLOSE_COMPENSATE_RET = 20031;	//后台关闭补偿返回 (tag为0表示成功)
	MCS_RETURN_FILTER_RET    = 20032;	//后台添加屏蔽字（tag为0表示成功，1 表示已存在屏蔽字，2 表示失败）
  MCS_RETURN_DROPRATE_RET	 = 20033; //返回后台设置玩家死亡掉落概率结果(tag为0表示成功，1表示设置失败)

	MCS_RETURN_QUICKSOFT_RET   = 20034;	 //返回外挂的设置  (tag为0表示成功，1表示设置失败)
  MCS_RETURN_CHATLEVEL_RET   = 20035;  //设置聊天等级 (tag为0表示成功，1表示设置失败)
  MCS_RETURN_DELGUILD_RET    = 20036;  //返回后台删除行会 (tag为0表示成功，1表示设置失败)
  MCS_RETURN_HUNDREDSERVER   = 20037;	 //返回设置的百服活动结果
  MCS_RETURN_RELOADCONFIG	   = 20038;  //返回后台加载引擎配置结果
	MCS_RETURN_REMOVEITEM	     = 20039;  //返回删除玩家物品结果 (tag为0表示成功，1表示设置失败)
	MCS_RETURN_REMOVEMONEY	   = 20040;	 //返回删除玩家金钱结果  (tag为0表示成功，1表示设置失败)
  MSS_DELAY_COMBINE_RET		   = 20041;	 //返回后台设置合服倒计时  (tag为0表示成功，1表示设置失败)
  MCS_RETURN_NOTICESTR		   = 20042;	 //返回后台请求公告列表
  MCS_RETURN_REFRESHCORSS	   = 20043;	 //返回后台刷新跨服配置(tag为0表示成功，1表示设置失败)
  MCS_RETURN_SET_COMMON_SRVID = 20044; //返回设置跨服的服务器ID (tag为0表示成功，1表示设置失败)
  MCS_RETURN_GET_COMMON_SRVID = 20045; //返回获取跨服的服务器Id  (tag为0表示成功，1表示设置失败)
  MCS_RETURN_SET_SURPRISERET	= 20046; //后台设置惊喜回馈返回(tag为0表示成功，1表示设置失败)
  MCS_RESET_GAMBLE	  	      = 20047; //重置寻宝元宝消耗(tag为0表示成功，1表示设置失败)
  MCS_RETURN_CHANGENAME       = 20048; //返回后台改名功能(tag为0表示成功，1表示设置失败)
  MCS_RETURN_OLDPLYBACK       = 20049; //返回老玩家回归结果(tag为0表示成功，1表示设置失败)
  MCS_RETURN_RELOADLAND       = 20050; //返回加载语言包(tag为0表示成功，1表示设置失败)
  MCS_RETURN_SET_GROUPON      = 20051;	//后台设置团购返回(tag为0表示成功，1表示设置失败，2表示已开启，3没开启)

  MCS_RETURN_CROSSBATTLE      = 20052; //返回后台开启跨服降魔战场(tag为0表示成功，1表示设置失败)
  MSS_RETURN_CROSSBATTLENUM   = 20053; //返回设置跨服降魔战场人数的结果 (tag为0表示成功，1表示设置失败)
  MCS_RELOAD_ITMEFUNCTION     = 20054; //返回刷新功能脚本结果 (tag为0表示成功，1表示设置失败)
 	MCS_VIEW_STATE	            = 20055; //特殊返回消息 查看系统各种状态(截取字符串)

implementation

end.
