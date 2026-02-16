import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/visa/domain/visa_procedure.dart';

void main() {
  group('VisaProcedure', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'visa-1',
        'procedure_type': 'renewal',
        'title': 'Visa Renewal',
        'description': 'How to renew your visa',
        'applicable_statuses': ['engineer_specialist', 'student'],
        'steps': [
          {'step_number': 1, 'title': 'Prepare documents', 'description': 'Gather required docs'},
          {'step_number': 2, 'title': 'Visit immigration', 'description': 'Go to local office'},
        ],
        'required_documents': ['Passport', 'Application form'],
        'fees': '4,000 JPY',
        'processing_time': '2-4 weeks',
        'disclaimer': 'This is general information.',
        'source_url': 'https://www.moj.go.jp/',
      };

      final proc = VisaProcedure.fromJson(json);

      expect(proc.id, 'visa-1');
      expect(proc.procedureType, 'renewal');
      expect(proc.title, 'Visa Renewal');
      expect(proc.applicableStatuses.length, 2);
      expect(proc.steps.length, 2);
      expect(proc.steps.first.stepNumber, 1);
      expect(proc.requiredDocuments.length, 2);
      expect(proc.fees, '4,000 JPY');
      expect(proc.processingTime, '2-4 weeks');
      expect(proc.disclaimer, isNotNull);
      expect(proc.sourceUrl, 'https://www.moj.go.jp/');
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'visa-2',
        'procedure_type': 'change',
        'title': 'Change of Status',
      };

      final proc = VisaProcedure.fromJson(json);

      expect(proc.applicableStatuses, isEmpty);
      expect(proc.steps, isEmpty);
      expect(proc.requiredDocuments, isEmpty);
      expect(proc.fees, isNull);
      expect(proc.disclaimer, isNull);
    });
  });

  group('VisaStep', () {
    test('fromJson creates valid instance', () {
      final json = {
        'step_number': 3,
        'title': 'Submit application',
        'description': 'Submit at counter',
      };

      final step = VisaStep.fromJson(json);

      expect(step.stepNumber, 3);
      expect(step.title, 'Submit application');
      expect(step.description, 'Submit at counter');
    });
  });
}
