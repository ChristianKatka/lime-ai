import { useState } from "react";
import type { RiskAssessment } from "../types";
import { AssessmentTable } from "./assessment-table/AssessmentTable";
import { AssessmentDetails } from "./assessment-details/AssessmentDetails";

interface AssessmentsViewProps {
  assessments: RiskAssessment[];
}

export const AssessmentsView = ({ assessments }: AssessmentsViewProps) => {
  const [selectedAssessment, setSelectedAssessment] =
    useState<RiskAssessment | null>(null);

  return (
    <div className="space-y-6">
      <AssessmentTable
        assessments={assessments}
        onSelectAssessment={setSelectedAssessment}
      />

      {selectedAssessment && (
        <AssessmentDetails
          assessment={selectedAssessment}
          onClose={() => setSelectedAssessment(null)}
        />
      )}
    </div>
  );
};
