import 'package:cooktogether/ui/widgets/planning_cell.dart';
import 'package:flutter/material.dart';
import 'package:cooktogether/ui/templates/main_screen_template.dart';
import 'package:intl/intl.dart';

class PlanningScreen extends StatelessWidget {
  const PlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreenTemplate(
      title: 'Planning',
      body: Column(
        children: [
          // Titre de la semaine
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Semaine du ${DateFormat('dd/MM/yyyy').format(_getStartOfWeek())}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          // Tableau avec les jours de la semaine
          Expanded(
            child: Column(
              children: [
                // Titre des repas
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Repas',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Matin',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Midi',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Goûter',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Soir',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Les jours de la semaine
                Expanded(
                  child: ListView.builder(
                    itemCount: 7,
                    itemBuilder: (context, dayIndex) {
                      final day = _getStartOfWeek().add(Duration(days: dayIndex));
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            // En-tête du jour
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  DateFormat('EEE d').format(day),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Les 4 repas de la journée
                            Expanded(
                              child: PlanningCell(
                                title: 'Petit-déjeuner',
                                meal: 'Céréales',
                                onTap: () {
                                  // TODO: Ajouter un repas
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: PlanningCell(
                                title: 'Déjeuner',
                                meal: 'Salade',
                                onTap: () {
                                  // TODO: Ajouter un repas
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: PlanningCell(
                                title: 'Collation',
                                meal: 'Fruit',
                                onTap: () {
                                  // TODO: Ajouter un repas
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: PlanningCell(
                                title: 'Dîner',
                                meal: 'Pâtes',
                                onTap: () {
                                  // TODO: Ajouter un repas
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime _getStartOfWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return startOfWeek;
  }
}
