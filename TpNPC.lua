
print(">>Script: TP NPC.")
--54844
--菜单所有者 --默认炉石
local itemEntry = 6948
local NPCID   = 190096
local NPCNAME = "传送"

--阵营
local TEAM_ALLIANCE=0
local TEAM_HORDE=1
--菜单号
local MMENU=1
local TPMENU=2
local GMMENU=3
local ENCMENU=4
--菜单类型
local FUNC=1
local MENU=2
local TP=3
local ENC=4

--数据库
local inSQL=[[
REPLACE INTO  INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`, `VerifiedBuild`)
VALUES (]]..NPCID..[[, 0, 0, 0, 0, 0, ']]..NPCNAME..[[', '', NULL, 0, 83, 83, 0, 35, 81, 1.2, 1.3, 1, 1, 20, 2, 1, 0, 1, 2000, 2000, 1, 1, 1, 0, 2048, 0, 0, 2, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 2, '', 12340);

REPLACE INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`)
VALUES (]]..NPCID..[[, 1, 16104, 1, 1, 12340);
]]

local Stone={
    GetTimeASString=function(player)
        local inGameTime=player:GetTotalPlayedTime()
        local days=math.modf(inGameTime/(24*3600))
        local hours=math.modf((inGameTime-(days*24*3600))/3600)
        local mins=math.modf((inGameTime-(days*24*3600+hours*3600))/60)
        return days.."天"..hours.."时"..mins.."分"
    end,
}

local Instances={--副本表
        {249,0},{249,1},{269,1},{309,0},
        {409,0},{469,0},
        {509,0},{531,0},{532,0},{533,0},{533,1},
        {534,0},{540,1},{542,1},{543,1},{544,0},{545,1},{546,1},{547,1},{548,0},
        {550,0},{552,1},{553,1},{554,1},{555,1},{556,1},{557,1},{558,1},
        {560,1},{564,0},{565,0},{568,0},
        {574,1},{575,1},{576,1},{578,1},
        {580,0},{585,1},{595,1},{598,1},{599,1},
        {600,1},{601,1},{602,1},{603,0},{603,1},{604,1},{608,1},
        {615,0},{615,1},{616,0},{616,1},{619,1},{624,0},{624,1},
        {631,0},{631,1},{631,2},{631,3},{632,1},
        {649,0},{649,1},{649,2},{649,3},--十字军的试炼
        {650,1},{658,1},{668,1},
        {724,0},{724,1},{724,2},{724,3},
}

