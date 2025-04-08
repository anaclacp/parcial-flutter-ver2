import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/trip.dart';
import '../../widgets/trip/trip_card.dart';
import '../../widgets/trip/trip_stats_widget.dart';


class TripDashboardPage extends StatefulWidget {
  const TripDashboardPage({super.key});

  @override
  State<TripDashboardPage> createState() => _TripDashboardPageState();
}

class _TripDashboardPageState extends State<TripDashboardPage> {
  final List<Trip> _trips = [
    Trip(
      id: '1',
      title: 'Bate e Volta para Campos do Jordão',
      startTime: DateTime.now().subtract(const Duration(days: 2)),
      endTime: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      distance: 120.5,
      duration: 180,
      averageSpeed: 40.2,
      maxSpeed: 65.8,
      notes: 'Viagem tranquila pela serra, com paradas para fotos e um café colonial.',
    ),
    Trip(
      id: '2',
      title: 'Viagem de Ribeirão Preto ao Posto Castelo em São Carlos',
      startTime: DateTime.now().subtract(const Duration(days: 7)),
      endTime: DateTime.now().subtract(const Duration(days: 7, hours: 5)),
      distance: 100.0,
      duration: 65,
      averageSpeed: 80.0,
      maxSpeed: 140.0,
      notes: 'Deslocamento pela Rodovia Washington Luís até o tradicional Castelo Restaurante & Grill para um café especial.',
    ),
    Trip(
      id: '3',
      title: 'Deslocamento da Unaerp para a Citel',
      startTime: DateTime.now().subtract(const Duration(days: 1)),
      endTime: DateTime.now().subtract(const Duration(days: 1, minutes: 45)),
      distance: 5.0,
      duration: 8,
      averageSpeed: 40.0,
      maxSpeed: 100.0,
      notes: 'Deslocamento urbano com tráfego leve. Percurso pela av. Maurilio Biagi de Ribeirão Preto.',
    ),
  ];

  String? _profileImagePath; 
  String _motoModel = 'R3 2026'; 
  String _motoColor = 'Branca'; 

  @override
  void initState() {
    super.initState();
    _profileImagePath = 'assets/images/ana_foto_perfil.jpg';
  }

