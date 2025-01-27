import 'package:app/models/alert.dart';
import 'package:app/pages/view_all_alerts.dart';
import 'package:app/repositories/alert_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_zoom/widget_zoom.dart';

class ViewAllAlertsToday extends StatefulWidget {
  const ViewAllAlertsToday({super.key});

  @override
  State<ViewAllAlertsToday> createState() => _ViewAllAlertsTodayState();
}

class _ViewAllAlertsTodayState extends State<ViewAllAlertsToday> {
  late List<Alert> allAlertsToday;
  late AlertRepository alerts;

  void viewAlert(Alert alert) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(15.0),
          color: const Color.fromARGB(255, 243, 242, 242),
          height: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: WidgetZoom(
                    heroAnimationTag: 'tag',
                    zoomWidget: Image.network(
                      alert.img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 52, 51, 92),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Descrição: ${alert.detection}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nível de confiança da detecção: ${alert.confidence}%',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Data: ${alert.date}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    alerts = context.watch<AlertRepository>();
    allAlertsToday = alerts.allAlertsToday;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Alertas hoje',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 77, 75, 134),
      ),
      body: RefreshIndicator(
        onRefresh: () => alerts.checkAlerts(),
        color: Colors.black,
        child: Container(
          margin: const EdgeInsets.only(top: 15.0),
          child: ListView.separated(
              itemBuilder: (BuildContext context, int alert) {
                return ListTile(
                  leading: SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(allAlertsToday[alert].img)),
                  ),
                  title: Text(
                    allAlertsToday[alert].detection,
                    style: const TextStyle(
                        fontSize: 14, color: Color.fromARGB(255, 52, 51, 92)),
                  ),
                  trailing: Text(
                    allAlertsToday[alert].date,
                    style:
                        const TextStyle(color: Color.fromARGB(255, 52, 51, 92)),
                  ),
                  onTap: () => viewAlert(allAlertsToday[alert]),
                );
              },
              separatorBuilder: (_, __) => const Divider(
                    height: 10,
                  ),
              itemCount: allAlertsToday.length),
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ViewAllAlerts()),
          );
        },
        label: const Text(
          'Ver todos alertas',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        backgroundColor: const Color.fromARGB(255, 77, 75, 134),
      ),
    );
  }
}