local Menu={
    [MMENU]={--传送菜单
        {MENU, "主要城市",            TPMENU+0x10,GOSSIP_ICON_BATTLE},
        {MENU, "东部王国",            TPMENU+0x20,GOSSIP_ICON_BATTLE},
        {MENU, "卡利姆多",            TPMENU+0x30,GOSSIP_ICON_BATTLE},
        {MENU, "外域",                TPMENU+0x40,GOSSIP_ICON_BATTLE},
        {MENU, "诺森德",                TPMENU+0x50,GOSSIP_ICON_BATTLE},
        {MENU, "经典旧世界地下城",    TPMENU+0x60,GOSSIP_ICON_BATTLE},
        {MENU, "燃烧的远征地下城",    TPMENU+0x70,GOSSIP_ICON_BATTLE},
        {MENU, "巫妖王之怒地下城",    TPMENU+0x80,GOSSIP_ICON_BATTLE},
        {MENU, "团队地下城",            TPMENU+0x90,GOSSIP_ICON_BATTLE},
        {MENU, "风景传送",            TPMENU+0xa0,GOSSIP_ICON_BATTLE},
        {MENU, "其他传送",            TPMENU+0xb0,GOSSIP_ICON_BATTLE},
        {MENU, "野外BOSS传送",        TPMENU+0xc0,GOSSIP_ICON_BATTLE},
    },
    [TPMENU+0x10]={--主要城市
        {TP, "达拉然", 571, 5809.55, 503.975, 657.526, 2.38338},
        {TP, "沙塔斯", 530, -1887.62, 5359.09, -12.4279, 4.40435},
        {TP, "暴风城", 0, -8842.09, 626.358, 94.0867, 3.61363,TEAM_ALLIANCE},
        {TP, "达纳苏斯", 1, 9869.91, 2493.58, 1315.88, 2.78897,TEAM_ALLIANCE},
        {TP, "铁炉堡", 0, -4900.47, -962.585, 501.455, 5.40538,TEAM_ALLIANCE},
        {TP, "埃索达", 530, -3864.92, -11643.7, -137.644, 5.50862,TEAM_ALLIANCE},
        {TP, "奥格瑞玛", 1, 1601.08, -4378.69, 9.9846, 2.14362,TEAM_HORDE},
        {TP, "雷霆崖",  1, -1274.45, 71.8601, 128.159, 2.80623,TEAM_HORDE},
        {TP, "幽暗城", 0, 1633.75, 240.167, -43.1034, 6.26128,TEAM_HORDE},
        {TP, "银月城", 530, 9738.28, -7454.19, 13.5605, 0.043914,TEAM_HORDE},
        {TP, "[中立]藏宝海湾",0, -14281.9, 552.564, 8.90422, 0.860144},
        {TP, "[中立]棘齿城",    1,    -955.21875,-3678.92,8.29946,    0},
        {TP, "[中立]加基森",    1,    -7122.79834,-3704.82,14.0526,    0},
    },
    [TPMENU+0x20]={--东部王国
        {TP, "艾尔文森林", 0,  -9449.06, 64.8392, 56.3581, 3.0704},
        {TP, "永歌森林", 530,  9024.37, -6682.55, 16.8973, 3.1413},
        {TP, "丹莫罗", 0,  -5603.76, -482.704, 396.98, 5.2349},
        {TP, "提瑞斯法林地", 0,  2274.95, 323.918, 34.1137, 4.2436},
        {TP, "幽魂之地", 530,  7595.73, -6819.6, 84.3718, 2.5656},
        {TP, "洛克莫丹", 0,  -5405.85, -2894.15, 341.972, 5.4823},
        {TP, "银松森林", 0,  505.126, 1504.63, 124.808, 1.7798},
        {TP, "西部荒野", 0,  -10684.9, 1033.63, 32.5389, 6.0738},
        {TP, "赤脊山", 0,  -9447.8, -2270.85, 71.8224, 0.28385},
        {TP, "暮色森林", 0,  -10531.7, -1281.91, 38.8647, 1.5695},
        {TP, "希尔斯布莱德丘陵", 0,  -385.805, -787.954, 54.6655, 1.0392},
        {TP, "湿地", 0,  -3517.75, -913.401, 8.86625, 2.6070},
        {TP, "奥特兰克山脉",0,  275.049, -652.044, 130.296, 0.50203},
        {MENU, "下一页", TPMENU+0x120,GOSSIP_ICON_CHAT},
    },
    [TPMENU+0x120]={--东部王国    2
        {TP, "阿拉希高地", 0,  -1581.45, -2704.06, 35.4168, 0.490373},
        {TP, "荆棘谷",  0,  -11921.7, -59.544, 39.7262, 3.7357},
        {TP, "荒芜之地", 0,  -6782.56, -3128.14, 240.48, 5.6591},
        {TP, "悲伤沼泽", 0,  -10368.6, -2731.3, 21.6537, 5.2923},
        {TP, "辛特兰", 0,  112.406, -3929.74, 136.358, 0.981903},
        {TP, "灼热峡谷",  0,  -6686.33, -1198.55, 240.027, 0.91688},
        {TP, "诅咒之地", 0,  -11184.7, -3019.31, 7.29238, 3.20542},
        {TP, "燃烧平原",  0,  -7979.78, -2105.72, 127.919, 5.10148},
        {TP, "西瘟疫之地", 0,    1743.69, -1723.86, 59.6648, 5.23722},
        {TP, "东瘟疫之地", 0,  2280.64, -5275.05, 82.0166, 4.747},
        {TP, "奎尔丹纳斯岛", 530,  12806.5, -6911.11, 41.1156, 2.2293},
    },
    [TPMENU+0x30]={--卡利姆多
        {TP, "秘蓝岛", 530, -4192.62, -12576.7, 36.7598, 1.62813},
        {TP, "秘血岛", 530, -2721.67, -12208.90, 9.08,     0},
        {TP, "达希尔", 1, 9889.03, 915.869, 1307.43, 1.9336},
        {TP, "杜隆塔尔", 1, 228.978, -4741.87, 10.1027, 0.416883},
        {TP, "莫高雷", 1, -2473.87, -501.225, -9.42465, 0.6525},
        {TP, "秘血岛", 530, -2095.7, -11841.1, 51.1557, 6.19288},
        {TP, "黑海岸", 1, 6463.25, 683.986, 8.92792, 4.33534},
        {TP, "贫瘠之地", 1, -575.772, -2652.45, 95.6384, 0.006469},
        {TP, "石爪山脉", 1, 1574.89, 1031.57, 137.442, 3.8013},
        {TP, "灰谷森林", 1, 1919.77, -2169.68, 94.6729, 6.14177},
        {TP, "千针石林", 1, -5375.53, -2509.2, -40.432, 2.41885},
        {TP, "凄凉之地", 1, -656.056, 1510.12, 88.3746, 3.29553},
        {TP, "尘泥沼泽", 1, -3350.12, -3064.85, 33.0364, 5.12666},
        {TP, "菲拉斯", 1, -4808.31, 1040.51, 103.769, 2.90655},
        {TP, "塔纳利斯沙漠", 1, -6940.91, -3725.7, 48.9381, 3.11174},
        {TP, "艾萨拉", 1, 3117.12, -4387.97, 91.9059, 5.49897},
        {TP, "费伍德森林", 1, 3898.8, -1283.33, 220.519, 6.24307},
        {TP, "安戈洛环形山", 1, -6291.55, -1158.62, -258.138, 0.457099},
        {TP, "希利苏斯", 1, -6815.25, 730.015, 40.9483, 2.39066},
        {TP, "冬泉谷", 1, 6658.57, -4553.48, 718.019, 5.18088},
    },
    [TPMENU+0x40]={--外域
        {TP, "地狱火半岛", 530, -207.335, 2035.92, 96.464, 1.59676},
        {TP, "地狱火半岛-荣耀堡",530,-683.05,2657.57,91.04,    0,TEAM_ALLIANCE},
        {TP, "地狱火半岛-萨尔玛",530,139.96,2671.51,85.509,    0,TEAM_HORDE},
        {TP, "赞加沼泽", 530, -220.297, 5378.58, 23.3223, 1.61718},
        {TP, "泰罗卡森林", 530, -2266.23, 4244.73, 1.47728, 3.68426},
        {TP, "纳格兰", 530, -1610.85, 7733.62, -17.2773, 1.33522},
        {TP, "刀锋山", 530, 2029.75, 6232.07, 133.495, 1.30395},
        {TP, "虚空风暴", 530, 3271.2, 3811.61, 143.153, 3.44101},
        {TP, "影月谷", 530, -3681.01, 2350.76, 76.587, 4.25995},
    },
    [TPMENU+0x50]={--诺森德
        {TP, "北风苔原", 571, 2954.24, 5379.13, 60.4538, 2.55544},
        {TP, "凛风峡湾", 571, 682.848, -3978.3, 230.161, 1.54207},
        {TP, "龙骨荒野", 571, 2678.17, 891.826, 4.37494, 0.101121},
        {TP, "灰熊丘陵", 571, 4017.35, -3403.85, 290, 5.35431},
        {TP, "祖达克", 571, 5560.23, -3211.66, 371.709, 5.55055},
        {TP, "索拉查盆地", 571, 5614.67, 5818.86, -69.722, 3.60807},
        {TP, "水晶之歌森林", 571, 5411.17, -966.37, 167.082, 1.57167},
        {TP, "风暴峭壁", 571, 6120.46, -1013.89, 408.39, 5.12322},
        {TP, "冰冠冰川", 571, 8323.28, 2763.5, 655.093, 2.87223},
        {TP, "冬拥湖", 571, 4522.23, 2828.01, 389.975, 0.215009},
    },
    [TPMENU+0x60]={--经典旧世界地下城
        {TP, "诺莫瑞根",0, -5163.54, 925.423, 257.181, 1.57423},
        {TP, "死亡矿井", 0, -11209.6, 1666.54, 24.6974, 1.42053},
        {TP, "暴风城监狱", 0, -8799.15, 832.718, 97.6348, 6.04085,TEAM_ALLIANCE},
        {TP, "怒焰裂谷",  1, 1811.78, -4410.5, -18.4704, 5.20165,TEAM_HORDE},
        {TP, "剃刀高地",  1, -4657.3, -2519.35, 81.0529, 4.54808},
        {TP, "剃刀沼泽", 1, -4470.28, -1677.77, 81.3925, 1.16302},
        {TP, "血色修道院", 0, 2873.15, -764.523, 160.332, 5.10447},
        {TP, "影牙城堡", 0, -234.675, 1561.63, 76.8921, 1.24031},
        {TP, "哀嚎洞穴", 1, -731.607, -2218.39, 17.0281, 2.78486},
        {TP, "黑暗深渊", 1, 4249.99, 740.102, -25.671, 1.34062},
        {TP, "黑石深渊", 0, -7179.34, -921.212, 165.821, 5.09599},
        {TP, "黑石塔", 0, -7527.05, -1226.77, 285.732, 5.29626},
        {TP, "厄运之槌", 1, -3520.14, 1119.38, 161.025, 4.70454},
        {TP, "玛拉顿", 1, -1421.42, 2907.83, 137.415, 1.70718},
        {TP, "通灵学院", 0, 1269.64, -2556.21, 93.6088, 0.620623},
        {TP, "斯坦索姆", 0, 3352.92, -3379.03, 144.782, 6.25978},
        {TP, "沉没的神庙", 0, -10177.9, -3994.9, -111.239, 6.01885},
        {TP, "奥达曼",0, -6071.37, -2955.16, 209.782, 0.015708},
        {TP, "祖尔法拉克", 1, -6801.19, -2893.02, 9.00388, 0.158639},
    },
    [TPMENU+0x70]={--燃烧的远征地下城
        {TP, "奥金顿", 530, -3324.49, 4943.45, -101.239, 4.63901},
        {TP, "时光之穴", 1, -8369.65, -4253.11, -204.272, -2.70526},
        {TP, "盘牙水库", 530, 738.865, 6865.77, -69.4659, 6.27655},
        {TP, "地狱火堡垒", 530, -347.29, 3089.82, 21.394, 5.68114},
        {TP, "魔导师平台", 530, 12884.6, -7317.69, 65.5023, 4.799},
        {TP, "风暴要塞", 530, 3100.48, 1536.49, 190.3, 4.62226},
    },
    [TPMENU+0x80]={--巫妖王之怒地下城
        {TP, "艾卓-尼鲁布", 571, 3707.86, 2150.23, 36.76, 3.22},
        {TP, "斯坦索姆的抉择", 1, -8756.39, -4440.68, -199.489, 4.66289},
        {TP, "冠军的试炼", 571, 8590.95, 791.792, 558.235, 3.13127},
        {TP, "达克萨隆堡垒", 571, 4765.59, -2038.24, 229.363, 0.887627},
        {TP, "古达克", 571, 6722.44, -4640.67, 450.632, 3.91123},
        {TP, "冰封大殿", 571, 5643.16, 2028.81, 798.274, 4.60242},
        {TP, "魔枢", 571, 3782.89, 6965.23, 105.088, 6.14194},
        {TP, "紫罗兰监狱", 571, 5693.08, 502.588, 652.672, 4.0229},
        {TP, "闪电大厅", 571, 9136.52, -1311.81, 1066.29, 5.19113},
        {TP, "石头大厅", 571, 8922.12, -1009.16, 1039.56, 1.57044},
        {TP, "乌特加德城堡",571, 1203.41, -4868.59, 41.2486, 0.283237},
        {TP, "乌特加德之巅", 571, 1267.24, -4857.3, 215.764, 3.22768},
    },
    [TPMENU+0x90]={--团队地下城
        {TP, "黑暗神庙", 530, -3649.92, 317.469, 35.2827, 2.94285},
        {TP, "黑翼之巢", 229, 152.451, -474.881, 116.84, 0.001073},
        {TP, "海加尔山之巅", 1, -8177.89, -4181.23, -167.552, 0.913338},
        {TP, "毒蛇神殿", 530, 797.855, 6865.77, -65.4165, 0.005938},
        {TP, "十字军的试炼", 571, 8515.61, 714.153, 558.248, 1.57753},
        {TP, "格鲁尔的巢穴", 530, 3530.06, 5104.08, 3.50861, 5.51117},
        {TP, "玛瑟里顿的巢穴", 530, -336.411, 3130.46, -102.928, 5.20322},
        {TP, "冰冠堡垒",571, 5855.22, 2102.03, 635.991, 3.57899},
        {TP, "卡拉赞", 0, -11118.9, -2010.33, 47.0819, 0.649895},
        {TP, "熔火之心", 230, 1126.64, -459.94, -102.535, 3.46095},
        {TP, "纳克萨玛斯", 571, 3668.72, -1262.46, 243.622, 4.785},
        {TP, "奥妮克希亚的巢穴", 1, -4708.27, -3727.64, 54.5589, 3.72786},
        {TP, "安其拉废墟", 1, -8409.82, 1499.06, 27.7179, 2.51868},
        {MENU, "下一页", TPMENU+0x190,GOSSIP_ICON_BATTLE},
    },
    [TPMENU+0x190]={--团队地下城2
        {TP, "太阳井高地", 530, 12574.1, -6774.81, 15.0904, 3.13788},
        {TP, "风暴要塞",  530, 3088.49, 1381.57, 184.863, 4.61973},
        {TP, "安其拉神殿", 1, -8240.09, 1991.32, 129.072, 0.941603},
        {TP, "永恒之眼", 571, 3784.17, 7028.84, 161.258, 5.79993},
        {TP, "黑曜石圣殿", 571, 3472.43, 264.923, -120.146, 3.27923},
        {TP, "奥杜尔",571, 9222.88, -1113.59, 1216.12, 6.27549},
        {TP, "阿尔卡冯的宝库", 571, 5453.72, 2840.79, 421.28, 0},
        {TP, "祖尔格拉布", 0, -11916.7, -1215.72, 92.289, 4.72454},
        {TP, "祖阿曼",530, 6851.78, -7972.57, 179.242, 4.64691},
    },
    [TPMENU+0xa0]={--风景传送
        {TP, "GM之岛",            1, 16222.1,        16252.1,    12.5872,    0},
        {TP, "时光之穴",        1,-8173.93018,    -4737.46387,33.77735,    0},
        {TP, "双塔山",            1,-3331.35327,    2225.72827,    30.9877,    0},
        {TP, "梦境之树",        1,-2914.7561,    1902.19934,    34.74103,    0},
        {TP, "恐怖之岛",        1, 4603.94678,    -3879.25097,944.18347,    0},
        {TP, "天涯海滩",        1,-9851.61719,    -3608.47412,8.93973,    0},
        {TP, "安戈洛环形山",    1,-8562.09668,    -2106.05664,8.85254,    0},
        {TP, "石堡瀑布",        0,-9481.49316,    -3326.91528,8.86435,    0},
        {TP, "暴雪建设公司路障",1, 5478.06006,    -3730.8501,    1593.44,    0},
    },
    [TPMENU+0xb0]={--其他传送
        {TP, "古拉巴什竞技场", 0, -13181.8, 339.356, 42.9805, 1.18013},
        --Alliance
        {TP, "奥特兰战场",0,    5.599396,-308.73822,132.26651,        0,TEAM_ALLIANCE},
        {TP, "阿拉希战场",0,    -1229.860352,-2545.07959,21.180079,    0,TEAM_ALLIANCE},
        --Horde
        {TP, "阿拉希战场",0,    -847.953491,-3519.764893,72.607727,    0,TEAM_HORDE},
        {TP, "奥特兰战场",0,    396.471863,-1006.229126,111.719086,    0,TEAM_HORDE},
        {TP, "战歌峡谷",  1,    1036.794800,-2106.138672,122.94553,    0,TEAM_HORDE},
    },
    [TPMENU+0xc0]={--野外BOSS传送
        {TP, "暮色森林",    0,-10526.16895,-434.996796,50.8948,    0},
        {TP, "辛特兰",    0,759.605713,-3893.341309,116.4753,    0},
        {TP, "灰谷",        1,3120.289307,-3439.444336,139.5663,0},
        {TP, "艾萨拉",    1,2622.219971,-5977.930176,100.5629,0},
        {TP, "菲拉斯",    1,-2741.290039,2009.481323,31.8773,    0},
        {TP, "诅咒之地",    0,-12234,-2474,-3,                    0},
        {TP, "水晶谷",    1,-6292.463379,1578.029053,0.1553,    0},
    },
}


