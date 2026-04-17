import 'package:record/record.dart';

class VoiceService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> hasPermission() async {
    return _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    final allowed = await hasPermission();
    if (!allowed) {
      throw Exception('No se concedió permiso de micrófono');
    }

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
    );
  }

  Future<String?> stopRecording() async {
    return _recorder.stop();
  }

  Future<void> cancelRecording() async {
    await _recorder.cancel();
  }

  Future<bool> isRecording() async {
    return _recorder.isRecording();
  }

  void dispose() {
    _recorder.dispose();
  }
}