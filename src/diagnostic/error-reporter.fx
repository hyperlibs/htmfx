/**
 * htmFX Structured Machine-Parseable Diagnostic Reporter (.fx)
 * Emits standardized error descriptors for AI self-healing and developer diagnostics.
 */

export interface DiagnosticError {
  code: string;
  type: 'SYNTAX_ERROR' | 'RUNTIME_ERROR' | 'WEBGL_ERROR' | 'DIRECTIVE_ERROR' | 'PHYSICS_ERROR';
  description: string;
  culprit: string;
  fix_suggestion: string;
  timestamp: string;
}

export class ErrorReporter {
  static emit(
    code: string,
    type: DiagnosticError['type'],
    description: string,
    culprit: string,
    fix_suggestion: string
  ): DiagnosticError {
    const error: DiagnosticError = {
      code,
      type,
      description,
      culprit,
      fix_suggestion,
      timestamp: new Date().toISOString()
    };

    console.error(`[htmFX::DIAGNOSTIC] ${JSON.stringify(error, null, 2)}`);
    return error;
  }
}
