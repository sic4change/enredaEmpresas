import 'package:enreda_empresas/app/models/userEnreda.dart';

/// Defensive client-side guard for the job-offer "match" score bug.
///
/// The authoritative `JobOfferApplication.match` score is computed
/// server-side (Firebase Cloud Functions), not in this Flutter codebase.
/// A latent backend bug grants high scores to participants whose profile
/// is effectively empty (no competencies, no abilities, no aboutMe blurb).
/// Until the Cloud Functions fix lands, this predicate lets the empresas
/// UI suppress the bogus number and surface "Perfil incompleto" instead.
///
/// Definition: a profile is "effectively empty" when ALL three signals are
/// missing — competencies map empty, abilities list empty/null, and aboutMe
/// blank. A participant with any one of these populated is treated as
/// having content and their stored `match` score is displayed as-is.
///
/// IMPORTANT — this is a temporary band-aid. The real fix belongs in the
/// Cloud Functions scoring algorithm; that work is out of scope for this
/// Flutter repo. When the backend fix ships, remove this guard.
bool isProfileEffectivelyEmpty(UserEnreda u) {
  final hasCompetencies = u.competencies.isNotEmpty;
  final hasAbilities = (u.abilities?.isNotEmpty ?? false);
  final hasAboutMe = (u.aboutMe ?? '').trim().isNotEmpty;
  return !hasCompetencies && !hasAbilities && !hasAboutMe;
}
