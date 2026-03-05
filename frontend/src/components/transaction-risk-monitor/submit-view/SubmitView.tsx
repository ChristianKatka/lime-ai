import { useState } from "react";
import type { TransactionFormData } from "../types";
import { FormInput } from "./form-input/FormInput";
import { JsonInput } from "./json-input/JsonInput";

interface SubmitViewProps {
  onAnalyze: (transactionData?: unknown) => void;
  isAnalyzing: boolean;
}

export const SubmitView = ({ onAnalyze, isAnalyzing }: SubmitViewProps) => {
  const [inputMode, setInputMode] = useState<"form" | "json">("form");
  const [jsonInput, setJsonInput] = useState("");
  const [formData, setFormData] = useState<TransactionFormData>({
    transactionId: "",
    country: "",
    amount: "",
    currency: "EUR",
    destination: "",
    beneficiary: "",
    purpose: "",
  });

  const handleInputChange = (
    e: React.ChangeEvent<
      HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement
    >,
  ) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleJsonSubmit = () => {
    try {
      const parsedData = JSON.parse(jsonInput);
      onAnalyze(parsedData);
    } catch (e) {
      console.log(e);
      alert("Invalid JSON format. Please check your input.");
    }
  };

  const handleFormSubmit = () => {
    const transactionData = {
      transaction_id: formData.transactionId,
      customer_country: formData.country,
      amount_eur: parseFloat(formData.amount),
      currency: formData.currency,
      destination_country: formData.destination,
      beneficiary: formData.beneficiary,
      description: formData.purpose,
    };
    onAnalyze(transactionData);
  };

  return (
    <div className="bg-slate-800 border-2 border-blue-500/30 rounded-xl p-8 shadow-lg">
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold text-white">
          Submit Transaction for Analysis
        </h2>
        <div className="flex gap-2">
          <button
            onClick={() => setInputMode("form")}
            className={`px-4 py-2 rounded-lg font-semibold transition-all ${
              inputMode === "form"
                ? "bg-blue-500 text-white"
                : "bg-slate-700 text-slate-300 hover:bg-slate-600"
            }`}
          >
            Form Input
          </button>
          <button
            onClick={() => setInputMode("json")}
            className={`px-4 py-2 rounded-lg font-semibold transition-all ${
              inputMode === "json"
                ? "bg-blue-500 text-white"
                : "bg-slate-700 text-slate-300 hover:bg-slate-600"
            }`}
          >
            JSON Input
          </button>
        </div>
      </div>

      {inputMode === "form" ? (
        <FormInput
          formData={formData}
          onInputChange={handleInputChange}
          onAnalyze={handleFormSubmit}
          isAnalyzing={isAnalyzing}
        />
      ) : (
        <JsonInput
          jsonInput={jsonInput}
          onJsonChange={setJsonInput}
          onSubmit={handleJsonSubmit}
          isAnalyzing={isAnalyzing}
        />
      )}
    </div>
  );
};
