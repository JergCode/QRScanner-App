import 'package:flutter/material.dart';

import 'package:qr_scanner_app/src/bloc/scans_bloc.dart';
import 'package:qr_scanner_app/src/models/scan_model.dart';
import 'package:qr_scanner_app/src/utils/scan_utils.dart';

class MapsPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    return StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scansStream,
        builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          final scans = snapshot.data;

          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          if (scans.isEmpty) return Center(child: Text('No scans found!!!'));

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, index) => Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              background: Container(color: Colors.red),
              onDismissed: (dir) => scansBloc.deleteScan(scans[index].id),
              child: ListTile(
                leading: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
                title: Text(scans[index].value),
                subtitle: Text(
                  'id: ${scans[index].id}',
                  style: Theme.of(context).textTheme.caption,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => ScanUtils.launchURL(scan: scans[index], context: context),
              ),
            ),
          );
        });
  }
}
