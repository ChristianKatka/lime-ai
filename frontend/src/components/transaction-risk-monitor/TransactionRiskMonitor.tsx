import { useState } from "react";
import { Header } from "./header/Header";
import { NavigationTabs } from "./navigation-tabs/NavigationTabs";
import { SubmitView } from "./submit-view/SubmitView";
import { AssessmentsView } from "./assessments-view/AssessmentsView";
import { MOCK_ASSESSMENTS } from "./mockData";

export const TransactionRiskMonitor = () => {
  const [activeView, setActiveView] = useState<"submit" | "assessments">(
    "submit",
  );
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [assessments] = useState(MOCK_ASSESSMENTS);

  const handleAnalyze = () => {
    setIsAnalyzing(true);
    setTimeout(() => {
      setIsAnalyzing(false);
      setActiveView("assessments");
    }, 2000);
  };

  return (
    <div className="min-h-screen bg-linear-to-br from-slate-900 to-slate-800 p-6">
      <Header />

      <NavigationTabs
        activeView={activeView}
        onViewChange={setActiveView}
        assessmentCount={assessments.length}
      />

      <div className="max-w-7xl mx-auto">
        {activeView === "submit" ? (
          <SubmitView onAnalyze={handleAnalyze} isAnalyzing={isAnalyzing} />
        ) : (
          <AssessmentsView assessments={assessments} />
        )}
      </div>
    </div>
  );
};
