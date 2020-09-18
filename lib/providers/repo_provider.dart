import '../repository/can_repository.dart'
import '../repository/dbc_repository.dart'


final canRepoProvider = Provider((ref) => CanRepository());
final dbcRepoProvider = Provider((ref) => DbcRepository());
