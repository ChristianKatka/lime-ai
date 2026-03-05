interface NavigationTabsProps {
  activeView: "submit" | "assessments";
  onViewChange: (view: "submit" | "assessments") => void;
  assessmentCount: number;
}

export const NavigationTabs = ({
  activeView,
  onViewChange,
  assessmentCount,
}: NavigationTabsProps) => {
  return (
    <div className="max-w-7xl mx-auto mb-6">
      <div className="flex gap-4">
        <button
          onClick={() => onViewChange("submit")}
          className={`px-6 py-3 rounded-lg font-semibold transition-all ${
            activeView === "submit"
              ? "bg-blue-500 text-white shadow-lg shadow-blue-500/20"
              : "bg-slate-800 text-slate-300 border-2 border-slate-600 hover:border-blue-400"
          }`}
        >
          Submit Transaction
        </button>
        <button
          onClick={() => onViewChange("assessments")}
          className={`px-6 py-3 rounded-lg font-semibold transition-all ${
            activeView === "assessments"
              ? "bg-blue-500 text-white shadow-lg shadow-blue-500/20"
              : "bg-slate-800 text-slate-300 border-2 border-slate-600 hover:border-blue-400"
          }`}
        >
          Risk Assessments ({assessmentCount})
        </button>
      </div>
    </div>
  );
};
