import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/trip.dart';
import '../../bloc/trip/trip_bloc.dart';
import '../../bloc/trip/trip_event.dart';
import '../../bloc/trip/trip_state.dart';
import '../../../core/constants/app_colors.dart';

class TripFormPage extends StatefulWidget {
  final Trip? initialTrip;

  const TripFormPage({Key? key, this.initialTrip}) : super(key: key);

  @override
  State<TripFormPage> createState() => _TripFormPageState();
}

class _TripFormPageState extends State<TripFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Estado de carregamento local para evitar travamentos
  bool _isLoading = false;

  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late TextEditingController _distanceController;
  late TextEditingController _durationController;
  late TextEditingController _maxSpeedController;
  
  DateTime? _startTime;
  DateTime? _endTime;

  bool get _isEditing => widget.initialTrip != null;

  @override
  void initState() {
    super.initState();
    final trip = widget.initialTrip;
    _titleController = TextEditingController(text: trip?.title ?? '');
    _notesController = TextEditingController(text: trip?.notes ?? '');
    _distanceController = TextEditingController(text: trip?.distance?.toString() ?? '');
    _durationController = TextEditingController(text: trip?.duration?.toString() ?? ''); 
    _maxSpeedController = TextEditingController(text: trip?.maxSpeed?.toString() ?? ''); 
    _startTime = trip?.startTime;
    _endTime = trip?.endTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _distanceController.dispose();
    _durationController.dispose(); 
    _maxSpeedController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartTime) async {
    final initialDate = (isStartTime ? _startTime : _endTime) ?? DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (newDate != null) {
      setState(() {
        if (isStartTime) {
          _startTime = newDate;
        } else {
          _endTime = newDate;
        }
      });
    }
  }

  void _submitForm() {
    if (_isLoading) return;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro: Usuário não autenticado.'), backgroundColor: Colors.red),
          );
          setState(() { _isLoading = false; });
          return;
      }

      final trip = Trip(
        id: widget.initialTrip?.id,
        userId: userId,
        title: _titleController.text,
        notes: _notesController.text,
        distance: double.tryParse(_distanceController.text),
        startTime: _startTime,
        endTime: _endTime,
        duration: int.tryParse(_durationController.text),  
        maxSpeed: double.tryParse(_maxSpeedController.text), 
      );

      if (_isEditing) {
        context.read<TripBloc>().add(UpdateTripEvent(trip: trip));
      } else {
        context.read<TripBloc>().add(CreateTripEvent(trip: trip));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Viagem' : 'Registrar Nova Viagem'),
      ),
      body: BlocListener<TripBloc, TripState>(
        listener: (context, state) {
          if (state is TripCreated || state is TripUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Viagem salva com sucesso!'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop(true);
          } else if (state is TripError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro: ${state.message}'), backgroundColor: Colors.red),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título da Viagem'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _distanceController,
                        decoration: const InputDecoration(labelText: 'Distância (km)', prefixIcon: Icon(Icons.straighten)),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _durationController,
                        decoration: const InputDecoration(labelText: 'Duração (min)', prefixIcon: Icon(Icons.timer_outlined)),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _maxSpeedController,
                  decoration: const InputDecoration(labelText: 'Velocidade Máxima (km/h)', prefixIcon: Icon(Icons.speed)),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),

                _buildDatePickerField(
                  context,
                  label: 'Data de Início',
                  date: _startTime,
                  onTap: () => _selectDate(context, true),
                ),
                const SizedBox(height: 16),
                _buildDatePickerField(
                  context,
                  label: 'Data de Fim',
                  date: _endTime,
                  onTap: () => _selectDate(context, false),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Anotações'),
                  maxLines: 4,
                ),
                const SizedBox(height: 32),
                
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitForm, // Desabilita o onPressed quando está carregando
                  icon: _isLoading 
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading 
                      ? 'Salvando...' 
                      : (_isEditing ? 'Salvar Alterações' : 'Registrar Viagem')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primaryColor,
                    disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context, {required String label, required DateTime? date, required VoidCallback onTap}) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          date != null ? dateFormat.format(date) : 'Selecione uma data',
          style: TextStyle(
            color: date != null ? Theme.of(context).textTheme.bodyLarge?.color : Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}