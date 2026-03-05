import type { RiskAssessment } from "../../types";

interface AssessmentDetailsProps {
  assessment: RiskAssessment;
  onClose: () => void;
}

export const AssessmentDetails = ({
  assessment,
  onClose,
}: AssessmentDetailsProps) => {
  return (
    <div className="bg-slate-800 border-2 border-blue-500/30 rounded-xl p-8 shadow-lg">
      <div className="flex items-start justify-between mb-6">
        <div>
          <h3 className="text-2xl font-bold text-white mb-2">
            Assessment Details
          </h3>
          <p className="text-slate-400 text-sm">ID: {assessment.id}</p>
        </div>
        <button
          onClick={onClose}
          className="px-4 py-2 bg-slate-700 hover:bg-slate-600 text-white rounded-lg transition-colors"
        >
          Close
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Summary */}
        <div className="md:col-span-2">
          <h4 className="text-slate-200 font-semibold mb-2">Summary</h4>
          <p className="text-white bg-slate-700 p-4 rounded-lg">
            {assessment.summary}
          </p>
        </div>

        {/* Risk Categories */}
        {assessment.risk_categories.length > 0 && (
          <div>
            <h4 className="text-slate-200 font-semibold mb-2">
              Risk Categories
            </h4>
            <div className="flex flex-wrap gap-2">
              {assessment.risk_categories.map((category, idx) => (
                <span
                  key={idx}
                  className="px-3 py-1 bg-blue-500/20 text-blue-400 border border-blue-500/50 rounded-lg font-semibold"
                >
                  {category}
                </span>
              ))}
            </div>
          </div>
        )}

        {/* Confidence */}
        <div>
          <h4 className="text-slate-200 font-semibold mb-2">
            Confidence Level
          </h4>
          <span className="inline-block px-4 py-2 bg-slate-700 text-white rounded-lg font-bold">
            {assessment.confidence}
          </span>
        </div>

        {/* Red Flags */}
        {assessment.red_flags.length > 0 && (
          <div className="md:col-span-2">
            <h4 className="text-slate-200 font-semibold mb-2">🚩 Red Flags</h4>
            <ul className="space-y-2">
              {assessment.red_flags.map((flag, idx) => (
                <li
                  key={idx}
                  className="flex items-start gap-2 text-red-400 bg-red-500/10 p-3 rounded-lg border border-red-500/30"
                >
                  <span className="text-red-500 font-bold">•</span>
                  <span>{flag}</span>
                </li>
              ))}
            </ul>
          </div>
        )}

        {/* Recommended Actions */}
        {assessment.recommended_actions.length > 0 && (
          <div className="md:col-span-2">
            <h4 className="text-slate-200 font-semibold mb-2">
              📋 Recommended Actions
            </h4>
            <ul className="space-y-2">
              {assessment.recommended_actions.map((action, idx) => (
                <li
                  key={idx}
                  className="flex items-start gap-2 text-blue-400 bg-blue-500/10 p-3 rounded-lg border border-blue-500/30"
                >
                  <span className="text-blue-500 font-bold">{idx + 1}.</span>
                  <span>{action}</span>
                </li>
              ))}
            </ul>
          </div>
        )}

        {/* Full JSON */}
        <div className="md:col-span-2">
          <h4 className="text-slate-200 font-semibold mb-2">
            Full JSON Details
          </h4>
          <pre className="bg-slate-900 text-green-400 p-4 rounded-lg overflow-x-auto text-sm border border-slate-700">
            {JSON.stringify(assessment, null, 2)}
          </pre>
        </div>
      </div>
    </div>
  );
};
