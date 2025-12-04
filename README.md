### 一些脚本
### 直接放在/root/wotlk/env/dist/bin/lua_scripts/extensions/目录即可
* PlayerLogin 玩家登录公告
* WorldChat 世界聊天（普通聊天频道）
* TeleportStore 多功能炉石 需要修改炉石的item技能id
* GlyphNPC 雕文商人 80010
* TpNPC 传送 80011
* VendorNPC 综合物品商人 80012
* NPC2 传送等功能 80013（待完善）
* Buffer 小宝的丝带技能
```sql
update item_template set flags = 67141696, spelltrigger_1 = 0, scriptName = 'buff_item', description = '比心，爱你，点击获取多个增益' where entry = 52019;
```
