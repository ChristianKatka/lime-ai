import type { TransactionFormData } from "../../types";

interface FormInputProps {
  formData: TransactionFormData;
  onInputChange: (
    e: React.ChangeEvent<
      HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement
    >,
  ) => void;
  onAnalyze: () => void;
  isAnalyzing: boolean;
}

export const FormInput = ({
  formData,
  onInputChange,
  onAnalyze,
  isAnalyzing,
}: FormInputProps) => {
  return (
    <>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label className="block text-slate-200 font-semibold mb-2">
            Transaction ID
          </label>
          <input
            type="text"
            name="transactionId"
            value={formData.transactionId}
            onChange={onInputChange}
            placeholder="TX-100001"
            className="w-full bg-slate-700 border-2 border-slate-600 focus:border-blue-400 rounded-lg px-4 py-3 text-white placeholder-slate-400 outline-none transition-colors"
          />
        </div>

        <div>
          <label className="block text-slate-200 font-semibold mb-2">
            Origin Country
          </label>
          <input
            type="text"
            name="country"
            value={formData.country}
            onChange={onInputChange}
            placeholder="Netherlands"
            className="w-full bg-slate-700 border-2 border-slate-600 focus:border-blue-400 rounded-lg px-4 py-3 text-white placeholder-slate-400 outline-none transition-colors"
          />
        </div>

        <div>
          <label className="block text-slate-200 font-semibold mb-2">
            Amount
          </label>
          <input
            type="number"
            name="amount"
            value={formData.amount}
            onChange={onInputChange}
            placeholder="16000"
            className="w-full bg-slate-700 border-2 border-slate-600 focus:border-blue-400 rounded-lg px-4 py-3 text-white placeholder-slate-400 outline-none transition-colors"
          />
        </div>

        <div>
          <label className="block text-slate-200 font-semibold mb-2">
            Currency
          </label>
          <select
            name="currency"
            value={formData.currency}
            onChange={onInputChange}
            className="w-full bg-slate-700 border-2 border-slate-600 focus:border-blue-400 rounded-lg px-4 py-3 text-white outline-none transition-colors"
          >
            <option value="EUR">EUR</option>
            <option value="USD">USD</option>
            <option value="GBP">GBP</option>
            <option value="CHF">CHF</option>
          </select>
        </div>

        <div>
          <label className="block text-slate-200 font-semibold mb-2">
            Destination Country
          </label>
          <input
            type="text"
            name="destination"
            value={formData.destination}
            onChange={onInputChange}
            placeholder="United Arab Emirates"
            className="w-full bg-slate-700 border-2 border-slate-600 focus:border-blue-400 rounded-lg px-4 py-3 text-white placeholder-slate-400 outline-none transition-colors"
          />
        </div>

        <div>
          <label className="block text-slate-200 font-semibold mb-2">
            Beneficiary
          </label>
          <input
            type="text"
            name="beneficiary"
            value={formData.beneficiary}
            onChange={onInputChange}
            placeholder="Company Name or Individual"
            className="w-full bg-slate-700 border-2 border-slate-600 focus:border-blue-400 rounded-lg px-4 py-3 text-white placeholder-slate-400 outline-none transition-colors"
          />
        </div>

        <div className="md:col-span-2">
          <label className="block text-slate-200 font-semibold mb-2">
            Purpose of Transfer
          </label>
          <textarea
            name="purpose"
            value={formData.purpose}
            onChange={onInputChange}
            placeholder="Business payment, personal transfer, investment, etc."
            rows={3}
            className="w-full bg-slate-700 border-2 border-slate-600 focus:border-blue-400 rounded-lg px-4 py-3 text-white placeholder-slate-400 outline-none transition-colors resize-none"
          />
        </div>
      </div>

      <div className="mt-8 flex items-center gap-4">
        <button
          onClick={onAnalyze}
          disabled={isAnalyzing}
          className="px-8 py-4 bg-blue-500 hover:bg-blue-600 disabled:bg-slate-600 text-white font-bold rounded-lg shadow-lg hover:shadow-blue-500/20 transition-all disabled:cursor-not-allowed"
        >
          {isAnalyzing ? "Analyzing..." : "Analyze Transaction"}
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
