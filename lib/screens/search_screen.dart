import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postcodes/models/place.dart';
import 'package:postcodes/models/search_response.dart';
import 'package:postcodes/styles/app_styles.dart';
import 'package:postcodes/widgets/place_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  TextEditingController searchController = TextEditingController();
  List<Place> apiPlaces = [];
  bool isLoading = false;
  bool isFirstLoad = true;
  bool hasError = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void clearSearch() {
    searchController.clear();
    query = '';
    setState(() {}); //  refresca la pantalla
  }

  Future<void> loadPlaces() async {
    final cleanedQuery = query.trim();
    if (cleanedQuery.isEmpty) return;

    isLoading = true;
    isFirstLoad = false;
    hasError = false;
    setState(() {});

    final url = Uri.parse(
      //'https://geocoding-api.open-meteo.com{Uri.encodeComponent(cleanedQuery)}&language=ca&countryCode=ES',
      'https://geocoding-api.open-meteo.com/v1/search?name=$cleanedQuery&language=ca&countrycode=ES',
    );
    debugPrint("===> $cleanedQuery <===");
    debugPrint("====> LA URL ENVIADA ES: $url <====");

    try {
      final http.Response response = await http.get(url);

      // Imprime el JSON devuelto en la consola de VS Code para auditar la respuesta en vivo
      debugPrint(response.body);

      if (response.statusCode == 200) {
        // Obtenemos los resultados directamente usando la función asíncrona
        final searchResponse = searchResponseFromJson(response.body);
        apiPlaces = searchResponse.results;
        debugPrint("===> Código 200");
      } else {
        hasError = true;
        debugPrint("===> No es código 200");
      }
    } catch (e, stackTrace) {
      // Con StackTrace capturamos los errores. Lo mostramos en el debugPrint("Stack Trace: $stackTrace") de abajo
      if (!mounted) return;
      debugPrint("Error detectado: $e");
      debugPrint("Stack Trace: $stackTrace");
      hasError = true; // Error real de infraestructura (ej: Modo Avión)
    }

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.background,
      appBar: AppBar(
        title: const Text("Codis Postals"),
        backgroundColor: AppStyles.primary,
        foregroundColor: AppStyles.onPrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              textInputAction:
                  TextInputAction.search, // Muestra la lupa en el teclado móvil
              onChanged: (value) {
                query = value;
                setState(() {});
              },
              onSubmitted: (value) async {
                query = value;
                await loadPlaces();
              },
              decoration: InputDecoration(
                hintText: 'Cerca una població o codi postal',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: clearSearch,
                      ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: AppStyles.primary),
                  )
                : hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          size: 48,
                          color: AppStyles.errorColor,
                        ),
                        AppStyles.smallSeparator,
                        Text(
                          "Error de connexió. Comprova que tens internet o que el servidor estigui actiu.",
                          style: AppStyles.bodyText,
                          textAlign: TextAlign.center,
                        ),
                        AppStyles.mediumSeparator,
                        ElevatedButton.icon(
                          onPressed: loadPlaces,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Tornar a intentar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.primary,
                            foregroundColor: AppStyles.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  )
                : isFirstLoad
                ? Center(
                    child: Text(
                      "Introdueix un codi postal o el nom d'una població per començar la cerca.",
                      style: AppStyles.infoText,
                      textAlign: TextAlign.center,
                    ),
                  )
                : apiPlaces
                      .isEmpty // Si la lista viene vacía por culpa del 99999
                ? Center(
                    child: Text(
                      "No hem trobat cap població per a «$query»",
                      style: AppStyles.infoText,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: apiPlaces.length,
                    itemBuilder: (context, index) {
                      debugPrint("===> Mostrant el CP de ${apiPlaces[index].name}: ${apiPlaces[index].postcodes} <===",
                      );
                    return PlaceCard(place: apiPlaces[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
