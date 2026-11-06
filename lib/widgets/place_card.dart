import 'package:flutter/material.dart';
import 'package:postcodes/models/place.dart';
import 'package:postcodes/styles/app_styles.dart';

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final postcodesStr = place.postcodes != null
        ? place.postcodes!.join(', ')
        : 'Sense codi';

    return Card(
      color: AppStyles.cardBackground,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        leading: Icon(Icons.location_on, color: AppStyles.primary),
        title: Text(place.name, style: AppStyles.sectionTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppStyles.smallSeparator,
            Text("Província: ${place.admin2}", style: AppStyles.bodyText),
            Text("Comunitat: ${place.admin1}", style: AppStyles.bodyText),
            Text(
              "C.P.: ${place.postcodes!.isEmpty ? 'No disponible' : postcodesStr}",
              style: AppStyles.infoText,
            ),
            Text(
              "Habitants: ${place.population ?? 'No disponible'}",
              style: AppStyles.infoText,
            ),
          ],
        ),
      ),
    );
  }
}
