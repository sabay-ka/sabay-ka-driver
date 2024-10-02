/// {@category Core}
abstract class TaskHandler {}

/// @nodoc
///
/// {@category Core}
class TaskHandlerImpl extends TaskHandler {
  final dynamic _id;

  TaskHandlerImpl(this._id);

  dynamic get id => _id;
}
