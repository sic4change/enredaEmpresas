import 'package:flutter/material.dart';
import '../../../models/criteria.dart';

class CriteriaDisplay extends StatelessWidget {
  final List<Criteria> criteria;

  CriteriaDisplay({required this.criteria});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Criterios:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: criteria.length,
          itemBuilder: (context, index) {
            final item = criteria[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '${item.criteriaId.toUpperCase()}: ' +
                    (item.requirementText != null
                        ? item.requirementText!
                        : item.competenciesNames!) +
                    ' (Peso: ${item.weight}%)',
                style: TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ],
    );
  }
}