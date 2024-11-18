import '../../domain/commom/uid.dart';

class AssetTreeNodeModel {
  final Uid id;
  final Uid? parentId;
  final String name;

  AssetTreeNodeModel({
    required this.id,
    required this.name,
    this.parentId,
  });

  @override
  String toString() => 'TreeNode(id: $id, name: $name)';
}
