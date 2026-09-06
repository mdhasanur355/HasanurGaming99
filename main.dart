import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appName = 'Hasanur Gaming 99';
const referralCode = 'HASANUR99';

void main() => runApp(const HasanurGamingApp());

class HasanurGamingApp extends StatelessWidget {
  const HasanurGamingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF080814),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9C27FF),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  String name = 'Guest';
  String myRef = referralCode;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      name = p.getString('name') ?? 'Guest';
      myRef = p.getString('ref') ?? referralCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _referrals(),
      _profile(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people_outline), label: 'Referrals'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _home() => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [Color(0xFF4A148C), Color(0xFF9C27B0)]),
        ),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('WELCOME', style: TextStyle(fontSize: 14)),
          SizedBox(height: 6),
          Text(appName, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Play • Enjoy • Invite friends'),
        ]),
      ),
      const SizedBox(height: 18),
      _card(Icons.sports_esports, 'Games', 'Your games can be added here.'),
      _card(Icons.link, 'My Referral Link', 'Share your referral link with friends.',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferralPage()))),
      _card(Icons.notifications_outlined, 'Notifications', 'Show announcements and game updates.'),
    ],
  );

  Widget _card(IconData icon, String title, String subtitle, {VoidCallback? onTap}) =>
      Card(
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: Colors.purpleAccent),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
        ),
      );

  Widget _referrals() => const ReferralPage(inTab: true);

  Widget _profile() => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      CircleAvatar(radius: 42, child: Text(name.isEmpty ? '?' : name[0].toUpperCase(), style: const TextStyle(fontSize: 30))),
      const SizedBox(height: 12),
      Center(child: Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
      const SizedBox(height: 22),
      ListTile(title: const Text('Referral ID'), subtitle: Text(myRef), leading: const Icon(Icons.link)),
      ListTile(title: const Text('Account'), subtitle: const Text('Local demo profile'), leading: const Icon(Icons.person)),
      FilledButton(onPressed: () => _showRegister(context), child: const Text('EDIT / REGISTER')),
    ],
  );

  void _showRegister(BuildContext context) {
    final n = TextEditingController(text: name == 'Guest' ? '' : name);
    final r = TextEditingController(text: myRef);
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Account Setup'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: n, decoration: const InputDecoration(labelText: 'Name')),
        TextField(controller: r, decoration: const InputDecoration(labelText: 'Referral ID')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () async {
          final p = await SharedPreferences.getInstance();
          await p.setString('name', n.text.trim().isEmpty ? 'Guest' : n.text.trim());
          await p.setString('ref', r.text.trim().isEmpty ? referralCode : r.text.trim());
          await _load();
          if (context.mounted) Navigator.pop(context);
        }, child: const Text('SAVE')),
      ],
    ));
  }
}

class ReferralPage extends StatelessWidget {
  final bool inTab;
  const ReferralPage({super.key, this.inTab = false});

  @override
  Widget build(BuildContext context) {
    final link = 'https://your-domain.example/register?ref=$referralCode';
    return Scaffold(
      appBar: inTab ? null : AppBar(title: const Text('My Referral Link')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        const Text('YOUR REFERRAL CODE', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Text(referralCode, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.amber)),
        const SizedBox(height: 24),
        const Text('YOUR REFERRAL LINK'),
        const SizedBox(height: 8),
        SelectableText(link, style: const TextStyle(color: Colors.cyanAccent)),
        const SizedBox(height: 24),
        const Text('My Referrals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const ListTile(leading: Icon(Icons.info_outline), title: Text('No online referrals yet.'), subtitle: Text('Connect a backend/database to store real users.')),
      ]),
    );
  }
}
