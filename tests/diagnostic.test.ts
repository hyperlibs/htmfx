import { describe, it, expect } from 'vitest';
import { ErrorReporter } from '../src/diagnostic/error-reporter.fx';

describe('ErrorReporter (.mx Diagnostic Format)', () => {
  it('formats diagnostic errors in pure .mx syntax', () => {
    const error = {
      code: 'FX-0042',
      type: 'DIRECTIVE_ERROR' as const,
      description: 'Invalid supersonic atmosphere parameter',
      culprit: '<hx-viewport 3datmos="$windy(1500m/s)">',
      fix_suggestion: 'Use $windy(Mach 4.3)',
      timestamp: '2026-09-04T12:30:00Z'
    };

    const mxOutput = ErrorReporter.formatMx(error);
    expect(mxOutput).toContain('@diag FX-0042');
    expect(mxOutput).toContain('type: DIRECTIVE_ERROR');
    expect(mxOutput).toContain('culprit: <hx-viewport 3datmos="$windy(1500m/s)">');
    expect(mxOutput).toContain('fix_suggestion: Use $windy(Mach 4.3)');

    const parsed = ErrorReporter.parseMx(mxOutput);
    expect(parsed?.code).toBe('FX-0042');
    expect(parsed?.type).toBe('DIRECTIVE_ERROR');
    expect(parsed?.fix_suggestion).toBe('Use $windy(Mach 4.3)');
  });
});
