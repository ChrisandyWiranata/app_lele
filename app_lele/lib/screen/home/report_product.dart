import 'package:app_lele/components/app_colors.dart';
import 'package:app_lele/service/product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportProductScreen extends StatelessWidget {
  final String productId;
  const ReportProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Reports',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.curelean,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ProductService().getReportsForProduct(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reports found.'));
          }

          final reports = snapshot.data!.docs;

          final Map<String, List<Map<String, dynamic>>> groupedReports = {};
          for (var doc in reports) {
            final report = doc.data() as Map<String, dynamic>;
            final timestamp = (report['timestamp'] as Timestamp).toDate();
            final date = DateFormat('dd-MM-yyyy').format(timestamp);

            if (groupedReports[date] == null) {
              groupedReports[date] = [];
            }
            groupedReports[date]!.add(report);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: groupedReports.keys.length,
            itemBuilder: (context, index) {
              final date = groupedReports.keys.elementAt(index);
              final reportsForDate = groupedReports[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.curelean,
                      ),
                    ),
                  ),
                  ...reportsForDate.map((report) {
                    final timestamp =
                        (report['timestamp'] as Timestamp).toDate();
                    final formattedTime =
                        DateFormat('HH:mm:ss').format(timestamp);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reason: ${report['reason']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.curelean,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Reported by: ${report['reportedBy']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Time: $formattedTime',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
