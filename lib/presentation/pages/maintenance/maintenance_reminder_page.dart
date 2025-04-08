import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/input_validator.dart';
import '../../../domain/entities/maintenance.dart';
import '../../bloc/maintenance/maintenance_bloc.dart';
import '../../bloc/maintenance/maintenance_event.dart';
import '../../bloc/maintenance/maintenance_state.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/maintenance/maintenance_card.dart';

class MaintenanceReminderPage extends StatefulWidget {
  const MaintenanceReminderPage({super.key});

  @override
  State<MaintenanceReminderPage> createState() => _MaintenanceReminderPageState();
}

class _MaintenanceReminderPageState extends State<MaintenanceReminderPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<MaintenanceBloc>().add(LoadMaintenanceRecordsEvent());
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembretes de Manutenção'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.white, // Cor do texto da aba SELECIONADA
          unselectedLabelColor: AppColors.white.withAlpha(179), // Cor do texto da aba NÃO SELECIONADA (branco um pouco opaco)
          indicatorColor: AppColors.white,
          tabs: const [
            Tab(text: 'Próximos'),
            Tab(text: 'Histórico'),
          ],
        ),
      ),
      body: BlocConsumer<MaintenanceBloc, MaintenanceState>(
        listener: (context, state) {
          if (state is MaintenanceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is MaintenanceAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lembrete de manutenção adicionado com sucesso'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is MaintenanceUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Status de manutenção atualizado com sucesso'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MaintenanceLoading) {
            return const LoadingIndicator(message: 'Carregando registros de manutenção...');
          }
          
          List<Maintenance> maintenanceRecords = [];
          if (state is MaintenanceRecordsLoaded) {
            maintenanceRecords = state.maintenanceRecords;
          }
          
          // Filter records for upcoming and history tabs
          final upcomingRecords = maintenanceRecords
              .where((record) => record.status != MaintenanceStatus.completed)
              .toList();
          
          final historyRecords = maintenanceRecords
              .where((record) => record.status == MaintenanceStatus.completed)
              .toList();
          
          return TabBarView(
            controller: _tabController,
            children: [
              // Upcoming Tab
              _buildUpcomingTab(upcomingRecords),
              
              // History Tab
              _buildHistoryTab(historyRecords),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMaintenanceDialog();
        },
        backgroundColor: AppColors.accentColor,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildUpcomingTab(List<Maintenance> records) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.build_outlined,
              color: AppColors.mediumGray,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma manutenção próxima',
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adicione lembretes de manutenção para manter os cuidados com sua moto em dia',
              style: TextStyle(
                color: AppColors.mediumGray,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _showAddMaintenanceDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Lembrete de Manutenção'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MaintenanceBloc>().add(LoadMaintenanceRecordsEvent());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return MaintenanceCard(
            maintenance: record,
            onMarkComplete: () {
              _showMarkCompleteDialog(record);
            },
            onEdit: () {
              _showEditMaintenanceDialog(record);
            },
            onDelete: () {
              _showDeleteConfirmation(record);
            },
          );
        },
      ),
    );
  }
  
  Widget _buildHistoryTab(List<Maintenance> records) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history,
              color: AppColors.mediumGray,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sem histórico de manutenção',
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'As tarefas de manutenção concluídas aparecerão aqui',
              style: TextStyle(
                color: AppColors.mediumGray,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MaintenanceBloc>().add(LoadMaintenanceRecordsEvent());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return MaintenanceCard(
            maintenance: record,
            isHistory: true,
            onDelete: () {
              _showDeleteConfirmation(record);
            },
          );
        },
      ),
    );
  }
  
  void _showAddMaintenanceDialog() {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final odometerController = TextEditingController();
    final notesController = TextEditingController();
    
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
    MaintenanceType selectedType = MaintenanceType.oilChange;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar lembrete de manutenção'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                AppTextField(
                  label: 'Título',
                  hint: 'Insira o título da manutenção',
                  controller: titleController,
                  validator: (value) => InputValidator.validateNotEmpty(
                    value,
                    'Título',
                  ),
                ),
                const SizedBox(height: 16),
                
                // Description
                AppTextField(
                  label: 'Descrição',
                  hint: 'Insira a descrição da manutenção',
                  controller: descriptionController,
                  maxLines: 2,
                  validator: (value) => InputValidator.validateNotEmpty(
                    value,
                    'Descrição',
                  ),
                ),
                const SizedBox(height: 16),
                
                // Type
                DropdownButtonFormField<MaintenanceType>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Manutenção',
                  ),
                  value: selectedType,
                  items: MaintenanceType.values.map((type) {
                    return DropdownMenuItem<MaintenanceType>(
                      value: type,
                      child: Text(_getMaintenanceTypeString(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedType = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Due Date
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data de Vencimento'),
                  subtitle: Text(DateFormat('dd MMM, yyyy', 'pt_BR').format(selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Odometer Threshold
                AppTextField(
                  label: 'Limite do Odômetro (km)',
                  hint: 'Insira o limite do Odômetro',
                  controller: odometerController,
                  keyboardType: TextInputType.number,
                  validator: (value) => InputValidator.validateNumber(
                    value,
                    'Limite do Odômetro',
                  ),
                ),
                const SizedBox(height: 16),
                
                // Notes
                AppTextField(
                  label: 'Notas (Opcional)',
                  hint: 'Insira quaisquer observações adicionais',
                  controller: notesController,
                  maxLines: 3,
                ),
              ],
            ),
          ),
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
              if (formKey.currentState!.validate()) {
                final maintenance = Maintenance(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  type: selectedType,
                  dueDate: selectedDate,
                  odometerThreshold: double.parse(odometerController.text),
                  status: MaintenanceStatus.pending,
                  notes: notesController.text.isNotEmpty ? notesController.text : null,
                );
                
                context.read<MaintenanceBloc>().add(AddMaintenanceEvent(maintenance: maintenance));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
  
  void _showEditMaintenanceDialog(Maintenance maintenance) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: maintenance.title);
    final descriptionController = TextEditingController(text: maintenance.description);
    final odometerController = TextEditingController(text: maintenance.odometerThreshold.toString());
    final notesController = TextEditingController(text: maintenance.notes ?? '');
    
    DateTime selectedDate = maintenance.dueDate;
    MaintenanceType selectedType = maintenance.type;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Lembrete de Manutenção'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                AppTextField(
                  label: 'Título',
                  hint: 'Insira o título da manutenção',
                  controller: titleController,
                  validator: (value) => InputValidator.validateNotEmpty(
                    value,
                    'Título',
                  ),
                ),
                const SizedBox(height: 16),
                
                // Description
                AppTextField(
                  label: 'Descrição',
                  hint: 'Insira a descrição da manutenção',
                  controller: descriptionController,
                  maxLines: 2,
                  validator: (value) => InputValidator.validateNotEmpty(
                    value,
                    'Descrição',
                  ),
                ),
                const SizedBox(height: 16),
                
                // Type
                DropdownButtonFormField<MaintenanceType>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Manutenção',
                  ),
                  value: selectedType,
                  items: MaintenanceType.values.map((type) {
                    return DropdownMenuItem<MaintenanceType>(
                      value: type,
                      child: Text(_getMaintenanceTypeString(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedType = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Due Date
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data de Vencimento'),
                  subtitle: Text(DateFormat('dd MMM, yyyy', 'pt_BR').format(selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Odometer Threshold
                AppTextField(
                  label: 'Limite do Odômetro (km)',
                  hint: 'Insira o limite do odômetro',
                  controller: odometerController,
                  keyboardType: TextInputType.number,
                  validator: (value) => InputValidator.validateNumber(
                    value,
                    'Limite do odômetro',
                  ),
                ),
                const SizedBox(height: 16),
                
                // Notes
                AppTextField(
                  label: 'Notas (Opcional)',
                  hint: 'Insira quaisquer observações adicionais',
                  controller: notesController,
                  maxLines: 3,
                ),
              ],
            ),
          ),
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
              if (formKey.currentState!.validate()) {
                final updatedMaintenance = Maintenance(
                  id: maintenance.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  type: selectedType,
                  dueDate: selectedDate,
                  odometerThreshold: double.parse(odometerController.text),
                  status: maintenance.status,
                  notes: notesController.text.isNotEmpty ? notesController.text : null,
                  completedDate: maintenance.completedDate,
                  completedOdometer: maintenance.completedOdometer,
                );
                
                context.read<MaintenanceBloc>().add(UpdateMaintenanceEvent(maintenance: updatedMaintenance));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
  
  void _showMarkCompleteDialog(Maintenance maintenance) {
    final formKey = GlobalKey<FormState>();
    final odometerController = TextEditingController();
    final notesController = TextEditingController();
    DateTime completedDate = DateTime.now();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Marcar como concluído'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Marcar "${maintenance.title}" como concluído?',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Completion Date
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data de Conclusão'),
                  subtitle: Text(DateFormat('dd MMM, yyyy', 'pt_BR').format(completedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: completedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != completedDate) {
                      setState(() {
                        completedDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Odometer Reading
                AppTextField(
                  label: 'Odômetro Atual (km)',
                  hint: 'Insira a leitura atual do odômetro',
                  controller: odometerController,
                  keyboardType: TextInputType.number,
                  validator: (value) => InputValidator.validateNumber(
                    value,
                    'Leitura do odômetro',
                  ),
                ),
                const SizedBox(height: 16),
                
                // Notes
                AppTextField(
                  label: 'Notas de Conclusão (Opcional)',
                  hint: 'Insira quaisquer observações sobre a manutenção',
                  controller: notesController,
                  maxLines: 3,
                ),
              ],
            ),
          ),
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
              if (formKey.currentState!.validate()) {
                final updatedMaintenance = Maintenance(
                  id: maintenance.id,
                  title: maintenance.title,
                  description: maintenance.description,
                  type: maintenance.type,
                  dueDate: maintenance.dueDate,
                  odometerThreshold: maintenance.odometerThreshold,
                  status: MaintenanceStatus.completed,
                  notes: maintenance.notes,
                  completedDate: completedDate,
                  completedOdometer: double.parse(odometerController.text),
                  completionNotes: notesController.text.isNotEmpty ? notesController.text : null,
                );
                
                context.read<MaintenanceBloc>().add(UpdateMaintenanceEvent(maintenance: updatedMaintenance));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Concluir'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteConfirmation(Maintenance maintenance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Manutenção'),
        content: Text(
          'Tem certeza de que deseja excluir "${maintenance.title}"? Esta ação não poderá ser desfeita.',
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
              context.read<MaintenanceBloc>().add(DeleteMaintenanceEvent(maintenanceId: maintenance.id!));
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
  
  String _getMaintenanceTypeString(MaintenanceType type) {
    switch (type) {
      case MaintenanceType.oilChange:
        return 'Troca de Óleo';
      case MaintenanceType.tireMaintenance:
        return 'Manutenção de Pneus';
      case MaintenanceType.chainLubrication:
        return 'Lubrificação da Corrente';
      case MaintenanceType.brakeService:
        return 'Serviço de Freios';
      case MaintenanceType.generalService:
        return 'Revisão Geral';
      case MaintenanceType.other:
        return 'Outro';
    }
  }
}

