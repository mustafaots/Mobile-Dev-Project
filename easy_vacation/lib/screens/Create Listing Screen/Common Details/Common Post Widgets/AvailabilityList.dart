import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/shared/themes.dart';

class AvailabilityList extends StatelessWidget {
  final List<AvailabilityInterval> availabilityIntervals;
  final Function(int) onRemoveInterval;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  
  const AvailabilityList({
    Key? key,
    required this.availabilityIntervals,
    required this.onRemoveInterval,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (availabilityIntervals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: secondaryTextColor.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            'No availability periods added',
            style: TextStyle(
              color: secondaryTextColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: availabilityIntervals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final interval = availabilityIntervals[index];
        final format = DateFormat('MMM dd, yyyy HH:mm');
        
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${format.format(interval.start)} - ${format.format(interval.end)}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duration: ${interval.end.difference(interval.start).inDays} days',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onRemoveInterval(index),
              ),
            ],
          ),
        );
      },
    );
  }
}