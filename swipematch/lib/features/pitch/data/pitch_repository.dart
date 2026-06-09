import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pitch_validator.dart';
import '../../../shared/constants/supabase_constants.dart';

class PitchRepository {
  PitchRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Uploads the pitch video, sets profiles.video_pitch_url, and fires
  /// pitch-transcribe in the background. Returns the public URL.
  Future<String> uploadAndPublish({
    required String profileId,
    required File file,
  }) async {
    await PitchValidator.validateFile(file);

    final ext = file.path.split('.').last.toLowerCase();
    // Path convention enforced by storage RLS: <profile_id>/<filename>
    final objectPath = '$profileId/pitch.$ext';

    await _supabase.storage.from(SupabaseConstants.pitchesBucket).upload(
          objectPath,
          file,
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: true,
            contentType: _mimeFor(ext),
          ),
        );

    final publicUrl = _supabase.storage
        .from(SupabaseConstants.pitchesBucket)
        .getPublicUrl(objectPath);

    await _supabase
        .from(SupabaseConstants.profiles)
        .update({
          'video_pitch_url': publicUrl,
          // null out the previous transcript until the new one is computed
          'video_pitch_transcript': null,
        })
        .eq('id', profileId);

    // Fire-and-forget the transcription job; non-blocking.
    unawaited(_triggerTranscribe(profileId: profileId, videoUrl: publicUrl));

    return publicUrl;
  }

  Future<void> deletePitch(String profileId) async {
    // Best-effort cleanup: remove any pitch object under <profile_id>/...
    try {
      final files = await _supabase.storage
          .from(SupabaseConstants.pitchesBucket)
          .list(path: profileId);
      if (files.isNotEmpty) {
        await _supabase.storage.from(SupabaseConstants.pitchesBucket).remove(
              files.map((f) => '$profileId/${f.name}').toList(),
            );
      }
    } catch (_) {
      // Storage cleanup best-effort; the DB row is the source of truth.
    }

    await _supabase
        .from(SupabaseConstants.profiles)
        .update({
          'video_pitch_url': null,
          'video_pitch_transcript': null,
        })
        .eq('id', profileId);
  }

  Future<void> _triggerTranscribe({
    required String profileId,
    required String videoUrl,
  }) async {
    try {
      await _supabase.functions.invoke(
        SupabaseConstants.fnPitchTranscribe,
        body: {'profileId': profileId, 'videoUrl': videoUrl},
      );
    } catch (_) {
      // Transcript will be retried by a background sweep if added later.
    }
  }

  String _mimeFor(String ext) => switch (ext) {
        'mp4' => 'video/mp4',
        'm4v' => 'video/mp4',
        'mov' => 'video/quicktime',
        'webm' => 'video/webm',
        _ => 'application/octet-stream',
      };
}

final pitchRepositoryProvider = Provider<PitchRepository>(
  (ref) => PitchRepository(Supabase.instance.client),
);
