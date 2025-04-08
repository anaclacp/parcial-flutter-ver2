import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/photo.dart';
import '../../../domain/entities/trip.dart';
import '../../bloc/trip/trip_bloc.dart';
import '../../bloc/trip/trip_event.dart';
import '../../bloc/trip/trip_state.dart';
import '../../widgets/common/loading_indicator.dart';
import 'package:intl/intl.dart';

class PhotoGalleryPage extends StatefulWidget {
  final Trip? trip; // Optional trip parameter to filter photos by trip

  const PhotoGalleryPage({
    super.key, 
    this.trip,  
  });

  @override
  State<PhotoGalleryPage> createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  bool _isMapView = false;

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      context.read<TripBloc>().add(LoadTripPhotosEvent(tripId: widget.trip!.id!));
    } else {
      context.read<TripBloc>().add(LoadAllPhotosEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip != null ? 'Fotos da Viagem' : 'Galeria de Fotos'),
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.grid_view : Icons.map),
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          if (state is TripLoading) {
            return const LoadingIndicator(message: 'Carregando fotos...');
          } else if (state is PhotosLoaded) {
            final photos = state.photos;
            
            if (photos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.photo_library_outlined,
                      color: AppColors.mediumGray,
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nenhuma foto ainda',
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.trip != null
                          ? 'Adicione fotos a esta viagem'
                          : 'Adicione fotos às suas viagens',
                      style: const TextStyle(
                        color: AppColors.mediumGray,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showAddPhotoOptions();
                      },
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Adicionar foto'),
                    ),
                  ],
                ),
              );
            }
            
            if (_isMapView) {
              return _buildMapView(photos);
            } else {
              return _buildGridView(photos);
            }
          } else if (state is TripError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(
                      color: AppColors.darkGray,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.trip != null) {
                        context.read<TripBloc>().add(
                              LoadTripPhotosEvent(tripId: widget.trip!.id!),
                            );
                      } else {
                        context.read<TripBloc>().add(LoadAllPhotosEvent());
                      }
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }
          
          return const Center(
            child: Text('Nenhuma foto disponível'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPhotoOptions();
        },
        backgroundColor: AppColors.accentColor,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
  
  Widget _buildGridView(List<Photo> photos) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return GestureDetector(
          onTap: () {
            _showPhotoDetail(photo);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  photo.url ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.lightGray,
                      child: const Icon(
                        Icons.broken_image,
                        color: AppColors.mediumGray,
                      ),
                    );
                  },
                ),
                if (photo.location != null)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withAlpha(179),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMapView(List<Photo> photos) {
    // This would be implemented with a map package like google_maps_flutter
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.map_outlined,
            size: 80,
            color: AppColors.mediumGray,
          ),
          const SizedBox(height: 16),
          const Text(
            'Visualizar Mapa de Fotos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${photos.length} fotos no mapa',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showPhotoDetail(Photo photo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(photo.caption ?? 'Detalhe da Foto'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDeleteConfirmation(photo);
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InteractiveViewer(
                  child: Center(
                    child: Image.network(
                      photo.url ?? 'https://via.placeholder.com/400',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.lightGray,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.mediumGray,
                              size: 80,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (photo.caption != null || photo.timestamp != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (photo.caption != null) ...[
                        Text(
                          photo.caption!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (photo.timestamp != null)
                        Text(
                          'Tirada em${DateFormat('dd MMM, yyyy \'às\' HH:mm', 'pt_BR').format(photo.timestamp!)}', 
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      if (photo.location != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Localização: ${photo.location!.latitude}, ${photo.location!.longitude}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAddPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primaryColor),
              title: const Text('Tirar Foto'),
              onTap: () {
                Navigator.of(context).pop();
                // Implement camera functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primaryColor),
              title: const Text('Escolher da galeria'),
              onTap: () {
                Navigator.of(context).pop();
                // Implement gallery picker
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDeleteConfirmation(Photo photo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir foto'),
        content: const Text(
          'Tem certeza de que deseja excluir esta foto? Esta ação não poderá ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TripBloc>().add(DeletePhotoEvent(photoId: photo.id!));
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

