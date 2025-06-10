import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:parcial/core/utils/input_validator.dart';
import 'package:parcial/domain/entities/trip.dart';
import 'package:parcial/presentation/bloc/trip/trip_bloc.dart';
import 'package:parcial/presentation/bloc/trip/trip_event.dart';
import 'package:parcial/presentation/widgets/common/app_button.dart';
import 'package:parcial/presentation/widgets/common/app_text_field.dart';

class TripFormPage extends StatefulWidget {
  // A viagem pode ser nula se estivermos criando uma nova.
  final Trip? trip;

  const TripFormPage({super.key, this.trip});

  @override
  State<TripFormPage> createState() => _TripFormPageState();
}

class _TripFormPageState extends State<TripFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para os campos do formulário
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late TextEditingController _distanceController;
  late TextEditingController _durationController;

  // Variáveis para data
  DateTime? _selectedDate;

  // Flag para saber se estamos editando ou criando
  bool get _isEditing => widget.trip != null;

  @override
  void initState() {
    super.initState();
    
    // Inicializa os controllers com os dados da viagem, se estivermos editando
    _titleController = TextEditingController(text: widget.trip?.title ?? '');
    _notesController = TextEditingController(text: widget.trip?.notes ?? '');
    _distanceController = TextEditingController(text: widget.trip?.distance?.toString() ?? '');
    _durationController = TextEditingController(text: widget.trip?.duration?.toString() ?? '');
    _selectedDate = widget.trip?.startTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _distanceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveTrip() {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: Usuário não autenticado.')),
        );
        return;
      }
      
      final trip = Trip(
        id: widget.trip?.id, 
        userId: userId,
        title: _titleController.text,
        notes: _notesController.text,
        distance: double.tryParse(_distanceController.text),
        duration: int.tryParse(_durationController.text),
        startTime: _selectedDate,
      );
      
      // Despacha o evento apropriado para o BLoC
      if (_isEditing) {
        context.read<TripBloc>().add(UpdateTripEvent(trip: trip));
      } else {
        context.read<TripBloc>().add(CreateTripEvent(trip: trip));
      }
      
      // Volta para a tela anterior após salvar
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Viagem' : 'Adicionar Nova Viagem'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Título da Viagem',
                controller: _titleController,
                validator: (value) => InputValidator.validateNotEmpty(value, 'Título'),
              ),
              const SizedBox(height: 20),
              
              // Seletor de Data
              ListTile(
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                leading: const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.calendar_today),
                ),
                title: const Text('Data da Viagem'),
                subtitle: Text(
                  _selectedDate == null 
                      ? 'Selecione uma data' 
                      : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Distância (km)',
                      controller: _distanceController,
                      keyboardType: TextInputType.number,
                      validator: (value) => InputValidator.validateNumber(value, 'Distância'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      label: 'Duração (min)',
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      validator: (value) => InputValidator.validateNumber(value, 'Duração'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              AppTextField(
                label: 'Notas da Viagem',
                controller: _notesController,
                maxLines: 5,
                hint: 'Descreva como foi a viagem, pontos de parada, etc.',
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 16),

              AppButton(
                text: _isEditing ? 'Salvar Alterações' : 'Adicionar Viagem',
                onPressed: _saveTrip,
                icon: Icons.save,
              )
            ],
          ),
        ),
      ),
    );
  }
}
