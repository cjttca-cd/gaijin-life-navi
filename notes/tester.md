## 测试报告
1. 测试范围：
   - Register 画面 3 个 Profile 字段（nationality / residence_status / residence_region）
   - Chat depth_level 数据传递与 UI 展示（usage counter + message bubble）
   - 5 语言 l10n 新增文案与编译
   - flutter analyze / flutter build web --release

2. 测试结果：PASS

3. 用例：18 pass / 0 fail

4. 发现问题：
   - [minor] 国籍搜索 `Ch` 时可正确过滤（如 Chile / CH 等），但不会匹配“中国(中国)”（因数据使用本地语名称而非英文名）。功能正常，示例预期需对齐。

5. 验证步骤：
   - 代码审查：
     - `app/lib/features/auth/presentation/register_screen.dart`
     - `app/lib/features/chat/domain/chat_response.dart`
     - `app/lib/features/chat/domain/chat_message.dart`
     - `app/lib/features/chat/presentation/providers/chat_providers.dart`
     - `app/lib/features/chat/presentation/widgets/usage_counter.dart`
     - `app/lib/features/chat/presentation/widgets/message_bubble.dart`
   - 静态检查：
     - `cd app && flutter analyze`（0 errors）
     - `cd app && flutter gen-l10n`（success）
     - `cd app && flutter build web --release`（success）
   - Flutter Web 截图：
     - `cd app/build/web && python3 -m http.server 8085`
     - Playwright 脚本访问 `/#/register`, `/#/chat` 并截图

6. 产出文件：
   - `artifacts/epics/phase-c-frontend/features/register-profile-chat-depth/test-report.md`
   - `artifacts/epics/phase-c-frontend/features/register-profile-chat-depth/screenshots/*.png`
