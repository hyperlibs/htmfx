/**
 * htmFX Structured Machine-Parseable Diagnostic Reporter (.fx)
 * Emits standardized .mx error descriptors (@diag) for AI self-healing and developer diagnostics.
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
  /**
   * Formats a diagnostic error into native .mx format
   */
  static formatMx(error: DiagnosticError): string {
    return [
      `@diag ${error.code}`,
      `  type: ${error.type}`,
      `  description: ${error.description}`,
      `  culprit: ${error.culprit}`,
      `  fix_suggestion: ${error.fix_suggestion}`,
      `  timestamp: ${error.timestamp}`
    ].join('\n');
  }

  /**
   * Emits and logs a native .mx diagnostic block
   */
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

    const mxBlock = ErrorReporter.formatMx(error);
    console.error(`[htmFX::DIAGNOSTIC]\n${mxBlock}`);
    return error;
  }

  /**
   * Parses raw .mx diagnostic strings back into typed DiagnosticError
   */
  static parseMx(raw: string): DiagnosticError | null {
    const lines = raw.split(/\r?\n/).map(l => l.trim()).filter(Boolean);
    if (!lines.length) return null;

    const diagHeader = lines[0].match(/^@diag\s+([a-zA-Z0-9_\-]+)/);
    if (!diagHeader) return null;

    const code = diagHeader[1];
    const data: Record<string, string> = {};

    for (let i = 1; i < lines.length; i++) {
      const line = lines[i];
      if (line.includes(':')) {
        const [k, ...v] = line.split(':');
        data[k.trim()] = v.join(':').trim();
      }
    }

    return {
      code,
      type: (data['type'] || 'RUNTIME_ERROR') as DiagnosticError['type'],
      description: data['description'] || '',
      culprit: data['culprit'] || '',
      fix_suggestion: data['fix_suggestion'] || '',
      timestamp: data['timestamp'] || new Date().toISOString()
    };
  }
}