  // --- Método Build Principal ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Viagens'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar Viagens',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidade de filtro ainda não implementada.')),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(), // Chama a construção do Drawer
      body: RefreshIndicator(
        onRefresh: () async {
          // Simula um refresh
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            setState(() {
              // Lógica de refresh (se buscar dados reais) iria aqui
            });
            ScaffoldMessenger.of(this.context).showSnackBar(
              const SnackBar(content: Text('Dados atualizados!')),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Widget de Estatísticas
              TripStatsWidget(
                totalTrips: _trips.length,
                totalDistance: _trips.fold(
                  0.0,
                  (sum, trip) => sum + (trip.distance ?? 0),
                ),
                longestTrip: _trips.fold(
                  0.0,
                  (max, trip) => trip.distance != null && trip.distance! > max
                      ? trip.distance!
                      : max,
                ),
              ),
              const SizedBox(height: 24),

              // Título "Viagens Recentes"
              const Text(
                'Viagens Recentes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 16),

              // Lista de Viagens ou Estado Vazio
              _trips.isEmpty
                  ? _buildEmptyState() 
                  : ListView.builder( 
                      shrinkWrap: true, 
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _trips.length,
                      itemBuilder: (context, index) {
                        final trip = _trips[index];
                        return TripCard(
                          trip: trip,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/viagem/detalhe',
                              arguments: trip,
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      // Botão Flutuante para Adicionar Viagem
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/trip/create'); 
        },
        tooltip: 'Adicionar Nova Viagem',
        backgroundColor: AppColors.accentColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.motorcycle_outlined,
              color: AppColors.mediumGray,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma viagem registrada ainda',
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Comece a registrar suas aventuras de moto',
              style: TextStyle(
                color: AppColors.mediumGray,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/trip/create'); // CONFIRME a rota
              },
              icon: const Icon(Icons.add),
              label: const Text('Registrar Nova Viagem'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    const String userName = 'Ana Clara'; // Nome fixo
    const String userEmail = 'ana@gmail.com'; // Email fixo

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                      onTap: _selectProfileImage, // Permite mudar a foto
                      borderRadius: BorderRadius.circular(35),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: AppColors.white.withAlpha(50),
                            backgroundImage: _profileImagePath != null
                                ? AssetImage(_profileImagePath!) // Mostra a imagem do asset
                                : null,
                            child: _profileImagePath == null
                                ? const Icon( // Ícone padrão se não houver imagem
                                    Icons.motorcycle,
                                    size: 40,
                                    color: AppColors.white,
                                  )
                                : null,
                          ),
                          // Ícone de editar foto
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.accentColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userName, // Nome do usuário
                    style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    userEmail, // Email do usuário
                    style: TextStyle(color: AppColors.white.withAlpha(204), fontSize: 13),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  // Dados da Moto
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Modelo: $_motoModel', style: TextStyle(color: AppColors.white.withAlpha(180), fontSize: 12), overflow: TextOverflow.ellipsis),
                            Text('Cor: $_motoColor', style: TextStyle(color: AppColors.white.withAlpha(180), fontSize: 12), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      // Botão editar dados da moto
                      InkWell(
                        onTap: _showEditMotoDialog,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.edit, color: AppColors.white.withAlpha(180), size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: AppColors.primaryColor),
            title: const Text('Painel de Viagens'),
            selected: ModalRoute.of(context)?.settings.name == '/', // CONFIRME ROTA
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/') { // CONFIRME ROTA
                Navigator.pushReplacementNamed(context, '/'); // CONFIRME ROTA
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: AppColors.primaryColor),
            title: const Text('Galeria de Fotos'),
            selected: ModalRoute.of(context)?.settings.name == '/fotos', // CONFIRME ROTA
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/fotos'); // CONFIRME ROTA
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_gas_station, color: AppColors.primaryColor),
            title: const Text('Consumo de Combustível'),
            selected: ModalRoute.of(context)?.settings.name == '/combustível', // CONFIRME ROTA
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/combustível'); // CONFIRME ROTA
            },
          ),
          ListTile(
            leading: const Icon(Icons.build, color: AppColors.primaryColor),
            title: const Text('Manutenção'),
            selected: ModalRoute.of(context)?.settings.name == '/manutenção', // CONFIRME ROTA
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/manutenção'); // CONFIRME ROTA
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.primaryColor),
            title: const Text('Configurações'),
            selected: ModalRoute.of(context)?.settings.name == '/configurações', // CONFIRME ROTA (se existir)
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Página de Configurações ainda não implementada.')),
              );
              // Navigator.pushNamed(context, '/configurações'); // CONFIRME ROTA (se existir)
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.primaryColor),
            title: const Text('Sobre'),
            selected: ModalRoute.of(context)?.settings.name == '/sobre', // CONFIRME ROTA
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sobre'); // CONFIRME ROTA
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.secondaryColor),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login'); // CONFIRME ROTA
            },
          ),
        ],
      ),
    );
  }

  // --- Função para "Selecionar" Imagem (Simulação) ---
  Future<void> _selectProfileImage() async {
    final exampleImages = [
      // SUBSTITUA PELOS CAMINHOS REAIS DOS SEUS ASSETS!
      'assets/images/ana_foto_perfil.jpg',
      'assets/images/moto_exemplo_1.png',
      'assets/images/moto_exemplo_2.jpg',
    ];
    final randomIndex = DateTime.now().millisecond % exampleImages.length;
    final selectedPath = exampleImages[randomIndex];

    print('Imagem selecionada (simulado): $selectedPath');
    setState(() { _profileImagePath = selectedPath; });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil atualizada (simulado)!')),
      );
    }
  }

  // --- Função para Editar Dados da Moto ---
  void _showEditMotoDialog() {
    final modelController = TextEditingController(text: _motoModel);
    final colorController = TextEditingController(text: _motoColor);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar Dados da Moto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: modelController, decoration: const InputDecoration(labelText: 'Modelo')),
              const SizedBox(height: 16),
              TextField(controller: colorController, decoration: const InputDecoration(labelText: 'Cor')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            TextButton(
              onPressed: () {
                setState(() {
                  _motoModel = modelController.text;
                  _motoColor = colorController.text;
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    ).then((_) {
      modelController.dispose();
      colorController.dispose();
    });
  }
} 