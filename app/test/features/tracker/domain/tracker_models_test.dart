import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/tracker/domain/procedure_template.dart';
import 'package:gaijin_life_navi/features/tracker/domain/user_procedure.dart';

void main() {
  group('ProcedureStatus', () {
    test('fromString parses all statuses', () {
      expect(ProcedureStatus.fromString('not_started'),
          ProcedureStatus.notStarted);
      expect(ProcedureStatus.fromString('in_progress'),
          ProcedureStatus.inProgress);
      expect(ProcedureStatus.fromString('completed'),
          ProcedureStatus.completed);
    });

    test('fromString defaults to notStarted for unknown', () {
      expect(ProcedureStatus.fromString('unknown'),
          ProcedureStatus.notStarted);
    });

    test('apiValue returns correct strings', () {
      expect(ProcedureStatus.notStarted.apiValue, 'not_started');
      expect(ProcedureStatus.inProgress.apiValue, 'in_progress');
      expect(ProcedureStatus.completed.apiValue, 'completed');
    });
  });

  group('UserProcedure', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'up-1',
        'procedure_ref_type': 'admin',
        'procedure_ref_id': 'admin-1',
        'title': 'Resident Registration',
        'status': 'in_progress',
        'due_date': '2026-03-01',
        'notes': 'Need passport copy',
        'completed_at': null,
        'created_at': '2026-02-16T10:00:00Z',
      };

      final proc = UserProcedure.fromJson(json);

      expect(proc.id, 'up-1');
      expect(proc.title, 'Resident Registration');
      expect(proc.status, ProcedureStatus.inProgress);
      expect(proc.dueDate, isNotNull);
      expect(proc.dueDate!.year, 2026);
      expect(proc.notes, 'Need passport copy');
      expect(proc.completedAt, isNull);
    });

    test('fromJson handles completed procedure', () {
      final json = {
        'id': 'up-2',
        'procedure_ref_type': 'admin',
        'procedure_ref_id': 'admin-2',
        'title': 'Bank Account',
        'status': 'completed',
        'completed_at': '2026-02-20T14:00:00Z',
      };

      final proc = UserProcedure.fromJson(json);

      expect(proc.status, ProcedureStatus.completed);
      expect(proc.completedAt, isNotNull);
    });
  });

  group('ProcedureTemplate', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'tmpl-1',
        'procedure_type': 'resident_registration',
        'title': 'Resident Registration',
        'description': 'Register at city hall',
        'category': 'essential',
        'is_arrival_essential': true,
      };

      final tmpl = ProcedureTemplate.fromJson(json);

      expect(tmpl.id, 'tmpl-1');
      expect(tmpl.title, 'Resident Registration');
      expect(tmpl.isArrivalEssential, isTrue);
      expect(tmpl.category, 'essential');
    });

    test('fromJson defaults isArrivalEssential to false', () {
      final json = {
        'id': 'tmpl-2',
        'procedure_type': 'tax_filing',
        'title': 'Tax Filing',
      };

      final tmpl = ProcedureTemplate.fromJson(json);

      expect(tmpl.isArrivalEssential, isFalse);
    });
  });
}
