import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/visa/domain/visa_procedure.dart';

void main() {
  group('VisaProcedure', () {
    test('fromJson creates valid instance from backend response', () {
      // Backend response structure:
      // - required_documents: List<dict> with {name, how_to_get}
      // - fees: dict with {application_fee, currency, notes}
      // - estimated_duration instead of processing_time
      // - steps use 'order' instead of 'step_number'
      final json = {
        'id': 'visa-1',
        'procedure_type': 'renewal',
        'title': 'Visa Renewal',
        'description': 'How to renew your visa',
        'applicable_statuses': ['engineer_specialist', 'student'],
        'steps': [
          {
            'order': 1,
            'title': 'Prepare documents',
            'description': 'Gather required docs',
          },
          {
            'order': 2,
            'title': 'Visit immigration',
            'description': 'Go to local office',
          },
        ],
        'required_documents': [
          {
            'name': 'Passport',
            'how_to_get': 'Your valid passport',
          },
          {
            'name': 'Application form',
            'how_to_get': 'Download from ISA website',
          },
        ],
        'fees': {
          'application_fee': 4000,
          'currency': 'JPY',
          'notes': 'Revenue stamp',
        },
        'estimated_duration': '2-4 weeks',
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
      expect(proc.requiredDocuments.first.name, 'Passport');
      expect(proc.requiredDocuments.first.howToGet, 'Your valid passport');
      expect(proc.fees, isNotNull);
      expect(proc.fees!['application_fee'], 4000);
      expect(proc.fees!['currency'], 'JPY');
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
    test('fromJson creates valid instance with order key', () {
      final json = {
        'order': 3,
        'title': 'Submit application',
        'description': 'Submit at counter',
      };

      final step = VisaStep.fromJson(json);

      expect(step.stepNumber, 3);
      expect(step.title, 'Submit application');
      expect(step.description, 'Submit at counter');
    });

    test('fromJson falls back to step_number key', () {
      final json = {
        'step_number': 2,
        'title': 'Visit office',
      };

      final step = VisaStep.fromJson(json);

      expect(step.stepNumber, 2);
    });
  });

  group('VisaDocument', () {
    test('fromJson creates valid instance', () {
      final json = {
        'name': 'Passport',
        'how_to_get': 'Your valid passport',
      };

      final doc = VisaDocument.fromJson(json);

      expect(doc.name, 'Passport');
      expect(doc.howToGet, 'Your valid passport');
    });

    test('fromJson handles missing how_to_get', () {
      final json = {
        'name': 'Residence card',
      };

      final doc = VisaDocument.fromJson(json);

      expect(doc.name, 'Residence card');
      expect(doc.howToGet, isNull);
    });
  });
}
