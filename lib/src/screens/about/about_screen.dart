import 'package:flutter/material.dart';
import 'package:greenio/src/utils/constants/assets_path.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  _showButtons({onTap, required IconData prefixIcon, required String title, required String subtitle}) {
    return InkWell(
      splashColor: Colors.green,
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.green[200]!),
        ),
        elevation: 2,
        color: Colors.green[500],
        child: ListTile(
          leading: Icon(prefixIcon),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text(subtitle),
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const EmptySpace(heightFraction: 0.03),
              Center(child: Image.asset(appLogoImagePath, height: 120)),
              const Divider(thickness: 2),
              _showButtons(prefixIcon: Icons.numbers, title: 'App Version', subtitle: 'Version 1.0.0'),
              _showButtons(
                prefixIcon: Icons.contact_mail_outlined,
                title: 'Contact us',
                subtitle: 'greenioworld23@gmail.com',
                onTap: () async {
                  const url = 'mailto:greenioworld23@gmail.com?subject=Feedback';
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
