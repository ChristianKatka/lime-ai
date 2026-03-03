export const Header = () => {
  return (
    <div className="max-w-7xl mx-auto mb-8">
      <div className="bg-slate-800 border-2 border-blue-500/30 rounded-xl p-6 shadow-lg">
        <div className="h-1 w-full bg-linear-to-r from-blue-400 via-blue-500 to-blue-400 rounded-full mb-4"></div>
        <h1 className="text-3xl font-bold text-white mb-2">
          Transaction Risk Monitor
        </h1>
        <p className="text-slate-300">
          Internal Compliance Dashboard - AML & Fraud Detection
        </p>
      </div>
    </div>
  );
};