function Stone.AddGossip(player, item, id)
    player:GossipClearMenu()--清除菜单
    local Rows=Menu[id] or {}
    local Pteam=player:GetTeam()
    local teamStr,team="",player:GetTeam()
    if(team==TEAM_ALLIANCE)then
        teamStr    ="[|cFF0070d0联盟|r]"
    elseif(team==TEAM_HORDE)then
        teamStr    ="[|cFFF000A0部落|r]"
    end
    for k, v in pairs(Rows) do
        local mtype,text,icon,intid=v[1],( v[2] or "???" ), (v[4] or GOSSIP_ICON_CHAT), (id*0x100+k)
        if(mtype==MENU)then
            player:GossipMenuAddItem(icon, text, 0, (v[3] or id )*0x100)
        elseif(mtype==FUNC or mtype==ENC)then
            local code,msg,money=v[5],(v[6]or ""), (v[7] or 0)
            if(mtype==ENC)then
                icon=GOSSIP_ICON_TABARD
            end
            if((code==true or code ==false))then
                player:GossipMenuAddItem(icon, text, money, intid, code, msg, money)
            else
                player:GossipMenuAddItem(icon, text, 0, intid)
            end
        elseif(mtype==TP)then
            local mteam=v[8] or TEAM_NONE
            if(mteam==Pteam)then
                player:GossipMenuAddItem(GOSSIP_ICON_TAXI, teamStr..text, 0, intid, false,"是否传送到 |cFFFFFF00"..text.."|r ?",0)
            elseif(mteam ==TEAM_NONE)then
                player:GossipMenuAddItem(GOSSIP_ICON_TAXI, text, 0, intid, false,"是否传送到 |cFFFFFF00"..text.."|r ?",0)
            end
        else
            player:GossipMenuAddItem(icon, text, 0, intid)
        end
    end
    if(id > 0)then--添加返回上一页菜单
        local length=string.len(string.format("%x",id))
        if(length>1)then
            local temp=bit_and(id,2^((length-1)*4)-1)
            if(temp ~= MMENU)then
                player:GossipMenuAddItem(GOSSIP_ICON_CHAT,"上一页", 0,temp*0x100)
            end
        end
    end
    if(id ~= MMENU)then--添加返回主菜单
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT,"主菜单", 0, MMENU*0x100)
    else
        if(player:GetGMRank()>=3)then--是GM
            player:GossipMenuAddItem(GOSSIP_ICON_CHAT,"GM功能", 0, GMMENU*0x100)
        end
        player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "在线总时间：|cFF000080"..Stone.GetTimeASString(player).."|r", 0, MMENU*0x100)
    end

    player:GossipSendMenu(1, item)--发送菜单
