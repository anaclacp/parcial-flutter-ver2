import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/input_validator.dart';
import '../../../domain/entities/fuel_record.dart';
import '../../bloc/trip/trip_bloc.dart';
import '../../bloc/trip/trip_event.dart';
import '../../bloc/trip/trip_state.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/loading_indicator.dart';


class FuelConsumptionPage extends StatefulWidget {
  const FuelConsumptionPage({super.key});

  @override
  State<FuelConsumptionPage> createState() => _FuelConsumptionPageState();
}

class _FuelConsumptionPageState extends State<FuelConsumptionPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<TripBloc>().add(LoadFuelRecordsEvent());
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
        title: const Text('Consumo de Combustível'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.white, // Cor do texto da aba SELECIONADA
          unselectedLabelColor: AppColors.white.withAlpha(179), // Cor do texto da aba NÃO SELECIONADA (branco um pouco opaco)
          indicatorColor: AppColors.white,
          tabs: const [
            Tab(text: 'Registros'),
            Tab(text: 'Estatísticas'),
          ],
        ),
      ),
      body: BlocConsumer<TripBloc, TripState>(
        listener: (context, state) {
          if (state is TripError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is FuelRecordAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro de combustível adicionado com sucesso'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TripLoading) {
            return const LoadingIndicator(message: 'Carregando registros de combustível...');
          }
          
          List<FuelRecord> fuelRecords = [];
          if (state is FuelRecordsLoaded) {
            fuelRecords = state.fuelRecords;
          }
          
          return TabBarView(
            controller: _tabController,
            children: [
              // Records Tab
              _buildRecordsTab(fuelRecords),
              
              // Statistics Tab
              _buildStatisticsTab(fuelRecords),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFuelRecordDialog();
        },
        backgroundColor: AppColors.accentColor,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildRecordsTab(List<FuelRecord> fuelRecords) {
    if (fuelRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_gas_station_outlined,
              color: AppColors.mediumGray,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Ainda não há registros de combustível',
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adicione seu primeiro registro de combustível',
              style: TextStyle(
                color: AppColors.mediumGray,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _showAddFuelRecordDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Registro de Combustível'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TripBloc>().add(LoadFuelRecordsEvent());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fuelRecords.length,
        itemBuilder: (context, index) {
          final record = fuelRecords[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM, yyyy', 'pt_BR').format(record.date),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGray,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.secondaryColor),
                        onPressed: () {
                          _showDeleteConfirmation(record);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Odômetro',
                    '${record.odometer} km',
                    Icons.speed,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Quantidade de Combustível',
                    '${record.amount} litros',
                    Icons.local_gas_station,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Custo de Combustível',
                    'R\$${record.cost.toStringAsFixed(2)}',
                    Icons.attach_money,
                  ),
                  if (record.fuelEconomy != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Economia de Combustível',
                      '${record.fuelEconomy!.toStringAsFixed(2)} km/l',
                      Icons.eco,
                    ),
                  ],
                  if (record.notes != null && record.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      record.notes!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGray,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildStatisticsTab(List<FuelRecord> fuelRecords) {
    if (fuelRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bar_chart,
              color: AppColors.mediumGray,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma estatística disponível',
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adicione registros de combustível para ver as estatísticas',
              style: TextStyle(
                color: AppColors.mediumGray,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    // Calculate statistics
    final totalFuel = fuelRecords.fold(0.0, (sum, record) => sum + record.amount);
    final totalCost = fuelRecords.fold(0.0, (sum, record) => sum + record.cost);
    
    // Calculate average fuel economy
    double avgFuelEconomy = 0;
    int recordsWithEconomy = 0;
    
    for (var record in fuelRecords) {
      if (record.fuelEconomy != null) {
        avgFuelEconomy += record.fuelEconomy!;
        recordsWithEconomy++;
      }
    }
    
    if (recordsWithEconomy > 0) {
      avgFuelEconomy /= recordsWithEconomy;
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumo de Combustível',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow(
                    'Total de Registros',
                    fuelRecords.length.toString(),
                    Icons.list_alt,
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    'Combustível Total',
                    '${totalFuel.toStringAsFixed(2)} litros',
                    Icons.local_gas_station,
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    'Custo Total',
                    'R\$${totalCost.toStringAsFixed(2)}',
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow(
                    'Média de Economia de Combustível',
                    recordsWithEconomy > 0
                        ? '${avgFuelEconomy.toStringAsFixed(2)} km/l'
                        : 'N/A',
                    Icons.eco,
                  ),
                ],
              ),
            ),
          ),
          
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tendência de Consumo de Combustível',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.bar_chart,
                            size: 60,
                            color: AppColors.mediumGray,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Gráfico de Consumo de Combustível',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Com base em ${fuelRecords.length} registros',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Análise de Custos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.pie_chart,
                            size: 60,
                            color: AppColors.mediumGray,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Gráfico de Custo de Combustível',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Custo total: R\$${totalCost.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 24,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _showAddFuelRecordDialog() {
    final formKey = GlobalKey<FormState>();
    final odometerController = TextEditingController();
    final amountController = TextEditingController();
    final costController = TextEditingController();
    final notesController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    
    showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Adicionar Registro de Combustível'),
        content: StatefulBuilder( // Use para atualizar a UI da data
          builder: (BuildContext context, StateSetter stateSetter) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile( // Date Picker
                      title: const Text('Data'),
                      subtitle: Text(DateFormat('dd MMM, yyyy').format(selectedDate)), 
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: dialogContext,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != selectedDate) {
                          stateSetter(() { 
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    // ... Resto dos AppTextFields como antes ...
                     const SizedBox(height: 16),
                     AppTextField(label: 'Odômetro (km)', controller: odometerController, /*...*/ validator: (v) => InputValidator.validateNumber(v, 'Odômetro'),),
                     const SizedBox(height: 16),
                     AppTextField(label: 'Quantidade de combustível (litros)', controller: amountController, /*...*/ validator: (v) => InputValidator.validateNumber(v, 'Quantidade'),),
                     const SizedBox(height: 16),
                     AppTextField(label: 'Custo com combustível', controller: costController, /*...*/ validator: (v) => InputValidator.validateNumber(v, 'Custo'),),
                     const SizedBox(height: 16),
                     AppTextField(label: 'Notas (Opcional)', controller: notesController, maxLines: 3,),

                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId == null) {
                    Navigator.of(dialogContext).pop(); // Fecha o diálogo
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro: Sessão expirada. Por favor, faça login novamente.'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return; // Interrompe a execução
                  }
                final fuelRecord = FuelRecord(
                  userId: userId, 
                  date: selectedDate,
                  odometer: double.parse(odometerController.text),
                  amount: double.parse(amountController.text),
                  cost: double.parse(costController.text),
                  notes: notesController.text.isNotEmpty ? notesController.text : null,
                );
                context.read<TripBloc>().add(AddFuelRecordEvent(fuelRecord: fuelRecord));
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      );
    },
  );
}
  
  void _showDeleteConfirmation(FuelRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Registro de Combustível'),
        content: const Text(
          'Tem certeza de que deseja excluir este registro de combustível? Esta ação não poderá ser desfeita.',
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
              context.read<TripBloc>().add(DeleteFuelRecordEvent(recordId: record.id!));
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

