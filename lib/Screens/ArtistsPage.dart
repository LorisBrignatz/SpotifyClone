import 'package:flutter/material.dart';
import 'package:musicplayer/Model/ArtistDataResponse.dart';
import 'package:musicplayer/Services/ApiService.dart';
import 'package:musicplayer/Screens/ArtistDetailPage.dart';
import 'package:musicplayer/Services/bottomBar.dart'; // Importez la classe BottomBar ici

class ArtistsPage extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40), // Ajoute un espace entre le haut de la page et le titre
            Text(
              "Artistas del momento",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40), // Ajoute un espace entre le titre et la liste des artistes
            Expanded(
              child: FutureBuilder<List<ArtistDataResponse>>(
                future: apiService.getAllArtistsData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error fetching artists data", style: TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No artists found", style: TextStyle(color: Colors.white)));
                  }

                  final artists = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Nombre de colonnes
                      crossAxisSpacing: 20, // Espacement horizontal entre les éléments
                      mainAxisSpacing: 25, // Espacement vertical entre les éléments
                    ),
                    itemCount: artists.length,
                    itemBuilder: (context, index) {
                      final artist = artists[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtistDetailPage(artist: artist),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 70, // Taille du cercle (photo de l'artiste)
                              backgroundImage: NetworkImage(
                                artist.photo ?? 'https://via.placeholder.com/100', // URL par défaut si null
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              artist.name ?? 'Unknown Artist', // Texte par défaut si null
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(currentIndex: 0), // Utilisez BottomBar ici
    );
  }
}