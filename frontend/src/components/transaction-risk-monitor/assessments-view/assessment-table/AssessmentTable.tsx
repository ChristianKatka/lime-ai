import type { RiskAssessment } from "../../types";

interface AssessmentTableProps {
  assessments: RiskAssessment[];
  onSelectAssessment: (assessment: RiskAssessment) => void;
}

const getRiskBadgeStyles = (level: string) => {
  switch (level) {
    case "HIGH":
      return {
        container: "bg-red-900/30 border-red-600",
        dot: "bg-red-500",
        text: "text-red-300",
      };
    case "MEDIUM":
      return {
        container: "bg-yellow-900/30 border-yellow-600",
        dot: "bg-yellow-500",
        text: "text-yellow-300",
      };
    case "LOW":
      return {
        container: "bg-green-900/30 border-green-600",
        dot: "bg-green-500",
        text: "text-green-300",
      };
    default:
      return {
        container: "bg-slate-700 border-slate-600",
        dot: "bg-slate-500",
        text: "text-slate-300",
      };
  }
};

const formatTimestamp = (timestamp: string) => {
  return new Date(timestamp).toLocaleString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
};

export const AssessmentTable = ({
  assessments,
  onSelectAssessment,
}: AssessmentTableProps) => {
  return (
    <div className="bg-slate-800 border-2 border-blue-500/30 rounded-xl overflow-hidden shadow-lg">
      <div className="p-6 border-b border-slate-700">
        <h2 className="text-2xl font-bold text-white">Risk Assessments</h2>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full">
          <thead className="bg-slate-900">
            <tr>
              <th className="px-6 py-4 text-left text-slate-200 font-semibold">
                Timestamp
              </th>
              <th className="px-6 py-4 text-left text-slate-200 font-semibold">
                Risk Level
              </th>
              <th className="px-6 py-4 text-left text-slate-200 font-semibold">
                Risk Score
              </th>
              <th className="px-6 py-4 text-left text-slate-200 font-semibold">
                Summary
              </th>
              <th className="px-6 py-4 text-left text-slate-200 font-semibold">
                Confidence
              </th>
            </tr>
          </thead>
          <tbody>
            {assessments.map((assessment) => (
              <tr
                key={assessment.id}
                onClick={() => onSelectAssessment(assessment)}
                className="border-t border-slate-700 hover:bg-slate-700/50 cursor-pointer transition-colors"
              >
                <td className="px-6 py-4 text-slate-300 whitespace-nowrap">
                  {formatTimestamp(assessment.time_stamp)}
                </td>
                <td className="px-6 py-4">
                  {(() => {
                    const styles = getRiskBadgeStyles(assessment.risk_level);
                    return (
                      <span
                        className={`inline-flex items-center gap-2 px-3 py-1.5 rounded-md border ${styles.container}`}
                      >
                        <span
                          className={`w-2 h-2 rounded-full ${styles.dot}`}
                        ></span>
                        <span
                          className={`font-semibold text-sm uppercase tracking-wide ${styles.text}`}
                        >
                          {assessment.risk_level}
                        </span>
                      </span>
                    );
                  })()}
                </td>
                <td className="px-6 py-4">
                  <span className="text-white font-bold text-lg">
                    {assessment.risk_score}
                  </span>
                </td>
                <td className="px-6 py-4 text-slate-300 max-w-md truncate">
                  {assessment.summary}
                </td>
                <td className="px-6 py-4">
                  <span className="text-slate-300 font-semibold">
                    {assessment.confidence}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
