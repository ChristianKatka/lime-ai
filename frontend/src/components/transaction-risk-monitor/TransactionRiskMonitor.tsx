import { useState, useEffect } from "react";
import type { RiskAssessment } from "./types";
import { Header } from "./header/Header";
import { NavigationTabs } from "./navigation-tabs/NavigationTabs";
import { SubmitView } from "./submit-view/SubmitView";
import { AssessmentsView } from "./assessments-view/AssessmentsView";
import {
  fetchRiskAssessments,
  submitTransaction,
} from "./api/riskAssessmentApi";

export const TransactionRiskMonitor = () => {
  const [activeView, setActiveView] = useState<"submit" | "assessments">(
    "submit",
  );
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [assessments, setAssessments] = useState<RiskAssessment[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const loadAssessments = async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await fetchRiskAssessments();
      setAssessments(data);
    } catch (err) {
      setError("Failed to load risk assessments. Please try again.");
      console.error(err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadAssessments();
  }, []);

  const handleAnalyze = async (transactionData?: unknown) => {
    setIsAnalyzing(true);
    setError(null);
    try {
      if (transactionData) {
        await submitTransaction(transactionData);
      }
      await new Promise((resolve) => setTimeout(resolve, 5000));
      await loadAssessments();
      setActiveView("assessments");
    } catch (err) {
      setError("Failed to submit transaction. Please try again.");
      console.error(err);
    } finally {
      setIsAnalyzing(false);
    }
  };

  return (
    <div className="min-h-screen bg-linear-to-br from-slate-900 to-slate-800 p-6">
      <Header />

      <NavigationTabs
        activeView={activeView}
        onViewChange={setActiveView}
        assessmentCount={assessments.length}
      />

      {error && (
        <div className="max-w-7xl mx-auto mb-6">
          <div className="bg-red-900/30 border-2 border-red-600 rounded-xl p-4">
            <p className="text-red-300 font-semibold">{error}</p>
          </div>
        </div>
      )}

      <div className="max-w-7xl mx-auto">
        {activeView === "submit" ? (
          <SubmitView onAnalyze={handleAnalyze} isAnalyzing={isAnalyzing} />
        ) : (
          <AssessmentsView
            assessments={assessments}
            isLoading={isLoading}
            onRefresh={loadAssessments}
          />
        )}
      </div>
    </div>
  );
};