end

function Stone.ShowGossip(event, player, item)
    -- player:MoveTo(0,player:GetX(),player:GetY(),player:GetZ()+0.01)--移动就停止当前施法
    Stone.AddGossip(player, item, MMENU)
end

function Stone.SelectGossip(event, player, item, sender, intid, code, menu_id)
    local menuid=math.modf(intid/0x100)    --菜单组
    local rowid    =intid-menuid*0x100        --第几项
    if(rowid== 0)then
        Stone.AddGossip(player, item, menuid)
    else
        player:GossipComplete()    --关闭菜单
        local v=Menu[menuid] and Menu[menuid][rowid]
        if(v)then                        --如果找到菜单项
            local mtype=v[1] or MENU
            if(mtype==MENU)then
                Stone.AddGossip(player, item, (v[3] or MMENU))
            elseif(mtype==FUNC)then                    --功能
                local f=v[3]
                if(f)then
                    player:ModifyMoney(-sender)        --扣费
                    f(player, code)
                end
            elseif(mtype==ENC)then
                local spellId,equipId=v[3],v[4]
                Enchanting(player, spellId, equipId, 0)
                Stone.AddGossip(player, item, menuid)
            elseif(mtype==TP)then                    --传送
                local map,mapid,x,y,z,o=v[2],v[3],v[4], v[5], v[6],v[7] or 0
                local pname=player:GetName()--得到玩家名
                if(player:Teleport(mapid,x,y,z,o,TELE_TO_GM_MODE))then--传送
                    Nplayer=GetPlayerByName(pname)--根据玩家名得到玩家
                    if(Nplayer)then
                        Nplayer:SendBroadcastMessage("已经到达 "..map)
                        Nplayer:ModifyMoney(-sender)--扣费
                    end
                else
                    print(">>Eluna Error: Teleport Stone : Teleport To "..mapid)
                end
            end
        end
    end
end

RegisterCreatureGossipEvent(NPCID, 1, Stone.ShowGossip)
RegisterCreatureGossipEvent(NPCID, 2, Stone.SelectGossip)