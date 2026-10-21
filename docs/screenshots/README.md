# 应用界面截图

共 33 张，来自 Android 9 / API 28 模拟器实际运行的 Flutter 界面，截图分辨率为 750 × 1624。截图过程同时验证导航和主要交互。

原设计导出图存放在 [reference](../reference/)，本目录为实现后的运行截图。长页面额外提供滚动后的画面；输入状态使用系统键盘。

| 序号 | 界面 | 截图文件 |
| --- | --- | --- |
| 1 | 引导：开始 | [01_intro.png](01_intro.png) |
| 2 | 引导：饮食 | [02_intro_diets.png](02_intro_diets.png) |
| 3 | 引导：身体部位 | [03_intro_body.png](03_intro_body.png) |
| 4 | 登录 | [04_login.png](04_login.png) |
| 5 | 注册 | [05_signup.png](05_signup.png) |
| 6 | 找回密码 | [06_forgot.png](06_forgot.png) |
| 7 | 演示验证码 | [07_verification.png](07_verification.png) |
| 8 | 目标选择 | [08_goal.png](08_goal.png) |
| 9 | 基本资料 | [09_details.png](09_details.png) |
| 10 | 饮食偏好 | [10_preferences.png](10_preferences.png) |
| 11 | 训练首页 | [11_home.png](11_home.png) |
| 12 | 课程详情 | [12_workout.png](12_workout.png) |
| 13 | 训练课程筛选 | [13_all_workouts.png](13_all_workouts.png) |
| 14 | 训练计时 | [14_player.png](14_player.png) |
| 15 | 训练文章列表 | [15_tips.png](15_tips.png) |
| 16 | 文章详情 | [16_article.png](16_article.png) |
| 17 | 饮食推荐 | [17_diet.png](17_diet.png) |
| 18 | 餐次列表 | [18_meals.png](18_meals.png) |
| 19 | 食谱食材 | [19_recipe.png](19_recipe.png) |
| 20 | 完整食谱 | [20_recipe_expanded.png](20_recipe_expanded.png) |
| 21 | 烹饪指南封面 | [21_cooking.png](21_cooking.png) |
| 22 | 初始追踪 | [22_track.png](22_track.png) |
| 23 | 个人中心：目标 | [23_profile.png](23_profile.png) |
| 24 | 个人中心：照片 | [24_photos.png](24_photos.png) |
| 25 | 个人中心：收藏 | [25_favorites.png](25_favorites.png) |
| 26 | 设置 | [26_settings.png](26_settings.png) |
| 27 | 编辑个人资料 | [27_edit_profile.png](27_edit_profile.png) |
| 28 | 训练首页下半部分 | [28_home_more.png](28_home_more.png) |
| 29 | 文章下半部分 | [29_article_more.png](29_article_more.png) |
| 30 | 食谱下半部分 | [30_recipe_more.png](30_recipe_more.png) |
| 31 | 训练完成 | [31_workout_complete.png](31_workout_complete.png) |
| 32 | 烹饪步骤 | [32_cooking_step.png](32_cooking_step.png) |
| 33 | 记录后的追踪 | [33_track_recorded.png](33_track_recorded.png) |

重新生成：

```powershell
flutter drive --driver=tool/screenshot_driver.dart --target=integration_test/app_test.dart -d <Android设备ID>
```

命令在项目根目录执行。测试设备屏幕大小影响输出分辨率；本次使用 375 × 812 逻辑像素。结果记录在 [test_report.json](../test_report.json)。

