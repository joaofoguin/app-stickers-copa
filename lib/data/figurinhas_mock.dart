import '../models/figurinha.dart';

final Map<String, List<String>> jogadoresPorSelecao = {
  'Brasil': [
    'Alisson',
    'Ederson',
    'Marquinhos',
    'Éder Militão',
    'Casemiro',
    'Bruno Guimarães',
    'Lucas Paquetá',
    'Rodrygo',
    'Vinicius Junior',
    'Raphinha',
    'Endrick',
    'Neymar',
  ],
  'Argentina': [
    'Emiliano Martínez',
    'Cristian Romero',
    'Nicolás Otamendi',
    'Rodrigo De Paul',
    'Enzo Fernández',
    'Alexis Mac Allister',
    'Ángel Di María',
    'Julián Álvarez',
    'Lautaro Martínez',
    'Lionel Messi',
    'Paulo Dybala',
    'Nicolás González',
  ],
  'França': [
    'Mike Maignan',
    'Jules Koundé',
    'William Saliba',
    'Dayot Upamecano',
    'Theo Hernández',
    'Aurélien Tchouaméni',
    'Adrien Rabiot',
    'Antoine Griezmann',
    'Ousmane Dembélé',
    'Kylian Mbappé',
    'Marcus Thuram',
    'Kingsley Coman',
  ],
  'Portugal': [
    'Diogo Costa',
    'Rúben Dias',
    'Pepe',
    'João Cancelo',
    'Nuno Mendes',
    'João Palhinha',
    'Bruno Fernandes',
    'Bernardo Silva',
    'Rafael Leão',
    'João Félix',
    'Gonçalo Ramos',
    'Cristiano Ronaldo',
  ],
  'Espanha': [
    'Unai Simón',
    'Dani Carvajal',
    'Aymeric Laporte',
    'Robin Le Normand',
    'Rodri',
    'Pedri',
    'Gavi',
    'Fabián Ruiz',
    'Dani Olmo',
    'Álvaro Morata',
    'Lamine Yamal',
    'Nico Williams',
  ],
  'Alemanha': [
    'Manuel Neuer',
    'Antonio Rüdiger',
    'Jonathan Tah',
    'Joshua Kimmich',
    'İlkay Gündoğan',
    'Toni Kroos',
    'Jamal Musiala',
    'Florian Wirtz',
    'Leroy Sané',
    'Kai Havertz',
    'Niclas Füllkrug',
    'Thomas Müller',
  ],
  'Inglaterra': [
    'Jordan Pickford',
    'Kyle Walker',
    'John Stones',
    'Harry Maguire',
    'Declan Rice',
    'Jude Bellingham',
    'Phil Foden',
    'Bukayo Saka',
    'Jack Grealish',
    'Marcus Rashford',
    'Harry Kane',
    'Ollie Watkins',
  ],
  'Uruguai': [
    'Sergio Rochet',
    'José María Giménez',
    'Ronald Araújo',
    'Mathías Olivera',
    'Manuel Ugarte',
    'Federico Valverde',
    'Rodrigo Bentancur',
    'Nicolás de la Cruz',
    'Giorgian de Arrascaeta',
    'Darwin Núñez',
    'Luis Suárez',
    'Facundo Pellistri',
  ],
};

final Map<String, String> siglasSelecoes = {
  'Brasil': 'BRA',
  'Argentina': 'ARG',
  'França': 'FRA',
  'Portugal': 'POR',
  'Espanha': 'ESP',
  'Alemanha': 'ALE',
  'Inglaterra': 'ING',
  'Uruguai': 'URU',
};

final List<Figurinha> figurinhasMock = gerarFigurinhas();

List<Figurinha> gerarFigurinhas() {
  final List<Figurinha> figurinhas = [];

  int idAtual = 1;

  jogadoresPorSelecao.forEach((selecao, jogadores) {
    final sigla = siglasSelecoes[selecao] ??
        selecao.substring(0, 3).toUpperCase();

    for (int i = 0; i < jogadores.length; i++) {
      final numero = i + 1;
      final codigo = '$sigla${numero.toString().padLeft(2, '0')}';
      final jogador = jogadores[i];

      figurinhas.add(
        Figurinha(
          id: idAtual,
          codigo: codigo,
          selecao: selecao,
          nome: jogador,
        ),
      );

      idAtual++;
    }
  });

  return figurinhas;
}