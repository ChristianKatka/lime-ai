export interface RiskAssessment {
  id: string;
  time_stamp: string;
  summary: string;
  risk_level: "LOW" | "MEDIUM" | "HIGH";
  risk_score: number;
  risk_categories: string[];
  red_flags: string[];
  missing_information: string[];
  recommended_actions: string[];
  confidence: "LOW" | "MEDIUM" | "HIGH";
}

export interface TransactionFormData {
  transactionId: string;
  country: string;
  amount: string;
  currency: string;
  destination: string;
  beneficiary: string;
  purpose: string;
}
