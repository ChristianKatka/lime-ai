interface JsonInputProps {
  jsonInput: string;
  onJsonChange: (value: string) => void;
  onSubmit: () => void;
  isAnalyzing: boolean;
}

export const JsonInput = ({
  jsonInput,
  onJsonChange,
  onSubmit,
  isAnalyzing,
}: JsonInputProps) => {
  return (
    <>
      <div className="space-y-4">
        <div>
          <label className="block text-slate-200 font-semibold mb-2">
            Paste Transaction JSON
          </label>
          <textarea
            value={jsonInput}
            onChange={(e) => onJsonChange(e.target.value)}
            placeholder={`{\n  "transaction_id": "TX-100333",\n  "timestamp": "2026-02-17T11:45:09Z",\n  "customer_id": "CUST-99832",\n  "customer_country": "Netherlands",\n  "amount_eur": 16000,\n  "currency": "EUR",\n  "destination_country": "United Arab Emirates",\n  "destination_bank_type": "Commercial",\n  "payment_method": "Wire Transfer",\n  "description": "Consulting services payment.",\n  "is_new_beneficiary": true,\n  "customer_risk_profile": "High"\n}`}
            rows={16}
            className="w-full bg-slate-900 border-2 border-slate-600 focus:border-blue-400 rounded-lg px-4 py-3 text-green-400 placeholder-slate-500 outline-none transition-colors resize-none font-mono text-sm"
          />
        </div>
      </div>

      <div className="mt-8 flex items-center gap-4">
        <button
          onClick={onSubmit}
          disabled={isAnalyzing || !jsonInput.trim()}
          className="px-8 py-4 bg-blue-500 hover:bg-blue-600 disabled:bg-slate-600 text-white font-bold rounded-lg shadow-lg hover:shadow-blue-500/20 transition-all disabled:cursor-not-allowed"
        >
          {isAnalyzing ? "Analyzing..." : "Submit JSON"}
        </button>

        {isAnalyzing && (
          <div className="flex items-center gap-3 text-blue-400">
            <div className="w-5 h-5 border-2 border-blue-400 border-t-transparent rounded-full animate-spin"></div>
            <span className="font-semibold">Queued for risk assessment</span>
          </div>
        )}
      </div>
    </>
  );
};
