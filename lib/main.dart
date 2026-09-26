import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Biến quản lý trạng thái Sáng (light) / Tối (dark)
  ThemeMode _themeMode = ThemeMode.light;

  // Hàm chuyển đổi theme
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF0468D7);

    return MaterialApp(
      title: 'F2_241A010179', // TODO: Thay bằng MSSV của bạn
      debugShowCheckedModeBanner: false,
      // Cấu hình Theme Sáng
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      // Cấu hình Theme Tối (NC1)
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      themeMode: _themeMode,
      home: LoginPage(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _ghiNho = false;
  bool _anMatKhau = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Banner đầu trang chứa nút chuyển Theme
              HeaderBanner(
                onToggleTheme: widget.onToggleTheme,
                isDarkMode: widget.isDarkMode,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final manHinhRong = constraints.maxWidth >= 700;
                    if (!manHinhRong) {
                      return Column(
                        children: [
                          _buildForm(context),
                          const SizedBox(height: 24),
                          const ProfileCard(),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildForm(context)),
                        const SizedBox(width: 24),
                        const Expanded(flex: 2, child: ProfileCard()),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Đăng nhập hệ thống',
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Nhập MSSV và mật khẩu để tiếp tục',
          style: textTheme.bodyMedium?.copyWith(color: scheme.outline),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Mã số sinh viên',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          obscureText: _anMatKhau,
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_anMatKhau ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _anMatKhau = !_anMatKhau),
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: _ghiNho,
              onChanged: (v) => setState(() => _ghiNho = v ?? false),
            ),
            const Text('Ghi nhớ đăng nhập'),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('Quên mật khẩu?')),
          ],
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đăng nhập (mô phỏng) thành công')),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('ĐĂNG NHẬP'),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('hoặc', style: TextStyle(color: scheme.outline)),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.school_outlined),
          label: const Text('Đăng nhập bằng tài khoản trường'),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Chưa có tài khoản?'),
            TextButton(onPressed: () {}, child: const Text('Đăng ký')),
          ],
        ),
      ],
    );
  }
}

/// Header Banner có nút bấm chuyển Sáng / Tối (NC1)
class HeaderBanner extends StatelessWidget {
  const HeaderBanner({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height:256,
      child: Stack(
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              // THÊM CẤU HÌNH ẢNH BÌA TẠI ĐÂY
              image: DecorationImage(
                image: const NetworkImage(
                  'https://cdn2.fptshop.com.vn/unsafe/hinh_nen_hai_huoc_0_142e94aaf1.jpg', // Link ảnh bìa 
                ),
                fit: BoxFit.cover, // Giúp ảnh tự căn vừa khung
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.35), // Phủ màu tối nhẹ giúp chữ dễ đọc hơn
                  BlendMode.darken,
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INT4211 – LẬP TRÌNH DI ĐỘNG',
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Cổng thực hành LTDD',
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onToggleTheme,
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: scheme.onPrimary,
                  ),
                  tooltip: isDarkMode ? 'Chuyển Chế độ Sáng' : 'Chuyển Chế độ Tối',
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: scheme.surface,
                child: CircleAvatar(
                  radius: 42,
                  backgroundImage: const NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOsqAWZ_j--WZIYNpFaa9wXYrKrpKmmhDRUZkINO8WcnFgVHMe5rpwIExe&s=10',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Thẻ Hồ Sơ Sinh Viên
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: CircleAvatar(child: Text('A')),
              title: Text('Trần Nguyễn Thanh Lộc'), // TODO: Đổi thành tên của bạn
              subtitle: Text('MSSV: 241A010179'), // TODO: Đổi thành MSSV của bạn
            ),
            const Divider(height: 1),
            const ListTile(
              leading: Icon(Icons.class_outlined),
              title: Text('Lớp'),
              subtitle: Text('CNTT – LTDD'),
            ),
            const ListTile(
              leading: Icon(Icons.mail_outline),
              title: Text('Email'),
              subtitle: Text('Loc241A010179@vhu.edu.vn'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: const [
                  Expanded(child: _StatBox(label: 'Lab đã nộp', value: '1')),
                  SizedBox(width: 12),
                  Expanded(child: _StatBox(label: 'Điểm TB lab', value: '8.5')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: scheme.primary,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: scheme.outline),
          ),
        ],
      ),
    );
  }
}