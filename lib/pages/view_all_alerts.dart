import 'package:app/models/alert.dart';
import 'package:app/pages/view_alert.dart';
import 'package:app/repositories/alert_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllAlerts extends StatefulWidget {
  const ViewAllAlerts({super.key});

  @override
  State<ViewAllAlerts> createState() => _ViewAllAlertsState();
}

class _ViewAllAlertsState extends State<ViewAllAlerts> {
  late List<Alert> allAlerts;
  late AlertRepository alerts;

  viewAlert(Alert alert) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewAlert(
          alert: alert,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    alerts = context.watch<AlertRepository>();
    allAlerts = alerts.allAlerts;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Alertas',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 242, 242),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int alert) {
            return ListTile(
              leading: SizedBox(
                width: 50,
                height: 60,
                child: Image.network(allAlerts[alert].img),
              ),
              title: Text(
                allAlerts[alert].detection,
                style: const TextStyle(fontSize: 14),
              ),
              trailing: Text(allAlerts[alert].date),
              onTap: () => viewAlert(allAlerts[alert]),
            );
          },
          separatorBuilder: (_, __) => const Divider(
                height: 10,
              ),
          itemCount: allAlerts.length),
      backgroundColor: const Color.fromARGB(255, 243, 242, 242),
    );
  }
}
