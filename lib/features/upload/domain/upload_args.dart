class UploadArgs {
  final List<String> paths;
  final String source; // 'camera' | 'gallery'

  const UploadArgs({required this.paths, required this.source});
}
